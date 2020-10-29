Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E2529EA4C
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 12:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgJ2LPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 07:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgJ2LPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 07:15:11 -0400
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4201D20791
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 11:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603970110;
        bh=6Fr/uD1LYilMDZm0QmvnANwzG9wwnurN0oVLq8UeBr8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lPZIcM2Vqa3YY30FxHsBeiKAgRTuoC6ylALxV3tdAO/HI8WJYye5aeUO9grjBJ190
         aLVE/rGdaRElSSM5YggNOVTtUiLGIoX37yCl5027LbtyJC/CdHSxensvmJMJMWuYUx
         MwqfVo0PJ0D5EAfLd7dh3P4djGLg2oknhV+7EgUE=
Received: by mail-ot1-f47.google.com with SMTP id h62so1887399oth.9
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 04:15:10 -0700 (PDT)
X-Gm-Message-State: AOAM531c7ZPn+19FFxiik4ONISaXNnIlQ48qbzkTpEDOJ0Zsgzh5aB0/
        3C4x9m/b6hxZMvEE0MPBr9eS+nvE9HSI8zeu7MA=
X-Google-Smtp-Source: ABdhPJy1zFp/8rxt3BOQb7vBU4X2dfHxCqxbF5PxgYQrYf1MuxVhOv3eesNX+Uovm2SPRMKetRy96coRgTuU492r+ag=
X-Received: by 2002:a05:6830:4028:: with SMTP id i8mr2671084ots.90.1603970109453;
 Thu, 29 Oct 2020 04:15:09 -0700 (PDT)
MIME-Version: 1.0
References: <20201029110334.4118-1-ardb@kernel.org>
In-Reply-To: <20201029110334.4118-1-ardb@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 29 Oct 2020 12:14:58 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGiJtqp51h2FA35Q44VDrsx8Kd3Pi=e45Trn6MLN=iV9A@mail.gmail.com>
Message-ID: <CAMj1kXGiJtqp51h2FA35Q44VDrsx8Kd3Pi=e45Trn6MLN=iV9A@mail.gmail.com>
Subject: Re: [PATCH] ARM: highmem: avoid clobbering non-page aligned memory reservations
To:     Linux ARM <linux-arm-kernel@lists.infradead.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Oct 2020 at 12:03, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> free_highpages() iterates over the free memblock regions in high
> memory, and marks each page as available for the memory management
> system. However, as it rounds the end of each region downwards, we
> may end up freeing a page that is memblock_reserve()d, resulting
> in memory corruption. So align the end of the range to the next
> page instead.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm/mm/init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index a391804c7ce3..d41781cb5496 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -354,7 +354,7 @@ static void __init free_highpages(void)
>         for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
>                                 &range_start, &range_end, NULL) {
>                 unsigned long start = PHYS_PFN(range_start);
> -               unsigned long end = PHYS_PFN(range_end);
> +               unsigned long end = PHYS_PFN(PAGE_ALIGN(range_end));
>

Apologies, this should be

-               unsigned long start = PHYS_PFN(range_start);
+               unsigned long start = PHYS_PFN(PAGE_ALIGN(range_start));
                unsigned long end = PHYS_PFN(range_end);


Strangely enough, the wrong version above also fixed the issue I was
seeing, but it is start that needs rounding up, not end.

>                 /* Ignore complete lowmem entries */
>                 if (end <= max_low)
> --
> 2.17.1
>
