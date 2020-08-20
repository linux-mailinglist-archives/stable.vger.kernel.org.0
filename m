Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177E524C062
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 16:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgHTOPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 10:15:54 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:63769 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727104AbgHTOPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 10:15:53 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22188046-1500050 
        for multiple; Thu, 20 Aug 2020 15:15:47 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915: Break up error capture compression loops with cond_resched()
Date:   Thu, 20 Aug 2020 15:15:46 +0100
Message-Id: <20200820141546.21194-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
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
---
 drivers/gpu/drm/i915/i915_gpu_error.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/i915/i915_gpu_error.c
index 6a3a2ce0b394..6551ff04d5a6 100644
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

