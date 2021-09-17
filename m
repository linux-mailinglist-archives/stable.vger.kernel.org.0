Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7230A40EF4E
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbhIQCfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:35:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242900AbhIQCe7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:34:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCE1A61108;
        Fri, 17 Sep 2021 02:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846018;
        bh=V0rOTL1VXOnzu4mGUHvnH0iSCcAwtqMHazvEpiR1u3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k31loUQ23T4v0P7SyfxZuwjUz3D/aeEJUESduCRMwVLPVHJH5hg2liTCMEX9NWHWq
         BXqze0LKzbirERLUFeS9xgDrulztyfSAD3NGLRLXg5EBKq3dh5fvGh5XmC2HHzHs8Z
         AyEoQ7/VrVmSb2HaDxNpssEKvQJZhGR5t8sd/m/dsmCa3qTQPAr9fwNaR4EvIDVaYC
         s2HVhIHSX9MLVfmSJvDoPzlopnNcvBOIJnFy5HAE8pp2OYql/ODdJmWs2IiKhzoeZi
         wCUDS5N9CQnfPphbdEqPLGUxjufVWmolUdEOyHRM0urxoWaJQHiohe3POXaeSpI3ff
         d6kqgLqapzA/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luben Tuikov <luben.tuikov@amd.com>,
        John Clements <john.clements@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <Alexander.Deucher@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        ray.huang@amd.com, Feifei.Xu@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 04/21] drm/amdgpu: Fixes to returning VBIOS RAS EEPROM address
Date:   Thu, 16 Sep 2021 22:32:58 -0400
Message-Id: <20210917023315.816225-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023315.816225-1-sashal@kernel.org>
References: <20210917023315.816225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit a6a355a22f7a0efa6a11bc90b5161f394d51fe95 ]

1) Generalize the function--if the user didn't set
   i2c_address, still return true/false to
   indicate whether VBIOS contains the RAS EEPROM
   address.  This function shouldn't evaluate
   whether the user set the i2c_address pointer or
   not.

2) Don't touch the caller's i2c_address, unless
   you have to--this function shouldn't have side
   effects.

3) Correctly set the function comment as a
   kernel-doc comment.

Cc: John Clements <john.clements@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c  | 50 ++++++++++++-------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
index 8f53837d4d3e..97178b307ed6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
@@ -468,14 +468,18 @@ bool amdgpu_atomfirmware_dynamic_boot_config_supported(struct amdgpu_device *ade
 	return (fw_cap & ATOM_FIRMWARE_CAP_DYNAMIC_BOOT_CFG_ENABLE) ? true : false;
 }
 
-/*
- * Helper function to query RAS EEPROM address
- *
- * @adev: amdgpu_device pointer
+/**
+ * amdgpu_atomfirmware_ras_rom_addr -- Get the RAS EEPROM addr from VBIOS
+ * adev: amdgpu_device pointer
+ * i2c_address: pointer to u8; if not NULL, will contain
+ *    the RAS EEPROM address if the function returns true
  *
- * Return true if vbios supports ras rom address reporting
+ * Return true if VBIOS supports RAS EEPROM address reporting,
+ * else return false. If true and @i2c_address is not NULL,
+ * will contain the RAS ROM address.
  */
-bool amdgpu_atomfirmware_ras_rom_addr(struct amdgpu_device *adev, uint8_t* i2c_address)
+bool amdgpu_atomfirmware_ras_rom_addr(struct amdgpu_device *adev,
+				      u8 *i2c_address)
 {
 	struct amdgpu_mode_info *mode_info = &adev->mode_info;
 	int index;
@@ -483,27 +487,39 @@ bool amdgpu_atomfirmware_ras_rom_addr(struct amdgpu_device *adev, uint8_t* i2c_a
 	union firmware_info *firmware_info;
 	u8 frev, crev;
 
-	if (i2c_address == NULL)
-		return false;
-
-	*i2c_address = 0;
-
 	index = get_index_into_master_table(atom_master_list_of_data_tables_v2_1,
-			firmwareinfo);
+					    firmwareinfo);
 
 	if (amdgpu_atom_parse_data_header(adev->mode_info.atom_context,
-				index, &size, &frev, &crev, &data_offset)) {
+					  index, &size, &frev, &crev,
+					  &data_offset)) {
 		/* support firmware_info 3.4 + */
 		if ((frev == 3 && crev >=4) || (frev > 3)) {
 			firmware_info = (union firmware_info *)
 				(mode_info->atom_context->bios + data_offset);
-			*i2c_address = firmware_info->v34.ras_rom_i2c_slave_addr;
+			/* The ras_rom_i2c_slave_addr should ideally
+			 * be a 19-bit EEPROM address, which would be
+			 * used as is by the driver; see top of
+			 * amdgpu_eeprom.c.
+			 *
+			 * When this is the case, 0 is of course a
+			 * valid RAS EEPROM address, in which case,
+			 * we'll drop the first "if (firm...)" and only
+			 * leave the check for the pointer.
+			 *
+			 * The reason this works right now is because
+			 * ras_rom_i2c_slave_addr contains the EEPROM
+			 * device type qualifier 1010b in the top 4
+			 * bits.
+			 */
+			if (firmware_info->v34.ras_rom_i2c_slave_addr) {
+				if (i2c_address)
+					*i2c_address = firmware_info->v34.ras_rom_i2c_slave_addr;
+				return true;
+			}
 		}
 	}
 
-	if (*i2c_address != 0)
-		return true;
-
 	return false;
 }
 
-- 
2.30.2

