Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE7950D7E9
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 05:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240612AbiDYEB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 00:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiDYEBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 00:01:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E5A35AAC;
        Sun, 24 Apr 2022 20:58:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3950A60F52;
        Mon, 25 Apr 2022 03:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4153C385A4;
        Mon, 25 Apr 2022 03:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650859096;
        bh=Qg2qC4MlVV8ba/9Yso7PQ4kibU52a66r+hx9krqhIq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oF8RXR1SU9VpaGp2Xxe2qjZ867pLsHYNH4mGXr8ciFPnEO0gwjcYmhWU8+71iZa6A
         Zb1l/Put2MGXbfsiiRVjVaLm6dYVjCA2uCfd9EFznRmUc74Y1KI6UcNMHJNqhTCbO3
         StY27togyW6lLrjN1Agca5+p8VgKMsubGjjGy5gOX0lAsWmDukumP0lysW7ET0Dn2l
         h2E9ZPg71hza1+dNjMQB5ZHzK3VYs7rVgk0cT2aLyuiV/u90OFg1o6YZ3NwIQVNX46
         zgFeGIiLYzMMBQfPhXKn/d8PCOC5tJjqbRb3WPVvzI2koosu7z8mXifSh1wHFriX75
         /oXvxzxGgE+Vw==
Date:   Mon, 25 Apr 2022 06:58:08 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guillaume Tucker <gtucker@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Russell King <linux@armlinux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Will Deacon <will@kernel.org>,
        "kernelci . org bot" <bot@kernelci.org>,
        kernelci-results@groups.io,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] arm[64]/memremap: don't abuse pfn_valid() to ensure
 presence of linear map
Message-ID: <YmYcUEZfyk1FbJyW@kernel.org>
References: <20220424172044.22220-1-rppt@kernel.org>
 <CAMj1kXGzL2u1gOBs7EutZXXej-2-a+EouEZySXXsQ0Dz0gaKTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGzL2u1gOBs7EutZXXej-2-a+EouEZySXXsQ0Dz0gaKTA@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 24, 2022 at 11:19:05PM +0200, Ard Biesheuvel wrote:
> On Sun, 24 Apr 2022 at 19:22, Mike Rapoport <rppt@kernel.org> wrote:
> >
> > From: Mike Rapoport <rppt@linux.ibm.com>
> >
> > The semantics of pfn_valid() is to check presence of the memory map for a
> > PFN and not whether a PFN is covered by the linear map. The memory map may
> > be present for NOMAP memory regions, but they won't be mapped in the linear
> > mapping.  Accessing such regions via __va() when they are memremap()'ed
> > will cause a crash.

...

> > diff --git a/kernel/iomem.c b/kernel/iomem.c
> > index 62c92e43aa0d..e85bed24c0a9 100644
> > --- a/kernel/iomem.c
> > +++ b/kernel/iomem.c
> > @@ -33,7 +33,7 @@ static void *try_ram_remap(resource_size_t offset, size_t size,
> >         unsigned long pfn = PHYS_PFN(offset);
> >
> >         /* In the simple case just return the existing linear address */
> > -       if (pfn_valid(pfn) && !PageHighMem(pfn_to_page(pfn)) &&
> > +       if (!PageHighMem(pfn_to_page(pfn)) &&
> 
> This looks wrong to me. Calling any of the PageXxx() accessors is only
> safe if the PFN is valid, since otherwise, we don't know if the
> associated struct page exists.

Yeah, you are right, was over-enthusiastic here...
 
> >             arch_memremap_can_ram_remap(offset, size, flags))
> >                 return __va(offset);
> >
> >
> > base-commit: b2d229d4ddb17db541098b83524d901257e93845
> > --
> > 2.28.0
> >

-- 
Sincerely yours,
Mike.
