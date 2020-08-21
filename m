Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20EB524D5A5
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 15:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgHUNBs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 21 Aug 2020 09:01:48 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:62309 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727123AbgHUNBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 09:01:48 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22198351-1500050 
        for multiple; Fri, 21 Aug 2020 14:01:43 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAHk-=wiu1WHD0x0VXKoLQGy43S7KLCY=Yd-TPDh=7tDW08554w@mail.gmail.com>
References: <20200821085011.28878-1-chris@chris-wilson.co.uk> <20200821085011.28878-2-chris@chris-wilson.co.uk> <CAHk-=wiu1WHD0x0VXKoLQGy43S7KLCY=Yd-TPDh=7tDW08554w@mail.gmail.com>
Subject: Re: [PATCH 2/4] drm/i915/gem: Sync the vmap PTEs upon construction
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux-MM <linux-mm@kvack.org>, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        stable <stable@vger.kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 21 Aug 2020 14:01:41 +0100
Message-ID: <159801490171.29194.13892566081151243171@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Linus Torvalds (2020-08-21 13:41:03)
> On Fri, Aug 21, 2020 at 1:50 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >
> > Since synchronising the PTE after assignment is a manual step, use the
> > newly exported interface to flush the PTE after assigning via
> > alloc_vm_area().
> 
> This commit message doesn't make much sense to me.
> 
> Are you talking about synchronizing the page directory structure
> across processes after possibly creating new kernel page tables?
> 
> Because that has nothing to do with the PTE. It's all about making
> sure the _upper_ layers of the page directories are populated
> everywhere..
> 
> The name seems off to me too - what are you "flushing"? (And yes, I
> know about the flush_cache_vmap(), but that looks just bogus, since
> any non-mapped area shouldn't have any virtual caches to begin with,
> so I suspect that is just the crazy architectures being confused -
> flush_cache_vmap() is a no-op on any sane architecture - and powerpc
> that mis-uses it for other things).

I was trying to mimic map_kernel_range() which does the
arch_sync_kernel_mappings and flush_cache_vmap on top of the
apply_to_page_range performed by alloc_vm_area, because buried away in
there, on x86-32, is a set_pmd(). Since map_kernel_range() wrapped
map_kernel_range_noflush(), flush seemed like the right verb.

Joerg pointed out that the sync belonged to __apply_to_page_range and
fixed it in situ.
-Chris
