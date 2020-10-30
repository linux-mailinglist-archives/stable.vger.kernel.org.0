Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E2C2A0E50
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 20:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgJ3TGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 15:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbgJ3TGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 15:06:40 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB68C0613CF
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 12:06:40 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w65so6125822pfd.3
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 12:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RQEa2t9G01U7xDWaaWZe1C3Uxzgnunrmlx0ygY2fWcs=;
        b=ECUDCKSGfehaCNag08WkqEban8v+QMHXjmKYcrJ4Dl5JPlyfGWZPeMUdvHcGxSjMRC
         k0B9lh8EY+IOCfH2sZfW1W+nh4aRm6enviBIfgw6E6XhOGjjPAmDyPkMIPE7efp8IEMJ
         Uj8i53CMfYQ9stj7IGscoNUARtyRHhkbe6z4MO9cfGpiYY12LxERVvvtOILYZ6ySMCRy
         xUGFJ9nqX34ZcsIVdIPYn5BAXDmVOtWshDBo3gopk4rEQERk020BTODYp5LBFU+fPR3z
         DRNT2an7sFvyRKJ83t0zj02Iav7bXeDiMpEJwaxdDSYXMIRmSX3uj7HGy2FSnMu3C4Ce
         N6Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RQEa2t9G01U7xDWaaWZe1C3Uxzgnunrmlx0ygY2fWcs=;
        b=SddtDg394HkKE+29WJ68esIkvqL5Javv4nwwyRwS92iANuprurE7ANE2ysI2XjhdYD
         H9HEJJ0ld0RZaG+O8WHIA9OWuawS1l1pSwetpBsorOBxuQ34vpE2z+G+Nvo7YB5TtK4U
         mPPoqTefVZyU0YLjf5yh0JoWNSTs8TVWAaHPbV3SQSNMJiaSSjRER4+sHpeb0fG2GQpM
         oH/OhTjzw5f15Zieorqzu9MOfUV6+g3QeTGyFwaE3NhxpP1ExmUGPG5pz2IS7YqRMOsl
         dmItdsNs+FZy8VGME4y+8hLKdHRbdMr0X0qlq14MEOtcgKij5o8FwEJSiEsWpIUgQuYM
         2xSQ==
X-Gm-Message-State: AOAM533cY8U3yWy2m6tlQKcjxWFwneX1IWwY8L6h+jAZMREvrX02uLhq
        QcDIlmgUJm7KOrJH1IDSkzF2dXUV1+4njLojfeXxuHigTTA=
X-Google-Smtp-Source: ABdhPJxopuZL/T3G9tBcqxPxPQJBXTQBXe3b2i2C09yLZSZB5X7dGzjDtZeOkKuMg56SH7s/XMUm4RqC0Pc67GwkL+M=
X-Received: by 2002:aa7:9a04:0:b029:163:fe2a:9e04 with SMTP id
 w4-20020aa79a040000b0290163fe2a9e04mr11070049pfj.30.1604084799111; Fri, 30
 Oct 2020 12:06:39 -0700 (PDT)
MIME-Version: 1.0
References: <CA+SOCLLXnxcf=bTazCT1amY7B4_37HTEXL2OwHowVGCb8SLSQQ@mail.gmail.com>
 <20201030190245.92967-1-jiancai@google.com>
In-Reply-To: <20201030190245.92967-1-jiancai@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 30 Oct 2020 12:06:28 -0700
Message-ID: <CAKwvOdmduyqjn7d6mG6CrSqCJC3ikJRphjWfKnqxvC2P=yoU2g@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86/crc32c - fix building with clang ias
To:     "# 3.4.x" <stable@vger.kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jian Cai <jiancai@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ stable

On Fri, Oct 30, 2020 at 12:04 PM Jian Cai <caij2003@gmail.com> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> commit 44623b2818f4 ("crypto: x86/crc32c - fix building with clang ias")
> upstream
>
> The clang integrated assembler complains about movzxw:
>
> arch/x86/crypto/crc32c-pcl-intel-asm_64.S:173:2: error: invalid instruction mnemonic 'movzxw'
>
> It seems that movzwq is the mnemonic that it expects instead,
> and this is what objdump prints when disassembling the file.
>
> Fixes: 6a8ce1ef3940 ("crypto: crc32c - Optimize CRC32C calculation with PCLMULQDQ instruction")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> [jc: Fixed conflicts due to lack of 34fdce6981b969]
> Signed-off-by: Jian Cai <jiancai@google.com>
> ---
>
> Thanks Nathan! This patch addresses Nathan's comments regarding format
> and note.
>
>
>  arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
> index d9b734d0c8cc..3c6e01520a97 100644
> --- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
> +++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
> @@ -170,7 +170,7 @@ continue_block:
>
>         ## branch into array
>         lea     jump_table(%rip), bufp
> -       movzxw  (bufp, %rax, 2), len
> +       movzwq  (bufp, %rax, 2), len
>         lea     crc_array(%rip), bufp
>         lea     (bufp, len, 1), bufp
>         JMP_NOSPEC bufp
> --
> 2.29.1.341.ge80a0c044ae-goog
>


-- 
Thanks,
~Nick Desaulniers
