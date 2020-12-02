Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A392CB661
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 09:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgLBIHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 03:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgLBIHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 03:07:34 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D3EC0613D6
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 00:06:53 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id z23so841918oti.13
        for <stable@vger.kernel.org>; Wed, 02 Dec 2020 00:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I0tCyRA5cbLP1uZu2kabfULOo+G8IcQ9utIsl4Q6Qro=;
        b=rJGXmXDgcvEjb/aw5JVmkAKVpVZEp5l2a4AkLWZS3XveRXEFhukyI7gP3J1HblBfaU
         rl6sBsPBJJ596YlrcOtcLWHGepkLSQAhUfCO2FuU+8/GDnjGV37k+Lim+2tnxwJTyBSz
         /jWfbcsle7MfYQgW4CemIn9gseU508B5F0MnIEXpPeBa4QgUxlaLNgJLbYiWCzp7ftLb
         EV4TMzfs0S1LyaviBHUAB1RhR6dfOqba+kkHVRZtgBGMQlPqI1eZ0KdYWPaId4UtWIxc
         ldda6MRBHCfd9NHSj72FECyeqrZWsr51+6q5koFoUtdPZ/Y45Fo4R894RrvKoEEHeykg
         UKeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I0tCyRA5cbLP1uZu2kabfULOo+G8IcQ9utIsl4Q6Qro=;
        b=rfXxTN+/xvFDttT47dgGWYvpeNfpFBtPeO4n7z08z8udnAkD1fUoJA1KV2hOceP4X/
         eG+/mhxKrzBze53KfrsiEFnOV2fLh/goyWN1W7ochrCiww8BfUycI3GFI3C/+BBC+DMa
         v9yzW8Rh5MuikLUT1F2lAkGNpHgd6vHdcDw4S4270kjC4b65P8LyklObbREKN5jc6EDd
         ilg2QgXGTuJ8F3tYTAR7MKbXk36Rq8aP5pzB75/YFzd6sdIYlkN/8ebnNdc5nIZoK4t8
         XNMkf5Vzu406uSroyFf/YKwjVBzNhDpqkeZFktdPNXe+POD2zpk8ApNviGBXbWZAN6EL
         ej/w==
X-Gm-Message-State: AOAM533F3I+MSyqwZzSaiIl7pVE9tkSeKY9Dg+11pFDyKhpunXipg7BR
        BtpdvtQpeuzDhviVVmqt/YousCz0tkjAPklWHGBQ6g==
X-Google-Smtp-Source: ABdhPJx+6kpSCP3aID8m0AhXIV6ICicwWUrtK8KxyoaYrNQLijZkzXq7vQJGtL0HtrnNGdN9zYx4lVKni6RihTYJqsI=
X-Received: by 2002:a9d:4d83:: with SMTP id u3mr987334otk.283.1606896412771;
 Wed, 02 Dec 2020 00:06:52 -0800 (PST)
MIME-Version: 1.0
References: <20201202071057.4877-1-andrey.zhizhikin@leica-geosystems.com>
In-Reply-To: <20201202071057.4877-1-andrey.zhizhikin@leica-geosystems.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Wed, 2 Dec 2020 09:06:41 +0100
Message-ID: <CAHUa44HuNPmWufnxzqGLrwJqLxTkjCivYGaHvukEkk6nOd1r3g@mail.gmail.com>
Subject: Re: [PATCH] optee: extend normal memory check to also write-through
To:     Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
Cc:     op-tee@lists.trustedfirmware.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrey,

On Wed, Dec 2, 2020 at 8:11 AM Andrey Zhizhikin
<andrey.zhizhikin@leica-geosystems.com> wrote:
>
> ARMv7 Architecture Reference Manual [1] section A3.5.5 details Normal
> memory type, together with cacheability attributes that could be applied
> to memory regions defined as "Normal memory".
>
> Section B2.1.2 of the Architecture Reference Manual [1] also provides
> details regarding the Memory attributes that could be assigned to
> particular memory regions, which includes the descrption of cacheability
> attributes and cache allocation hints.
>
> Memory type and cacheability attributes forms 2 separate definitions,
> where cacheability attributes defines a mechanism of coherency control
> rather than the type of memory itself.
>
> In other words: Normal memory type can be configured with several
> combination of cacheability attributes, namely:
> - Write-Through (WT)
> - Write-Back (WB) followed by cache allocation hint:
>   - Write-Allocate
>   - No Write-Allocate (also known as Read-Allocate)
>
> Those types are mapped in the kernel to corresponding macros:
> - Write-Through: L_PTE_MT_WRITETHROUGH
> - Write-Back Write-Allocate: L_PTE_MT_WRITEALLOC
> - Write-Back Read-Allocate: L_PTE_MT_WRITEBACK
>
> Current implementation of the op-tee driver takes in account only 2 last
> memory region types, while performing a check if the memory block is
> allocated as "Normal memory", leaving Write-Through allocations to be
> not considered.
>
> Extend verification mechanism to include also Normal memory regios,
> which are designated with Write-Through cacheability attributes.

Are you trying to fix a real error with this or are you just trying to
cover all cases? I suspect the latter since you'd likely have
coherency problems with OP-TEE in Secure world if you used
Write-Through instead. Correct me if I'm wrong, but "Write-Back
Write-Allocate" and "Write-Back Read-Allocate" are both compatible
with each other as the "Allocate" part is just a hint.

Cheers,
Jens

>
> Link: [1]: https://developer.arm.com/documentation/ddi0406/cd
> Fixes: 853735e40424 ("optee: add writeback to valid memory type")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
> ---
>  drivers/tee/optee/call.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/tee/optee/call.c b/drivers/tee/optee/call.c
> index c981757ba0d4..8da27d02a2d6 100644
> --- a/drivers/tee/optee/call.c
> +++ b/drivers/tee/optee/call.c
> @@ -535,7 +535,8 @@ static bool is_normal_memory(pgprot_t p)
>  {
>  #if defined(CONFIG_ARM)
>         return (((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEALLOC) ||
> -               ((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEBACK));
> +               ((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEBACK) ||
> +               ((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITETHROUGH));
>  #elif defined(CONFIG_ARM64)
>         return (pgprot_val(p) & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL);
>  #else
> --
> 2.17.1
>
