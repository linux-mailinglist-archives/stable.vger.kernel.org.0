Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D24228A35
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 22:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgGUU4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 16:56:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbgGUU4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 16:56:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B0D32068F;
        Tue, 21 Jul 2020 20:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595365008;
        bh=KXe07neV+ZEgRPCCe7/VBouncKkNzZrEdGEz94FCszg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QZZgSDgeznpntPXTPGfzhqLSggplonVNcIOIWjDSritOEhpcCFHK//hVd58N3PKC/
         T61U1Ww0bZS/hBk0MTKPvV5/qT7OJxIdtLj/ABvXq5jmZU/Cf7KSMHphTrBWAIGJhM
         nsSkt7mR6+AYrX5krzxDO5pqDyiTSP6jPi3UwLjw=
Date:   Tue, 21 Jul 2020 13:56:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Michael J. Ruhl" <michael.j.ruhl@intel.com>
Cc:     dri-devel@lists.freedesktop.org,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: Re: [PATCH v2] io-mapping: Indicate mapping failure
Message-Id: <20200721135648.9603d924377825a7e6c0023b@linux-foundation.org>
In-Reply-To: <20200721171936.81563-1-michael.j.ruhl@intel.com>
References: <20200721171936.81563-1-michael.j.ruhl@intel.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 21 Jul 2020 13:19:36 -0400 "Michael J. Ruhl" <michael.j.ruhl@intel.com> wrote:

> The !ATOMIC_IOMAP version of io_maping_init_wc will always return
> success, even when the ioremap fails.
> 
> Since the ATOMIC_IOMAP version returns NULL when the init fails, and
> callers check for a NULL return on error this is unexpected.
> 
> During a device probe, where the ioremap failed, a crash can look
> like this:
> 
> BUG: unable to handle page fault for address: 0000000000210000
>  #PF: supervisor write access in kernel mode
>  #PF: error_code(0x0002) - not-present page
>  Oops: 0002 [#1] PREEMPT SMP
>  CPU: 0 PID: 177 Comm:
>  RIP: 0010:fill_page_dma [i915]
>   gen8_ppgtt_create [i915]
>   i915_ppgtt_create [i915]
>   intel_gt_init [i915]
>   i915_gem_init [i915]
>   i915_driver_probe [i915]
>   pci_device_probe
>   really_probe
>   driver_probe_device
> 
> The remap failure occurred much earlier in the probe.  If it had
> been propagated, the driver would have exited with an error.
> 
> Return NULL on ioremap failure.
>
> ...
>
> --- a/include/linux/io-mapping.h
> +++ b/include/linux/io-mapping.h
> @@ -118,7 +118,7 @@ io_mapping_init_wc(struct io_mapping *iomap,
>  	iomap->prot = pgprot_noncached(PAGE_KERNEL);
>  #endif
>  
> -	return iomap;
> +	return iomap->iomem ? iomap : NULL;
>  }
>  
>  static inline void

LGTM.  However I do think it would be stylistically better/typical to
detect and handle the error early, rather than to blunder on,
pointlessly initializing things?

--- a/include/linux/io-mapping.h~io-mapping-indicate-mapping-failure-fix
+++ a/include/linux/io-mapping.h
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
@@ -118,7 +121,7 @@ io_mapping_init_wc(struct io_mapping *io
 	iomap->prot = pgprot_noncached(PAGE_KERNEL);
 #endif
 
-	return iomap->iomem ? iomap : NULL;
+	return iomap;
 }
 
 static inline void
_

