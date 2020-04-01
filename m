Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED7B19AFAE
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732692AbgDAQUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:20:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732776AbgDAQUK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:20:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA06320658;
        Wed,  1 Apr 2020 16:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758009;
        bh=1uym/NfZoYYtSW6PsOW9L9OYHhSkLVLhOmrYVWsoVtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zMj963TJE06qFsAMShTWU9X05SHzGfUv0j1aZksK0tqmZy0sHtHOPHoIkxR0FmQx3
         XOeqJMZ+2Q/wKR8VGG9+yjGEds6WQsG7mh/STrjYlQ4SWpDnPXH/gVLVGigdGuySin
         IpdG7FPpdlla8vL4xo/CuqZQRbixH2veuDzpsNRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Jonathan McDowell <noodles@earth.li>,
        Len Brown <len.brown@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 5.5 14/30] iwlwifi: dont send GEO_TX_POWER_LIMIT if no wgds table
Date:   Wed,  1 Apr 2020 18:17:18 +0200
Message-Id: <20200401161426.829341597@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.345528747@linuxfoundation.org>
References: <20200401161414.345528747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Golan Ben Ami <golan.ben.ami@intel.com>

commit 0433ae556ec8fb588a0735ddb09d3eb9806df479 upstream.

The GEO_TX_POWER_LIMIT command was sent although
there is no wgds table, so the fw got wrong SAR values
from the driver.

Fix this by avoiding sending the command if no wgds
tables are available.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Fixes: 39c1a9728f93 ("iwlwifi: refactor the SAR tables from mvm to acpi")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Tested-By: Jonathan McDowell <noodles@earth.li>
Tested-by: Len Brown <len.brown@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20200318081237.46db40617cc6.Id5cf852ec8c5dbf20ba86bad7b165a0c828f8b2e@changeid
Cc: Felipe Contreras <felipe.contreras@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c |   14 ++++++++------
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h |   14 ++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  |    9 ++++++++-
 3 files changed, 24 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2017        Intel Deutschland GmbH
- * Copyright (C) 2019 Intel Corporation
+ * Copyright (C) 2019 - 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -27,7 +27,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2017        Intel Deutschland GmbH
- * Copyright (C) 2019 Intel Corporation
+ * Copyright (C) 2019 - 2020 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -491,13 +491,13 @@ int iwl_validate_sar_geo_profile(struct
 }
 IWL_EXPORT_SYMBOL(iwl_validate_sar_geo_profile);
 
-void iwl_sar_geo_init(struct iwl_fw_runtime *fwrt,
-		      struct iwl_per_chain_offset_group *table)
+int iwl_sar_geo_init(struct iwl_fw_runtime *fwrt,
+		     struct iwl_per_chain_offset_group *table)
 {
 	int ret, i, j;
 
 	if (!iwl_sar_geo_support(fwrt))
-		return;
+		return -EOPNOTSUPP;
 
 	ret = iwl_sar_get_wgds_table(fwrt);
 	if (ret < 0) {
@@ -505,7 +505,7 @@ void iwl_sar_geo_init(struct iwl_fw_runt
 				"Geo SAR BIOS table invalid or unavailable. (%d)\n",
 				ret);
 		/* we don't fail if the table is not available */
-		return;
+		return -ENOENT;
 	}
 
 	BUILD_BUG_ON(ACPI_NUM_GEO_PROFILES * ACPI_WGDS_NUM_BANDS *
@@ -530,5 +530,7 @@ void iwl_sar_geo_init(struct iwl_fw_runt
 					i, j, value[1], value[2], value[0]);
 		}
 	}
+
+	return 0;
 }
 IWL_EXPORT_SYMBOL(iwl_sar_geo_init);
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2017        Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019        Intel Corporation
+ * Copyright(c) 2018 - 2020        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -27,7 +27,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2017        Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019       Intel Corporation
+ * Copyright(c) 2018 - 2020       Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -171,8 +171,9 @@ bool iwl_sar_geo_support(struct iwl_fw_r
 int iwl_validate_sar_geo_profile(struct iwl_fw_runtime *fwrt,
 				 struct iwl_host_cmd *cmd);
 
-void iwl_sar_geo_init(struct iwl_fw_runtime *fwrt,
-		      struct iwl_per_chain_offset_group *table);
+int iwl_sar_geo_init(struct iwl_fw_runtime *fwrt,
+		     struct iwl_per_chain_offset_group *table);
+
 #else /* CONFIG_ACPI */
 
 static inline void *iwl_acpi_get_object(struct device *dev, acpi_string method)
@@ -243,9 +244,10 @@ static inline int iwl_validate_sar_geo_p
 	return -ENOENT;
 }
 
-static inline void iwl_sar_geo_init(struct iwl_fw_runtime *fwrt,
-				    struct iwl_per_chain_offset_group *table)
+static inline int iwl_sar_geo_init(struct iwl_fw_runtime *fwrt,
+				   struct iwl_per_chain_offset_group *table)
 {
+	return -ENOENT;
 }
 
 #endif /* CONFIG_ACPI */
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -749,10 +749,17 @@ static int iwl_mvm_sar_geo_init(struct i
 	u16 cmd_wide_id =  WIDE_ID(PHY_OPS_GROUP, GEO_TX_POWER_LIMIT);
 	union geo_tx_power_profiles_cmd cmd;
 	u16 len;
+	int ret;
 
 	cmd.geo_cmd.ops = cpu_to_le32(IWL_PER_CHAIN_OFFSET_SET_TABLES);
 
-	iwl_sar_geo_init(&mvm->fwrt, cmd.geo_cmd.table);
+	ret = iwl_sar_geo_init(&mvm->fwrt, cmd.geo_cmd.table);
+	/*
+	 * It is a valid scenario to not support SAR, or miss wgds table,
+	 * but in that case there is no need to send the command.
+	 */
+	if (ret)
+		return 0;
 
 	cmd.geo_cmd.table_revision = cpu_to_le32(mvm->fwrt.geo_rev);
 


