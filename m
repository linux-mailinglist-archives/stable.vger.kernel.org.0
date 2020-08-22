Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D22324E889
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 18:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgHVQNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 12:13:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:57120 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbgHVQNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Aug 2020 12:13:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 49E7DB746;
        Sat, 22 Aug 2020 16:13:29 +0000 (UTC)
Date:   Sat, 22 Aug 2020 18:12:58 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Pavel Machek <pavel@ucw.cz>, Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm: Track page table modifications in
 __apply_to_page_range()
Message-ID: <20200822161258.GP3354@suse.de>
References: <20200821123746.16904-1-joro@8bytes.org>
 <CAHk-=wgNEsVwVMwQdHL4O1tDWQa-HcmOv-EmqLTQH+SoC2CkWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgNEsVwVMwQdHL4O1tDWQa-HcmOv-EmqLTQH+SoC2CkWA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 12:18:41PM -0700, Linus Torvalds wrote:
> It also strikes me that I think the only architecture that uses the
> whole arch_sync_kernel_mappings() thing is now just x86-32.
> 
> [ Well, x86-64 still has it, but that's because we undid the 64-bit
> removal, but it's on the verge of going away and x86-64 shouldn't
> actually _need_ it any more ]
> 
> So all of this seems to be purely for 32-bit x86. Which kind of makes
> this all fail the smell test.

Yeah, it is certainly not the nicest thing to have in generic mm code,
but at least it is an improvement of the vmalloc_sync_all() interface we
had before, where the function had to be called at random undefined
places.

And x86-32 needs it, as long as we have the !SHARED_KERNEL_PMD cases
(which includes legacy paging). Or we also pre-allocate the PMDs on
x86-32 and forbid large ioremap mappings. But since the vmalloc area
gets larger with less RAM on x86-32, this would penalize low memory
machines by using more pages for the pre-allocations.

Not sure if making the vmalloc area on x86-32 a fixed 128MB range of
address space independent of RAM size is doable or if it will break some
machines. But with that pre-allocating PMDs would make more sense and we
could get rid of the p?d_alloc_track() stuff.

Regards,

	Joerg
