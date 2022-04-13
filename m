Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D2C4FF1F6
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 10:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbiDMIeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 04:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbiDMIeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 04:34:05 -0400
Received: from farmhouse.coelho.fi (paleale.coelho.fi [176.9.41.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A1845AF0
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 01:31:44 -0700 (PDT)
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <luca@coelho.fi>)
        id 1neY0o-0002PU-UQ;
        Wed, 13 Apr 2022 11:06:04 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     stable@vger.kernel.org
Cc:     gregory.greenman@intel.com, luca@coelho.fi
Date:   Wed, 13 Apr 2022 11:06:00 +0300
Message-Id: <20220413080600.281718-1-luca@coelho.fi>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <1648991790212197@kroah.com>
References: <1648991790212197@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
Subject: [PATCH 5.17] iwlwifi: yoyo: fix DBGI_SRAM ini dump header.
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rotem Saado <rotem.saado@intel.com>

commit 34bc27783a31a05d2fb987d8fa0f4f702efd0359 upstream.

DBGI SRAM is new type of monitor, therefore it should be
dump as monitor type with ini dump monitor header.

Signed-off-by: Rotem Saado <rotem.saado@intel.com>
Fixes: 89639e06d0f3 ("iwlwifi: yoyo: support for new DBGI_SRAM region")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220129105618.6c31f6a2dcfc.If311c1d548bc5f7157a449e848ea01f71f5592eb@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  6 ++++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 29 +++++++++++++++++--
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |  2 ++
 4 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 330ef04ca51a..d7b18d9e39e5 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -299,6 +299,12 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 			.addr = DBGC_CUR_DBGBUF_STATUS,			\
 			.mask = DBGC_CUR_DBGBUF_STATUS_IDX_MSK,		\
 		},							\
+	},								\
+	.mon_dbgi_regs = {						\
+		.write_ptr = {						\
+			.addr = DBGI_SRAM_FIFO_POINTERS,		\
+			.mask = DBGI_SRAM_FIFO_POINTERS_WR_PTR_MSK,	\
+		},							\
 	}
 
 const struct iwl_cfg_trans_params iwl_qnj_trans_cfg = {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 372cc950cc88..e4e75139343f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1694,6 +1694,17 @@ iwl_dump_ini_mon_smem_fill_header(struct iwl_fw_runtime *fwrt,
 					    &fwrt->trans->cfg->mon_smem_regs);
 }
 
+static void *
+iwl_dump_ini_mon_dbgi_fill_header(struct iwl_fw_runtime *fwrt,
+				  struct iwl_dump_ini_region_data *reg_data,
+				  void *data, u32 data_len)
+{
+	struct iwl_fw_ini_monitor_dump *mon_dump = (void *)data;
+
+	return iwl_dump_ini_mon_fill_header(fwrt, reg_data, mon_dump,
+					    &fwrt->trans->cfg->mon_dbgi_regs);
+}
+
 static void *
 iwl_dump_ini_err_table_fill_header(struct iwl_fw_runtime *fwrt,
 				   struct iwl_dump_ini_region_data *reg_data,
@@ -1859,6 +1870,20 @@ iwl_dump_ini_mon_smem_get_size(struct iwl_fw_runtime *fwrt,
 	return size;
 }
 
+static u32 iwl_dump_ini_mon_dbgi_get_size(struct iwl_fw_runtime *fwrt,
+					  struct iwl_dump_ini_region_data *reg_data)
+{
+	struct iwl_fw_ini_region_tlv *reg = (void *)reg_data->reg_tlv->data;
+	u32 size = le32_to_cpu(reg->dev_addr.size);
+	u32 ranges = iwl_dump_ini_mem_ranges(fwrt, reg_data);
+
+	if (!size || !ranges)
+		return 0;
+
+	return sizeof(struct iwl_fw_ini_monitor_dump) + ranges *
+		(size + sizeof(struct iwl_fw_ini_error_dump_range));
+}
+
 static u32 iwl_dump_ini_txf_get_size(struct iwl_fw_runtime *fwrt,
 				     struct iwl_dump_ini_region_data *reg_data)
 {
@@ -2253,8 +2278,8 @@ static const struct iwl_dump_ini_mem_ops iwl_dump_ini_region_ops[] = {
 	},
 	[IWL_FW_INI_REGION_DBGI_SRAM] = {
 		.get_num_of_ranges = iwl_dump_ini_mem_ranges,
-		.get_size = iwl_dump_ini_mem_get_size,
-		.fill_mem_hdr = iwl_dump_ini_mem_fill_header,
+		.get_size = iwl_dump_ini_mon_dbgi_get_size,
+		.fill_mem_hdr = iwl_dump_ini_mon_dbgi_fill_header,
 		.fill_range = iwl_dump_ini_dbgi_sram_iter,
 	},
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index e122b8b4e1fc..d5907521853a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -408,6 +408,7 @@ struct iwl_cfg {
 	u32 min_256_ba_txq_size;
 	const struct iwl_fw_mon_regs mon_dram_regs;
 	const struct iwl_fw_mon_regs mon_smem_regs;
+	const struct iwl_fw_mon_regs mon_dbgi_regs;
 };
 
 #define IWL_CFG_ANY (~0)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 9331a6b6bf36..8d37a7e8fa6e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -356,6 +356,8 @@
 /* DBGI SRAM Register details */
 #define DBGI_SRAM_TARGET_ACCESS_RDATA_LSB		0x00A2E154
 #define DBGI_SRAM_TARGET_ACCESS_RDATA_MSB		0x00A2E158
+#define DBGI_SRAM_FIFO_POINTERS				0x00A2E148
+#define DBGI_SRAM_FIFO_POINTERS_WR_PTR_MSK		0x00000FFF
 
 enum {
 	ENABLE_WFPM = BIT(31),
-- 
2.35.1

