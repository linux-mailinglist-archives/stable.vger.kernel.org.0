Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9082B10BD8C
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731081AbfK0U4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:56:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731067AbfK0U4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:56:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 629F22068E;
        Wed, 27 Nov 2019 20:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888195;
        bh=40KOctADMc2kGz5duai8pYEfu7RExPJwRBK9jHSlvf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GiPjF41Yiok0hGIgiDGpnHydX2mSh/NCZs5QdS1TMp567V4WWPohigVnF2nW61O9w
         Wzxs8qbBCYgcoQS0T1UjnHXn6rHhbxiBUSbRmW35Q/eeEdjcxbNUQS1+PlRCoOR6Y/
         zyZTsKRd68Or7Ut/oU9WUucQA50u9/p3jNzOU7Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/306] ath10k: set probe request oui during driver start
Date:   Wed, 27 Nov 2019 21:28:10 +0100
Message-Id: <20191127203117.777116671@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

[ Upstream commit f1157695c527d4ee949ac83f743f80107751a70c ]

Currently the wmi command for setting probe request
oui, needed for mac randomization, is sent during
the mac register. At this time, during the driver
init the wmi has already been detached. This can
cause unexpected behavior since the firmware is
already down and the wmi has been detached.

Send the wmi command for setting probe request
oui during the driver start. This will make sure
that the firmware is started and wmi is initialized
before we send this command.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Fixes: 60e1d0fb290197fe505dff6e4e3b7e4d258dbf60
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d3d33cc2adfde..613ca74f1b286 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4686,6 +4686,14 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto err_core_stop;
 	}
 
+	if (test_bit(WMI_SERVICE_SPOOF_MAC_SUPPORT, ar->wmi.svc_map)) {
+		ret = ath10k_wmi_scan_prob_req_oui(ar, ar->mac_addr);
+		if (ret) {
+			ath10k_err(ar, "failed to set prob req oui: %i\n", ret);
+			goto err_core_stop;
+		}
+	}
+
 	if (test_bit(WMI_SERVICE_ADAPTIVE_OCS, ar->wmi.svc_map)) {
 		ret = ath10k_wmi_adaptive_qcs(ar, true);
 		if (ret) {
@@ -8551,12 +8559,6 @@ int ath10k_mac_register(struct ath10k *ar)
 	}
 
 	if (test_bit(WMI_SERVICE_SPOOF_MAC_SUPPORT, ar->wmi.svc_map)) {
-		ret = ath10k_wmi_scan_prob_req_oui(ar, ar->mac_addr);
-		if (ret) {
-			ath10k_err(ar, "failed to set prob req oui: %i\n", ret);
-			goto err_dfs_detector_exit;
-		}
-
 		ar->hw->wiphy->features |=
 			NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
 	}
-- 
2.20.1



