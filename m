Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC4B44712E
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 18:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfFOQJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 12:09:46 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:53179 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726703AbfFOQJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 12:09:45 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 71566434;
        Sat, 15 Jun 2019 12:09:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 15 Jun 2019 12:09:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=fjUSG5
        m/cVncz0NZm/8yvsml2Nte/nCdZNXYnnKYlJY=; b=VehoTjcFr8+NIhfUKOcXKn
        RO12a7qMoynON0AgUDzH1q1IaQ0hLr0wKZpHNPPVn11Xx57uADtVaGGfiHiN6SzU
        cVlS96DScUt6LRFFRu9l9jsgpUKm9FoiHDEnpm9pOnFF/77wJge9uEuzR6DXr/OY
        +cbiIZOmQwyUkcjpD7WZYefvDtDaBhXQ94OwwDRgRFpbamF/dApYOjyETmPWnvu2
        nWJj750hsAr2ZZ8i0RiJp6wiHgKX2icn86xN8W3pW3erHuOYe6iJkQ517iDlXbNf
        F3mYAHjK2NKvR1cdj17APLV89Xq7ny8EZPMmH3J2em5bv8E0q3xT1BWUWBJymlHg
        ==
X-ME-Sender: <xms:RxgFXUGjhM2najs9OBkcvtDITfob9KxiPckx_0_Mo59gqmtokB1kDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgpdhkvghrnhgvlhdroh
    hrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:RxgFXRneNivTEvPZwUvc2CMmio_WkYqVu9QlFVRHoPTWVQadMNOskw>
    <xmx:RxgFXZLzneDHIvzztyXctP76VY05BJRgsoQZGQldULMbUgDyM86_pg>
    <xmx:RxgFXabqrMHfpDGfus8zGZBbPd1MIF2qtvpvqeG4jRoykNFiXz2gSQ>
    <xmx:RxgFXY1FZnh97024Z_luMTYX1BDxYyx23sCMzPX4H4d07_VTePO2aw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 192ED380083;
        Sat, 15 Jun 2019 12:09:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/dmc: protect against reading random memory" failed to apply to 4.19-stable tree
To:     lucas.demarchi@intel.com, jani.nikula@intel.com,
        rodrigo.vivi@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 15 Jun 2019 18:09:41 +0200
Message-ID: <15606149811389@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 326fb6dd1483c985a6ef47db3fa8788bb99e8b83 Mon Sep 17 00:00:00 2001
From: Lucas De Marchi <lucas.demarchi@intel.com>
Date: Wed, 5 Jun 2019 16:55:35 -0700
Subject: [PATCH] drm/i915/dmc: protect against reading random memory

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
(cherry picked from commit bc7b488b1d1c71dc4c5182206911127bc6c410d6)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/intel_csr.c b/drivers/gpu/drm/i915/intel_csr.c
index f43c2a2563a5..96618af47088 100644
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

