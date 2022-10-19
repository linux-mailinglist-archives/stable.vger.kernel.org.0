Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE0A603B12
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiJSICB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiJSIB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:01:59 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055A253A73;
        Wed, 19 Oct 2022 01:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666166518; x=1697702518;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+uppgJ9213B3sM4pyr75DjdtKc6V+nm10+koSdQc6PM=;
  b=nNPm49bZUDaHStX2lt0WmQRAQWE0fOrx8mbal7cm0lNF1DfTRAh1lmv4
   +7dgWSAUTUxMMKOObJra/Pj6WAfnOjxodpP/1EqkmH+h7iHzy5ChVEnDb
   hI1fPjx4C8q1Hnub/oLI/3pVpdtmI4Y6jT9u6/OA/swgIvA4cAUkM3EFn
   o8ZUajmEyFxExFTEiu9l00Ou/IW4fN5U22oyZyqTP3nNEQGq1YvZ8rFXD
   47Lwbmz7J06IlxYtd8EoYAcdboJYujAaK/KazvPPkgCftxJPBsbnmST0B
   UaNaBSAYTuMveVFz0yEJKH/KSPvqFzUfAALqajtw5u9pDUhWpJ/V3pLpk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="307446748"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="307446748"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 01:01:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="629133423"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="629133423"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by orsmga002.jf.intel.com with SMTP; 19 Oct 2022 01:01:54 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 19 Oct 2022 11:01:53 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH stable-5.19+ 2/2] drm/i915/bios: Use hardcoded fp_timing size for generating LFP data pointers
Date:   Wed, 19 Oct 2022 11:01:49 +0300
Message-Id: <20221019080149.22870-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221019080149.22870-1-ville.syrjala@linux.intel.com>
References: <Y0+fex0i0vmBL6QX@kroah.com>
 <20221019080149.22870-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

The current scheme for generating the LFP data table pointers
(when the block including them is missing from the VBT) expects
the 0xffff sequence to only appear in the fp_timing terminator
entries. However some VBTs also have extra 0xffff sequences
elsewhere in the LFP data. When looking for the terminators
we may end up finding those extra sequeneces insted, which means
we deduce the wrong size for the fp_timing table. The code
then notices the inconsistent looking values and gives up on
the generated data table pointers, preventing us from parsing
the LFP data table entirely.

Let's give up on the "search for the terminators" approach
and instead just hardcode the expected size for the fp_timing
table.

We have enough sanity checks in place to make sure we
shouldn't end up parsing total garbage even if that size
should change in the future (although that seems unlikely
as the fp_timing and dvo_timing tables have been declared
obsolete as of VBT version 229).

Cc: <stable@vger.kernel.org> # 5.19+
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6592
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220818192223.29881-3-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit d3a7051841f0a4bcb1ee26a1b721c6150cc4c2b1)
---
 drivers/gpu/drm/i915/display/intel_bios.c | 46 +++++++++--------------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index 1a30e645c5a7..459571e2cc57 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -337,18 +337,6 @@ static bool fixup_lfp_data_ptrs(const void *bdb, void *ptrs_block)
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
@@ -372,11 +360,22 @@ static void next_lfp_data_ptr(struct lvds_lfp_data_ptr_table *next,
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
@@ -385,17 +384,8 @@ static void *generate_lfp_data_ptrs(struct drm_i915_private *i915,
 
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
 
@@ -413,7 +403,7 @@ static void *generate_lfp_data_ptrs(struct drm_i915_private *i915,
 	table_size = sizeof(struct lvds_dvo_timing);
 	size = make_lfp_data_ptr(&ptrs->ptr[0].dvo_timing, table_size, size);
 
-	table_size = t0 - block + 2;
+	table_size = fp_timing_size;
 	size = make_lfp_data_ptr(&ptrs->ptr[0].fp_timing, table_size, size);
 
 	if (ptrs->ptr[0].fp_timing.table_size)
@@ -428,14 +418,14 @@ static void *generate_lfp_data_ptrs(struct drm_i915_private *i915,
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
-- 
2.35.1

