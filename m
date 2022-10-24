Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9A560A1B9
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiJXLcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiJXLc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:32:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EA05726D;
        Mon, 24 Oct 2022 04:32:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFCA161257;
        Mon, 24 Oct 2022 11:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CFBC433C1;
        Mon, 24 Oct 2022 11:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611129;
        bh=3OvWPyMcLqjL4YA7kf1WwcIcmYqLuyCFPIa5p8Kn9iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbIK7KWOhP4H7BkXLbME059EM+iCt4VnSeqNe2YJFeeX7a4LzS8pFm/zL7/1hINFF
         7pARmez+bCllusFy8RqMX0jSooL4vtEiP/5b9fLRBDMs/v16/isqRkCbfuV8Bssrg6
         wCKFeMB2efSgFid6BR92O3QuDy+8yGg6Mi4hZjgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.0 02/20] drm/i915/bios: Use hardcoded fp_timing size for generating LFP data pointers
Date:   Mon, 24 Oct 2022 13:31:04 +0200
Message-Id: <20221024112934.517947061@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
References: <20221024112934.415391158@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit d3a7051841f0a4bcb1ee26a1b721c6150cc4c2b1 upstream.

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

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6592
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220818192223.29881-3-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_bios.c |   46 +++++++++++-------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -337,18 +337,6 @@ static bool fixup_lfp_data_ptrs(const vo
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
@@ -372,11 +360,22 @@ static void next_lfp_data_ptr(struct lvd
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
@@ -385,17 +384,8 @@ static void *generate_lfp_data_ptrs(stru
 
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
 
@@ -413,7 +403,7 @@ static void *generate_lfp_data_ptrs(stru
 	table_size = sizeof(struct lvds_dvo_timing);
 	size = make_lfp_data_ptr(&ptrs->ptr[0].dvo_timing, table_size, size);
 
-	table_size = t0 - block + 2;
+	table_size = fp_timing_size;
 	size = make_lfp_data_ptr(&ptrs->ptr[0].fp_timing, table_size, size);
 
 	if (ptrs->ptr[0].fp_timing.table_size)
@@ -428,14 +418,14 @@ static void *generate_lfp_data_ptrs(stru
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


