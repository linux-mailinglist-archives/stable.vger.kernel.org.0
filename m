Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630DE40E882
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356007AbhIPRor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355406AbhIPRl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C347661A88;
        Thu, 16 Sep 2021 16:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811181;
        bh=X+FLbjA7aUy6pDS2PfreaYIzs44DNysFpu7NLz6bn04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cr3tpFcVGIjEprXLIxctCzCaxFI/Q4iLWNWq4ltGQ/UePshfwg8L8Kl5oUWmHcTD9
         9640h8MttN6ddpd5jYJ9bech8IYDuZ4NzWcmQ2t95lVIPTRPk0OruC8T5BjkUI1mOq
         dbeCsEXIkajeToU7mEcCMxUwpNipAQvOu93msPlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 370/432] iwlwifi: mvm: Fix umac scan request probe parameters
Date:   Thu, 16 Sep 2021 18:01:59 +0200
Message-Id: <20210916155823.345828857@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 35fc5feca7b24b97e828e6e6a4243b4b9b0131f8 ]

Both 'iwl_scan_probe_params_v3' and 'iwl_scan_probe_params_v4'
wrongly addressed the 'bssid_array' field which should supposed
to be any array of BSSIDs each of size ETH_ALEN and not the
opposite. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210802215208.04146f24794f.I90726440ddff75013e9fecbe9fa1a05c69e3f17b@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index b2605aefc290..8b200379f7c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2012-2014, 2018-2020 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2021 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -874,7 +874,7 @@ struct iwl_scan_probe_params_v3 {
 	u8 reserved;
 	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
 	__le32 short_ssid[SCAN_SHORT_SSID_MAX_SIZE];
-	u8 bssid_array[ETH_ALEN][SCAN_BSSID_MAX_SIZE];
+	u8 bssid_array[SCAN_BSSID_MAX_SIZE][ETH_ALEN];
 } __packed; /* SCAN_PROBE_PARAMS_API_S_VER_3 */
 
 /**
@@ -894,7 +894,7 @@ struct iwl_scan_probe_params_v4 {
 	__le16 reserved;
 	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
 	__le32 short_ssid[SCAN_SHORT_SSID_MAX_SIZE];
-	u8 bssid_array[ETH_ALEN][SCAN_BSSID_MAX_SIZE];
+	u8 bssid_array[SCAN_BSSID_MAX_SIZE][ETH_ALEN];
 } __packed; /* SCAN_PROBE_PARAMS_API_S_VER_4 */
 
 #define SCAN_MAX_NUM_CHANS_V3 67
-- 
2.30.2



