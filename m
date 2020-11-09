Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A362ABA47
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387550AbgKINRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:17:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387555AbgKINRI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:17:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F06A20731;
        Mon,  9 Nov 2020 13:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927826;
        bh=YopzUqnTBgw3ySv48NYmbbGrAaxxv81qlNrkmhYOYnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVdPndkMwWvsj3x+S3QPqNkIxtpJNLBdYuwgLbfZ0lcDduqDeUsDE6pf43+DtcEpZ
         2h0W0FyZRlq6W9RQzSVJWwgC+PIeAWNk+7neUvffKZAE/pL25y7kqaHxX40pjdoNr/
         v2tFNOU1XomO/w3auukesTa4FHz9QVlEX80IsVcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Candelaria, Jared" <jared.candelaria@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        "Bloomfield, Jon" <jon.bloomfield@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 009/133] drm/i915: Avoid mixing integer types during batch copies
Date:   Mon,  9 Nov 2020 13:54:31 +0100
Message-Id: <20201109125031.168552219@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit c60b93cd4862d108214a14e655358ea714d7a12a upstream.

Be consistent and use unsigned long throughout the chunk copies to
avoid the inherent clumsiness of mixing integer types of different
widths and signs. Failing to take acount of a wider unsigned type when
using min_t can lead to treating it as a negative, only for it flip back
to a large unsigned value after passing a boundary check.

Fixes: ed13033f0287 ("drm/i915/cmdparser: Only cache the dst vmap")
Testcase: igt/gen9_exec_parse/bb-large
Reported-by: "Candelaria, Jared" <jared.candelaria@intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: "Candelaria, Jared" <jared.candelaria@intel.com>
Cc: "Bloomfield, Jon" <jon.bloomfield@intel.com>
Cc: <stable@vger.kernel.org> # v4.9+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200928215942.31917-1-chris@chris-wilson.co.uk
(cherry picked from commit b7eeb2b4132ccf1a7d38f434cde7043913d1ed3c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |    7 +++++--
 drivers/gpu/drm/i915/i915_cmd_parser.c         |   10 +++++-----
 drivers/gpu/drm/i915/i915_drv.h                |    4 ++--
 3 files changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -1962,8 +1962,8 @@ struct eb_parse_work {
 	struct i915_vma *batch;
 	struct i915_vma *shadow;
 	struct i915_vma *trampoline;
-	unsigned int batch_offset;
-	unsigned int batch_length;
+	unsigned long batch_offset;
+	unsigned long batch_length;
 };
 
 static int __eb_parse(struct dma_fence_work *work)
@@ -2033,6 +2033,9 @@ static int eb_parse_pipeline(struct i915
 	struct eb_parse_work *pw;
 	int err;
 
+	GEM_BUG_ON(overflows_type(eb->batch_start_offset, pw->batch_offset));
+	GEM_BUG_ON(overflows_type(eb->batch_len, pw->batch_length));
+
 	pw = kzalloc(sizeof(*pw), GFP_KERNEL);
 	if (!pw)
 		return -ENOMEM;
--- a/drivers/gpu/drm/i915/i915_cmd_parser.c
+++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
@@ -1136,7 +1136,7 @@ find_reg(const struct intel_engine_cs *e
 /* Returns a vmap'd pointer to dst_obj, which the caller must unmap */
 static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
 		       struct drm_i915_gem_object *src_obj,
-		       u32 offset, u32 length)
+		       unsigned long offset, unsigned long length)
 {
 	bool needs_clflush;
 	void *dst, *src;
@@ -1166,8 +1166,8 @@ static u32 *copy_batch(struct drm_i915_g
 		}
 	}
 	if (IS_ERR(src)) {
+		unsigned long x, n;
 		void *ptr;
-		int x, n;
 
 		/*
 		 * We can avoid clflushing partial cachelines before the write
@@ -1184,7 +1184,7 @@ static u32 *copy_batch(struct drm_i915_g
 		ptr = dst;
 		x = offset_in_page(offset);
 		for (n = offset >> PAGE_SHIFT; length; n++) {
-			int len = min_t(int, length, PAGE_SIZE - x);
+			int len = min(length, PAGE_SIZE - x);
 
 			src = kmap_atomic(i915_gem_object_get_page(src_obj, n));
 			if (needs_clflush)
@@ -1414,8 +1414,8 @@ static bool shadow_needs_clflush(struct
  */
 int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 			    struct i915_vma *batch,
-			    u32 batch_offset,
-			    u32 batch_length,
+			    unsigned long batch_offset,
+			    unsigned long batch_length,
 			    struct i915_vma *shadow,
 			    bool trampoline)
 {
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1903,8 +1903,8 @@ void intel_engine_init_cmd_parser(struct
 void intel_engine_cleanup_cmd_parser(struct intel_engine_cs *engine);
 int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 			    struct i915_vma *batch,
-			    u32 batch_offset,
-			    u32 batch_length,
+			    unsigned long batch_offset,
+			    unsigned long batch_length,
 			    struct i915_vma *shadow,
 			    bool trampoline);
 #define I915_CMD_PARSER_TRAMPOLINE_SIZE 8


