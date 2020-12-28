Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218FD2E4234
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436914AbgL1OCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:02:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436909AbgL1OCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB28E207B6;
        Mon, 28 Dec 2020 14:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164117;
        bh=ksdiw6UQcVF/xUC2KcPYMyRnWtQpsKdadddnRXN56ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1PzIw/i87Uf7CFwEiNPHFeZP1vk3RyD9Td3XXKiVY1YBdxIw6BsFvhCQlyj9FjiR
         VrFqaq15z+0K/wu97XWtbUzDeLW66iTsmNbRAxYGGWWHC0flBcKOmkan9JV8Ul07CO
         AFIeVbuUoLZkeod0NG9Kt6r99NCRRWlCDwH24vL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/717] ath11k: Fix number of rules in filtered ETSI regdomain
Date:   Mon, 28 Dec 2020 13:41:04 +0100
Message-Id: <20201228125024.158153730@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 6189be7d145c3a2d48514eb8755483602ff5a4b4 ]

The ath11k code will try to insert wheather rader related limits when the
DFS region is set to ETSI. For this reason, it will add two more entries in
the array of reg_rules. But the 2.4.0.1 firmware is prefiltering the list
of reg rules it returns for 2.4GHz PHYs. They will then not contain the
list of 5GHz rules and thus no wheather radar band rules were inserted by
this code.

But the code didn't fix the n_reg_rules for this regulatory domain and PHY
when this happened. This resulted in a rejection by is_valid_rd because it
found rules which start and end at 0khz. This resulted in a splat like:

  Invalid regulatory domain detected
  ------------[ cut here ]------------
  WARNING: at backports-20200628-4.4.60-9a94b73e75/net/wireless/reg.c:3721
  [...]
  ath11k c000000.wifi1: failed to perform regd update : -22

The number of rules must therefore be saved after they were converted from
the ath11k format to the ieee80211_regdomain format and not before.

Tested with IPQ8074 WLAN.HK.2.4.0.1.r1-00019-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201030101940.2387952-1-sven@narfation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/reg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
index 83f75f8855ebe..678d0885fcee7 100644
--- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -585,7 +585,6 @@ ath11k_reg_build_regd(struct ath11k_base *ab,
 	if (!tmp_regd)
 		goto ret;
 
-	tmp_regd->n_reg_rules = num_rules;
 	memcpy(tmp_regd->alpha2, reg_info->alpha2, REG_ALPHA2_LEN + 1);
 	memcpy(alpha2, reg_info->alpha2, REG_ALPHA2_LEN + 1);
 	alpha2[2] = '\0';
@@ -598,7 +597,7 @@ ath11k_reg_build_regd(struct ath11k_base *ab,
 	/* Update reg_rules[] below. Firmware is expected to
 	 * send these rules in order(2G rules first and then 5G)
 	 */
-	for (; i < tmp_regd->n_reg_rules; i++) {
+	for (; i < num_rules; i++) {
 		if (reg_info->num_2g_reg_rules &&
 		    (i < reg_info->num_2g_reg_rules)) {
 			reg_rule = reg_info->reg_rules_2g_ptr + i;
@@ -653,6 +652,8 @@ ath11k_reg_build_regd(struct ath11k_base *ab,
 			   flags);
 	}
 
+	tmp_regd->n_reg_rules = i;
+
 	if (intersect) {
 		default_regd = ab->default_regd[reg_info->phy_id];
 
-- 
2.27.0



