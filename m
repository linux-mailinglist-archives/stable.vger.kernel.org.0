Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E17B7889B
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 11:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfG2Jjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 05:39:41 -0400
Received: from conssluserg-06.nifty.com ([210.131.2.91]:20905 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfG2Jjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 05:39:41 -0400
X-Greylist: delayed 1392 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2019 05:39:40 EDT
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id x6T9dZk6032431;
        Mon, 29 Jul 2019 18:39:36 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com x6T9dZk6032431
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1564393176;
        bh=OvGgGY+dgwLXgEKVa2h6PzusTMe05KI1PVF/woNjrhk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=A4v2BH/xAeLIhnO42BZ/x9uQ4+WEMdBV9dB+rYLnglOykUhWDFOFWVa73Emf8Gycm
         rghWwoz3WN5dzBdIp+egO6z/MByjpw7VgupiEElTwzj4/5ERT1yacLPzSwCQ5xfjT7
         26ZmIRLiXg+3kcrg+nLwRPYYRckZtTzmM6gL79HUOpF+MnmVdS3GsnxiCCd0wu1jgb
         UrDFvjM67jKDTQul/vH5poRqoEa9PAUAKLrAVOcj+SDUHRLtP1KsBczN/VZnJTvNjO
         fhb/VAXCWN/wJPbT2tYMXwlrGE7TNp0GeqJk7Qr5xZnIVkZpLYFAjIqczxgY5Afg2B
         c4UVJAagV9O9g==
X-Nifty-SrcIP: [209.85.221.176]
Received: by mail-vk1-f176.google.com with SMTP id b69so11866731vkb.3;
        Mon, 29 Jul 2019 02:39:36 -0700 (PDT)
X-Gm-Message-State: APjAAAUt8NlOEj2859aPHppiGIZrFxsI0RJNJQgk4BJ0XRLSbM2km92j
        4FYeZn77Kmw1Dws0XlDR87rR84F/CK4l9mbxcC0=
X-Google-Smtp-Source: APXvYqwEX+Lp8XpvfBa4PcWqJpgOlLEg0Aba3p7+WL/zHArfuap+JR6G0C4CvAMZW3uB2c3HEIKDtFji+TvuRuE8UyM=
X-Received: by 2002:a1f:a34c:: with SMTP id m73mr27418063vke.74.1564393175172;
 Mon, 29 Jul 2019 02:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190729091517.5334-1-yamada.masahiro@socionext.com>
In-Reply-To: <20190729091517.5334-1-yamada.masahiro@socionext.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Mon, 29 Jul 2019 18:38:59 +0900
X-Gmail-Original-Message-ID: <CAK7LNASjXdMJG5OVz4qhyGHHLGd0uZO9ifH_iqkUqYxKD+Xn2g@mail.gmail.com>
Message-ID: <CAK7LNASjXdMJG5OVz4qhyGHHLGd0uZO9ifH_iqkUqYxKD+Xn2g@mail.gmail.com>
Subject: Re: [PATCH] kbuild: initialize CLANG_FLAGS correctly in the top Makefile
To:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Cc:     Stephen Boyd <swboyd@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        stable <stable@vger.kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 6:16 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> CLANG_FLAGS is initialized by the following line:
>
>   CLANG_FLAGS     := --target=$(notdir $(CROSS_COMPILE:%-=%))
>
> ..., which is run only when CROSS_COMPILE is set.
>
> Some build targets (bindeb-pkg etc.) recurse to the top Makefile.
>
> When you build the kernel with Clang but without CROSS_COMPILE,
> the same compiler flags such as -no-integrated-as are accumulated
> into CLANG_FLAGS.
>
> If you run 'make CC=clang' and then 'make CC=clang bindeb-pkg',
> Kbuild will recompile everything needlessly due to the build command
> change.
>
> Fix this by correctly initializing CLANG_FLAGS.
>
> Fixes: 238bcbc4e07f ("kbuild: consolidate Clang compiler flags")
> Cc: <stable@vger.kernel.org> # v4.20+

This should be v5.0+

> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---


-- 
Best Regards
Masahiro Yamada
