Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA40426C004
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 11:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgIPJBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 05:01:07 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:61298 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726505AbgIPJBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 05:01:06 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22442877-1500050 
        for multiple; Wed, 16 Sep 2020 10:00:59 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] drm/i915: Break up error capture compression loops with cond_resched()
Date:   Wed, 16 Sep 2020 10:00:58 +0100
Message-Id: <20200916090059.3189-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200916090059.3189-1-chris@chris-wilson.co.uk>
References: <20200916090059.3189-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As the error capture will compress user buffers as directed to by the
user, it can take an arbitrary amount of time and space. Break up the
compression loops with a call to cond_resched(), that will allow other
processes to schedule (avoiding the soft lockups) and also serve as a
warning should we try to make this loop atomic in the future.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
---
 drivers/gpu/drm/i915/i915_gpu_error.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/i915/i915_gpu_error.c
index 3e6cbb0d1150..a635ec8d0b94 100644
--- a/drivers/gpu/drm/i915/i915_gpu_error.c
+++ b/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -311,6 +311,8 @@ static int compress_page(struct i915_vma_compress *c,
 
 		if (zlib_deflate(zstream, Z_NO_FLUSH) != Z_OK)
 			return -EIO;
+
+		cond_resched();
 	} while (zstream->avail_in);
 
 	/* Fallback to uncompressed if we increase size? */
@@ -397,6 +399,7 @@ static int compress_page(struct i915_vma_compress *c,
 	if (!(wc && i915_memcpy_from_wc(ptr, src, PAGE_SIZE)))
 		memcpy(ptr, src, PAGE_SIZE);
 	dst->pages[dst->page_count++] = ptr;
+	cond_resched();
 
 	return 0;
 }
-- 
2.20.1

