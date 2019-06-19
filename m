Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEFF44C430
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 01:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730810AbfFSXwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 19:52:05 -0400
Received: from mga18.intel.com ([134.134.136.126]:43641 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbfFSXwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 19:52:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 16:52:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,394,1557212400"; 
   d="scan'208";a="162363829"
Received: from anusha.jf.intel.com ([10.54.75.56])
  by orsmga003.jf.intel.com with ESMTP; 19 Jun 2019 16:52:03 -0700
From:   Anusha Srivatsa <anusha.srivatsa@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Lucas De Marchi <lucas.demarchi@intel.com>, stable@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 8/21] drm/i915/dmc: protect against reading random memory
Date:   Wed, 19 Jun 2019 16:42:11 -0700
Message-Id: <20190619234224.7681-9-anusha.srivatsa@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190619234224.7681-1-anusha.srivatsa@intel.com>
References: <20190619234224.7681-1-anusha.srivatsa@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas De Marchi <lucas.demarchi@intel.com>

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
Cc: stable@vger.kernel.org
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190605235535.17791-1-lucas.demarchi@intel.com
---
 drivers/gpu/drm/i915/intel_csr.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_csr.c b/drivers/gpu/drm/i915/intel_csr.c
index 4527b9662330..bf0eebd385b9 100644
--- a/drivers/gpu/drm/i915/intel_csr.c
+++ b/drivers/gpu/drm/i915/intel_csr.c
@@ -303,10 +303,17 @@ static u32 *parse_csr_fw(struct drm_i915_private *dev_priv,
 	u32 dmc_offset = CSR_DEFAULT_FW_OFFSET, readcount = 0, nbytes;
 	u32 i;
 	u32 *dmc_payload;
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
@@ -366,6 +373,9 @@ static u32 *parse_csr_fw(struct drm_i915_private *dev_priv,
 	/* Convert dmc_offset into number of bytes. By default it is in dwords*/
 	dmc_offset *= 4;
 	readcount += dmc_offset;
+	fsize += dmc_offset;
+	if (fsize > fw->size)
+		goto error_truncated;
 
 	/* Extract dmc_header information. */
 	dmc_header = (struct intel_dmc_header *)&fw->data[readcount];
@@ -397,6 +407,10 @@ static u32 *parse_csr_fw(struct drm_i915_private *dev_priv,
 
 	/* fw_size is in dwords, so multiplied by 4 to convert into bytes. */
 	nbytes = dmc_header->fw_size * 4;
+	fsize += nbytes;
+	if (fsize > fw->size)
+		goto error_truncated;
+
 	if (nbytes > csr->max_fw_size) {
 		DRM_ERROR("DMC FW too big (%u bytes)\n", nbytes);
 		return NULL;
@@ -410,6 +424,10 @@ static u32 *parse_csr_fw(struct drm_i915_private *dev_priv,
 	}
 
 	return memcpy(dmc_payload, &fw->data[readcount], nbytes);
+
+error_truncated:
+	DRM_ERROR("Truncated DMC firmware, rejecting.\n");
+	return NULL;
 }
 
 static void intel_csr_runtime_pm_get(struct drm_i915_private *dev_priv)
