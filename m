Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F82812C925
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387484AbfL2SBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:01:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733097AbfL2R4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B0B9222C3;
        Sun, 29 Dec 2019 17:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642196;
        bh=rmRl139AxwHsTpMf/zq6Qr0pUL5g6YxMSoOYXSDn98w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgkquZ316fjiaTl8dAsTrJ1J47BIGAG1M/WNHrfvYuJtLy4JlN3ZbLXNkaPBkO0iO
         Bkbxh1/b7rLvrM+mpw5GhClWHSM1LLpcp1T0wfigvplFz3S9TV4TDC3U0AInU71OH6
         bzROAAcUKb49NMT1aWKlPizs4xkbR0MAKbS8dEV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 383/434] ath10k: Revert "ath10k: add cleanup in ath10k_sta_state()"
Date:   Sun, 29 Dec 2019 18:27:16 +0100
Message-Id: <20191229172727.594657975@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit f4fe2e53349f1072d33c69f484dbf9d77bb8f45a ]

This reverts commit 334f5b61a6f29834e881923b98d1e27e5ce9620d.

This caused ath10k_snoc on Qualcomm MSM8998, SDM845 and QCS404 platforms to
trigger an assert in the firmware:

err_qdi.c:456:EF:wlan_process:1:cmnos_thread.c:3900:Asserted in wlan_vdev.c:_wlan_vdev_up:3219

Revert the offending commit for now.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 2b53ea6ca205..36d24ea126a2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6551,12 +6551,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 
 		spin_unlock_bh(&ar->data_lock);
 
-		if (!sta->tdls) {
-			ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
-			ath10k_mac_dec_num_stations(arvif, sta);
-			kfree(arsta->tx_stats);
+		if (!sta->tdls)
 			goto exit;
-		}
 
 		ret = ath10k_wmi_update_fw_tdls_state(ar, arvif->vdev_id,
 						      WMI_TDLS_ENABLE_ACTIVE);
-- 
2.20.1



