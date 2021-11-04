Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDE24454AF
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhKDOQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:16:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231603AbhKDOQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 171E8611C4;
        Thu,  4 Nov 2021 14:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035248;
        bh=9NQ/wQlnZGBEFQcFTSMk29QaXmqIR8ysDyYtcpB/7tM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QyAhrC6tYGd5nQjLI0aGz2HBZGI+Kr/wkgBsdZNDn+hDy38k1+j/rqfw4IpGOEdw
         dcVhMd4RGTQpbWPSs8wGM6zc93J0wfm8nsBfkdUZ1PCgyXr8T6Og+N8S40LDhhMo6a
         kD5RxZZjmtEVoa20oBN9fmmJnoUhRfUFwc+o4zY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.15 08/12] Revert "wcn36xx: Disable bmps when encryption is disabled"
Date:   Thu,  4 Nov 2021 15:12:34 +0100
Message-Id: <20211104141159.824950802@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.551636584@linuxfoundation.org>
References: <20211104141159.551636584@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 285bb1738e196507bf985574d0bc1e9dd72d46b1 upstream.

This reverts commit c6522a5076e1a65877c51cfee313a74ef61cabf8.

Testing on tip-of-tree shows that this is working now. Revert this and
re-enable BMPS for Open APs.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211022140447.2846248-3-bryan.odonoghue@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c    |   10 ----------
 drivers/net/wireless/ath/wcn36xx/pmc.c     |    5 +----
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |    1 -
 3 files changed, 1 insertion(+), 15 deletions(-)

--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -604,15 +604,6 @@ static int wcn36xx_set_key(struct ieee80
 				}
 			}
 		}
-		/* FIXME: Only enable bmps support when encryption is enabled.
-		 * For any reasons, when connected to open/no-security BSS,
-		 * the wcn36xx controller in bmps mode does not forward
-		 * 'wake-up' beacons despite AP sends DTIM with station AID.
-		 * It could be due to a firmware issue or to the way driver
-		 * configure the station.
-		 */
-		if (vif->type == NL80211_IFTYPE_STATION)
-			vif_priv->allow_bmps = true;
 		break;
 	case DISABLE_KEY:
 		if (!(IEEE80211_KEY_FLAG_PAIRWISE & key_conf->flags)) {
@@ -913,7 +904,6 @@ static void wcn36xx_bss_info_changed(str
 				    vif->addr,
 				    bss_conf->aid);
 			vif_priv->sta_assoc = false;
-			vif_priv->allow_bmps = false;
 			wcn36xx_smd_set_link_st(wcn,
 						bss_conf->bssid,
 						vif->addr,
--- a/drivers/net/wireless/ath/wcn36xx/pmc.c
+++ b/drivers/net/wireless/ath/wcn36xx/pmc.c
@@ -23,10 +23,7 @@ int wcn36xx_pmc_enter_bmps_state(struct
 {
 	int ret = 0;
 	struct wcn36xx_vif *vif_priv = wcn36xx_vif_to_priv(vif);
-
-	if (!vif_priv->allow_bmps)
-		return -ENOTSUPP;
-
+	/* TODO: Make sure the TX chain clean */
 	ret = wcn36xx_smd_enter_bmps(wcn, vif);
 	if (!ret) {
 		wcn36xx_dbg(WCN36XX_DBG_PMC, "Entered BMPS\n");
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -128,7 +128,6 @@ struct wcn36xx_vif {
 	enum wcn36xx_hal_bss_type bss_type;
 
 	/* Power management */
-	bool allow_bmps;
 	enum wcn36xx_power_state pw_state;
 
 	u8 bss_index;


