Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753D34F09D3
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 15:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358822AbiDCNSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 09:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358798AbiDCNS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 09:18:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84823E54
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 06:16:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40E0AB80D33
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 13:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF6CC340F0;
        Sun,  3 Apr 2022 13:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648991792;
        bh=fGkgNGc9jDnH9nUHGZ1ko0h8zl/R5H8b6BkC8vWXdkg=;
        h=Subject:To:Cc:From:Date:From;
        b=UCj/VaGRs3TU2etNBqv2IY4WnNcYYAoEaskFJJBoK4mCY/f8Cpcrd9U8d/VR0pGvJ
         YcQkh2rqMf4BJ9mOmz6DwGDGfhAwzDtyID9t/CBSaE3DQ+Th3BR03Oht9loOUib0Pr
         7p9kZR0HJ71Z3iGk/zz03Nif4WTzF/ve8fJ9jiHE=
Subject: FAILED: patch "[PATCH] iwlwifi: yoyo: fix DBGI_SRAM ini dump header." failed to apply to 5.15-stable tree
To:     rotem.saado@intel.com, luciano.coelho@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 15:16:30 +0200
Message-ID: <1648991790182207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 34bc27783a31a05d2fb987d8fa0f4f702efd0359 Mon Sep 17 00:00:00 2001
From: Rotem Saado <rotem.saado@intel.com>
Date: Sat, 29 Jan 2022 13:16:12 +0200
Subject: [PATCH] iwlwifi: yoyo: fix DBGI_SRAM ini dump header.

DBGI SRAM is new type of monitor, therefore it should be
dump as monitor type with ini dump monitor header.

Signed-off-by: Rotem Saado <rotem.saado@intel.com>
Fixes: 89639e06d0f3 ("iwlwifi: yoyo: support for new DBGI_SRAM region")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220129105618.6c31f6a2dcfc.If311c1d548bc5f7157a449e848ea01f71f5592eb@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 7fb209ec442d..22f33c074ac9 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -300,6 +300,12 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
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
index 5c0d094887fc..101d9085e835 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1696,6 +1696,17 @@ iwl_dump_ini_mon_smem_fill_header(struct iwl_fw_runtime *fwrt,
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
@@ -1861,6 +1872,20 @@ iwl_dump_ini_mon_smem_get_size(struct iwl_fw_runtime *fwrt,
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
@@ -2285,8 +2310,8 @@ static const struct iwl_dump_ini_mem_ops iwl_dump_ini_region_ops[] = {
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
index f46ec44da1eb..2eb7f87672b4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -408,6 +408,7 @@ struct iwl_cfg {
 	u32 min_ba_txq_size;
 	const struct iwl_fw_mon_regs mon_dram_regs;
 	const struct iwl_fw_mon_regs mon_smem_regs;
+	const struct iwl_fw_mon_regs mon_dbgi_regs;
 };
 
 #define IWL_CFG_ANY (~0)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 95b3dae7b504..186e22c4e6c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -358,6 +358,8 @@
 #define DBGI_SRAM_TARGET_ACCESS_CFG_RESET_ADDRESS_MSK	0x10000
 #define DBGI_SRAM_TARGET_ACCESS_RDATA_LSB		0x00A2E154
 #define DBGI_SRAM_TARGET_ACCESS_RDATA_MSB		0x00A2E158
+#define DBGI_SRAM_FIFO_POINTERS				0x00A2E148
+#define DBGI_SRAM_FIFO_POINTERS_WR_PTR_MSK		0x00000FFF
 
 enum {
 	ENABLE_WFPM = BIT(31),

