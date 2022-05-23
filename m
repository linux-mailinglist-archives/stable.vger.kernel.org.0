Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E71531A54
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240272AbiEWR2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241095AbiEWR0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EC064D0C;
        Mon, 23 May 2022 10:21:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FEEE60A2A;
        Mon, 23 May 2022 17:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A264C385A9;
        Mon, 23 May 2022 17:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326361;
        bh=ZJCdzB4JjmfNnE0xCuIeYbYphw6GuQ+RQi5gJUGaDuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1UeL+vKDq/9oNpZoTlawWMkc55A2DndGaFDBBz5vwVKZ0kBLebGMxsZug+yiNNMIr
         K1RDe8XRA2ZSoeVYYcZ1P7Q5F77HYmQXbfcECJ2L/2DS+bX6WIbL/BXd9DSlsxME4u
         OgRLA+sTQ2MBFtU6txOU7CZniDfOx8YSF6Vh3kqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas De Marchi <lucas.demarchi@intel.com>,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.15 058/132] drm/i915/dmc: Add MMIO range restrictions
Date:   Mon, 23 May 2022 19:04:27 +0200
Message-Id: <20220523165832.873976122@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anusha Srivatsa <anusha.srivatsa@intel.com>

commit 54395a33718af1c04b5098203335b25382291a16 upstream.

Bspec has added some steps that check forDMC MMIO range before
programming them

v2: Fix for CI
v3: move register defines to .h (Anusha)
- Check MMIO restrictions per pipe
- Add MMIO restricton for v1 dmc header as well (Lucas)
v4: s/_PICK/_PICK_EVEN and use it only for Pipe DMC scenario.
- clean up sanity check logic.(Lucas)
- Add MMIO range for RKL as well.(Anusha)
v5: Use DISPLAY_VER instead of per platform check (Lucas)

BSpec: 49193

Cc: stable@vger.kernel.org
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Anusha Srivatsa <anusha.srivatsa@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220511000847.1068302-1-anusha.srivatsa@intel.com
(cherry picked from commit 21c47196aec3a93f913a7515e1e7b30e6c54d6c6)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dmc.c |   44 +++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_reg.h          |   16 +++++++++++
 2 files changed, 60 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_dmc.c
+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
@@ -375,6 +375,44 @@ static void dmc_set_fw_offset(struct int
 	}
 }
 
+static bool dmc_mmio_addr_sanity_check(struct intel_dmc *dmc,
+				       const u32 *mmioaddr, u32 mmio_count,
+				       int header_ver, u8 dmc_id)
+{
+	struct drm_i915_private *i915 = container_of(dmc, typeof(*i915), dmc);
+	u32 start_range, end_range;
+	int i;
+
+	if (dmc_id >= DMC_FW_MAX) {
+		drm_warn(&i915->drm, "Unsupported firmware id %u\n", dmc_id);
+		return false;
+	}
+
+	if (header_ver == 1) {
+		start_range = DMC_MMIO_START_RANGE;
+		end_range = DMC_MMIO_END_RANGE;
+	} else if (dmc_id == DMC_FW_MAIN) {
+		start_range = TGL_MAIN_MMIO_START;
+		end_range = TGL_MAIN_MMIO_END;
+	} else if (DISPLAY_VER(i915) >= 13) {
+		start_range = ADLP_PIPE_MMIO_START;
+		end_range = ADLP_PIPE_MMIO_END;
+	} else if (DISPLAY_VER(i915) >= 12) {
+		start_range = TGL_PIPE_MMIO_START(dmc_id);
+		end_range = TGL_PIPE_MMIO_END(dmc_id);
+	} else {
+		drm_warn(&i915->drm, "Unknown mmio range for sanity check");
+		return false;
+	}
+
+	for (i = 0; i < mmio_count; i++) {
+		if (mmioaddr[i] < start_range || mmioaddr[i] > end_range)
+			return false;
+	}
+
+	return true;
+}
+
 static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
 			       const struct intel_dmc_header_base *dmc_header,
 			       size_t rem_size, u8 dmc_id)
@@ -444,6 +482,12 @@ static u32 parse_dmc_fw_header(struct in
 		return 0;
 	}
 
+	if (!dmc_mmio_addr_sanity_check(dmc, mmioaddr, mmio_count,
+					dmc_header->header_ver, dmc_id)) {
+		drm_err(&i915->drm, "DMC firmware has Wrong MMIO Addresses\n");
+		return 0;
+	}
+
 	for (i = 0; i < mmio_count; i++) {
 		dmc_info->mmioaddr[i] = _MMIO(mmioaddr[i]);
 		dmc_info->mmiodata[i] = mmiodata[i];
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -7818,6 +7818,22 @@ enum {
 /* MMIO address range for DMC program (0x80000 - 0x82FFF) */
 #define DMC_MMIO_START_RANGE	0x80000
 #define DMC_MMIO_END_RANGE	0x8FFFF
+#define DMC_V1_MMIO_START_RANGE	0x80000
+#define TGL_MAIN_MMIO_START	0x8F000
+#define TGL_MAIN_MMIO_END	0x8FFFF
+#define _TGL_PIPEA_MMIO_START	0x92000
+#define _TGL_PIPEA_MMIO_END	0x93FFF
+#define _TGL_PIPEB_MMIO_START	0x96000
+#define _TGL_PIPEB_MMIO_END	0x97FFF
+#define ADLP_PIPE_MMIO_START	0x5F000
+#define ADLP_PIPE_MMIO_END	0x5FFFF
+
+#define TGL_PIPE_MMIO_START(dmc_id)	_PICK_EVEN(((dmc_id) - 1), _TGL_PIPEA_MMIO_START,\
+						_TGL_PIPEB_MMIO_START)
+
+#define TGL_PIPE_MMIO_END(dmc_id)	_PICK_EVEN(((dmc_id) - 1), _TGL_PIPEA_MMIO_END,\
+						_TGL_PIPEB_MMIO_END)
+
 #define SKL_DMC_DC3_DC5_COUNT	_MMIO(0x80030)
 #define SKL_DMC_DC5_DC6_COUNT	_MMIO(0x8002C)
 #define BXT_DMC_DC3_DC5_COUNT	_MMIO(0x80038)


