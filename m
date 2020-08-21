Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7D524D2E0
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 12:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgHUKge convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 21 Aug 2020 06:36:34 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:58620 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728428AbgHUKgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 06:36:17 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22196525-1500050 
        for multiple; Fri, 21 Aug 2020 11:36:09 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200821102204.GH3354@suse.de>
References: <20200821085011.28878-1-chris@chris-wilson.co.uk> <20200821095129.GF3354@suse.de> <159800366215.29194.8455636122843151159@build.alporthouse.com> <20200821102204.GH3354@suse.de>
Subject: Re: [PATCH 1/4] mm: Export flush_vm_area() to sync the PTEs upon construction
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>, stable@vger.kernel.org
To:     Joerg Roedel <jroedel@suse.de>
Date:   Fri, 21 Aug 2020 11:36:07 +0100
Message-ID: <159800616716.29194.8354000222129735639@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Joerg Roedel (2020-08-21 11:22:04)
> On Fri, Aug 21, 2020 at 10:54:22AM +0100, Chris Wilson wrote:
> > Ok. I thought it had to be after assigning the *ptep. If we apply the
> > sync first, do not have to worry about PGTBL_PTE_MODIFIED from the
> > *ptep?
> 
> Hmm, if I understand the code correctly, you are re-implementing some
> generic ioremap/vmalloc mapping logic in the i915 driver. I don't know
> the reason, but if it is valid you need to manually call
> arch_sync_kernel_mappings() from your driver like this to be correct:
> 
>         if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PTE_MODIFIED)
>                 arch_sync_kernel_mappings();
> 
> In practice this is a no-op, because nobody sets PGTBL_PTE_MODIFIED in
> ARCH_PAGE_TABLE_SYNC_MASK, so the above code would be optimized away.
> 
> But what you really care about is the tracking in apply_to_page_range(),
> as that allocates the !pte levels of your page-table, which needs
> synchronization on x86-32.
> 
> Btw, what are the reasons you can't use generic vmalloc/ioremap
> interfaces to map the range?

ioremap_prot and ioremap_page_range assume a contiguous IO address. So
we needed to allocate the vmalloc area [and would then need to iterate
over the discontiguous iomem chunks with ioremap_page_range], and since
alloc_vm_area returned the ptep, it looked clearer to then assign those
according to whether we wanted ioremapping or a plain page. So we ended
up with one call to the core to return us a vm_struct and a pte array
that worked for either backing store.
-Chris
