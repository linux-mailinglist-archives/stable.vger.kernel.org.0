Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260BE228A39
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 22:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbgGUU5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 16:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbgGUU5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 16:57:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F235E2068F;
        Tue, 21 Jul 2020 20:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595365039;
        bh=47HH6QkGny3t+PJsAhLsLtAlYgrRhHjchOOHZ5uJMBc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vyPS86kwYpBcJpfryYFhmTsp2DXCoNEofWLirVyu4+MFeHojAg9RrbUCUa0MR6tFF
         B9lUqUUbvY8cVp+naeWkwx34vRzF1+c7jNQt1Qs+qzlMM7K1dHK1IwDFVdXy6MsiSu
         lnBaoYU3Q0Pqx/B+FWoFuv+GTPhE7PW1+kkq9d2o=
Date:   Tue, 21 Jul 2020 13:57:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        chris@chris-wilson.co.uk, michael.j.ruhl@intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        stable@vger.kernel.org
Subject:  + io-mapping-indicate-mapping-failure.patch added to -mm
 tree
Message-ID: <20200721205718.2Tm852Zqu%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: io-mapping: indicate mapping failure
has been added to the -mm tree.  Its filename is
     io-mapping-indicate-mapping-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/io-mapping-indicate-mapping-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/io-mapping-indicate-mapping-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Michael J. Ruhl" <michael.j.ruhl@intel.com>
Subject: io-mapping: indicate mapping failure

The !ATOMIC_IOMAP version of io_maping_init_wc will always return success,
even when the ioremap fails.

Since the ATOMIC_IOMAP version returns NULL when the init fails, and
callers check for a NULL return on error this is unexpected.

During a device probe, where the ioremap failed, a crash can look
like this:

BUG: unable to handle page fault for address: 0000000000210000
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 Oops: 0002 [#1] PREEMPT SMP
 CPU: 0 PID: 177 Comm:
 RIP: 0010:fill_page_dma [i915]
  gen8_ppgtt_create [i915]
  i915_ppgtt_create [i915]
  intel_gt_init [i915]
  i915_gem_init [i915]
  i915_driver_probe [i915]
  pci_device_probe
  really_probe
  driver_probe_device

The remap failure occurred much earlier in the probe.  If it had
been propagated, the driver would have exited with an error.

Return NULL on ioremap failure.

Link: http://lkml.kernel.org/r/20200721171936.81563-1-michael.j.ruhl@intel.com
Fixes: cafaf14a5d8f ("io-mapping: Always create a struct to hold metadata about the io-mapping")
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io-mapping.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/io-mapping.h~io-mapping-indicate-mapping-failure
+++ a/include/linux/io-mapping.h
@@ -118,7 +118,7 @@ io_mapping_init_wc(struct io_mapping *io
 	iomap->prot = pgprot_noncached(PAGE_KERNEL);
 #endif
 
-	return iomap;
+	return iomap->iomem ? iomap : NULL;
 }
 
 static inline void
_

Patches currently in -mm which might be from michael.j.ruhl@intel.com are

io-mapping-indicate-mapping-failure.patch

