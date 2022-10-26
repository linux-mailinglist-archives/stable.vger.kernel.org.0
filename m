Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4237F60DFD3
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 13:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbiJZLlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 07:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbiJZLj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 07:39:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49122D8F61;
        Wed, 26 Oct 2022 04:38:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE4D561E4E;
        Wed, 26 Oct 2022 11:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32F7C433D6;
        Wed, 26 Oct 2022 11:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666784319;
        bh=/kx+x8DugSBNm6PW001U+9peT4Ir4QqMb5e58wt8BKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+wrPpsR7yAeYduJ1/iwqtEq2ISYmQ3E6kVehY6xNwyeFT2UUJo8Yc3AYRgyRSJod
         he84kkRfoTpwI12OA7qw8yvRq2wmUNruFNoB5lTtWq9BVwMdzoT2/oEBgUaFTcQBTM
         G1RLiWb07+Ru/zZ19Ioz2TQ5EL2KNV5kwgvaXMUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.0.4
Date:   Wed, 26 Oct 2022 13:38:22 +0200
Message-Id: <1666784302145181@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <1666784302211190@kroah.com>
References: <1666784302211190@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index d4297b3d0735..f2e41dccdd89 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 0
-SUBLEVEL = 3
+SUBLEVEL = 4
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index e4080ad96089..aa6d109fac08 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -269,6 +269,8 @@ static __init int efivar_ssdt_load(void)
 			acpi_status ret = acpi_load_table(data, NULL);
 			if (ret)
 				pr_err("failed to load table: %u\n", ret);
+			else
+				continue;
 		} else {
 			pr_err("failed to get var data: 0x%lx\n", status);
 		}
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index dd74d2ad3184..433b61587139 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/sizes.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -20,19 +21,19 @@ static struct efivars *__efivars;
 
 static DEFINE_SEMAPHORE(efivars_lock);
 
-efi_status_t check_var_size(u32 attributes, unsigned long size)
+static efi_status_t check_var_size(u32 attributes, unsigned long size)
 {
 	const struct efivar_operations *fops;
 
 	fops = __efivars->ops;
 
 	if (!fops->query_variable_store)
-		return EFI_UNSUPPORTED;
+		return (size <= SZ_64K) ? EFI_SUCCESS : EFI_OUT_OF_RESOURCES;
 
 	return fops->query_variable_store(attributes, size, false);
 }
-EXPORT_SYMBOL_NS_GPL(check_var_size, EFIVAR);
 
+static
 efi_status_t check_var_size_nonblocking(u32 attributes, unsigned long size)
 {
 	const struct efivar_operations *fops;
@@ -40,11 +41,10 @@ efi_status_t check_var_size_nonblocking(u32 attributes, unsigned long size)
 	fops = __efivars->ops;
 
 	if (!fops->query_variable_store)
-		return EFI_UNSUPPORTED;
+		return (size <= SZ_64K) ? EFI_SUCCESS : EFI_OUT_OF_RESOURCES;
 
 	return fops->query_variable_store(attributes, size, true);
 }
-EXPORT_SYMBOL_NS_GPL(check_var_size_nonblocking, EFIVAR);
 
 /**
  * efivars_kobject - get the kobject for the registered efivars
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 25e1f5ed7ead..91665fe44e7c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2926,6 +2926,14 @@ static int amdgpu_device_ip_suspend_phase1(struct amdgpu_device *adev)
 	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
 	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
 
+	/*
+	 * Per PMFW team's suggestion, driver needs to handle gfxoff
+	 * and df cstate features disablement for gpu reset(e.g. Mode1Reset)
+	 * scenario. Add the missing df cstate disablement here.
+	 */
+	if (amdgpu_dpm_set_df_cstate(adev, DF_CSTATE_DISALLOW))
+		dev_warn(adev->dev, "Failed to disallow df cstate");
+
 	for (i = adev->num_ip_blocks - 1; i >= 0; i--) {
 		if (!adev->ip_blocks[i].status.valid)
 			continue;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h
index ae2d337158f3..f77401709d83 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h
@@ -27,7 +27,7 @@
 // *** IMPORTANT ***
 // SMU TEAM: Always increment the interface version if
 // any structure is changed in this file
-#define PMFW_DRIVER_IF_VERSION 5
+#define PMFW_DRIVER_IF_VERSION 7
 
 typedef struct {
   int32_t value;
@@ -163,8 +163,8 @@ typedef struct {
   uint16_t DclkFrequency;               //[MHz]
   uint16_t MemclkFrequency;             //[MHz]
   uint16_t spare;                       //[centi]
-  uint16_t UvdActivity;                 //[centi]
   uint16_t GfxActivity;                 //[centi]
+  uint16_t UvdActivity;                 //[centi]
 
   uint16_t Voltage[2];                  //[mV] indices: VDDCR_VDD, VDDCR_SOC
   uint16_t Current[2];                  //[mA] indices: VDDCR_VDD, VDDCR_SOC
@@ -199,6 +199,19 @@ typedef struct {
   uint16_t DeviceState;
   uint16_t CurTemp;                     //[centi-Celsius]
   uint16_t spare2;
+
+  uint16_t AverageGfxclkFrequency;
+  uint16_t AverageFclkFrequency;
+  uint16_t AverageGfxActivity;
+  uint16_t AverageSocclkFrequency;
+  uint16_t AverageVclkFrequency;
+  uint16_t AverageVcnActivity;
+  uint16_t AverageDRAMReads;          //Filtered DF Bandwidth::DRAM Reads
+  uint16_t AverageDRAMWrites;         //Filtered DF Bandwidth::DRAM Writes
+  uint16_t AverageSocketPower;        //Filtered value of CurrentSocketPower
+  uint16_t AverageCorePower;          //Filtered of [sum of CorePower[8]])
+  uint16_t AverageCoreC0Residency[8]; //Filtered of [average C0 residency %  per core]
+  uint32_t MetricsCounter;            //Counts the # of metrics table parameter reads per update to the metrics table, i.e. if the metrics table update happens every 1 second, this value could be up to 1000 if the smu collected metrics data every cycle, or as low as 0 if the smu was asleep the whole time. Reset to 0 after writing.
 } SmuMetrics_t;
 
 typedef struct {
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index f442bf085a31..f75b9688f512 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -28,7 +28,7 @@
 #define SMU13_DRIVER_IF_VERSION_INV 0xFFFFFFFF
 #define SMU13_DRIVER_IF_VERSION_YELLOW_CARP 0x04
 #define SMU13_DRIVER_IF_VERSION_ALDE 0x08
-#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x05
+#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x07
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_5 0x04
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0 0x30
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_7 0x2C
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index 445005571f76..9cd005131f56 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -2242,9 +2242,17 @@ static void arcturus_get_unique_id(struct smu_context *smu)
 static int arcturus_set_df_cstate(struct smu_context *smu,
 				  enum pp_df_cstate state)
 {
+	struct amdgpu_device *adev = smu->adev;
 	uint32_t smu_version;
 	int ret;
 
+	/*
+	 * Arcturus does not need the cstate disablement
+	 * prerequisite for gpu reset.
+	 */
+	if (amdgpu_in_reset(adev) || adev->in_suspend)
+		return 0;
+
 	ret = smu_cmn_get_smc_version(smu, NULL, &smu_version);
 	if (ret) {
 		dev_err(smu->adev->dev, "Failed to get smu version!\n");
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index 619aee51b123..d30ec3005ea1 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1640,6 +1640,15 @@ static bool aldebaran_is_baco_supported(struct smu_context *smu)
 static int aldebaran_set_df_cstate(struct smu_context *smu,
 				   enum pp_df_cstate state)
 {
+	struct amdgpu_device *adev = smu->adev;
+
+	/*
+	 * Aldebaran does not need the cstate disablement
+	 * prerequisite for gpu reset.
+	 */
+	if (amdgpu_in_reset(adev) || adev->in_suspend)
+		return 0;
+
 	return smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_DFCstateControl, state, NULL);
 }
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index 1d454485e0d9..29529328152d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -119,6 +119,7 @@ static struct cmn2asic_msg_mapping smu_v13_0_0_message_map[SMU_MSG_MAX_COUNT] =
 	MSG_MAP(NotifyPowerSource,		PPSMC_MSG_NotifyPowerSource,           0),
 	MSG_MAP(Mode1Reset,			PPSMC_MSG_Mode1Reset,                  0),
 	MSG_MAP(PrepareMp1ForUnload,		PPSMC_MSG_PrepareMp1ForUnload,         0),
+	MSG_MAP(DFCstateControl,		PPSMC_MSG_SetExternalClientDfCstateAllow, 0),
 };
 
 static struct cmn2asic_mapping smu_v13_0_0_clk_map[SMU_CLK_COUNT] = {
@@ -1753,6 +1754,15 @@ static int smu_v13_0_0_set_mp1_state(struct smu_context *smu,
 	return ret;
 }
 
+static int smu_v13_0_0_set_df_cstate(struct smu_context *smu,
+				     enum pp_df_cstate state)
+{
+	return smu_cmn_send_smc_msg_with_param(smu,
+					       SMU_MSG_DFCstateControl,
+					       state,
+					       NULL);
+}
+
 static const struct pptable_funcs smu_v13_0_0_ppt_funcs = {
 	.get_allowed_feature_mask = smu_v13_0_0_get_allowed_feature_mask,
 	.set_default_dpm_table = smu_v13_0_0_set_default_dpm_table,
@@ -1822,6 +1832,7 @@ static const struct pptable_funcs smu_v13_0_0_ppt_funcs = {
 	.mode1_reset_is_support = smu_v13_0_0_is_mode1_reset_supported,
 	.mode1_reset = smu_v13_0_mode1_reset,
 	.set_mp1_state = smu_v13_0_0_set_mp1_state,
+	.set_df_cstate = smu_v13_0_0_set_df_cstate,
 };
 
 void smu_v13_0_0_set_ppt_funcs(struct smu_context *smu)
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index c422bf8a09b1..c4102cfb734c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -121,6 +121,7 @@ static struct cmn2asic_msg_mapping smu_v13_0_7_message_map[SMU_MSG_MAX_COUNT] =
 	MSG_MAP(Mode1Reset,             PPSMC_MSG_Mode1Reset,                  0),
 	MSG_MAP(PrepareMp1ForUnload,		PPSMC_MSG_PrepareMp1ForUnload,         0),
 	MSG_MAP(SetMGpuFanBoostLimitRpm,	PPSMC_MSG_SetMGpuFanBoostLimitRpm,     0),
+	MSG_MAP(DFCstateControl,		PPSMC_MSG_SetExternalClientDfCstateAllow, 0),
 };
 
 static struct cmn2asic_mapping smu_v13_0_7_clk_map[SMU_CLK_COUNT] = {
@@ -1587,6 +1588,16 @@ static bool smu_v13_0_7_is_mode1_reset_supported(struct smu_context *smu)
 
 	return true;
 }
+
+static int smu_v13_0_7_set_df_cstate(struct smu_context *smu,
+				     enum pp_df_cstate state)
+{
+	return smu_cmn_send_smc_msg_with_param(smu,
+					       SMU_MSG_DFCstateControl,
+					       state,
+					       NULL);
+}
+
 static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.get_allowed_feature_mask = smu_v13_0_7_get_allowed_feature_mask,
 	.set_default_dpm_table = smu_v13_0_7_set_default_dpm_table,
@@ -1649,6 +1660,7 @@ static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.mode1_reset_is_support = smu_v13_0_7_is_mode1_reset_supported,
 	.mode1_reset = smu_v13_0_mode1_reset,
 	.set_mp1_state = smu_v13_0_7_set_mp1_state,
+	.set_df_cstate = smu_v13_0_7_set_df_cstate,
 };
 
 void smu_v13_0_7_set_ppt_funcs(struct smu_context *smu)
diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index 7d6eb9ad7a02..459571e2cc57 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -135,18 +135,6 @@ static u32 raw_block_offset(const void *bdb, enum bdb_block_id section_id)
 	return block - bdb;
 }
 
-/* size of the block excluding the header */
-static u32 raw_block_size(const void *bdb, enum bdb_block_id section_id)
-{
-	const void *block;
-
-	block = find_raw_section(bdb, section_id);
-	if (!block)
-		return 0;
-
-	return get_blocksize(block);
-}
-
 struct bdb_block_entry {
 	struct list_head node;
 	enum bdb_block_id section_id;
@@ -231,9 +219,14 @@ static bool validate_lfp_data_ptrs(const void *bdb,
 {
 	int fp_timing_size, dvo_timing_size, panel_pnp_id_size, panel_name_size;
 	int data_block_size, lfp_data_size;
+	const void *data_block;
 	int i;
 
-	data_block_size = raw_block_size(bdb, BDB_LVDS_LFP_DATA);
+	data_block = find_raw_section(bdb, BDB_LVDS_LFP_DATA);
+	if (!data_block)
+		return false;
+
+	data_block_size = get_blocksize(data_block);
 	if (data_block_size == 0)
 		return false;
 
@@ -261,21 +254,6 @@ static bool validate_lfp_data_ptrs(const void *bdb,
 	if (16 * lfp_data_size > data_block_size)
 		return false;
 
-	/*
-	 * Except for vlv/chv machines all real VBTs seem to have 6
-	 * unaccounted bytes in the fp_timing table. And it doesn't
-	 * appear to be a really intentional hole as the fp_timing
-	 * 0xffff terminator is always within those 6 missing bytes.
-	 */
-	if (fp_timing_size + dvo_timing_size + panel_pnp_id_size != lfp_data_size &&
-	    fp_timing_size + 6 + dvo_timing_size + panel_pnp_id_size != lfp_data_size)
-		return false;
-
-	if (ptrs->ptr[0].fp_timing.offset + fp_timing_size > ptrs->ptr[0].dvo_timing.offset ||
-	    ptrs->ptr[0].dvo_timing.offset + dvo_timing_size != ptrs->ptr[0].panel_pnp_id.offset ||
-	    ptrs->ptr[0].panel_pnp_id.offset + panel_pnp_id_size != lfp_data_size)
-		return false;
-
 	/* make sure the table entries have uniform size */
 	for (i = 1; i < 16; i++) {
 		if (ptrs->ptr[i].fp_timing.table_size != fp_timing_size ||
@@ -289,6 +267,23 @@ static bool validate_lfp_data_ptrs(const void *bdb,
 			return false;
 	}
 
+	/*
+	 * Except for vlv/chv machines all real VBTs seem to have 6
+	 * unaccounted bytes in the fp_timing table. And it doesn't
+	 * appear to be a really intentional hole as the fp_timing
+	 * 0xffff terminator is always within those 6 missing bytes.
+	 */
+	if (fp_timing_size + 6 + dvo_timing_size + panel_pnp_id_size == lfp_data_size)
+		fp_timing_size += 6;
+
+	if (fp_timing_size + dvo_timing_size + panel_pnp_id_size != lfp_data_size)
+		return false;
+
+	if (ptrs->ptr[0].fp_timing.offset + fp_timing_size != ptrs->ptr[0].dvo_timing.offset ||
+	    ptrs->ptr[0].dvo_timing.offset + dvo_timing_size != ptrs->ptr[0].panel_pnp_id.offset ||
+	    ptrs->ptr[0].panel_pnp_id.offset + panel_pnp_id_size != lfp_data_size)
+		return false;
+
 	/* make sure the tables fit inside the data block */
 	for (i = 0; i < 16; i++) {
 		if (ptrs->ptr[i].fp_timing.offset + fp_timing_size > data_block_size ||
@@ -300,6 +295,15 @@ static bool validate_lfp_data_ptrs(const void *bdb,
 	if (ptrs->panel_name.offset + 16 * panel_name_size > data_block_size)
 		return false;
 
+	/* make sure fp_timing terminators are present at expected locations */
+	for (i = 0; i < 16; i++) {
+		const u16 *t = data_block + ptrs->ptr[i].fp_timing.offset +
+			fp_timing_size - 2;
+
+		if (*t != 0xffff)
+			return false;
+	}
+
 	return true;
 }
 
@@ -333,18 +337,6 @@ static bool fixup_lfp_data_ptrs(const void *bdb, void *ptrs_block)
 	return validate_lfp_data_ptrs(bdb, ptrs);
 }
 
-static const void *find_fp_timing_terminator(const u8 *data, int size)
-{
-	int i;
-
-	for (i = 0; i < size - 1; i++) {
-		if (data[i] == 0xff && data[i+1] == 0xff)
-			return &data[i];
-	}
-
-	return NULL;
-}
-
 static int make_lfp_data_ptr(struct lvds_lfp_data_ptr_table *table,
 			     int table_size, int total_size)
 {
@@ -368,11 +360,22 @@ static void next_lfp_data_ptr(struct lvds_lfp_data_ptr_table *next,
 static void *generate_lfp_data_ptrs(struct drm_i915_private *i915,
 				    const void *bdb)
 {
-	int i, size, table_size, block_size, offset;
-	const void *t0, *t1, *block;
+	int i, size, table_size, block_size, offset, fp_timing_size;
 	struct bdb_lvds_lfp_data_ptrs *ptrs;
+	const void *block;
 	void *ptrs_block;
 
+	/*
+	 * The hardcoded fp_timing_size is only valid for
+	 * modernish VBTs. All older VBTs definitely should
+	 * include block 41 and thus we don't need to
+	 * generate one.
+	 */
+	if (i915->vbt.version < 155)
+		return NULL;
+
+	fp_timing_size = 38;
+
 	block = find_raw_section(bdb, BDB_LVDS_LFP_DATA);
 	if (!block)
 		return NULL;
@@ -381,17 +384,8 @@ static void *generate_lfp_data_ptrs(struct drm_i915_private *i915,
 
 	block_size = get_blocksize(block);
 
-	size = block_size;
-	t0 = find_fp_timing_terminator(block, size);
-	if (!t0)
-		return NULL;
-
-	size -= t0 - block - 2;
-	t1 = find_fp_timing_terminator(t0 + 2, size);
-	if (!t1)
-		return NULL;
-
-	size = t1 - t0;
+	size = fp_timing_size + sizeof(struct lvds_dvo_timing) +
+		sizeof(struct lvds_pnp_id);
 	if (size * 16 > block_size)
 		return NULL;
 
@@ -409,7 +403,7 @@ static void *generate_lfp_data_ptrs(struct drm_i915_private *i915,
 	table_size = sizeof(struct lvds_dvo_timing);
 	size = make_lfp_data_ptr(&ptrs->ptr[0].dvo_timing, table_size, size);
 
-	table_size = t0 - block + 2;
+	table_size = fp_timing_size;
 	size = make_lfp_data_ptr(&ptrs->ptr[0].fp_timing, table_size, size);
 
 	if (ptrs->ptr[0].fp_timing.table_size)
@@ -424,14 +418,14 @@ static void *generate_lfp_data_ptrs(struct drm_i915_private *i915,
 		return NULL;
 	}
 
-	size = t1 - t0;
+	size = fp_timing_size + sizeof(struct lvds_dvo_timing) +
+		sizeof(struct lvds_pnp_id);
 	for (i = 1; i < 16; i++) {
 		next_lfp_data_ptr(&ptrs->ptr[i].fp_timing, &ptrs->ptr[i-1].fp_timing, size);
 		next_lfp_data_ptr(&ptrs->ptr[i].dvo_timing, &ptrs->ptr[i-1].dvo_timing, size);
 		next_lfp_data_ptr(&ptrs->ptr[i].panel_pnp_id, &ptrs->ptr[i-1].panel_pnp_id, size);
 	}
 
-	size = t1 - t0;
 	table_size = sizeof(struct lvds_lfp_panel_name);
 
 	if (16 * (size + table_size) <= block_size) {
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 50bab12d9476..043cf1cc8794 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1142,6 +1142,7 @@
 #define USB_DEVICE_ID_SONY_PS4_CONTROLLER_2	0x09cc
 #define USB_DEVICE_ID_SONY_PS4_CONTROLLER_DONGLE	0x0ba0
 #define USB_DEVICE_ID_SONY_PS5_CONTROLLER	0x0ce6
+#define USB_DEVICE_ID_SONY_PS5_CONTROLLER_2	0x0df2
 #define USB_DEVICE_ID_SONY_MOTION_CONTROLLER	0x03d5
 #define USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER	0x042f
 #define USB_DEVICE_ID_SONY_BUZZ_CONTROLLER		0x0002
diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index b1b5721b5d8f..d21d868e29ab 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -46,6 +46,7 @@ struct ps_device {
 	uint32_t fw_version;
 
 	int (*parse_report)(struct ps_device *dev, struct hid_report *report, u8 *data, int size);
+	void (*remove)(struct ps_device *dev);
 };
 
 /* Calibration data for playstation motion sensors. */
@@ -174,6 +175,7 @@ struct dualsense {
 	struct led_classdev player_leds[5];
 
 	struct work_struct output_worker;
+	bool output_worker_initialized;
 	void *output_report_dmabuf;
 	uint8_t output_seq; /* Sequence number for output report. */
 };
@@ -299,6 +301,7 @@ static const struct {int x; int y; } ps_gamepad_hat_mapping[] = {
 	{0, 0},
 };
 
+static inline void dualsense_schedule_work(struct dualsense *ds);
 static void dualsense_set_lightbar(struct dualsense *ds, uint8_t red, uint8_t green, uint8_t blue);
 
 /*
@@ -792,6 +795,7 @@ static int dualsense_get_calibration_data(struct dualsense *ds)
 	return ret;
 }
 
+
 static int dualsense_get_firmware_info(struct dualsense *ds)
 {
 	uint8_t *buf;
@@ -881,7 +885,7 @@ static int dualsense_player_led_set_brightness(struct led_classdev *led, enum le
 	ds->update_player_leds = true;
 	spin_unlock_irqrestore(&ds->base.lock, flags);
 
-	schedule_work(&ds->output_worker);
+	dualsense_schedule_work(ds);
 
 	return 0;
 }
@@ -925,6 +929,16 @@ static void dualsense_init_output_report(struct dualsense *ds, struct dualsense_
 	}
 }
 
+static inline void dualsense_schedule_work(struct dualsense *ds)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ds->base.lock, flags);
+	if (ds->output_worker_initialized)
+		schedule_work(&ds->output_worker);
+	spin_unlock_irqrestore(&ds->base.lock, flags);
+}
+
 /*
  * Helper function to send DualSense output reports. Applies a CRC at the end of a report
  * for Bluetooth reports.
@@ -1085,7 +1099,7 @@ static int dualsense_parse_report(struct ps_device *ps_dev, struct hid_report *r
 		spin_unlock_irqrestore(&ps_dev->lock, flags);
 
 		/* Schedule updating of microphone state at hardware level. */
-		schedule_work(&ds->output_worker);
+		dualsense_schedule_work(ds);
 	}
 	ds->last_btn_mic_state = btn_mic_state;
 
@@ -1200,10 +1214,22 @@ static int dualsense_play_effect(struct input_dev *dev, void *data, struct ff_ef
 	ds->motor_right = effect->u.rumble.weak_magnitude / 256;
 	spin_unlock_irqrestore(&ds->base.lock, flags);
 
-	schedule_work(&ds->output_worker);
+	dualsense_schedule_work(ds);
 	return 0;
 }
 
+static void dualsense_remove(struct ps_device *ps_dev)
+{
+	struct dualsense *ds = container_of(ps_dev, struct dualsense, base);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ds->base.lock, flags);
+	ds->output_worker_initialized = false;
+	spin_unlock_irqrestore(&ds->base.lock, flags);
+
+	cancel_work_sync(&ds->output_worker);
+}
+
 static int dualsense_reset_leds(struct dualsense *ds)
 {
 	struct dualsense_output_report report;
@@ -1240,7 +1266,7 @@ static void dualsense_set_lightbar(struct dualsense *ds, uint8_t red, uint8_t gr
 	ds->lightbar_blue = blue;
 	spin_unlock_irqrestore(&ds->base.lock, flags);
 
-	schedule_work(&ds->output_worker);
+	dualsense_schedule_work(ds);
 }
 
 static void dualsense_set_player_leds(struct dualsense *ds)
@@ -1263,7 +1289,7 @@ static void dualsense_set_player_leds(struct dualsense *ds)
 
 	ds->update_player_leds = true;
 	ds->player_leds_state = player_ids[player_id];
-	schedule_work(&ds->output_worker);
+	dualsense_schedule_work(ds);
 }
 
 static struct ps_device *dualsense_create(struct hid_device *hdev)
@@ -1302,7 +1328,9 @@ static struct ps_device *dualsense_create(struct hid_device *hdev)
 	ps_dev->battery_capacity = 100; /* initial value until parse_report. */
 	ps_dev->battery_status = POWER_SUPPLY_STATUS_UNKNOWN;
 	ps_dev->parse_report = dualsense_parse_report;
+	ps_dev->remove = dualsense_remove;
 	INIT_WORK(&ds->output_worker, dualsense_output_worker);
+	ds->output_worker_initialized = true;
 	hid_set_drvdata(hdev, ds);
 
 	max_output_report_size = sizeof(struct dualsense_output_report_bt);
@@ -1439,7 +1467,8 @@ static int ps_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto err_stop;
 	}
 
-	if (hdev->product == USB_DEVICE_ID_SONY_PS5_CONTROLLER) {
+	if (hdev->product == USB_DEVICE_ID_SONY_PS5_CONTROLLER ||
+		hdev->product == USB_DEVICE_ID_SONY_PS5_CONTROLLER_2) {
 		dev = dualsense_create(hdev);
 		if (IS_ERR(dev)) {
 			hid_err(hdev, "Failed to create dualsense.\n");
@@ -1470,6 +1499,9 @@ static void ps_remove(struct hid_device *hdev)
 	ps_devices_list_remove(dev);
 	ps_device_release_player_id(dev);
 
+	if (dev->remove)
+		dev->remove(dev);
+
 	hid_hw_close(hdev);
 	hid_hw_stop(hdev);
 }
@@ -1477,6 +1509,8 @@ static void ps_remove(struct hid_device *hdev)
 static const struct hid_device_id ps_devices[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS5_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS5_CONTROLLER) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS5_CONTROLLER_2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS5_CONTROLLER_2) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ps_devices);
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 811b0a5379d0..2f1cc66d2641 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -2035,7 +2035,7 @@ static void disable_passdown_if_not_supported(struct clone *clone)
 		reason = "max discard sectors smaller than a region";
 
 	if (reason) {
-		DMWARN("Destination device (%pd) %s: Disabling discard passdown.",
+		DMWARN("Destination device (%pg) %s: Disabling discard passdown.",
 		       dest_dev, reason);
 		clear_bit(DM_CLONE_DISCARD_PASSDOWN, &clone->flags);
 	}
diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 4691a33bc374..2a4b3efb7e12 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -1051,13 +1051,13 @@ static void amd_get_iomux_res(struct amd_gpio *gpio_dev)
 
 	index = device_property_match_string(dev, "pinctrl-resource-names",  "iomux");
 	if (index < 0) {
-		dev_warn(dev, "failed to get iomux index\n");
+		dev_dbg(dev, "iomux not supported\n");
 		goto out_no_pinmux;
 	}
 
 	gpio_dev->iomux_base = devm_platform_ioremap_resource(gpio_dev->pdev, index);
 	if (IS_ERR(gpio_dev->iomux_base)) {
-		dev_warn(dev, "Failed to get iomux %d io resource\n", index);
+		dev_dbg(dev, "iomux not supported %d io resource\n", index);
 		goto out_no_pinmux;
 	}
 
diff --git a/drivers/thermal/intel/intel_powerclamp.c b/drivers/thermal/intel/intel_powerclamp.c
index 46cd799af148..bf3e4edeceda 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -531,11 +531,7 @@ static int start_power_clamp(void)
 	cpus_read_lock();
 
 	/* prefer BSP */
-	control_cpu = 0;
-	if (!cpu_online(control_cpu)) {
-		control_cpu = get_cpu();
-		put_cpu();
-	}
+	control_cpu = cpumask_first(cpu_online_mask);
 
 	clamping = true;
 	schedule_delayed_work(&poll_pkg_cstate_work, 0);
diff --git a/drivers/video/aperture.c b/drivers/video/aperture.c
index d245826a9324..101e13c2cf41 100644
--- a/drivers/video/aperture.c
+++ b/drivers/video/aperture.c
@@ -335,30 +335,36 @@ EXPORT_SYMBOL(aperture_remove_conflicting_devices);
  */
 int aperture_remove_conflicting_pci_devices(struct pci_dev *pdev, const char *name)
 {
+	bool primary = false;
 	resource_size_t base, size;
 	int bar, ret;
 
-	/*
-	 * WARNING: Apparently we must kick fbdev drivers before vgacon,
-	 * otherwise the vga fbdev driver falls over.
-	 */
-#if IS_REACHABLE(CONFIG_FB)
-	ret = remove_conflicting_pci_framebuffers(pdev, name);
-	if (ret)
-		return ret;
+#ifdef CONFIG_X86
+	primary = pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;
 #endif
-	ret = vga_remove_vgacon(pdev);
-	if (ret)
-		return ret;
 
 	for (bar = 0; bar < PCI_STD_NUM_BARS; ++bar) {
 		if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
 			continue;
+
 		base = pci_resource_start(pdev, bar);
 		size = pci_resource_len(pdev, bar);
-		aperture_detach_devices(base, size);
+		ret = aperture_remove_conflicting_devices(base, size, primary, name);
+		if (ret)
+			break;
 	}
 
+	if (ret)
+		return ret;
+
+	/*
+	 * WARNING: Apparently we must kick fbdev drivers before vgacon,
+	 * otherwise the vga fbdev driver falls over.
+	 */
+	ret = vga_remove_vgacon(pdev);
+	if (ret)
+		return ret;
+
 	return 0;
 
 }
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index bda4d304feb6..4ed0960e6c05 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1787,54 +1787,6 @@ int remove_conflicting_framebuffers(struct apertures_struct *a,
 }
 EXPORT_SYMBOL(remove_conflicting_framebuffers);
 
-/**
- * remove_conflicting_pci_framebuffers - remove firmware-configured framebuffers for PCI devices
- * @pdev: PCI device
- * @name: requesting driver name
- *
- * This function removes framebuffer devices (eg. initialized by firmware)
- * using memory range configured for any of @pdev's memory bars.
- *
- * The function assumes that PCI device with shadowed ROM drives a primary
- * display and so kicks out vga16fb.
- */
-int remove_conflicting_pci_framebuffers(struct pci_dev *pdev, const char *name)
-{
-	struct apertures_struct *ap;
-	bool primary = false;
-	int err, idx, bar;
-
-	for (idx = 0, bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
-		if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
-			continue;
-		idx++;
-	}
-
-	ap = alloc_apertures(idx);
-	if (!ap)
-		return -ENOMEM;
-
-	for (idx = 0, bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
-		if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
-			continue;
-		ap->ranges[idx].base = pci_resource_start(pdev, bar);
-		ap->ranges[idx].size = pci_resource_len(pdev, bar);
-		pci_dbg(pdev, "%s: bar %d: 0x%lx -> 0x%lx\n", __func__, bar,
-			(unsigned long)pci_resource_start(pdev, bar),
-			(unsigned long)pci_resource_end(pdev, bar));
-		idx++;
-	}
-
-#ifdef CONFIG_X86
-	primary = pdev->resource[PCI_ROM_RESOURCE].flags &
-					IORESOURCE_ROM_SHADOW;
-#endif
-	err = remove_conflicting_framebuffers(ap, name, primary);
-	kfree(ap);
-	return err;
-}
-EXPORT_SYMBOL(remove_conflicting_pci_framebuffers);
-
 /**
  *	register_framebuffer - registers a frame buffer device
  *	@fb_info: frame buffer info structure
diff --git a/fs/efivarfs/vars.c b/fs/efivarfs/vars.c
index a0ef63cfcecb..9e4f47808bd5 100644
--- a/fs/efivarfs/vars.c
+++ b/fs/efivarfs/vars.c
@@ -651,22 +651,6 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 	if (err)
 		return err;
 
-	/*
-	 * Ensure that the available space hasn't shrunk below the safe level
-	 */
-	status = check_var_size(attributes, *size + ucs2_strsize(name, 1024));
-	if (status != EFI_SUCCESS) {
-		if (status != EFI_UNSUPPORTED) {
-			err = efi_status_to_err(status);
-			goto out;
-		}
-
-		if (*size > 65536) {
-			err = -ENOSPC;
-			goto out;
-		}
-	}
-
 	status = efivar_set_variable_locked(name, vendor, attributes, *size,
 					    data, false);
 	if (status != EFI_SUCCESS) {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index d2b84c2fec39..4459794b65db 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1055,9 +1055,6 @@ efi_status_t efivar_set_variable_locked(efi_char16_t *name, efi_guid_t *vendor,
 efi_status_t efivar_set_variable(efi_char16_t *name, efi_guid_t *vendor,
 				 u32 attr, unsigned long data_size, void *data);
 
-efi_status_t check_var_size(u32 attributes, unsigned long size);
-efi_status_t check_var_size_nonblocking(u32 attributes, unsigned long size);
-
 #if IS_ENABLED(CONFIG_EFI_CAPSULE_LOADER)
 extern bool efi_capsule_pending(int *reset_type);
 
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 07fcd0e56682..b91c77016560 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -615,8 +615,6 @@ extern ssize_t fb_sys_write(struct fb_info *info, const char __user *buf,
 /* drivers/video/fbmem.c */
 extern int register_framebuffer(struct fb_info *fb_info);
 extern void unregister_framebuffer(struct fb_info *fb_info);
-extern int remove_conflicting_pci_framebuffers(struct pci_dev *pdev,
-					       const char *name);
 extern int remove_conflicting_framebuffers(struct apertures_struct *a,
 					   const char *name, bool primary);
 extern int fb_prepare_logo(struct fb_info *fb_info, int rotate);
diff --git a/include/linux/net.h b/include/linux/net.h
index 711c3593c3b8..18d942bbdf6e 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -41,6 +41,7 @@ struct net;
 #define SOCK_NOSPACE		2
 #define SOCK_PASSCRED		3
 #define SOCK_PASSSEC		4
+#define SOCK_SUPPORT_ZC		5
 
 #ifndef ARCH_HAS_SOCKET_TYPES
 /**
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index c6536d4b2da0..6f1d0e5df23a 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1164,10 +1164,10 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, alloc_node);
 		if (!wqe)
 			goto err;
+		wq->wqes[node] = wqe;
 		if (!alloc_cpumask_var(&wqe->cpu_mask, GFP_KERNEL))
 			goto err;
 		cpumask_copy(wqe->cpu_mask, cpumask_of_node(node));
-		wq->wqes[node] = wqe;
 		wqe->node = alloc_node;
 		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
diff --git a/io_uring/net.c b/io_uring/net.c
index 4878bf40f8b1..7804ac77745b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1001,6 +1001,8 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
+	if (!test_bit(SOCK_SUPPORT_ZC, &sock->flags))
+		return -EOPNOTSUPP;
 
 	msg.msg_name = NULL;
 	msg.msg_control = NULL;
diff --git a/kernel/gcov/gcc_4_7.c b/kernel/gcov/gcc_4_7.c
index 460c12b7dfea..7971e989e425 100644
--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -30,6 +30,13 @@
 
 #define GCOV_TAG_FUNCTION_LENGTH	3
 
+/* Since GCC 12.1 sizes are in BYTES and not in WORDS (4B). */
+#if (__GNUC__ >= 12)
+#define GCOV_UNIT_SIZE				4
+#else
+#define GCOV_UNIT_SIZE				1
+#endif
+
 static struct gcov_info *gcov_info_head;
 
 /**
@@ -383,12 +390,18 @@ size_t convert_to_gcda(char *buffer, struct gcov_info *info)
 	pos += store_gcov_u32(buffer, pos, info->version);
 	pos += store_gcov_u32(buffer, pos, info->stamp);
 
+#if (__GNUC__ >= 12)
+	/* Use zero as checksum of the compilation unit. */
+	pos += store_gcov_u32(buffer, pos, 0);
+#endif
+
 	for (fi_idx = 0; fi_idx < info->n_functions; fi_idx++) {
 		fi_ptr = info->functions[fi_idx];
 
 		/* Function record. */
 		pos += store_gcov_u32(buffer, pos, GCOV_TAG_FUNCTION);
-		pos += store_gcov_u32(buffer, pos, GCOV_TAG_FUNCTION_LENGTH);
+		pos += store_gcov_u32(buffer, pos,
+			GCOV_TAG_FUNCTION_LENGTH * GCOV_UNIT_SIZE);
 		pos += store_gcov_u32(buffer, pos, fi_ptr->ident);
 		pos += store_gcov_u32(buffer, pos, fi_ptr->lineno_checksum);
 		pos += store_gcov_u32(buffer, pos, fi_ptr->cfg_checksum);
@@ -402,7 +415,8 @@ size_t convert_to_gcda(char *buffer, struct gcov_info *info)
 			/* Counter record. */
 			pos += store_gcov_u32(buffer, pos,
 					      GCOV_TAG_FOR_COUNTER(ct_idx));
-			pos += store_gcov_u32(buffer, pos, ci_ptr->num * 2);
+			pos += store_gcov_u32(buffer, pos,
+				ci_ptr->num * 2 * GCOV_UNIT_SIZE);
 
 			for (cv_idx = 0; cv_idx < ci_ptr->num; cv_idx++) {
 				pos += store_gcov_u64(buffer, pos,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5f1d84d901c7..5fbd0a5b48f7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -457,6 +457,7 @@ void tcp_init_sock(struct sock *sk)
 	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[1]));
 	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[1]));
 
+	set_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
 	sk_sockets_allocated_inc(sk);
 }
 EXPORT_SYMBOL(tcp_init_sock);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 560d9eadeaa5..516b11c136da 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1620,6 +1620,7 @@ int udp_init_sock(struct sock *sk)
 {
 	skb_queue_head_init(&udp_sk(sk)->reader_queue);
 	sk->sk_destruct = udp_destruct_sock;
+	set_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(udp_init_sock);
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 4ae8b9574778..384426d7e9dd 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -931,28 +931,8 @@ snd_hda_codec_device_init(struct hda_bus *bus, unsigned int codec_addr,
 	}
 
 	codec->bus = bus;
-	codec->depop_delay = -1;
-	codec->fixup_id = HDA_FIXUP_ID_NOT_SET;
-	codec->core.dev.release = snd_hda_codec_dev_release;
-	codec->core.exec_verb = codec_exec_verb;
 	codec->core.type = HDA_DEV_LEGACY;
 
-	mutex_init(&codec->spdif_mutex);
-	mutex_init(&codec->control_mutex);
-	snd_array_init(&codec->mixers, sizeof(struct hda_nid_item), 32);
-	snd_array_init(&codec->nids, sizeof(struct hda_nid_item), 32);
-	snd_array_init(&codec->init_pins, sizeof(struct hda_pincfg), 16);
-	snd_array_init(&codec->driver_pins, sizeof(struct hda_pincfg), 16);
-	snd_array_init(&codec->cvt_setups, sizeof(struct hda_cvt_setup), 8);
-	snd_array_init(&codec->spdif_out, sizeof(struct hda_spdif_out), 16);
-	snd_array_init(&codec->jacktbl, sizeof(struct hda_jack_tbl), 16);
-	snd_array_init(&codec->verbs, sizeof(struct hda_verb *), 8);
-	INIT_LIST_HEAD(&codec->conn_list);
-	INIT_LIST_HEAD(&codec->pcm_list_head);
-	INIT_DELAYED_WORK(&codec->jackpoll_work, hda_jackpoll_work);
-	refcount_set(&codec->pcm_ref, 1);
-	init_waitqueue_head(&codec->remove_sleep);
-
 	return codec;
 }
 EXPORT_SYMBOL_GPL(snd_hda_codec_device_init);
@@ -1005,8 +985,29 @@ int snd_hda_codec_device_new(struct hda_bus *bus, struct snd_card *card,
 	if (snd_BUG_ON(codec_addr > HDA_MAX_CODEC_ADDRESS))
 		return -EINVAL;
 
+	codec->core.dev.release = snd_hda_codec_dev_release;
+	codec->core.exec_verb = codec_exec_verb;
+
 	codec->card = card;
 	codec->addr = codec_addr;
+	mutex_init(&codec->spdif_mutex);
+	mutex_init(&codec->control_mutex);
+	snd_array_init(&codec->mixers, sizeof(struct hda_nid_item), 32);
+	snd_array_init(&codec->nids, sizeof(struct hda_nid_item), 32);
+	snd_array_init(&codec->init_pins, sizeof(struct hda_pincfg), 16);
+	snd_array_init(&codec->driver_pins, sizeof(struct hda_pincfg), 16);
+	snd_array_init(&codec->cvt_setups, sizeof(struct hda_cvt_setup), 8);
+	snd_array_init(&codec->spdif_out, sizeof(struct hda_spdif_out), 16);
+	snd_array_init(&codec->jacktbl, sizeof(struct hda_jack_tbl), 16);
+	snd_array_init(&codec->verbs, sizeof(struct hda_verb *), 8);
+	INIT_LIST_HEAD(&codec->conn_list);
+	INIT_LIST_HEAD(&codec->pcm_list_head);
+	refcount_set(&codec->pcm_ref, 1);
+	init_waitqueue_head(&codec->remove_sleep);
+
+	INIT_DELAYED_WORK(&codec->jackpoll_work, hda_jackpoll_work);
+	codec->depop_delay = -1;
+	codec->fixup_id = HDA_FIXUP_ID_NOT_SET;
 
 #ifdef CONFIG_PM
 	codec->power_jiffies = jiffies;
