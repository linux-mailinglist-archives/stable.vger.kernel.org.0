Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938866DAB96
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 12:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjDGKpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Apr 2023 06:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbjDGKpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Apr 2023 06:45:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F3C86A8;
        Fri,  7 Apr 2023 03:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 419FA61015;
        Fri,  7 Apr 2023 10:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A828CC433EF;
        Fri,  7 Apr 2023 10:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680864340;
        bh=muu+JIlK5fHa6J8PR8unxJYJv48OaEoAfH6LrCt/btI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=A8zTIcVawhMgzhWmdn9y9FiYTrsAEZ1bCKWm6xiV1xDE7k9AayjLPQI9QL//zFsWT
         E1RZvo2e3ezfVF4y+pUX3VtQYtKC6PFJJ7T2ByKjJGudRmfK+Jl0xsmlZvEqjtEBXm
         cv7JZfA359wqpeKUC0mgfvY0bGMkkFA+eK13VeH4wqLkSyFvJ3udTiDCfdGs0vws43
         GB8+6FX8fk/WJUM9Uq7XOzL6xZncdPW3pGH6P80dOcMm1TUTroQgm+M683GFqz3j3M
         grlY2iThEVbkMZOD60oLbG2dQgcSTFFJbwEQ8mbbljIo/vbmsI75dvCPMY/K8pocU8
         ktOE0aRSjVzGw==
Received: by mail-lj1-f169.google.com with SMTP id b6so23151417ljr.1;
        Fri, 07 Apr 2023 03:45:40 -0700 (PDT)
X-Gm-Message-State: AAQBX9fzkw3w84OYWyMqttOVjkpRbD+NwDyKYvQBRHAHgxMYy4P8TYCL
        xY6G/jazBkbr+BW0NclNJQb1obEUni3WMSuvdDQ=
X-Google-Smtp-Source: AKy350bOLCKKqmE65Wr+ZeKb7BWxqw9i1ccVmclFMyLlJMcKQiRf/sSWiDlgIgpyMW36rAKF11wKzbpx9XMEfpl5Dg4=
X-Received: by 2002:a2e:a307:0:b0:2a5:f850:c356 with SMTP id
 l7-20020a2ea307000000b002a5f850c356mr461087lje.2.1680864338726; Fri, 07 Apr
 2023 03:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230406040515.383238-1-jhubbard@nvidia.com> <CAMj1kXHxyntweiq76CdW=ov2_CkEQUbdPekGNDtFp7rBCJJE2w@mail.gmail.com>
 <a421b96a-ed4b-ae7d-2fe9-ed5f5f8deacf@nvidia.com>
In-Reply-To: <a421b96a-ed4b-ae7d-2fe9-ed5f5f8deacf@nvidia.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 7 Apr 2023 12:45:27 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGtFyugzi9MZW=4_oVTy==eAF6283fwvX9fdZhO98ZA3g@mail.gmail.com>
Message-ID: <CAMj1kXGtFyugzi9MZW=4_oVTy==eAF6283fwvX9fdZhO98ZA3g@mail.gmail.com>
Subject: Re: [PATCH] arm64/mm: don't WARN when alloc/free-ing device private pages
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Feiyang Chen <chenfeiyang@loongson.cn>,
        Alistair Popple <apopple@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 7 Apr 2023 at 02:13, John Hubbard <jhubbard@nvidia.com> wrote:
>
> On 4/6/23 00:31, Ard Biesheuvel wrote:
> > Hello John,
> >
> > On Thu, 6 Apr 2023 at 06:05, John Hubbard <jhubbard@nvidia.com> wrote:
> >>
> >> Although CONFIG_DEVICE_PRIVATE and hmm_range_fault() and related
> >> functionality was first developed on x86, it also works on arm64.
> >> However, when trying this out on an arm64 system, it turns out that
> >> there is a massive slowdown during the setup and teardown phases.
> >>
> >> This slowdown is due to lots of calls to WARN_ON()'s that are checking
> >> for pages that are out of the physical range for the CPU. However,
> >> that's a design feature of device private pages: they are specfically
> >> chosen in order to be outside of the range of the CPU's true physical
> >> pages.
> >>
>
> Hi Ard,
>
> Thank you for looking at this so soon, I've been working on filling
> in some details and studying what you said.
>
> By the way, to address an implicit question from Andrew on the other
> thread, the reason that this slows things down is due to a loop in
> __add_pages() that repeatedly calls through to vmemmap_populate(),
> like this:
>
> device driver setup: allocate struct pages for the device (GPU)
>     memremap_pages(pagemap.type = MEMORY_DEVICE_PRIVATE)
>         pagemap_range()
>         __add_pages() /* device private case does this */
>             for (; pfn < end_pfn; pfn += cur_nr_pages) {
>                 /* this loops 125 times on an x86 test machine: */
>                 sparse_add_section()
>                     section_activate()
>                         populate_section_memmap()
>                             __populate_section_memmap()
>                                 vmemmap_populate()
>
> >
> > Currently, the vmemmap region is dimensioned to only cover the PFN
> > range that backs the linear map. So the WARN() seems appropriate here:
> > you are mapping struct page[] ranges outside of the allocated window,
> > and afaict, you might actually wrap around and corrupt the linear map
> > at the start of the kernel VA space like this.
> >
>
> Well...it's only doing a partial hotplug of these pages, just enough to get
> ZONE_DEVICE to work. As I understand it so far, only the struct pages
> themselves are ever accessed, not any mappings.
>

That is what I am talking about - the struct pages are allocated in a
region that is reserved for something else.

Maybe an example helps here:

When running the 39-bit VA kernel build on a AMD Seatte board, we will
have (assuming sizeof(struct page) == 64)

memstart_addr := 0x80_0000_0000

PAGE_OFFSET := 0xffff_ff80_0000_0000

VMEMMAP_SHIFT := 6
VMEMMAP_START := 0xffff_fffe_0000_0000
VMEMMAP_SIZE := 0x1_0000_0000

pfn_to_page() conversions are based on ordinary array indexing
involving vemmap[], where vmemmap is defined as

#define vmemmap \
    ((struct page *)VMEMMAP_START - (memstart_addr >> PAGE_SHIFT))

So the PFN associated with the first usable DRAM address is
0x800_0000, and pfn_to_page(0x800_0000) will return VMEMMAP_START.

pfn_to_page(x) for any x < 0x800_0000 will produce a kernel VA that
points into the vmalloc area, and may conflict with the kernel
mapping, modules mappings, per-CPU mappings, IO mappings, etc etc.

pfn_to_page(x) for values 0xc00_0000 < x < 0x1000_0000 will produce a
kernel VA that points outside the region set aside for the vmemmap.
This region is currently unused, but that will likely change soon.

pfn_to_page(x) for any x >= 0x1000_0000 will wrap around and produce a
bogus address in the user range.

The bottom line is that the VMEMMAP region is dimensioned to cover
system memory only, i.e., what can be covered by the kernel direct
map. If you want to allocate struct pages for thing that are not
system memory, you will need to enlarge the VMEMMAP region, and ensure
that request_mem_region() produces a region that is covered by it.

This is going to be tricky with LPA2, because there, the 4k pages
configuration already uses up half of the vmalloc region to cover the
linear map, so we have to consider this carefully.


> More below:
>
> ...
> >>                 /* arch/x86/mm/init_64.c */
> >>                 vmemmap_free()
> >>                 {
> >>                   VM_BUG_ON(!PAGE_ALIGNED(start));
> >>                   VM_BUG_ON(!PAGE_ALIGNED(end));
> >>                   ...
> >>                 }
> >>
> >> So, the warning is a false positive for this case. Therefore, skip the
> >> warning if CONFIG_DEVICE_PRIVATE is set.
> >>
> >
> > I don't think this is a false positive. We'll need to adjust
> > VMEMMAP_SIZE to account for this.
> >
>
> Looking at the (new to me) arm64 code for this, VMEMMAP_SIZE is only
> ever used to calculate VMEMMAP_END, which in turn is used for the
> WARN_ON()'s in question, plus as the "ceiling" arg to free_empty_tables().
>
> It seems Mostly Harmless. How would you feel about changing it to a
> WARN_ON_ONCE() as Andrew suggested? That would completely fix the
> user-visible symptoms:
>

Actually, it should be a hard error, given the above.

> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 6f9d8898a025..82d4205af9f2 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1157,7 +1157,7 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
>  int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>                 struct vmem_altmap *altmap)
>  {
> -       WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
> +       WARN_ON_ONCE((start < VMEMMAP_START) || (end > VMEMMAP_END));
>
>         if (!IS_ENABLED(CONFIG_ARM64_4K_PAGES))
>                 return vmemmap_populate_basepages(start, end, node, altmap);
> @@ -1169,7 +1169,7 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>  void vmemmap_free(unsigned long start, unsigned long end,
>                 struct vmem_altmap *altmap)
>  {
> -       WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
> +       WARN_ON_ONCE((start < VMEMMAP_START) || (end > VMEMMAP_END));
>
>         unmap_hotplug_range(start, end, true, altmap);
>         free_empty_tables(start, end, VMEMMAP_START, VMEMMAP_END);
>
>
>
> thanks,
> --
> John Hubbard
> NVIDIA
>
