Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C0010B8C4
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729872AbfK0Uq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:46:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbfK0Uq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:46:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 516D4217AB;
        Wed, 27 Nov 2019 20:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887585;
        bh=YqUcwOq8I3LA1ZX50LegnrMryAU6YaLufek0Ui9iE+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uq7HxPXyBzAMINaBWJbHMD6hiTej7uEYa+FXicX7pzVD82n6VIwuu774KyNGZfTOG
         3BYIJ6n2j2+xAXW6noGTHY4poK/vsm+VABr/hsl+2A1QAW5zpDtBP9mS5xqeK/w9tv
         6dsaIsTYZsbj7eQKoCw7ji/l+tg3JY+6V1LOIICU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 017/211] mwifiex: Fix NL80211_TX_POWER_LIMITED
Date:   Wed, 27 Nov 2019 21:29:10 +0100
Message-Id: <20191127203052.496121197@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

[ Upstream commit 65a576e27309120e0621f54d5c81eb9128bd56be ]

NL80211_TX_POWER_LIMITED was treated as NL80211_TX_POWER_AUTOMATIC,
which is the opposite of what should happen and can cause nasty
regulatory problems.

if/else converted to a switch without default to make gcc warn
on unhandled enum values.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c  | 13 +++++++++++--
 drivers/net/wireless/marvell/mwifiex/ioctl.h     |  1 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 11 +++++++----
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index dde47c5488184..5e8e34a08b2d6 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -362,11 +362,20 @@ mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
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
diff --git a/drivers/net/wireless/marvell/mwifiex/ioctl.h b/drivers/net/wireless/marvell/mwifiex/ioctl.h
index 48e154e1865df..0dd592ea6e833 100644
--- a/drivers/net/wireless/marvell/mwifiex/ioctl.h
+++ b/drivers/net/wireless/marvell/mwifiex/ioctl.h
@@ -267,6 +267,7 @@ struct mwifiex_ds_encrypt_key {
 
 struct mwifiex_power_cfg {
 	u32 is_power_auto;
+	u32 is_power_fixed;
 	u32 power_level;
 };
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 82828a2079638..a8043d76152a4 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -728,6 +728,9 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 	txp_cfg = (struct host_cmd_ds_txpwr_cfg *) buf;
 	txp_cfg->action = cpu_to_le16(HostCmd_ACT_GEN_SET);
 	if (!power_cfg->is_power_auto) {
+		u16 dbm_min = power_cfg->is_power_fixed ?
+			      dbm : priv->min_tx_power_level;
+
 		txp_cfg->mode = cpu_to_le32(1);
 		pg_tlv = (struct mwifiex_types_power_group *)
 			 (buf + sizeof(struct host_cmd_ds_txpwr_cfg));
@@ -742,7 +745,7 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		pg->last_rate_code = 0x03;
 		pg->modulation_class = MOD_CLASS_HR_DSSS;
 		pg->power_step = 0;
-		pg->power_min = (s8) dbm;
+		pg->power_min = (s8) dbm_min;
 		pg->power_max = (s8) dbm;
 		pg++;
 		/* Power group for modulation class OFDM */
@@ -750,7 +753,7 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		pg->last_rate_code = 0x07;
 		pg->modulation_class = MOD_CLASS_OFDM;
 		pg->power_step = 0;
-		pg->power_min = (s8) dbm;
+		pg->power_min = (s8) dbm_min;
 		pg->power_max = (s8) dbm;
 		pg++;
 		/* Power group for modulation class HTBW20 */
@@ -758,7 +761,7 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		pg->last_rate_code = 0x20;
 		pg->modulation_class = MOD_CLASS_HT;
 		pg->power_step = 0;
-		pg->power_min = (s8) dbm;
+		pg->power_min = (s8) dbm_min;
 		pg->power_max = (s8) dbm;
 		pg->ht_bandwidth = HT_BW_20;
 		pg++;
@@ -767,7 +770,7 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		pg->last_rate_code = 0x20;
 		pg->modulation_class = MOD_CLASS_HT;
 		pg->power_step = 0;
-		pg->power_min = (s8) dbm;
+		pg->power_min = (s8) dbm_min;
 		pg->power_max = (s8) dbm;
 		pg->ht_bandwidth = HT_BW_40;
 	}
-- 
2.20.1



