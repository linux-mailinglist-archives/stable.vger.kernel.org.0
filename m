Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4992328E6B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbhCATaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:30:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241489AbhCATZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:25:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D46D64FF6;
        Mon,  1 Mar 2021 17:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618433;
        bh=nAeagvxmNBgZwV5lsDPusW+DDwpujxjfC8cx7sKQ4Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1OFBGcRWT1Yv158mTT8dL3atx5JYUyELNy0jomY3OSkQ+GYva59GVjBrCATaoErY
         Wcuv7G0ePblWNTNBIOCt2bM1YP2CL02ZWebRhG1lLQyJJ/emgMpvMBoptb5UDDHGbo
         Vvg7CSmZh/LlTu8tx8ouBi9WTTAJKRh3C7Rjanbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/663] ath11k: fix a locking bug in ath11k_mac_op_start()
Date:   Mon,  1 Mar 2021 17:05:33 +0100
Message-Id: <20210301161145.937954480@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c202e2ebe1dc454ad54fd0018c023ec553d47284 ]

This error path leads to a Smatch warning:

	drivers/net/wireless/ath/ath11k/mac.c:4269 ath11k_mac_op_start()
	error: double unlocked '&ar->conf_mutex' (orig line 4251)

We're not holding the lock when we do the "goto err;" so it leads to a
double unlock.  The fix is to hold the lock for a little longer.

Fixes: c83c500b55b6 ("ath11k: enable idle power save mode")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
[kvalo@codeaurora.org: move also rcu_assign_pointer() call]
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/YBk4GoeE+yc0wlJH@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index af427d9051a07..b5bd9b06da89e 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4213,11 +4213,6 @@ static int ath11k_mac_op_start(struct ieee80211_hw *hw)
 	/* Configure the hash seed for hash based reo dest ring selection */
 	ath11k_wmi_pdev_lro_cfg(ar, ar->pdev->pdev_id);
 
-	mutex_unlock(&ar->conf_mutex);
-
-	rcu_assign_pointer(ab->pdevs_active[ar->pdev_idx],
-			   &ab->pdevs[ar->pdev_idx]);
-
 	/* allow device to enter IMPS */
 	if (ab->hw_params.idle_ps) {
 		ret = ath11k_wmi_pdev_set_param(ar, WMI_PDEV_PARAM_IDLE_PS_CONFIG,
@@ -4227,6 +4222,12 @@ static int ath11k_mac_op_start(struct ieee80211_hw *hw)
 			goto err;
 		}
 	}
+
+	mutex_unlock(&ar->conf_mutex);
+
+	rcu_assign_pointer(ab->pdevs_active[ar->pdev_idx],
+			   &ab->pdevs[ar->pdev_idx]);
+
 	return 0;
 
 err:
-- 
2.27.0



