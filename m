Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4022F142D
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbhAKNV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:21:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733246AbhAKNTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:19:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BAAE2229C;
        Mon, 11 Jan 2021 13:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371115;
        bh=qTsFhm8C1KkjChvnUpqPkXt1ZpVh7r9qSFbqq2w+djE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5zaGUrufSGpN5Kdppy6O0N6qvMc9C7R9slaWysCp/pRTwlgmaHS3qrh2749eyyBR
         o4iVN1jPlPMHIC3pn8PYppJ3hkbjpviR2GiSPY8tL3RoflxT1+DSHaCtrUHZy4wOwp
         WMNXBK1ip/oKB5Ns7iE1FUyCvpFr15EMYPa7FtVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Auld <matthew.auld@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 130/145] drm/i915: clear the shadow batch
Date:   Mon, 11 Jan 2021 14:02:34 +0100
Message-Id: <20210111130054.762270523@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Auld <matthew.auld@intel.com>

commit 75353bcd2184010f08a3ed2f0da019bd9d604e1e upstream.

The shadow batch is an internal object, which doesn't have any page
clearing, and since the batch_len can be smaller than the object, we
should take care to clear it.

Testcase: igt/gen9_exec_parse/shadow-peek
Fixes: 4f7af1948abc ("drm/i915: Support ro ppgtt mapped cmdparser shadow buffers")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20201224151358.401345-1-matthew.auld@intel.com
Cc: stable@vger.kernel.org
(cherry picked from commit eeb52ee6c4a429ec301faf1dc48988744960786e)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_cmd_parser.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/i915/i915_cmd_parser.c
+++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
@@ -1166,7 +1166,7 @@ static u32 *copy_batch(struct drm_i915_g
 		}
 	}
 	if (IS_ERR(src)) {
-		unsigned long x, n;
+		unsigned long x, n, remain;
 		void *ptr;
 
 		/*
@@ -1177,14 +1177,15 @@ static u32 *copy_batch(struct drm_i915_g
 		 * We don't care about copying too much here as we only
 		 * validate up to the end of the batch.
 		 */
+		remain = length;
 		if (!(dst_obj->cache_coherent & I915_BO_CACHE_COHERENT_FOR_READ))
-			length = round_up(length,
+			remain = round_up(remain,
 					  boot_cpu_data.x86_clflush_size);
 
 		ptr = dst;
 		x = offset_in_page(offset);
-		for (n = offset >> PAGE_SHIFT; length; n++) {
-			int len = min(length, PAGE_SIZE - x);
+		for (n = offset >> PAGE_SHIFT; remain; n++) {
+			int len = min(remain, PAGE_SIZE - x);
 
 			src = kmap_atomic(i915_gem_object_get_page(src_obj, n));
 			if (needs_clflush)
@@ -1193,13 +1194,15 @@ static u32 *copy_batch(struct drm_i915_g
 			kunmap_atomic(src);
 
 			ptr += len;
-			length -= len;
+			remain -= len;
 			x = 0;
 		}
 	}
 
 	i915_gem_object_unpin_pages(src_obj);
 
+	memset32(dst + length, 0, (dst_obj->base.size - length) / sizeof(u32));
+
 	/* dst_obj is returned with vmap pinned */
 	return dst;
 }
@@ -1392,11 +1395,6 @@ static unsigned long *alloc_whitelist(u3
 
 #define LENGTH_BIAS 2
 
-static bool shadow_needs_clflush(struct drm_i915_gem_object *obj)
-{
-	return !(obj->cache_coherent & I915_BO_CACHE_COHERENT_FOR_WRITE);
-}
-
 /**
  * intel_engine_cmd_parser() - parse a batch buffer for privilege violations
  * @engine: the engine on which the batch is to execute
@@ -1539,16 +1537,9 @@ int intel_engine_cmd_parser(struct intel
 				ret = 0; /* allow execution */
 			}
 		}
-
-		if (shadow_needs_clflush(shadow->obj))
-			drm_clflush_virt_range(batch_end, 8);
 	}
 
-	if (shadow_needs_clflush(shadow->obj)) {
-		void *ptr = page_mask_bits(shadow->obj->mm.mapping);
-
-		drm_clflush_virt_range(ptr, (void *)(cmd + 1) - ptr);
-	}
+	i915_gem_object_flush_map(shadow->obj);
 
 	if (!IS_ERR_OR_NULL(jump_whitelist))
 		kfree(jump_whitelist);


