Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57208657574
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 11:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiL1KtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 05:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiL1KtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 05:49:16 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F737DA3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 02:49:15 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id e24so3467844uam.10
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 02:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qc4GMdi1dtN/U5J4nf2BxViaxJc5bdEY/94/Fx0h1oo=;
        b=GDpb95sQOqwhtno042AWhfoDl0nhCVpuvOZfzg0N9VK7B+ObUvY1HJXg5UDnuFEZyT
         XcvanvurpsD0m/qKhH5+eVkxhOYTAzHgGiu0ERW6rP3mojiBawuT1oESSOXJkT/xnmPS
         yIJJ0QuDcA893uMQBzoI2PhczPk68eeucdyUZJq6yO4usDmoAg094Sd0Sdz+dzY/kZ6d
         BPKRNavyeaP7nqCE4k31L/VZAEwr4EiiXH+LnE7JjBOWGoHMF7SrvSTKljdg8q9uxZCT
         PPFwzSTbq3931s1pRbWicWA7ByGGcMeRDatgcaPq7W2WNTKdCggg/hTxpTNFl+yiNvrL
         0wcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qc4GMdi1dtN/U5J4nf2BxViaxJc5bdEY/94/Fx0h1oo=;
        b=5FUXjdrLlUaRQzhk/7TPJdotT7uU5ksRcf7qIaq6a3qR43kwtLju0qR29yRyl2eyMA
         vdS71179tuHIJ9AKBKCkEtCOzC0XxDfEzMkK+q23lVYmzqiyU0Ot7gkKPuvC44DgYiBt
         KJbUO8l9mFqFWf62XuTY7eCne4LaRQTTXiJu/UR+hidv8sI0WQVQkgWc2b69Ew0/Vb5P
         xoVxHgBIaSnKqzYQrn1WH+CVpAp63K/9lQzW2TRDJJr1qPw8XnTNb0rz2tKuHPSvnUNB
         JuWdmKGB7tcMcbzjXjSbs6UvkLhXPWFIo6VW2RadVXcY9uwocGd4obdHOBcHQmMJAU7A
         Flaw==
X-Gm-Message-State: AFqh2kpVB8+Uwa3gJP2n33FInVdinHr3loMb6Fe1U90ez6Rll29ukrwF
        WeV4L0791j31iuodTOvyq4cGXuuyCBUlo0kFZa5Lpg==
X-Google-Smtp-Source: AMrXdXtFsHIeSouKwNPlsTpcJOWSMlR0NPg9XgKy51UaKg6Cvktw0EIVnnGJFn0Fu8vAMp+iebSa/M1UJx/vBFw5lT4=
X-Received: by 2002:ab0:152b:0:b0:418:620e:6794 with SMTP id
 o40-20020ab0152b000000b00418620e6794mr2222573uae.59.1672224554156; Wed, 28
 Dec 2022 02:49:14 -0800 (PST)
MIME-Version: 1.0
References: <20221213191813.4054267-1-giulio.benetti@benettiengineering.com>
In-Reply-To: <20221213191813.4054267-1-giulio.benetti@benettiengineering.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 28 Dec 2022 16:19:02 +0530
Message-ID: <CA+G9fYvHyx+R2Dbw+qijK5aG=k2w+YN_o3-KwWVYK1U-3L-ddg@mail.gmail.com>
Subject: Re: [PATCH] ARM: mm: fix warning on phys_addr_t to void pointer assignment
To:     Giulio Benetti <giulio.benetti@benettiengineering.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Will Deacon <will@kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Dec 2022 at 00:48, Giulio Benetti
<giulio.benetti@benettiengineering.com> wrote:
>
> zero_page is a void* pointer but memblock_alloc() returns phys_addr_t type
> so this generates a warning while using clang and with -Wint-error enabled
> that becomes and error. So let's cast the return of memblock_alloc() to
> (void *).
>
> Cc: <stable@vger.kernel.org> # 4.14.x +
> Fixes: 340a982825f7 ("ARM: 9266/1: mm: fix no-MMU ZERO_PAGE() implementation")
> Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


> ---
>  arch/arm/mm/nommu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mm/nommu.c b/arch/arm/mm/nommu.c
> index c1494a4dee25..53f2d8774fdb 100644
> --- a/arch/arm/mm/nommu.c
> +++ b/arch/arm/mm/nommu.c
> @@ -161,7 +161,7 @@ void __init paging_init(const struct machine_desc *mdesc)
>         mpu_setup();
>
>         /* allocate the zero page. */
> -       zero_page = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
> +       zero_page = (void *)memblock_alloc(PAGE_SIZE, PAGE_SIZE);
>         if (!zero_page)
>                 panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
>                       __func__, PAGE_SIZE, PAGE_SIZE);
> --
> 2.34.1


--
Linaro LKFT
https://lkft.linaro.org
