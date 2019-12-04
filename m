Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE46113205
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbfLDSE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:04:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730265AbfLDSEy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:04:54 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A16420659;
        Wed,  4 Dec 2019 18:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482693;
        bh=ZfXiKwwqm2R4DXLa1XPSGYx1e1bjblTR5Y61Ob2UMiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sO4CKunFrSteTJAnNUseM4Df6oCxVFdH3qkgwq76JIEJJm31h6eAGSpz66SvEoDkE
         1SX7KYgcd5fQf0gCompOjHphvsQfvdVnIuzMVW18RJQPfw/2uJ3jCr+Lxi7YWXTUdQ
         8mVoetZfuD6OEO+4VTrHtyQxKmHBcp3HnLlSA39M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 054/209] iwlwifi: move iwl_nvm_check_version() into dvm
Date:   Wed,  4 Dec 2019 18:54:26 +0100
Message-Id: <20191204175325.089483740@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 64866e5da1eabd0c52ff45029b245f5465920031 ]

This function is only half-used by mvm (i.e. only the nvm_version part
matters, since the calibration version is irrelevant), so it's
pointless to export it from iwlwifi.  If mvm uses this function, it
has the additional complexity of setting the calib version to a bogus
value on all cfg structs.

To avoid this, move the function to dvm and make a simple comparison
of the nvm_version in mvm instead.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 17 +++++++++++++++++
 .../wireless/intel/iwlwifi/iwl-eeprom-parse.c | 19 -------------------
 .../wireless/intel/iwlwifi/iwl-eeprom-parse.h |  5 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  4 +++-
 4 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 2acd94da9efeb..051a2fea95724 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1229,6 +1229,23 @@ static int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 	return 0;
 }
 
+static int iwl_nvm_check_version(struct iwl_nvm_data *data,
+				 struct iwl_trans *trans)
+{
+	if (data->nvm_version >= trans->cfg->nvm_ver ||
+	    data->calib_version >= trans->cfg->nvm_calib_ver) {
+		IWL_DEBUG_INFO(trans, "device EEPROM VER=0x%x, CALIB=0x%x\n",
+			       data->nvm_version, data->calib_version);
+		return 0;
+	}
+
+	IWL_ERR(trans,
+		"Unsupported (too old) EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
+		data->nvm_version, trans->cfg->nvm_ver,
+		data->calib_version,  trans->cfg->nvm_calib_ver);
+	return -EINVAL;
+}
+
 static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 						 const struct iwl_cfg *cfg,
 						 const struct iwl_fw *fw,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
index 3199d345b4274..92727f7e42db7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
@@ -928,22 +928,3 @@ iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
 	return NULL;
 }
 IWL_EXPORT_SYMBOL(iwl_parse_eeprom_data);
-
-/* helper functions */
-int iwl_nvm_check_version(struct iwl_nvm_data *data,
-			     struct iwl_trans *trans)
-{
-	if (data->nvm_version >= trans->cfg->nvm_ver ||
-	    data->calib_version >= trans->cfg->nvm_calib_ver) {
-		IWL_DEBUG_INFO(trans, "device EEPROM VER=0x%x, CALIB=0x%x\n",
-			       data->nvm_version, data->calib_version);
-		return 0;
-	}
-
-	IWL_ERR(trans,
-		"Unsupported (too old) EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
-		data->nvm_version, trans->cfg->nvm_ver,
-		data->calib_version,  trans->cfg->nvm_calib_ver);
-	return -EINVAL;
-}
-IWL_EXPORT_SYMBOL(iwl_nvm_check_version);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
index b33888991b946..5545210151cd9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Mobile Communications GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Mobile Communications GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -121,9 +123,6 @@ struct iwl_nvm_data *
 iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
 		      const u8 *eeprom, size_t eeprom_size);
 
-int iwl_nvm_check_version(struct iwl_nvm_data *data,
-			  struct iwl_trans *trans);
-
 int iwl_init_sband_channels(struct iwl_nvm_data *data,
 			    struct ieee80211_supported_band *sband,
 			    int n_channels, enum nl80211_band band);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 534c0ea7b232e..78228f870f8f5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -501,7 +501,9 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	if (mvm->nvm_file_name)
 		iwl_mvm_load_nvm_to_nic(mvm);
 
-	WARN_ON(iwl_nvm_check_version(mvm->nvm_data, mvm->trans));
+	WARN_ONCE(mvm->nvm_data->nvm_version < mvm->trans->cfg->nvm_ver,
+		  "Too old NVM version (0x%0x, required = 0x%0x)",
+		  mvm->nvm_data->nvm_version, mvm->trans->cfg->nvm_ver);
 
 	/*
 	 * abort after reading the nvm in case RF Kill is on, we will complete
-- 
2.20.1



