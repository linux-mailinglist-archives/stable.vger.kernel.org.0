Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B865822F093
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732499AbgG0OZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732493AbgG0OZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:25:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 775222083E;
        Mon, 27 Jul 2020 14:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859942;
        bh=Rc3LqmVNrUoUef3e4HgaTNJPrptVc3bY/lS8DI5SHkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4syDZ+HT1e9k/mijVs17xVKnI4LN+HZAQQQVYOJKf2s7RiyE4j2+oQsIeknTLJcD
         Wey4CLyjAtGUrUqWNk/Z6Nxd88h5bSJKmOHyHbEmAl2xOFCkU1HE1vn6JCNjITGFSK
         EmHfjCtrwD9dmei2AXrvrneMuW+g9VPGfMklk2yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.7 165/179] io-mapping: indicate mapping failure
Date:   Mon, 27 Jul 2020 16:05:40 +0200
Message-Id: <20200727134940.703288031@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

commit e0b3e0b1a04367fc15c07f44e78361545b55357c upstream.

The !ATOMIC_IOMAP version of io_maping_init_wc will always return
success, even when the ioremap fails.

Since the ATOMIC_IOMAP version returns NULL when the init fails, and
callers check for a NULL return on error this is unexpected.

During a device probe, where the ioremap failed, a crash can look like
this:

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

The remap failure occurred much earlier in the probe.  If it had been
propagated, the driver would have exited with an error.

Return NULL on ioremap failure.

[akpm@linux-foundation.org: detect ioremap_wc() errors earlier]

Fixes: cafaf14a5d8f ("io-mapping: Always create a struct to hold metadata about the io-mapping")
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200721171936.81563-1-michael.j.ruhl@intel.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/io-mapping.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/io-mapping.h
+++ b/include/linux/io-mapping.h
@@ -107,9 +107,12 @@ io_mapping_init_wc(struct io_mapping *io
 		   resource_size_t base,
 		   unsigned long size)
 {
+	iomap->iomem = ioremap_wc(base, size);
+	if (!iomap->iomem)
+		return NULL;
+
 	iomap->base = base;
 	iomap->size = size;
-	iomap->iomem = ioremap_wc(base, size);
 #if defined(pgprot_noncached_wc) /* archs can't agree on a name ... */
 	iomap->prot = pgprot_noncached_wc(PAGE_KERNEL);
 #elif defined(pgprot_writecombine)


