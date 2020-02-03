Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582D7150C89
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731321AbgBCQhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:37:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731067AbgBCQhW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:37:22 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97FFC2082E;
        Mon,  3 Feb 2020 16:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747842;
        bh=ge7LTakQNE86jfJZXXtHnWue7IyB06nHdwzzOmtn0Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdVOAMFfQS3rO2cR3tPeaU56D+qkDueW9Jha8wYlv9UdN34iaglIH94KGlEE38Nby
         sGMMtGWRiPzfoSWlSckGQ+n+Ctt80L6WsD2VX/fuQuENQ3GxKr7E7S2yh0yQlbmy94
         lMBAZp7YVY3Nd30M6kYMeEfvvUaX8wOZVvaGyvb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 62/90] iwlwifi: Dont ignore the cap field upon mcc update
Date:   Mon,  3 Feb 2020 16:20:05 +0000
Message-Id: <20200203161925.150558357@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

[ Upstream commit 2763bba6328c53c455d8f7f5302b80030551c31b ]

When receiving a new MCC driver get all the data about the new country
code and its regulatory information.
Mistakenly, we ignored the cap field, which includes global regulatory
information which should be applies to every channel.
Fix it.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 48 ++++++++++++++++++-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.h    |  6 +--
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  3 +-
 3 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index c8972f6e38bac..5d546dac78142 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -225,6 +225,34 @@ enum iwl_nvm_channel_flags {
 	NVM_CHANNEL_DC_HIGH		= BIT(12),
 };
 
+/**
+ * enum iwl_reg_capa_flags - global flags applied for the whole regulatory
+ * domain.
+ * @REG_CAPA_BF_CCD_LOW_BAND: Beam-forming or Cyclic Delay Diversity in the
+ *	2.4Ghz band is allowed.
+ * @REG_CAPA_BF_CCD_HIGH_BAND: Beam-forming or Cyclic Delay Diversity in the
+ *	5Ghz band is allowed.
+ * @REG_CAPA_160MHZ_ALLOWED: 11ac channel with a width of 160Mhz is allowed
+ *	for this regulatory domain (valid only in 5Ghz).
+ * @REG_CAPA_80MHZ_ALLOWED: 11ac channel with a width of 80Mhz is allowed
+ *	for this regulatory domain (valid only in 5Ghz).
+ * @REG_CAPA_MCS_8_ALLOWED: 11ac with MCS 8 is allowed.
+ * @REG_CAPA_MCS_9_ALLOWED: 11ac with MCS 9 is allowed.
+ * @REG_CAPA_40MHZ_FORBIDDEN: 11n channel with a width of 40Mhz is forbidden
+ *	for this regulatory domain (valid only in 5Ghz).
+ * @REG_CAPA_DC_HIGH_ENABLED: DC HIGH allowed.
+ */
+enum iwl_reg_capa_flags {
+	REG_CAPA_BF_CCD_LOW_BAND	= BIT(0),
+	REG_CAPA_BF_CCD_HIGH_BAND	= BIT(1),
+	REG_CAPA_160MHZ_ALLOWED		= BIT(2),
+	REG_CAPA_80MHZ_ALLOWED		= BIT(3),
+	REG_CAPA_MCS_8_ALLOWED		= BIT(4),
+	REG_CAPA_MCS_9_ALLOWED		= BIT(5),
+	REG_CAPA_40MHZ_FORBIDDEN	= BIT(7),
+	REG_CAPA_DC_HIGH_ENABLED	= BIT(9),
+};
+
 static inline void iwl_nvm_print_channel_flags(struct device *dev, u32 level,
 					       int chan, u32 flags)
 {
@@ -1031,6 +1059,7 @@ IWL_EXPORT_SYMBOL(iwl_parse_nvm_data);
 
 static u32 iwl_nvm_get_regdom_bw_flags(const u16 *nvm_chan,
 				       int ch_idx, u16 nvm_flags,
+				       u16 cap_flags,
 				       const struct iwl_cfg *cfg)
 {
 	u32 flags = NL80211_RRF_NO_HT40;
@@ -1069,13 +1098,27 @@ static u32 iwl_nvm_get_regdom_bw_flags(const u16 *nvm_chan,
 	    (flags & NL80211_RRF_NO_IR))
 		flags |= NL80211_RRF_GO_CONCURRENT;
 
+	/*
+	 * cap_flags is per regulatory domain so apply it for every channel
+	 */
+	if (ch_idx >= NUM_2GHZ_CHANNELS) {
+		if (cap_flags & REG_CAPA_40MHZ_FORBIDDEN)
+			flags |= NL80211_RRF_NO_HT40;
+
+		if (!(cap_flags & REG_CAPA_80MHZ_ALLOWED))
+			flags |= NL80211_RRF_NO_80MHZ;
+
+		if (!(cap_flags & REG_CAPA_160MHZ_ALLOWED))
+			flags |= NL80211_RRF_NO_160MHZ;
+	}
+
 	return flags;
 }
 
 struct ieee80211_regdomain *
 iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 		       int num_of_ch, __le32 *channels, u16 fw_mcc,
-		       u16 geo_info)
+		       u16 geo_info, u16 cap)
 {
 	int ch_idx;
 	u16 ch_flags;
@@ -1133,7 +1176,8 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 		}
 
 		reg_rule_flags = iwl_nvm_get_regdom_bw_flags(nvm_chan, ch_idx,
-							     ch_flags, cfg);
+							     ch_flags, cap,
+							     cfg);
 
 		/* we can't continue the same rule */
 		if (ch_idx == 0 || prev_reg_rule_flags != reg_rule_flags ||
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
index b7e1ddf8f177b..4eeedb41e9ac7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2008 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -29,7 +29,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -103,7 +103,7 @@ iwl_parse_nvm_data(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 struct ieee80211_regdomain *
 iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 		       int num_of_ch, __le32 *channels, u16 fw_mcc,
-		       u16 geo_info);
+		       u16 geo_info, u16 cap);
 
 /**
  * struct iwl_nvm_section - describes an NVM section in memory.
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 49aeab7c27a27..18ccc2692437f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -256,7 +256,8 @@ struct ieee80211_regdomain *iwl_mvm_get_regdomain(struct wiphy *wiphy,
 				      __le32_to_cpu(resp->n_channels),
 				      resp->channels,
 				      __le16_to_cpu(resp->mcc),
-				      __le16_to_cpu(resp->geo_info));
+				      __le16_to_cpu(resp->geo_info),
+				      __le16_to_cpu(resp->cap));
 	/* Store the return source id */
 	src_id = resp->source_id;
 	kfree(resp);
-- 
2.20.1



