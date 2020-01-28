Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18A8F14B633
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgA1ODW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:03:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgA1ODW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:03:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6991424685;
        Tue, 28 Jan 2020 14:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220201;
        bh=IJD9R2j0hsqiGOgYqv+TWIQqwiy/lpRCbiwIDBQJYNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x70EJf7SrErR5sMtycvhpfLxYmPBaewHauvgqu09+pm5QdGfF4IRA7yOrAm56Kher
         o+NKI6xE5RqtmQOVzTE4Zhp0Vh0mo2fn+9uPdu0APSmXv1ncamLnZYLRHZ2M7eOlZt
         99NyuUQT+BTW4wjznV4bAAHdbUQWeQjRAKtpxWYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.4 040/104] drm/i915: Align engine->uabi_class/instance with i915_drm.h
Date:   Tue, 28 Jan 2020 15:00:01 +0100
Message-Id: <20200128135823.145637119@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

commit 5eec71829ad7749a8c918f66a91a9bcf6fb4462a upstream.

In our ABI we have defined I915_ENGINE_CLASS_INVALID_NONE and
I915_ENGINE_CLASS_INVALID_VIRTUAL as negative values which creates
implicit coupling with type widths used in, also ABI, struct
i915_engine_class_instance.

One place where we export engine->uabi_class
I915_ENGINE_CLASS_INVALID_VIRTUAL is from our our tracepoints. Because the
type of the former is u8 in contrast to u16 defined in the ABI, 254 will
be returned instead of 65534 which userspace would legitimately expect.

Another place is I915_CONTEXT_PARAM_ENGINES.

Therefore we need to align the type used to store engine ABI class and
instance.

v2:
 * Update the commit message mentioning get_engines and cc stable.
   (Chris)

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: 6d06779e8672 ("drm/i915: Load balancing across a virtual engine")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v5.3+
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20200116134508.25211-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit 0b3bd0cdc329a1e2e00995cffd61aacf58c87cb4)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_busy.c     |   12 ++++++------
 drivers/gpu/drm/i915/gt/intel_engine_types.h |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_busy.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_busy.c
@@ -9,16 +9,16 @@
 #include "i915_gem_ioctls.h"
 #include "i915_gem_object.h"
 
-static __always_inline u32 __busy_read_flag(u8 id)
+static __always_inline u32 __busy_read_flag(u16 id)
 {
-	if (id == (u8)I915_ENGINE_CLASS_INVALID)
+	if (id == (u16)I915_ENGINE_CLASS_INVALID)
 		return 0xffff0000u;
 
 	GEM_BUG_ON(id >= 16);
 	return 0x10000u << id;
 }
 
-static __always_inline u32 __busy_write_id(u8 id)
+static __always_inline u32 __busy_write_id(u16 id)
 {
 	/*
 	 * The uABI guarantees an active writer is also amongst the read
@@ -29,14 +29,14 @@ static __always_inline u32 __busy_write_
 	 * last_read - hence we always set both read and write busy for
 	 * last_write.
 	 */
-	if (id == (u8)I915_ENGINE_CLASS_INVALID)
+	if (id == (u16)I915_ENGINE_CLASS_INVALID)
 		return 0xffffffffu;
 
 	return (id + 1) | __busy_read_flag(id);
 }
 
 static __always_inline unsigned int
-__busy_set_if_active(const struct dma_fence *fence, u32 (*flag)(u8 id))
+__busy_set_if_active(const struct dma_fence *fence, u32 (*flag)(u16 id))
 {
 	const struct i915_request *rq;
 
@@ -57,7 +57,7 @@ __busy_set_if_active(const struct dma_fe
 		return 0;
 
 	/* Beware type-expansion follies! */
-	BUILD_BUG_ON(!typecheck(u8, rq->engine->uabi_class));
+	BUILD_BUG_ON(!typecheck(u16, rq->engine->uabi_class));
 	return flag(rq->engine->uabi_class);
 }
 
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -300,8 +300,8 @@ struct intel_engine_cs {
 	u8 class;
 	u8 instance;
 
-	u8 uabi_class;
-	u8 uabi_instance;
+	u16 uabi_class;
+	u16 uabi_instance;
 
 	u32 context_size;
 	u32 mmio_base;


