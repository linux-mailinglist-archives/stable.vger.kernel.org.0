Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05C5C134BEF
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbgAHTsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:48:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43726 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730463AbgAHTqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:04 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHE-0006p4-76; Wed, 08 Jan 2020 19:46:00 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-007dod-6C; Wed, 08 Jan 2020 19:45:59 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "Adrian Bunk" <bunk@kernel.org>
Date:   Wed, 08 Jan 2020 19:43:50 +0000
Message-ID: <lsq.1578512578.688246585@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 52/63] mwifiex: Fix NL80211_TX_POWER_LIMITED
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Bunk <bunk@kernel.org>

commit 65a576e27309120e0621f54d5c81eb9128bd56be upstream.

NL80211_TX_POWER_LIMITED was treated as NL80211_TX_POWER_AUTOMATIC,
which is the opposite of what should happen and can cause nasty
regulatory problems.

if/else converted to a switch without default to make gcc warn
on unhandled enum values.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 3.16: adjust filenames]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/cfg80211.c  | 13 +++++++++++--
 drivers/net/wireless/mwifiex/ioctl.h     |  1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c | 11 +++++++----
 3 files changed, 19 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -343,11 +343,20 @@ mwifiex_cfg80211_set_tx_power(struct wip
 	struct mwifiex_power_cfg power_cfg;
 	int dbm = MBM_TO_DBM(mbm);
 
-	if (type == NL80211_TX_POWER_FIXED) {
+	switch (type) {
+	case NL80211_TX_POWER_FIXED:
 		power_cfg.is_power_auto = 0;
+		power_cfg.is_power_fixed = 1;
 		power_cfg.power_level = dbm;
-	} else {
+		break;
+	case NL80211_TX_POWER_LIMITED:
+		power_cfg.is_power_auto = 0;
+		power_cfg.is_power_fixed = 0;
+		power_cfg.power_level = dbm;
+		break;
+	case NL80211_TX_POWER_AUTOMATIC:
 		power_cfg.is_power_auto = 1;
+		break;
 	}
 
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -245,6 +245,7 @@ struct mwifiex_ds_encrypt_key {
 
 struct mwifiex_power_cfg {
 	u32 is_power_auto;
+	u32 is_power_fixed;
 	u32 power_level;
 };
 
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -659,6 +659,9 @@ int mwifiex_set_tx_power(struct mwifiex_
 	txp_cfg = (struct host_cmd_ds_txpwr_cfg *) buf;
 	txp_cfg->action = cpu_to_le16(HostCmd_ACT_GEN_SET);
 	if (!power_cfg->is_power_auto) {
+		u16 dbm_min = power_cfg->is_power_fixed ?
+			      dbm : priv->min_tx_power_level;
+
 		txp_cfg->mode = cpu_to_le32(1);
 		pg_tlv = (struct mwifiex_types_power_group *)
 			 (buf + sizeof(struct host_cmd_ds_txpwr_cfg));
@@ -673,7 +676,7 @@ int mwifiex_set_tx_power(struct mwifiex_
 		pg->last_rate_code = 0x03;
 		pg->modulation_class = MOD_CLASS_HR_DSSS;
 		pg->power_step = 0;
-		pg->power_min = (s8) dbm;
+		pg->power_min = (s8) dbm_min;
 		pg->power_max = (s8) dbm;
 		pg++;
 		/* Power group for modulation class OFDM */
@@ -681,7 +684,7 @@ int mwifiex_set_tx_power(struct mwifiex_
 		pg->last_rate_code = 0x07;
 		pg->modulation_class = MOD_CLASS_OFDM;
 		pg->power_step = 0;
-		pg->power_min = (s8) dbm;
+		pg->power_min = (s8) dbm_min;
 		pg->power_max = (s8) dbm;
 		pg++;
 		/* Power group for modulation class HTBW20 */
@@ -689,7 +692,7 @@ int mwifiex_set_tx_power(struct mwifiex_
 		pg->last_rate_code = 0x20;
 		pg->modulation_class = MOD_CLASS_HT;
 		pg->power_step = 0;
-		pg->power_min = (s8) dbm;
+		pg->power_min = (s8) dbm_min;
 		pg->power_max = (s8) dbm;
 		pg->ht_bandwidth = HT_BW_20;
 		pg++;
@@ -698,7 +701,7 @@ int mwifiex_set_tx_power(struct mwifiex_
 		pg->last_rate_code = 0x20;
 		pg->modulation_class = MOD_CLASS_HT;
 		pg->power_step = 0;
-		pg->power_min = (s8) dbm;
+		pg->power_min = (s8) dbm_min;
 		pg->power_max = (s8) dbm;
 		pg->ht_bandwidth = HT_BW_40;
 	}

