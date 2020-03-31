Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3222C199FEA
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 22:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgCaU03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 16:26:29 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43506 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbgCaU03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 16:26:29 -0400
Received: by mail-ot1-f65.google.com with SMTP id a6so23483821otb.10
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 13:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5biacjWwL9vWej8/K+6NDiMJSVSC78cfHx9uqKWhJHk=;
        b=LLUThaqZWg7mMXSE/kw8kkiGRmBczF/iezzplNXlI7a1isxZIpJQG9wADb4017TPux
         ezLyWAqmi7F9h1LDo+jmLT1aWSMx3sFgOCTg7s0Pxih8nHVqkxXqZlZgoWcvkOXKdVTp
         YizDXPRrbaIrFv5WhUsRpNMSeMbWeYsuWSurDH9cMrNinW+jX743PkaPC8/h7QC+XhVu
         w/dmCEVTTkt++z1e4k/AqmE/hAZZXducP2q/LMrEioPlyRcLBY7r5fj3/dAOB/Dt5j+q
         YH76oY5oJW8oGDjky/XXhTudI1gKpn1WiveDAGjxmyKF3mE+7nvlPxQM8UinRc/NZJdf
         5cww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5biacjWwL9vWej8/K+6NDiMJSVSC78cfHx9uqKWhJHk=;
        b=mQPAzIkyRoCbqIsVPmuNhK/aPih2Ie9G2n4AVOm+hrqfccQFPxM2TvBdZKh+skLTKc
         voz27tUFuWNZEK9D/1D4mpy7LRK+cbPMRheZDN0ftvgluw+UzNNJzumGmH+sgU3jeyOJ
         KoW1QZXFcqbXp2gd9Sco2XyZQZNy48y7oMwW776zmQxccG0pWxlLI5HzlIOpVXY/P38i
         C59MILVgkhOOB3wbyYxUbFrHtN/ncKrFW4J0fno2mLpAfoSRFoRXkx+loLM4fdk+r79w
         q6k8pWON1J7knv2D5/hldL4C8MoNedHL+oGlZ6YWEp+f5krKe6bD0pIah/8Pudh9vNrw
         ru+g==
X-Gm-Message-State: ANhLgQ2fzDoTlRBzzgUeRj3sezqGqxUmluZYpfLgAbawr9eQ5nxBTbDP
        F+ogY2ublccwJ9w6Sm4F6f4nhy43lQA=
X-Google-Smtp-Source: ADFU+vvhBeNI9WduAVt40sG5j7gOWMV/QOesBAILVgEUZE+Qbu9FIMPWQM19zAcpdrK8TqunrqIiOA==
X-Received: by 2002:a9d:70d0:: with SMTP id w16mr15065460otj.9.1585686386971;
        Tue, 31 Mar 2020 13:26:26 -0700 (PDT)
Received: from localhost (187-177-25-55.dynamic.axtel.net. [187.177.25.55])
        by smtp.gmail.com with ESMTPSA id x14sm4981oia.42.2020.03.31.13.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 13:26:26 -0700 (PDT)
From:   Felipe Contreras <felipe.contreras@gmail.com>
To:     stable@vger.kernel.org
Cc:     Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Jonathan McDowell <noodles@earth.li>,
        Len Brown <len.brown@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH] iwlwifi: don't send GEO_TX_POWER_LIMIT if no wgds table
Date:   Tue, 31 Mar 2020 14:26:25 -0600
Message-Id: <20200331202625.7998-1-felipe.contreras@gmail.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Golan Ben Ami <golan.ben.ami@intel.com>

commit 0433ae556ec8 upstream
version linux-5.5.y

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
Cc: <stable@vger.kernel.org>
---

Without this patch certain wireless devices simply stop working since
Linux 5.5.

---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c | 14 ++++++++------
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h | 14 ++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  |  9 ++++++++-
 3 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index 48d375a86d86..ba2aff3af0fe 100644
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
@@ -491,13 +491,13 @@ int iwl_validate_sar_geo_profile(struct iwl_fw_runtime *fwrt,
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
@@ -505,7 +505,7 @@ void iwl_sar_geo_init(struct iwl_fw_runtime *fwrt,
 				"Geo SAR BIOS table invalid or unavailable. (%d)\n",
 				ret);
 		/* we don't fail if the table is not available */
-		return;
+		return -ENOENT;
 	}
 
 	BUILD_BUG_ON(ACPI_NUM_GEO_PROFILES * ACPI_WGDS_NUM_BANDS *
@@ -530,5 +530,7 @@ void iwl_sar_geo_init(struct iwl_fw_runtime *fwrt,
 					i, j, value[1], value[2], value[0]);
 		}
 	}
+
+	return 0;
 }
 IWL_EXPORT_SYMBOL(iwl_sar_geo_init);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
index 4a6e8262974b..5590e5cc8fbb 100644
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
@@ -171,8 +171,9 @@ bool iwl_sar_geo_support(struct iwl_fw_runtime *fwrt);
 int iwl_validate_sar_geo_profile(struct iwl_fw_runtime *fwrt,
 				 struct iwl_host_cmd *cmd);
 
-void iwl_sar_geo_init(struct iwl_fw_runtime *fwrt,
-		      struct iwl_per_chain_offset_group *table);
+int iwl_sar_geo_init(struct iwl_fw_runtime *fwrt,
+		     struct iwl_per_chain_offset_group *table);
+
 #else /* CONFIG_ACPI */
 
 static inline void *iwl_acpi_get_object(struct device *dev, acpi_string method)
@@ -243,9 +244,10 @@ static inline int iwl_validate_sar_geo_profile(struct iwl_fw_runtime *fwrt,
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
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index c09624d8d7ee..81b7da5815eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -749,10 +749,17 @@ static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
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
 
-- 
2.26.0

