Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D096A1ACBC6
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442661AbgDPPtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:49:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896676AbgDPNdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:33:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67AEE221EB;
        Thu, 16 Apr 2020 13:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043978;
        bh=09QvhtRGrOLEMW1wLzmWFmr4KotkIXwu4+Ba9yZJCU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m7BjCClZIkuZhyaBy/OOSJYa/pVSF+VfHQn6XYfZm4MpL4z2OpesUVdL3qurJjkLV
         ighB3+kkWhzwgPBsVt49+zqUjBlpj7nmCILuFtO+nZsmv+cOriIcK3f91ZcdMJdwOx
         1cvHBZnvQDmsg5+U8eOvFCrxVQHal3csxIpgsLBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 006/257] iwlwifi: mvm: Fix rate scale NSS configuration
Date:   Thu, 16 Apr 2020 15:20:57 +0200
Message-Id: <20200416131326.670770834@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit ce19801ba75a902ab515dda03b57738c708d0781 ]

The TLC configuration did not take into consideration the station's
SMPS configuration, and thus configured rates for 2 NSS even if
static SMPS was reported by the station. Fix this.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200306151129.b4f940d13eca.Ieebfa889d08205a3a961ae0138fb5832e8a0f9c1@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    | 29 ++++++++++++++-----
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index 80ef238a84884..ca99a9c4f70ef 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2017        Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2018 - 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -27,7 +27,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2017        Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2018 - 2020 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -195,11 +195,13 @@ rs_fw_vht_set_enabled_rates(const struct ieee80211_sta *sta,
 {
 	u16 supp;
 	int i, highest_mcs;
+	u8 nss = sta->rx_nss;
 
-	for (i = 0; i < sta->rx_nss; i++) {
-		if (i == IWL_TLC_NSS_MAX)
-			break;
+	/* the station support only a single receive chain */
+	if (sta->smps_mode == IEEE80211_SMPS_STATIC)
+		nss = 1;
 
+	for (i = 0; i < nss && i < IWL_TLC_NSS_MAX; i++) {
 		highest_mcs = rs_fw_vht_highest_rx_mcs_index(vht_cap, i + 1);
 		if (!highest_mcs)
 			continue;
@@ -245,8 +247,13 @@ rs_fw_he_set_enabled_rates(const struct ieee80211_sta *sta,
 	u16 tx_mcs_160 =
 		le16_to_cpu(sband->iftype_data->he_cap.he_mcs_nss_supp.tx_mcs_160);
 	int i;
+	u8 nss = sta->rx_nss;
 
-	for (i = 0; i < sta->rx_nss && i < IWL_TLC_NSS_MAX; i++) {
+	/* the station support only a single receive chain */
+	if (sta->smps_mode == IEEE80211_SMPS_STATIC)
+		nss = 1;
+
+	for (i = 0; i < nss && i < IWL_TLC_NSS_MAX; i++) {
 		u16 _mcs_160 = (mcs_160 >> (2 * i)) & 0x3;
 		u16 _mcs_80 = (mcs_80 >> (2 * i)) & 0x3;
 		u16 _tx_mcs_160 = (tx_mcs_160 >> (2 * i)) & 0x3;
@@ -307,8 +314,14 @@ static void rs_fw_set_supp_rates(struct ieee80211_sta *sta,
 		cmd->mode = IWL_TLC_MNG_MODE_HT;
 		cmd->ht_rates[IWL_TLC_NSS_1][IWL_TLC_HT_BW_NONE_160] =
 			cpu_to_le16(ht_cap->mcs.rx_mask[0]);
-		cmd->ht_rates[IWL_TLC_NSS_2][IWL_TLC_HT_BW_NONE_160] =
-			cpu_to_le16(ht_cap->mcs.rx_mask[1]);
+
+		/* the station support only a single receive chain */
+		if (sta->smps_mode == IEEE80211_SMPS_STATIC)
+			cmd->ht_rates[IWL_TLC_NSS_2][IWL_TLC_HT_BW_NONE_160] =
+				0;
+		else
+			cmd->ht_rates[IWL_TLC_NSS_2][IWL_TLC_HT_BW_NONE_160] =
+				cpu_to_le16(ht_cap->mcs.rx_mask[1]);
 	}
 }
 
-- 
2.20.1



