Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF685D6D3
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 21:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfGBTXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 15:23:10 -0400
Received: from mga17.intel.com ([192.55.52.151]:52402 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbfGBTXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 15:23:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jul 2019 12:23:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,444,1557212400"; 
   d="scan'208";a="362345242"
Received: from ldmartin-desk1.jf.intel.com (HELO ldmartin-desk1.intel.com) ([10.24.8.246])
  by fmsmga005.fm.intel.com with ESMTP; 02 Jul 2019 12:23:09 -0700
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     stable@vger.kernel.org
Cc:     intel-gfx@lists.freedesktop.org,
        Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH stable-4.9+] drm/i915/dmc: protect against reading random memory
Date:   Tue,  2 Jul 2019 12:23:04 -0700
Message-Id: <20190702192304.31955-1-lucas.demarchi@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit bc7b488b1d1c71dc4c5182206911127bc6c410d6 upstream.

While loading the DMC firmware we were double checking the headers made
sense, but in no place we checked that we were actually reading memory
we were supposed to. This could be wrong in case the firmware file is
truncated or malformed.

Before this patch:
	# ls -l /lib/firmware/i915/icl_dmc_ver1_07.bin
	-rw-r--r-- 1 root root  25716 Feb  1 12:26 icl_dmc_ver1_07.bin
	# truncate -s 25700 /lib/firmware/i915/icl_dmc_ver1_07.bin
	# modprobe i915
	# dmesg| grep -i dmc
	[drm:intel_csr_ucode_init [i915]] Loading i915/icl_dmc_ver1_07.bin
	[drm] Finished loading DMC firmware i915/icl_dmc_ver1_07.bin (v1.7)

i.e. it loads random data. Now it fails like below:
	[drm:intel_csr_ucode_init [i915]] Loading i915/icl_dmc_ver1_07.bin
	[drm:csr_load_work_fn [i915]] *ERROR* Truncated DMC firmware, rejecting.
	i915 0000:00:02.0: Failed to load DMC firmware i915/icl_dmc_ver1_07.bin. Disabling runtime power management.
	i915 0000:00:02.0: DMC firmware homepage: https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/i915

Before reading any part of the firmware file, validate the input first.

Fixes: eb805623d8b1 ("drm/i915/skl: Add support to load SKL CSR firmware.")
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190605235535.17791-1-lucas.demarchi@intel.com
(cherry picked from commit bc7b488b1d1c71dc4c5182206911127bc6c410d6)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
[ Lucas: backported to 4.9+ adjusting the context ]
Cc: stable@vger.kernel.org # v4.9+
---
 drivers/gpu/drm/i915/intel_csr.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_csr.c b/drivers/gpu/drm/i915/intel_csr.c
index 1ea0e1f43397..54d878cb458f 100644
--- a/drivers/gpu/drm/i915/intel_csr.c
+++ b/drivers/gpu/drm/i915/intel_csr.c
@@ -280,10 +280,17 @@ static uint32_t *parse_csr_fw(struct drm_i915_private *dev_priv,
 	uint32_t i;
 	uint32_t *dmc_payload;
 	uint32_t required_version;
+	size_t fsize;
 
 	if (!fw)
 		return NULL;
 
+	fsize = sizeof(struct intel_css_header) +
+		sizeof(struct intel_package_header) +
+		sizeof(struct intel_dmc_header);
+	if (fsize > fw->size)
+		goto error_truncated;
+
 	/* Extract CSS Header information*/
 	css_header = (struct intel_css_header *)fw->data;
 	if (sizeof(struct intel_css_header) !=
@@ -349,6 +356,9 @@ static uint32_t *parse_csr_fw(struct drm_i915_private *dev_priv,
 		return NULL;
 	}
 	readcount += dmc_offset;
+	fsize += dmc_offset;
+	if (fsize > fw->size)
+		goto error_truncated;
 
 	/* Extract dmc_header information. */
 	dmc_header = (struct intel_dmc_header *)&fw->data[readcount];
@@ -379,6 +389,10 @@ static uint32_t *parse_csr_fw(struct drm_i915_private *dev_priv,
 
 	/* fw_size is in dwords, so multiplied by 4 to convert into bytes. */
 	nbytes = dmc_header->fw_size * 4;
+	fsize += nbytes;
+	if (fsize > fw->size)
+		goto error_truncated;
+
 	if (nbytes > CSR_MAX_FW_SIZE) {
 		DRM_ERROR("CSR firmware too big (%u) bytes\n", nbytes);
 		return NULL;
@@ -392,6 +406,10 @@ static uint32_t *parse_csr_fw(struct drm_i915_private *dev_priv,
 	}
 
 	return memcpy(dmc_payload, &fw->data[readcount], nbytes);
+
+error_truncated:
+	DRM_ERROR("Truncated DMC firmware, rejecting.\n");
+	return NULL;
 }
 
 static void csr_load_work_fn(struct work_struct *work)
-- 
2.21.0

