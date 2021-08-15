Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C185E3EC921
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 14:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237917AbhHOMou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 08:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231809AbhHOMou (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 08:44:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45E0561152;
        Sun, 15 Aug 2021 12:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629031460;
        bh=I4Wsup8QkUe47ERoVMU9bQbjZzQqrC1lG3lBO9Q0muI=;
        h=Subject:To:Cc:From:Date:From;
        b=lrwxYVAiN4FKGy+o/GuyTB32nJYF7SexHA5OnT6Ft3+790NkOmp5BM6MHO0K00/7j
         iyAYr/4rgA3ey6PpT8o7NMFGcksUWgYY+Esp2DZW6Gn0tZY5TS0Ny7GKzZSr8ZxAHD
         HDcZo7oBDGWTKiD3r5rjkf7+Tdmwsi8FlSTvVLAA=
Subject: FAILED: patch "[PATCH] drm/amdgpu: set RAS EEPROM address from VBIOS" failed to apply to 5.10-stable tree
To:     john.clements@amd.com, Hawking.Zhang@amd.com,
        alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Aug 2021 14:44:18 +0200
Message-ID: <1629031458105209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 39932ef75897bfcb8ba1120e7b09d615d74762fd Mon Sep 17 00:00:00 2001
From: John Clements <john.clements@amd.com>
Date: Wed, 4 Aug 2021 17:11:40 +0800
Subject: [PATCH] drm/amdgpu: set RAS EEPROM address from VBIOS

update to latest atombios fw table

[Backport to 5.14 - Alex]

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1670
Signed-off-by: John Clements <john.clements@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>.
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
index 3b5d13189073..8f53837d4d3e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
@@ -468,6 +468,46 @@ bool amdgpu_atomfirmware_dynamic_boot_config_supported(struct amdgpu_device *ade
 	return (fw_cap & ATOM_FIRMWARE_CAP_DYNAMIC_BOOT_CFG_ENABLE) ? true : false;
 }
 
+/*
+ * Helper function to query RAS EEPROM address
+ *
+ * @adev: amdgpu_device pointer
+ *
+ * Return true if vbios supports ras rom address reporting
+ */
+bool amdgpu_atomfirmware_ras_rom_addr(struct amdgpu_device *adev, uint8_t* i2c_address)
+{
+	struct amdgpu_mode_info *mode_info = &adev->mode_info;
+	int index;
+	u16 data_offset, size;
+	union firmware_info *firmware_info;
+	u8 frev, crev;
+
+	if (i2c_address == NULL)
+		return false;
+
+	*i2c_address = 0;
+
+	index = get_index_into_master_table(atom_master_list_of_data_tables_v2_1,
+			firmwareinfo);
+
+	if (amdgpu_atom_parse_data_header(adev->mode_info.atom_context,
+				index, &size, &frev, &crev, &data_offset)) {
+		/* support firmware_info 3.4 + */
+		if ((frev == 3 && crev >=4) || (frev > 3)) {
+			firmware_info = (union firmware_info *)
+				(mode_info->atom_context->bios + data_offset);
+			*i2c_address = firmware_info->v34.ras_rom_i2c_slave_addr;
+		}
+	}
+
+	if (*i2c_address != 0)
+		return true;
+
+	return false;
+}
+
+
 union smu_info {
 	struct atom_smu_info_v3_1 v31;
 };
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.h
index 1bbbb195015d..751248b253de 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.h
@@ -36,6 +36,7 @@ int amdgpu_atomfirmware_get_clock_info(struct amdgpu_device *adev);
 int amdgpu_atomfirmware_get_gfx_info(struct amdgpu_device *adev);
 bool amdgpu_atomfirmware_mem_ecc_supported(struct amdgpu_device *adev);
 bool amdgpu_atomfirmware_sram_ecc_supported(struct amdgpu_device *adev);
+bool amdgpu_atomfirmware_ras_rom_addr(struct amdgpu_device *adev, uint8_t* i2c_address);
 bool amdgpu_atomfirmware_mem_training_supported(struct amdgpu_device *adev);
 bool amdgpu_atomfirmware_dynamic_boot_config_supported(struct amdgpu_device *adev);
 int amdgpu_atomfirmware_get_fw_reserved_fb_size(struct amdgpu_device *adev);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index f40c871da0c6..38222de921d1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -26,6 +26,7 @@
 #include "amdgpu_ras.h"
 #include <linux/bits.h>
 #include "atom.h"
+#include "amdgpu_atomfirmware.h"
 
 #define EEPROM_I2C_TARGET_ADDR_VEGA20		0xA0
 #define EEPROM_I2C_TARGET_ADDR_ARCTURUS		0xA8
@@ -96,6 +97,9 @@ static bool __get_eeprom_i2c_addr(struct amdgpu_device *adev,
 	if (!i2c_addr)
 		return false;
 
+	if (amdgpu_atomfirmware_ras_rom_addr(adev, (uint8_t*)i2c_addr))
+		return true;
+
 	switch (adev->asic_type) {
 	case CHIP_VEGA20:
 		*i2c_addr = EEPROM_I2C_TARGET_ADDR_VEGA20;
diff --git a/drivers/gpu/drm/amd/include/atomfirmware.h b/drivers/gpu/drm/amd/include/atomfirmware.h
index 3811e58dd857..44955458fe38 100644
--- a/drivers/gpu/drm/amd/include/atomfirmware.h
+++ b/drivers/gpu/drm/amd/include/atomfirmware.h
@@ -590,7 +590,7 @@ struct atom_firmware_info_v3_4 {
 	uint8_t  board_i2c_feature_id;            // enum of atom_board_i2c_feature_id_def
 	uint8_t  board_i2c_feature_gpio_id;       // i2c id find in gpio_lut data table gpio_id
 	uint8_t  board_i2c_feature_slave_addr;
-	uint8_t  reserved3;
+	uint8_t  ras_rom_i2c_slave_addr;
 	uint16_t bootup_mvddq_mv;
 	uint16_t bootup_mvpp_mv;
 	uint32_t zfbstartaddrin16mb;

