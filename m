Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D54A2011FB
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404179AbgFSPZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393070AbgFSPZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:25:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41B0A20B80;
        Fri, 19 Jun 2020 15:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580351;
        bh=RErxoPQL57Pp8qE20X8tNu1DhNmZrHDXsOBxyT30KC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0AhGZjDVwJ/ii4/Sp7zFTYOf5x5eKv63JnaGj2uHjvP78eCc9MLRqe55mgYwNN1Dk
         95Ck29+OVb4dzrJCD/iTPNyasFMEd7OQFCRPF+5gwsXah2AjyeclZ73wIwO2LXaXIa
         2hvYe3A9Mbo+GuE5lD3ETKpUWq0MZfnHLnMAp3HI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 186/376] brcmfmac: fix WPA/WPA2-PSK 4-way handshake offload and SAE offload failures
Date:   Fri, 19 Jun 2020 16:31:44 +0200
Message-Id: <20200619141719.154196204@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

[ Upstream commit b2fe11f0777311a764e47e2f9437809b4673b7b1 ]

An incorrect value of use_fwsup is set for 4-way handshake offload for
WPA//WPA2-PSK, caused by commit 3b1e0a7bdfee ("brcmfmac: add support for
SAE authentication offload"). It results in missing bit
BRCMF_VIF_STATUS_EAP_SUCCESS set in brcmf_is_linkup() and causes the
failure. This patch correct the value for the case.

Also setting bit BRCMF_VIF_STATUS_EAP_SUCCESS for SAE offload case in
brcmf_is_linkup() to fix SAE offload failure.

Fixes: 3b1e0a7bdfee ("brcmfmac: add support for SAE authentication offload")
Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1589277788-119966-1-git-send-email-chi-hsien.lin@cypress.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 2ba165330038..bacd762cdf3e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1819,6 +1819,10 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 		switch (sme->crypto.akm_suites[0]) {
 		case WLAN_AKM_SUITE_SAE:
 			val = WPA3_AUTH_SAE_PSK;
+			if (sme->crypto.sae_pwd) {
+				brcmf_dbg(INFO, "using SAE offload\n");
+				profile->use_fwsup = BRCMF_PROFILE_FWSUP_SAE;
+			}
 			break;
 		default:
 			bphy_err(drvr, "invalid cipher group (%d)\n",
@@ -2104,11 +2108,6 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		goto done;
 	}
 
-	if (sme->crypto.sae_pwd) {
-		brcmf_dbg(INFO, "using SAE offload\n");
-		profile->use_fwsup = BRCMF_PROFILE_FWSUP_SAE;
-	}
-
 	if (sme->crypto.psk &&
 	    profile->use_fwsup != BRCMF_PROFILE_FWSUP_SAE) {
 		if (WARN_ON(profile->use_fwsup != BRCMF_PROFILE_FWSUP_NONE)) {
@@ -5495,7 +5494,8 @@ static bool brcmf_is_linkup(struct brcmf_cfg80211_vif *vif,
 	u32 event = e->event_code;
 	u32 status = e->status;
 
-	if (vif->profile.use_fwsup == BRCMF_PROFILE_FWSUP_PSK &&
+	if ((vif->profile.use_fwsup == BRCMF_PROFILE_FWSUP_PSK ||
+	     vif->profile.use_fwsup == BRCMF_PROFILE_FWSUP_SAE) &&
 	    event == BRCMF_E_PSK_SUP &&
 	    status == BRCMF_E_STATUS_FWSUP_COMPLETED)
 		set_bit(BRCMF_VIF_STATUS_EAP_SUCCESS, &vif->sme_state);
-- 
2.25.1



