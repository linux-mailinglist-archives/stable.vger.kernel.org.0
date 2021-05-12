Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4049837CF16
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241498AbhELRIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244435AbhELQqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:46:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E504661E77;
        Wed, 12 May 2021 16:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836091;
        bh=m1E1TLUF4UBhP6QbE9Gf3HS6db30AH3Yt8W9wHFxGBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVdtD0AFLm+zw7eeBeCeBf7b5Lz9lEmO8oTOHHKMSXKrBD0j1nSYTE9TgTvWyVRe8
         3Qxss3WobhMst70iDjG/vVsWwfmvZurcTC7Nil1EzYu4aYR5MOKAlJZ6ERgP/ke3sr
         RZFTDsC2K1PhinqUuquNwa9Lqq4IN4by29kHYDp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 571/677] iwlwifi: rs-fw: dont support stbc for HE 160
Date:   Wed, 12 May 2021 16:50:17 +0200
Message-Id: <20210512144856.366454267@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit a9174578262b86f15cb1882f35e53b1fae0649fd ]

Our HE doesn't support it so never set HE 160 stbc

Fixes: 3e467b8e4cf4 ("iwlwifi: rs-fw: enable STBC in he correctly")
Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210411124418.550fd1903eb7.I8ddbc2f87044a5ef78d916c9c59be797811a1b7f@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index 8772b65c9dab..2d58cb969918 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Copyright (C) 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 #include "rs.h"
 #include "fw-api.h"
@@ -72,19 +72,15 @@ static u16 rs_fw_get_config_flags(struct iwl_mvm *mvm,
 	bool vht_ena = vht_cap->vht_supported;
 	u16 flags = 0;
 
+	/* get STBC flags */
 	if (mvm->cfg->ht_params->stbc &&
 	    (num_of_ant(iwl_mvm_get_valid_tx_ant(mvm)) > 1)) {
-		if (he_cap->has_he) {
-			if (he_cap->he_cap_elem.phy_cap_info[2] &
-			    IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ)
-				flags |= IWL_TLC_MNG_CFG_FLAGS_STBC_MSK;
-
-			if (he_cap->he_cap_elem.phy_cap_info[7] &
-			    IEEE80211_HE_PHY_CAP7_STBC_RX_ABOVE_80MHZ)
-				flags |= IWL_TLC_MNG_CFG_FLAGS_HE_STBC_160MHZ_MSK;
-		} else if ((ht_cap->cap & IEEE80211_HT_CAP_RX_STBC) ||
-			   (vht_ena &&
-			    (vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK)))
+		if (he_cap->has_he && he_cap->he_cap_elem.phy_cap_info[2] &
+				      IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ)
+			flags |= IWL_TLC_MNG_CFG_FLAGS_STBC_MSK;
+		else if (vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK)
+			flags |= IWL_TLC_MNG_CFG_FLAGS_STBC_MSK;
+		else if (ht_cap->cap & IEEE80211_HT_CAP_RX_STBC)
 			flags |= IWL_TLC_MNG_CFG_FLAGS_STBC_MSK;
 	}
 
-- 
2.30.2



