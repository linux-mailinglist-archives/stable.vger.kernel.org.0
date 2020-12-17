Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249762DD032
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 12:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgLQLO6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 17 Dec 2020 06:14:58 -0500
Received: from mail-ot1-f46.google.com ([209.85.210.46]:44081 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbgLQLO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 06:14:57 -0500
Received: by mail-ot1-f46.google.com with SMTP id f16so26841638otl.11;
        Thu, 17 Dec 2020 03:14:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KJvh92esfWyHpcdkLeM+bdzabnEWcD1A6t+as3ieGWU=;
        b=WV9VhZu6Ov55FKLJ++nMcGJHPMkzXEAWCGY0XYDyDDH2A+Aa6288/zX5z6OB6NmkEQ
         EAsE/53+3S38wZDTMzTeoUz6Wp8J9qyHobBAGBY4hZYNaNgDPj4CJBCbhiqvaJW52pkD
         KnjRAJxf+h8uokCseCHNIKmHzRdJoj91WquIh2JbkEdi+cOOkj+L8SW4AGNT8jBr7EUs
         7mUfISGW+v+UUbHLwZFXX6g33kmXasLVlrxeytaOagH7iF+A8AyUMl9KncAbw3JYWocL
         5MSBPOKQfNdv0zF5mEWoX4pkHdU+FjWz8Z5hLyM+xOdQcXtIMxgWQjRIyF9SXvG2DBhc
         c5dA==
X-Gm-Message-State: AOAM532/E4hFyvx93GilWhPrfW3YPY7f/sye1LtDzZGmnPNWqfeQDORW
        k6fa4E6FDi/xlXnJ7Z7URFhhIiC5q/dGRlbQKKM=
X-Google-Smtp-Source: ABdhPJzfh/T4FJJMaSbA8072V/qZfQ6UcGpwTzGY99OQj+SuzW1sn57JfH4h5kRcjaVbSgyJMKv/z+WPO2hipu/hULw=
X-Received: by 2002:a9d:63cd:: with SMTP id e13mr29394063otl.37.1608203656271;
 Thu, 17 Dec 2020 03:14:16 -0800 (PST)
MIME-Version: 1.0
References: <20201216233956.280068-1-paul@crapouillou.net>
In-Reply-To: <20201216233956.280068-1-paul@crapouillou.net>
From:   =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Date:   Thu, 17 Dec 2020 12:14:04 +0100
Message-ID: <CAAdtpL7kP_+VWJHNhiqybh9PbnLbbgiT-d29sj7arSk8Ckpwvg@mail.gmail.com>
Subject: Re: [PATCH] MIPS: boot: Fix unaligned access with CONFIG_MIPS_RAW_APPENDED_DTB
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>, od@zcrc.me,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 17, 2020 at 12:41 AM Paul Cercueil <paul@crapouillou.net> wrote:
>
> The compressed payload is not necesarily 4-byte aligned, at least when
> compiling with Clang. In that case, the 4-byte value appended to the
> compressed payload that corresponds to the uncompressed kernel image
> size must be read using get_unaligned_le().
>
> This fixes Clang-built kernels not booting on MIPS (tested on a Ingenic
> JZ4770 board).
>
> Fixes: b8f54f2cde78 ("MIPS: ZBOOT: copy appended dtb to the end of the kernel")
> Cc: <stable@vger.kernel.org> # v4.7
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  arch/mips/boot/compressed/decompress.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
