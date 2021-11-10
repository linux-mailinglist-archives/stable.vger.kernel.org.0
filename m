Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1905D44C81A
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhKJS6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:53386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233672AbhKJS5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:57:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD18F61186;
        Wed, 10 Nov 2021 18:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570212;
        bh=Kc9Qc/E1Dl/uONBjKow7nOp5LCqgeGgl5kDuljE1lCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fvel9+1cxXEjqAEE8I0h7JxaJy6HX+ogH3JVvziou0AEsPrFXAiR4C/bRD8AYuiCF
         6pQNYUXtZzbteiHylXy4gGjYZ05T0ZQu697OIc4Q/VumtZdFe3v3en5hsh5zmVx16x
         NZSGr0Q4+5UeaRyqSAx0vpfBENnEAV4pYgX7c/GQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 13/26] kfence: default to dynamic branch instead of static keys mode
Date:   Wed, 10 Nov 2021 19:44:12 +0100
Message-Id: <20211110182004.120292963@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182003.700594531@linuxfoundation.org>
References: <20211110182003.700594531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

commit 4f612ed3f748962cbef1316ff3d323e2b9055b6e upstream.

We have observed that on very large machines with newer CPUs, the static
key/branch switching delay is on the order of milliseconds.  This is due
to the required broadcast IPIs, which simply does not scale well to
hundreds of CPUs (cores).  If done too frequently, this can adversely
affect tail latencies of various workloads.

One workaround is to increase the sample interval to several seconds,
while decreasing sampled allocation coverage, but the problem still
exists and could still increase tail latencies.

As already noted in the Kconfig help text, there are trade-offs: at
lower sample intervals the dynamic branch results in better performance;
however, at very large sample intervals, the static keys mode can result
in better performance -- careful benchmarking is recommended.

Our initial benchmarking showed that with large enough sample intervals
and workloads stressing the allocator, the static keys mode was slightly
better.  Evaluating and observing the possible system-wide side-effects
of the static-key-switching induced broadcast IPIs, however, was a blind
spot (in particular on large machines with 100s of cores).

Therefore, a major downside of the static keys mode is, unfortunately,
that it is hard to predict performance on new system architectures and
topologies, but also making conclusions about performance of new
workloads based on a limited set of benchmarks.

Most distributions will simply select the defaults, while targeting a
large variety of different workloads and system architectures.  As such,
the better default is CONFIG_KFENCE_STATIC_KEYS=n, and re-enabling it is
only recommended after careful evaluation.

For reference, on x86-64 the condition in kfence_alloc() generates
exactly
2 instructions in the kmem_cache_alloc() fast-path:

 | ...
 | cmpl   $0x0,0x1a8021c(%rip)  # ffffffff82d560d0 <kfence_allocation_gate>
 | je     ffffffff812d6003      <kmem_cache_alloc+0x243>
 | ...

which, given kfence_allocation_gate is infrequently modified, should be
well predicted by most CPUs.

Link: https://lkml.kernel.org/r/20211019102524.2807208-2-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/dev-tools/kfence.rst |   12 ++++++++----
 lib/Kconfig.kfence                 |   26 +++++++++++++++-----------
 2 files changed, 23 insertions(+), 15 deletions(-)

--- a/Documentation/dev-tools/kfence.rst
+++ b/Documentation/dev-tools/kfence.rst
@@ -231,10 +231,14 @@ Guarded allocations are set up based on
 of the sample interval, the next allocation through the main allocator (SLAB or
 SLUB) returns a guarded allocation from the KFENCE object pool (allocation
 sizes up to PAGE_SIZE are supported). At this point, the timer is reset, and
-the next allocation is set up after the expiration of the interval. To "gate" a
-KFENCE allocation through the main allocator's fast-path without overhead,
-KFENCE relies on static branches via the static keys infrastructure. The static
-branch is toggled to redirect the allocation to KFENCE.
+the next allocation is set up after the expiration of the interval.
+
+When using ``CONFIG_KFENCE_STATIC_KEYS=y``, KFENCE allocations are "gated"
+through the main allocator's fast-path by relying on static branches via the
+static keys infrastructure. The static branch is toggled to redirect the
+allocation to KFENCE. Depending on sample interval, target workloads, and
+system architecture, this may perform better than the simple dynamic branch.
+Careful benchmarking is recommended.
 
 KFENCE objects each reside on a dedicated page, at either the left or right
 page boundaries selected at random. The pages to the left and right of the
--- a/lib/Kconfig.kfence
+++ b/lib/Kconfig.kfence
@@ -25,17 +25,6 @@ menuconfig KFENCE
 
 if KFENCE
 
-config KFENCE_STATIC_KEYS
-	bool "Use static keys to set up allocations"
-	default y
-	depends on JUMP_LABEL # To ensure performance, require jump labels
-	help
-	  Use static keys (static branches) to set up KFENCE allocations. Using
-	  static keys is normally recommended, because it avoids a dynamic
-	  branch in the allocator's fast path. However, with very low sample
-	  intervals, or on systems that do not support jump labels, a dynamic
-	  branch may still be an acceptable performance trade-off.
-
 config KFENCE_SAMPLE_INTERVAL
 	int "Default sample interval in milliseconds"
 	default 100
@@ -56,6 +45,21 @@ config KFENCE_NUM_OBJECTS
 	  pages are required; with one containing the object and two adjacent
 	  ones used as guard pages.
 
+config KFENCE_STATIC_KEYS
+	bool "Use static keys to set up allocations" if EXPERT
+	depends on JUMP_LABEL
+	help
+	  Use static keys (static branches) to set up KFENCE allocations. This
+	  option is only recommended when using very large sample intervals, or
+	  performance has carefully been evaluated with this option.
+
+	  Using static keys comes with trade-offs that need to be carefully
+	  evaluated given target workloads and system architectures. Notably,
+	  enabling and disabling static keys invoke IPI broadcasts, the latency
+	  and impact of which is much harder to predict than a dynamic branch.
+
+	  Say N if you are unsure.
+
 config KFENCE_STRESS_TEST_FAULTS
 	int "Stress testing of fault handling and error reporting" if EXPERT
 	default 0


