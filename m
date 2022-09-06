Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37195AED37
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239836AbiIFN6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240041AbiIFN4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:56:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C1782D06;
        Tue,  6 Sep 2022 06:42:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69AD6B818C0;
        Tue,  6 Sep 2022 13:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FA5C433C1;
        Tue,  6 Sep 2022 13:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471736;
        bh=CokGPfzHoASZ6pra4lgp/IDl+kyekfeklOkeoq0Fsk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/lRQKsUjoztHdDQdwNHik298qkqPXNNyfyq+newBN14NDniCkoTpRrHsxWFySAER
         tRXMx+ZMkPFMZj7rh6qkNX84nZb7gQaVh4NxFZ+GltWT8OVPDx11O2x+c8sBmHsg7I
         KeHJHl44eiKd/MqlZBAaoKwMfvOifzd2LlDhKNUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Auld <matthew.auld@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Ramalingam C <ramalingam.c@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 020/155] drm/i915/ttm: fix CCS handling
Date:   Tue,  6 Sep 2022 15:29:28 +0200
Message-Id: <20220906132830.279675979@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 8d905254162965c8e6be697d82c7dbf5d08f574d ]

Crucible + recent Mesa seems to sometimes hit:

GEM_BUG_ON(num_ccs_blks > NUM_CCS_BLKS_PER_XFER)

And it looks like we can also trigger this with gem_lmem_swapping, if we
modify the test to use slightly larger object sizes.

Looking closer it looks like we have the following issues in
migrate_copy():

  - We are using plain integer in various places, which we can easily
    overflow with a large object.

  - We pass the entire object size (when the src is lmem) into
    emit_pte() and then try to copy it, which doesn't work, since we
    only have a few fixed sized windows in which to map the pages and
    perform the copy. With an object > 8M we therefore aren't properly
    copying the pages. And then with an object > 64M we trigger the
    GEM_BUG_ON(num_ccs_blks > NUM_CCS_BLKS_PER_XFER).

So it looks like our copy handling for any object > 8M (which is our
CHUNK_SZ) is currently broken on DG2.

Fixes: da0595ae91da ("drm/i915/migrate: Evict and restore the flatccs capable lmem obj")
Testcase: igt@gem_lmem_swapping
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Ramalingam C <ramalingam.c@intel.com>
Reviewed-by: Ramalingam C<ramalingam.c@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220805132240.442747-2-matthew.auld@intel.com
(cherry picked from commit 8676145eb2f53a9940ff70910caf0125bd8a4bc2)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_migrate.c | 44 ++++++++++++-------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
index 2b10b96b17b5b..933648cc90ff9 100644
--- a/drivers/gpu/drm/i915/gt/intel_migrate.c
+++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
@@ -638,9 +638,9 @@ static int emit_copy(struct i915_request *rq,
 	return 0;
 }
 
-static int scatter_list_length(struct scatterlist *sg)
+static u64 scatter_list_length(struct scatterlist *sg)
 {
-	int len = 0;
+	u64 len = 0;
 
 	while (sg && sg_dma_len(sg)) {
 		len += sg_dma_len(sg);
@@ -650,28 +650,26 @@ static int scatter_list_length(struct scatterlist *sg)
 	return len;
 }
 
-static void
+static int
 calculate_chunk_sz(struct drm_i915_private *i915, bool src_is_lmem,
-		   int *src_sz, u32 bytes_to_cpy, u32 ccs_bytes_to_cpy)
+		   u64 bytes_to_cpy, u64 ccs_bytes_to_cpy)
 {
-	if (ccs_bytes_to_cpy) {
-		if (!src_is_lmem)
-			/*
-			 * When CHUNK_SZ is passed all the pages upto CHUNK_SZ
-			 * will be taken for the blt. in Flat-ccs supported
-			 * platform Smem obj will have more pages than required
-			 * for main meory hence limit it to the required size
-			 * for main memory
-			 */
-			*src_sz = min_t(int, bytes_to_cpy, CHUNK_SZ);
-	} else { /* ccs handling is not required */
-		*src_sz = CHUNK_SZ;
-	}
+	if (ccs_bytes_to_cpy && !src_is_lmem)
+		/*
+		 * When CHUNK_SZ is passed all the pages upto CHUNK_SZ
+		 * will be taken for the blt. in Flat-ccs supported
+		 * platform Smem obj will have more pages than required
+		 * for main meory hence limit it to the required size
+		 * for main memory
+		 */
+		return min_t(u64, bytes_to_cpy, CHUNK_SZ);
+	else
+		return CHUNK_SZ;
 }
 
-static void get_ccs_sg_sgt(struct sgt_dma *it, u32 bytes_to_cpy)
+static void get_ccs_sg_sgt(struct sgt_dma *it, u64 bytes_to_cpy)
 {
-	u32 len;
+	u64 len;
 
 	do {
 		GEM_BUG_ON(!it->sg || !sg_dma_len(it->sg));
@@ -702,12 +700,12 @@ intel_context_migrate_copy(struct intel_context *ce,
 {
 	struct sgt_dma it_src = sg_sgt(src), it_dst = sg_sgt(dst), it_ccs;
 	struct drm_i915_private *i915 = ce->engine->i915;
-	u32 ccs_bytes_to_cpy = 0, bytes_to_cpy;
+	u64 ccs_bytes_to_cpy = 0, bytes_to_cpy;
 	enum i915_cache_level ccs_cache_level;
 	u32 src_offset, dst_offset;
 	u8 src_access, dst_access;
 	struct i915_request *rq;
-	int src_sz, dst_sz;
+	u64 src_sz, dst_sz;
 	bool ccs_is_src, overwrite_ccs;
 	int err;
 
@@ -790,8 +788,8 @@ intel_context_migrate_copy(struct intel_context *ce,
 		if (err)
 			goto out_rq;
 
-		calculate_chunk_sz(i915, src_is_lmem, &src_sz,
-				   bytes_to_cpy, ccs_bytes_to_cpy);
+		src_sz = calculate_chunk_sz(i915, src_is_lmem,
+					    bytes_to_cpy, ccs_bytes_to_cpy);
 
 		len = emit_pte(rq, &it_src, src_cache_level, src_is_lmem,
 			       src_offset, src_sz);
-- 
2.35.1



