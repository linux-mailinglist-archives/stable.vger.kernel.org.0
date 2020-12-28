Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143B52E41F5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438163AbgL1PPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:15:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:39142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437488AbgL1OEv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85A8121D94;
        Mon, 28 Dec 2020 14:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164251;
        bh=gyENQ7KWCYm9B7OxZ1NKziauzyC86sTqMIco/x552u0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUdPh5abeMIxE4afJS1GN/sK2STewya3uN0QUzIAfkMoTUfjTJAjjWAgpsVKIU3qd
         Z6+qW+A09Ly5iL0Z16Eb+KlodfuotEivtYNKtH1nXoZNfNbFy6hbJ06UtaVZ2QFYVe
         ebVmsjkMes/hz/uoY3ioHzgVlBpr8nxQ6RPAN9XA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Dewar <alex.dewar90@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/717] ath11k: Handle errors if peer creation fails
Date:   Mon, 28 Dec 2020 13:41:22 +0100
Message-Id: <20201228125025.010687826@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Dewar <alex.dewar90@gmail.com>

[ Upstream commit c134d1f8c436d96b3f62896c630278e3ec001280 ]

ath11k_peer_create() is called without its return value being checked,
meaning errors will be unhandled. Add missing check and, as the mutex is
unconditionally unlocked on leaving this function, simplify the exit
path.

Addresses-Coverity-ID: 1497531 ("Code maintainability issues")
Fixes: 701e48a43e15 ("ath11k: add packet log support for QCA6390")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201004100218.311653-1-alex.dewar90@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 7f8dd47d23333..7a2c9708693ec 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -5225,20 +5225,26 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 	    arvif->vdev_type != WMI_VDEV_TYPE_AP &&
 	    arvif->vdev_type != WMI_VDEV_TYPE_MONITOR) {
 		memcpy(&arvif->chanctx, ctx, sizeof(*ctx));
-		mutex_unlock(&ar->conf_mutex);
-		return 0;
+		ret = 0;
+		goto out;
 	}
 
 	if (WARN_ON(arvif->is_started)) {
-		mutex_unlock(&ar->conf_mutex);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}
 
 	if (ab->hw_params.vdev_start_delay) {
 		param.vdev_id = arvif->vdev_id;
 		param.peer_type = WMI_PEER_TYPE_DEFAULT;
 		param.peer_addr = ar->mac_addr;
+
 		ret = ath11k_peer_create(ar, arvif, NULL, &param);
+		if (ret) {
+			ath11k_warn(ab, "failed to create peer after vdev start delay: %d",
+				    ret);
+			goto out;
+		}
 	}
 
 	ret = ath11k_mac_vdev_start(arvif, &ctx->def);
@@ -5246,23 +5252,21 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 		ath11k_warn(ab, "failed to start vdev %i addr %pM on freq %d: %d\n",
 			    arvif->vdev_id, vif->addr,
 			    ctx->def.chan->center_freq, ret);
-		goto err;
+		goto out;
 	}
 	if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR) {
 		ret = ath11k_monitor_vdev_up(ar, arvif->vdev_id);
 		if (ret)
-			goto err;
+			goto out;
 	}
 
 	arvif->is_started = true;
 
 	/* TODO: Setup ps and cts/rts protection */
 
-	mutex_unlock(&ar->conf_mutex);
-
-	return 0;
+	ret = 0;
 
-err:
+out:
 	mutex_unlock(&ar->conf_mutex);
 
 	return ret;
-- 
2.27.0



