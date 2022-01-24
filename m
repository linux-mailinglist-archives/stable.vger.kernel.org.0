Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC28499977
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455450AbiAXVf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:35:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42362 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452840AbiAXV1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:27:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0B06B8121C;
        Mon, 24 Jan 2022 21:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511E2C340E4;
        Mon, 24 Jan 2022 21:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059630;
        bh=3JX4NxME83wn+3Sx/vJIXU37WPkZe9zA5CufjNXYz9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNkatMxy8fR61nQ4g5mdkTTZ4nzeaXS/JfuPgYmHsbWuYrIYH1l1eu0EjPluFtGJq
         0hiCjEx0yI/5rFnn6I5YHh+PGW9WbuTJT/+rdWPl8/F6nW15JfXIj9Eb7vt2HoSQyg
         7FEjWyzzJMGtww3pyn7AJL2irrf4ZglgHvyfGinA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Edwards <CFSworks@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0680/1039] iwlwifi: recognize missing PNVM data and then log filename
Date:   Mon, 24 Jan 2022 19:41:09 +0100
Message-Id: <20220124184148.222339339@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 1db385c668d3ccb04ccdb5f0f190fd17b2db29c6 ]

We can detect that a FW SYSASSERT is due to missing PNVM data by
checking the assertion code.  When this happens, it's is useful for
the user if we print the filename where the driver is looking for the
data.

Add the PNVM missing assertion code to the dump list and print out the
name of the file we're looking for when this happens.

Reported-by: Sam Edwards <CFSworks@gmail.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211210090244.1d8725b7518a.I0c36617a7282bd445cda484d97ac4a83022706ee@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dump.c | 9 +++++++++
 drivers/net/wireless/intel/iwlwifi/fw/img.c  | 6 +++---
 drivers/net/wireless/intel/iwlwifi/fw/img.h  | 4 ++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dump.c b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
index 016b3a4c5f513..6a37933a02169 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dump.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
@@ -12,6 +12,7 @@
 #include "iwl-io.h"
 #include "iwl-prph.h"
 #include "iwl-csr.h"
+#include "pnvm.h"
 
 /*
  * Note: This structure is read from the device with IO accesses,
@@ -147,6 +148,7 @@ static void iwl_fwrt_dump_umac_error_log(struct iwl_fw_runtime *fwrt)
 	struct iwl_trans *trans = fwrt->trans;
 	struct iwl_umac_error_event_table table = {};
 	u32 base = fwrt->trans->dbg.umac_error_event_table;
+	char pnvm_name[MAX_PNVM_NAME];
 
 	if (!base &&
 	    !(fwrt->trans->dbg.error_event_table_tlv_status &
@@ -164,6 +166,13 @@ static void iwl_fwrt_dump_umac_error_log(struct iwl_fw_runtime *fwrt)
 			fwrt->trans->status, table.valid);
 	}
 
+	if ((table.error_id & ~FW_SYSASSERT_CPU_MASK) ==
+	    FW_SYSASSERT_PNVM_MISSING) {
+		iwl_pnvm_get_fs_name(trans, pnvm_name, sizeof(pnvm_name));
+		IWL_ERR(fwrt, "PNVM data is missing, please install %s\n",
+			pnvm_name);
+	}
+
 	IWL_ERR(fwrt, "0x%08X | %s\n", table.error_id,
 		iwl_fw_lookup_assert_desc(table.error_id));
 	IWL_ERR(fwrt, "0x%08X | umac branchlink1\n", table.blink1);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/img.c b/drivers/net/wireless/intel/iwlwifi/fw/img.c
index 24a9666736913..530674a35eeb2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/img.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/img.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright(c) 2019 - 2020 Intel Corporation
+ * Copyright(c) 2019 - 2021 Intel Corporation
  */
 
 #include "img.h"
@@ -49,10 +49,9 @@ u8 iwl_fw_lookup_notif_ver(const struct iwl_fw *fw, u8 grp, u8 cmd, u8 def)
 }
 EXPORT_SYMBOL_GPL(iwl_fw_lookup_notif_ver);
 
-#define FW_SYSASSERT_CPU_MASK 0xf0000000
 static const struct {
 	const char *name;
-	u8 num;
+	u32 num;
 } advanced_lookup[] = {
 	{ "NMI_INTERRUPT_WDG", 0x34 },
 	{ "SYSASSERT", 0x35 },
@@ -73,6 +72,7 @@ static const struct {
 	{ "NMI_INTERRUPT_ACTION_PT", 0x7C },
 	{ "NMI_INTERRUPT_UNKNOWN", 0x84 },
 	{ "NMI_INTERRUPT_INST_ACTION_PT", 0x86 },
+	{ "PNVM_MISSING", FW_SYSASSERT_PNVM_MISSING },
 	{ "ADVANCED_SYSASSERT", 0 },
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/img.h b/drivers/net/wireless/intel/iwlwifi/fw/img.h
index 993bda17fa309..fa7b1780064c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/img.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/img.h
@@ -279,4 +279,8 @@ u8 iwl_fw_lookup_cmd_ver(const struct iwl_fw *fw, u8 grp, u8 cmd, u8 def);
 
 u8 iwl_fw_lookup_notif_ver(const struct iwl_fw *fw, u8 grp, u8 cmd, u8 def);
 const char *iwl_fw_lookup_assert_desc(u32 num);
+
+#define FW_SYSASSERT_CPU_MASK		0xf0000000
+#define FW_SYSASSERT_PNVM_MISSING	0x0010070d
+
 #endif  /* __iwl_fw_img_h__ */
-- 
2.34.1



