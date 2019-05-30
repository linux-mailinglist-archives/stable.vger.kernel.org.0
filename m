Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAE822F552
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfE3DLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728626AbfE3DLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:38 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD05C24481;
        Thu, 30 May 2019 03:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185898;
        bh=xSpoQjODxqZdFGO2ced1WiqABYFP4VZxw/aswlJFmcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sl1aIRNtdEPwwkJXyTdmakpWvIu73eC2FD5C1amfImy4sRIM5nAxemWSotXSDmAQD
         q61dLleG1FjQv/AgNWy1//hAMR7mVMiMLxs/NyeUlHfhqnZe/GOSay99U3bm5eLs9C
         nmiyTZSLCoPlIZJ+G0N1HQkhbprDPaDIvJrtKtBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lior David <liord@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 264/405] wil6210: fix return code of wmi_mgmt_tx and wmi_mgmt_tx_ext
Date:   Wed, 29 May 2019 20:04:22 -0700
Message-Id: <20190530030554.299325891@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 49122ec42634f73babb1dc96f170023e5228d080 ]

The functions that send management TX frame have 3 possible
results: success and other side acknowledged receive (ACK=1),
success and other side did not acknowledge receive(ACK=0) and
failure to send the frame. The current implementation
incorrectly reports the ACK=0 case as failure.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  5 +++++
 drivers/net/wireless/ath/wil6210/wmi.c      | 11 ++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index a1e226652b4ab..692730415d781 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1274,7 +1274,12 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     params->wait);
 
 out:
+	/* when the sent packet was not acked by receiver(ACK=0), rc will
+	 * be -EAGAIN. In this case this function needs to return success,
+	 * the ACK=0 will be reflected in tx_status.
+	 */
 	tx_status = (rc == 0);
+	rc = (rc == -EAGAIN) ? 0 : rc;
 	cfg80211_mgmt_tx_status(wdev, cookie ? *cookie : 0, buf, len,
 				tx_status, GFP_KERNEL);
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index bda4a9712f91f..63116f4b62c7f 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -3502,8 +3502,9 @@ int wmi_mgmt_tx(struct wil6210_vif *vif, const u8 *buf, size_t len)
 	rc = wmi_call(wil, WMI_SW_TX_REQ_CMDID, vif->mid, cmd, total,
 		      WMI_SW_TX_COMPLETE_EVENTID, &evt, sizeof(evt), 2000);
 	if (!rc && evt.evt.status != WMI_FW_STATUS_SUCCESS) {
-		wil_err(wil, "mgmt_tx failed with status %d\n", evt.evt.status);
-		rc = -EINVAL;
+		wil_dbg_wmi(wil, "mgmt_tx failed with status %d\n",
+			    evt.evt.status);
+		rc = -EAGAIN;
 	}
 
 	kfree(cmd);
@@ -3555,9 +3556,9 @@ int wmi_mgmt_tx_ext(struct wil6210_vif *vif, const u8 *buf, size_t len,
 	rc = wmi_call(wil, WMI_SW_TX_REQ_EXT_CMDID, vif->mid, cmd, total,
 		      WMI_SW_TX_COMPLETE_EVENTID, &evt, sizeof(evt), 2000);
 	if (!rc && evt.evt.status != WMI_FW_STATUS_SUCCESS) {
-		wil_err(wil, "mgmt_tx_ext failed with status %d\n",
-			evt.evt.status);
-		rc = -EINVAL;
+		wil_dbg_wmi(wil, "mgmt_tx_ext failed with status %d\n",
+			    evt.evt.status);
+		rc = -EAGAIN;
 	}
 
 	kfree(cmd);
-- 
2.20.1



