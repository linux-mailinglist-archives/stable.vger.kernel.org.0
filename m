Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E63066B386
	for <lists+stable@lfdr.de>; Sun, 15 Jan 2023 19:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjAOSos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Jan 2023 13:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbjAOSoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Jan 2023 13:44:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C4D12878
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 10:44:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB2B060D2E
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 18:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F448C433EF;
        Sun, 15 Jan 2023 18:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673808284;
        bh=YO7OSqXz+dPMCB/8U0rzm5fdfK0+gFUR8iS2h+bc9D0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MH1dkqjndB7AF6Qdr3/nxJssbxeVSKpdyc5Hw/FzZNCalvjE4UHhFS57gMuGX28H2
         JYHiqnmB1Dwi4qxZktrGtzkw43AYwVZlxVyApTlJw0tdUXZpGolhXFRHMc053zzG6l
         onOU1iKu1a6mn5uTnflpLH7kSdHp0qCvURyUdKMbPV6wtGBhlGlFvWJPrupvLulb+W
         Givb3ix0B6opyV5cmL9zMzSU/JtwVUuB+5AHRHEjsPGrigCmnVfs0fvQlDC00GPDJw
         VnzC8/x1WT8PdLqz4dRMttYS064X0sfBCQwg6v+G+1MEY4eDk7YoqZ7a9uZZaps57+
         wMxPtBUY+hT1Q==
Date:   Sun, 15 Jan 2023 20:44:33 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Aaron Thompson <dev@aaront.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mm: Always release pages to the buddy
 allocator in" failed to apply to 5.15-stable tree
Message-ID: <Y8RJkeo1AeIseJ2/@kernel.org>
References: <1673714753254212@kroah.com>
 <Y8O6DR6ygBU6+nbe@kernel.org>
 <01010185b4ab0650-155b2e0c-d18b-4e04-b3a6-5f1604a36478-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01010185b4ab0650-155b2e0c-d18b-4e04-b3a6-5f1604a36478-000000@us-west-2.amazonses.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 15, 2023 at 09:03:05AM +0000, Aaron Thompson wrote:
> 
> On 2023-01-15 00:32, Mike Rapoport wrote:
> > On Sat, Jan 14, 2023 at 05:45:53PM +0100, gregkh@linuxfoundation.org
> > wrote:
> > > 
> > > The patch below does not apply to the 5.15-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git
> > > commit
> > > id to <stable@vger.kernel.org>.
> > 
> > The patch below applies to 5.15, 5.10 and 5.4.
> 
> Thanks Mike. The code works as intended, but the commit message and the
> comments have some inaccuracies (changed function names, no KMSAN). Does
> that matter? I can send updated patches if so, just let me know.

It's up to stable folks, I think.
Greg?

> > As for 4.19 and 4.14, they still have bootmem/nobootmem so I'd rather
> > wouldn't touch them.
> > 
> > From c292bd7e64214fcc78b7c72a9ccd3973dd19b7fb Mon Sep 17 00:00:00 2001
> > From: Aaron Thompson <dev@aaront.org>
> > Date: Fri, 6 Jan 2023 22:22:44 +0000
> > Subject: [PATCH] mm: Always release pages to the buddy allocator in
> >  memblock_free_late().
> > 
> > If CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, memblock_free_pages()
> > only releases pages to the buddy allocator if they are not in the
> > deferred range. This is correct for free pages (as defined by
> > for_each_free_mem_pfn_range_in_zone()) because free pages in the
> > deferred range will be initialized and released as part of the deferred
> > init process. memblock_free_pages() is called by memblock_free_late(),
> > which is used to free reserved ranges after memblock_free_all() has
> > run. All pages in reserved ranges have been initialized at that point,
> > and accordingly, those pages are not touched by the deferred init
> > process. This means that currently, if the pages that
> > memblock_free_late() intends to release are in the deferred range, they
> > will never be released to the buddy allocator. They will forever be
> > reserved.
> > 
> > In addition, memblock_free_pages() calls kmsan_memblock_free_pages(),
> > which is also correct for free pages but is not correct for reserved
> > pages. KMSAN metadata for reserved pages is initialized by
> > kmsan_init_shadow(), which runs shortly before memblock_free_all().
> > 
> > For both of these reasons, memblock_free_pages() should only be called
> > for free pages, and memblock_free_late() should call __free_pages_core()
> > directly instead.
> > 
> > One case where this issue can occur in the wild is EFI boot on
> > x86_64. The x86 EFI code reserves all EFI boot services memory ranges
> > via memblock_reserve() and frees them later via memblock_free_late()
> > (efi_reserve_boot_services() and efi_free_boot_services(),
> > respectively). If any of those ranges happens to fall within the
> > deferred init range, the pages will not be released and that memory will
> > be unavailable.
> > 
> > For example, on an Amazon EC2 t3.micro VM (1 GB) booting via EFI:
> > 
> > v6.2-rc2:
> >   # grep -E 'Node|spanned|present|managed' /proc/zoneinfo
> >   Node 0, zone      DMA
> >           spanned  4095
> >           present  3999
> >           managed  3840
> >   Node 0, zone    DMA32
> >           spanned  246652
> >           present  245868
> >           managed  178867
> > 
> > v6.2-rc2 + patch:
> >   # grep -E 'Node|spanned|present|managed' /proc/zoneinfo
> >   Node 0, zone      DMA
> >           spanned  4095
> >           present  3999
> >           managed  3840
> >   Node 0, zone    DMA32
> >           spanned  246652
> >           present  245868
> >           managed  222816   # +43,949 pages
> > 
> > Fixes: 3a80a7fa7989 ("mm: meminit: initialise a subset of struct pages
> > if CONFIG_DEFERRED_STRUCT_PAGE_INIT is set")
> > Signed-off-by: Aaron Thompson <dev@aaront.org>
> > Link:
> > https://lore.kernel.org/r/01010185892de53e-e379acfb-7044-4b24-b30a-e2657c1ba989-000000@us-west-2.amazonses.com
> > Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
> > ---
> >  mm/memblock.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index 2b7397781c99..838d59a74c65 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -1615,7 +1615,13 @@ void __init __memblock_free_late(phys_addr_t
> > base, phys_addr_t size)
> >  	end = PFN_DOWN(base + size);
> > 
> >  	for (; cursor < end; cursor++) {
> > -		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
> > +		/*
> > +		 * Reserved pages are always initialized by the end of
> > +		 * memblock_free_all() (by memmap_init() and, if deferred
> > +		 * initialization is enabled, memmap_init_reserved_pages()), so
> > +		 * these pages can be released directly to the buddy allocator.
> > +		 */
> > +		__free_pages_core(pfn_to_page(cursor), 0);
> >  		totalram_pages_inc();
> >  	}
> >  }
> > --
> > 2.35.1
> > 
> > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> 
> Thanks,
> -- Aaron

-- 
Sincerely yours,
Mike.
