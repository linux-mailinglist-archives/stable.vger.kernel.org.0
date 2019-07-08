Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDDE6224A
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388336AbfGHPYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388335AbfGHPYS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:24:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3B6521738;
        Mon,  8 Jul 2019 15:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599457;
        bh=DS4k/28IlLaFYt9GbiZOqgQw5cQBJh4xa+XDZaWXaQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHyHM6EfPqnf8cxyt1Nu9AUc2yA1ueSZL/6bUi+WrG4l9SDPX8CyYETuYTZru/KZH
         smgGTNTXG0D3G56FQnnVau+eqHLHciEJmdXFiza5p4i8B6qpB2p6yNXgDpqbrP5xyj
         EnKMVC2rfubds5xrYTU2su0qbAfiAMPbLeBuo7yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas De Marchi <lucas.demarchi@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 22/56] drm/i915/dmc: protect against reading random memory
Date:   Mon,  8 Jul 2019 17:13:14 +0200
Message-Id: <20190708150521.041295238@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_csr.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_csr.c b/drivers/gpu/drm/i915/intel_csr.c
index 92c1f8e166dc..0bdbbd4027fe 100644
--- a/drivers/gpu/drm/i915/intel_csr.c
+++ b/drivers/gpu/drm/i915/intel_csr.c
@@ -277,10 +277,17 @@ static uint32_t *parse_csr_fw(struct drm_i915_private *dev_priv,
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
@@ -350,6 +357,9 @@ static uint32_t *parse_csr_fw(struct drm_i915_private *dev_priv,
 		return NULL;
 	}
 	readcount += dmc_offset;
+	fsize += dmc_offset;
+	if (fsize > fw->size)
+		goto error_truncated;
 
 	/* Extract dmc_header information. */
 	dmc_header = (struct intel_dmc_header *)&fw->data[readcount];
@@ -380,6 +390,10 @@ static uint32_t *parse_csr_fw(struct drm_i915_private *dev_priv,
 
 	/* fw_size is in dwords, so multiplied by 4 to convert into bytes. */
 	nbytes = dmc_header->fw_size * 4;
+	fsize += nbytes;
+	if (fsize > fw->size)
+		goto error_truncated;
+
 	if (nbytes > CSR_MAX_FW_SIZE) {
 		DRM_ERROR("CSR firmware too big (%u) bytes\n", nbytes);
 		return NULL;
@@ -393,6 +407,10 @@ static uint32_t *parse_csr_fw(struct drm_i915_private *dev_priv,
 	}
 
 	return memcpy(dmc_payload, &fw->data[readcount], nbytes);
+
+error_truncated:
+	DRM_ERROR("Truncated DMC firmware, rejecting.\n");
+	return NULL;
 }
 
 static void csr_load_work_fn(struct work_struct *work)
-- 
2.20.1



