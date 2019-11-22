Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37FBB106EB9
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbfKVLA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:00:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730440AbfKVLAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:00:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1374A20706;
        Fri, 22 Nov 2019 11:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420454;
        bh=Em/6r+eVCEBPBMQzKf3l+OODRJz6v5UF0j2kgMaZOdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aArECem1CMRiYBOP4cVVJOs/0eEhBJwx8E9Dmg61rRHXMSZgAqmPU2bqA13NTOK38
         D6/nL/tBHN+FMuTZbAP/LsSB9UJgbZLjSA9b+O+S/ON2fF6+PeMKDaq6PsV8RhGK41
         PSwy38Skw5apMUVa1CBv4dG0ZWL0k6noHXOiNB2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/220] brcmfmac: reduce timeout for action frame scan
Date:   Fri, 22 Nov 2019 11:27:56 +0100
Message-Id: <20191122100920.744852084@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

[ Upstream commit edb6d6885bef82d1eac432dbeca9fbf4ec349d7e ]

Finding a common channel to send an action frame out is required for
some action types. Since a loop with several scan retry is used to find
the channel, a short wait time could be considered for each attempt.
This patch reduces the wait time from 1500 to 450 msec for each action
frame scan.

This patch fixes the WFA p2p certification 5.1.20 failure caused by the
long action frame send time.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 3e9c4f2f5dd12..7822740a8cb40 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -74,7 +74,7 @@
 #define P2P_AF_MAX_WAIT_TIME		msecs_to_jiffies(2000)
 #define P2P_INVALID_CHANNEL		-1
 #define P2P_CHANNEL_SYNC_RETRY		5
-#define P2P_AF_FRM_SCAN_MAX_WAIT	msecs_to_jiffies(1500)
+#define P2P_AF_FRM_SCAN_MAX_WAIT	msecs_to_jiffies(450)
 #define P2P_DEFAULT_SLEEP_TIME_VSDB	200
 
 /* WiFi P2P Public Action Frame OUI Subtypes */
@@ -1134,7 +1134,6 @@ static s32 brcmf_p2p_af_searching_channel(struct brcmf_p2p_info *p2p)
 {
 	struct afx_hdl *afx_hdl = &p2p->afx_hdl;
 	struct brcmf_cfg80211_vif *pri_vif;
-	unsigned long duration;
 	s32 retry;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -1150,7 +1149,6 @@ static s32 brcmf_p2p_af_searching_channel(struct brcmf_p2p_info *p2p)
 	 * pending action frame tx is cancelled.
 	 */
 	retry = 0;
-	duration = msecs_to_jiffies(P2P_AF_FRM_SCAN_MAX_WAIT);
 	while ((retry < P2P_CHANNEL_SYNC_RETRY) &&
 	       (afx_hdl->peer_chan == P2P_INVALID_CHANNEL)) {
 		afx_hdl->is_listen = false;
@@ -1158,7 +1156,8 @@ static s32 brcmf_p2p_af_searching_channel(struct brcmf_p2p_info *p2p)
 			  retry);
 		/* search peer on peer's listen channel */
 		schedule_work(&afx_hdl->afx_work);
-		wait_for_completion_timeout(&afx_hdl->act_frm_scan, duration);
+		wait_for_completion_timeout(&afx_hdl->act_frm_scan,
+					    P2P_AF_FRM_SCAN_MAX_WAIT);
 		if ((afx_hdl->peer_chan != P2P_INVALID_CHANNEL) ||
 		    (!test_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL,
 			       &p2p->status)))
@@ -1171,7 +1170,7 @@ static s32 brcmf_p2p_af_searching_channel(struct brcmf_p2p_info *p2p)
 			afx_hdl->is_listen = true;
 			schedule_work(&afx_hdl->afx_work);
 			wait_for_completion_timeout(&afx_hdl->act_frm_scan,
-						    duration);
+						    P2P_AF_FRM_SCAN_MAX_WAIT);
 		}
 		if ((afx_hdl->peer_chan != P2P_INVALID_CHANNEL) ||
 		    (!test_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL,
-- 
2.20.1



