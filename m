Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314AD595A90
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiHPLsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234530AbiHPLrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:47:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596F3CE489;
        Tue, 16 Aug 2022 04:22:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D507B611DD;
        Tue, 16 Aug 2022 11:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7790C4314B;
        Tue, 16 Aug 2022 11:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660648921;
        bh=B3Cp+rc9JnP4A5sS0Tb/beiRMg2eQ2MfwsgJcC6DSic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XRSpu/YJyH1+Y7NPcgpdaBLaXPr1J1K4UaGAYmizLXGcG8jFmishpqAaGPFB6hQug
         zs5hF8CLiYKyp+G06kLm1vH3IGQ7hwd0W6fKl9k9C9LIswGRHlLFI2yqzEx7t9/Drp
         RNpcH0ncWKKNmsrI33O7GsGvegWHUBV5PTkJS8R8=
Date:   Tue, 16 Aug 2022 13:21:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrey Konovalov <andreyknvl@google.com>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 0767/1157] kasan: fix zeroing vmalloc memory with
 HW_TAGS
Message-ID: <Yvt91VYNEJFnWV1r@kroah.com>
References: <20220815180439.416659447@linuxfoundation.org>
 <20220815180510.173732661@linuxfoundation.org>
 <9b1474ea-8568-cdb5-72dc-51d577497f8a@kernel.org>
 <817356d8-2a5f-56a4-ca4e-03f5a185c8af@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <817356d8-2a5f-56a4-ca4e-03f5a185c8af@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 01:14:13PM +0200, Jiri Slaby wrote:
> On 16. 08. 22, 13:04, Jiri Slaby wrote:
> > On 15. 08. 22, 20:02, Greg Kroah-Hartman wrote:
> > > From: Andrey Konovalov <andreyknvl@google.com>
> > > 
> > > [ Upstream commit 6c2f761dad7851d8088b91063ccaea3c970efe78 ]
> > > 
> > > HW_TAGS KASAN skips zeroing page_alloc allocations backing vmalloc
> > > mappings via __GFP_SKIP_ZERO.  Instead, these pages are zeroed via
> > > kasan_unpoison_vmalloc() by passing the KASAN_VMALLOC_INIT flag.
> > > 
> > > The problem is that __kasan_unpoison_vmalloc() does not zero pages when
> > > either kasan_vmalloc_enabled() or is_vmalloc_or_module_addr() fail.
> > > 
> > > Thus:
> > > 
> > > 1. Change __vmalloc_node_range() to only set KASAN_VMALLOC_INIT when
> > >     __GFP_SKIP_ZERO is set.
> > > 
> > > 2. Change __kasan_unpoison_vmalloc() to always zero pages when the
> > >     KASAN_VMALLOC_INIT flag is set.
> > > 
> > > 3. Add WARN_ON() asserts to check that KASAN_VMALLOC_INIT cannot be set
> > >     in other early return paths of __kasan_unpoison_vmalloc().
> > > 
> > > Also clean up the comment in __kasan_unpoison_vmalloc.
> > > 
> > > Link: https://lkml.kernel.org/r/4bc503537efdc539ffc3f461c1b70162eea31cf6.1654798516.git.andreyknvl@google.com
> > > Fixes: 23689e91fb22 ("kasan, vmalloc: add vmalloc tagging for HW_TAGS")
> > > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > > Cc: Marco Elver <elver@google.com>
> > > Cc: Alexander Potapenko <glider@google.com>
> > > Cc: Dmitry Vyukov <dvyukov@google.com>
> > > Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >   mm/kasan/hw_tags.c | 32 +++++++++++++++++++++++---------
> > >   mm/vmalloc.c       | 10 +++++-----
> > >   2 files changed, 28 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> > > index 9e1b6544bfa8..9ad8eff71b28 100644
> > > --- a/mm/kasan/hw_tags.c
> > > +++ b/mm/kasan/hw_tags.c
> > > @@ -257,27 +257,37 @@ static void unpoison_vmalloc_pages(const void
> > > *addr, u8 tag)
> > >       }
> > >   }
> > > +static void init_vmalloc_pages(const void *start, unsigned long size)
> > > +{
> > > +    const void *addr;
> > > +
> > > +    for (addr = start; addr < start + size; addr += PAGE_SIZE) {
> > > +        struct page *page = virt_to_page(addr);
> > > +
> > > +        clear_highpage_kasan_tagged(page);
> > 
> > This breaks build on aarch64:
> > > mm/kasan/hw_tags.c: In function 'init_vmalloc_pages':
> > > mm/kasan/hw_tags.c:267:17: error: implicit declaration of function
> > > 'clear_highpage_kasan_tagged'
> > > [-Werror=implicit-function-declaration]
> 
> Which translates into: this is missing:
> commit d9da8f6cf55eeca642c021912af1890002464c64
> Author: Andrey Konovalov <andreyknvl@gmail.com>
> Date:   Thu Jun 9 20:18:46 2022 +0200
> 
>     mm: introduce clear_highpage_kasan_tagged

Thanks, now added to both 5.18.y and 5.19.y.  I'll push out some -rc2
releases with this in it so it can get some testing.

greg k-h
