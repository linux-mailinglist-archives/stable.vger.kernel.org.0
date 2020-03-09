Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8FB17D825
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 03:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgCICbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Mar 2020 22:31:48 -0400
Received: from condef-01.nifty.com ([202.248.20.66]:49071 "EHLO
        condef-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgCICbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Mar 2020 22:31:48 -0400
X-Greylist: delayed 720 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Mar 2020 22:31:47 EDT
Received: from conssluserg-01.nifty.com ([10.126.8.80])by condef-01.nifty.com with ESMTP id 0292BmfV010446
        for <stable@vger.kernel.org>; Mon, 9 Mar 2020 11:11:48 +0900
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id 0292Bg27013094;
        Mon, 9 Mar 2020 11:11:43 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 0292Bg27013094
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1583719903;
        bh=cjFzylmuOvPTqSk4AfYJnlN1AXZVcRsUD5oy7paosWc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=brn1anuSdORCiRuJ9lSE0AjZagjqXtvR78d4vUb4hzdQ3qgfS1br2sLhX7GzyPqlT
         p3l3ejD5C0rs0lC+i4sYwEQArXxb29y0fDK81OflaZ9ayhVlalbIIrlpH7YIDSX9+a
         XF6OcCo8tBLaW4JxDs/wz0lR8OBmgxY8R7Gb7Fp1qmebHzC4afuZbBxUqdbl3Gj28Y
         ryJULcB39Zn6D16L5AoeDkh9mKItEhZEUTCWXjg9vA6iLlV//dub4Y8bW/yMaIHBBI
         REt2gO+kd7fnwNaBZuyZAWX9tWMWw4oL7hARL1V2m0n3wya2JHPIPELc1sbdXPInYY
         nrMf/BuB5o9ag==
X-Nifty-SrcIP: [209.85.221.177]
Received: by mail-vk1-f177.google.com with SMTP id t129so2143326vkg.6;
        Sun, 08 Mar 2020 19:11:43 -0700 (PDT)
X-Gm-Message-State: ANhLgQ31sIp2v5D70BxhMUDm1+Nrhi6FR0z0/6JqnCLbPA7aqRB6/eW2
        3e2mPH9tOgB0BCuzc86u8+29LwVAWHAcLBD3gKo=
X-Google-Smtp-Source: ADFU+vvt/JkrJjzd0deT/8rILIY+sbXN6h9yfSM2dN5SefnMYnQGmDsYiOXIbi9AgSGUBU5LhPzl8FfgiRG9piZrc3o=
X-Received: by 2002:a1f:8cd5:: with SMTP id o204mr7525937vkd.66.1583719902032;
 Sun, 08 Mar 2020 19:11:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200308073400.23398-1-natechancellor@gmail.com>
In-Reply-To: <20200308073400.23398-1-natechancellor@gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 9 Mar 2020 11:11:05 +0900
X-Gmail-Original-Message-ID: <CAK7LNARcTHpd8fzrAhFVB_AR7NoBgenX64de0eS2uN8g0by9PQ@mail.gmail.com>
Message-ID: <CAK7LNARcTHpd8fzrAhFVB_AR7NoBgenX64de0eS2uN8g0by9PQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Disable -Wpointer-to-enum-cast
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nathan,

On Sun, Mar 8, 2020 at 4:34 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang's -Wpointer-to-int-cast deviates from GCC in that it warns when
> casting to enums. The kernel does this in certain places, such as device
> tree matches to set the version of the device being used, which allows
> the kernel to avoid using a gigantic union.
>
> https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L428
> https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L402
> https://elixir.bootlin.com/linux/v5.5.8/source/include/linux/mod_devicetable.h#L264
>
> To avoid a ton of false positive warnings, disable this particular part
> of the warning, which has been split off into a separate diagnostic so
> that the entire warning does not need to be turned off for clang.
>
> Cc: stable@vger.kernel.org
> Link: https://github.com/ClangBuiltLinux/linux/issues/887
> Link: https://github.com/llvm/llvm-project/commit/2a41b31fcdfcb67ab7038fc2ffb606fd50b83a84
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index 86035d866f2c..90e56d5657c9 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -748,6 +748,10 @@ KBUILD_CFLAGS += -Wno-tautological-compare
>  # source of a reference will be _MergedGlobals and not on of the whitelisted names.
>  # See modpost pattern 2
>  KBUILD_CFLAGS += -mno-global-merge
> +# clang's -Wpointer-to-int-cast warns when casting to enums, which does not match GCC.
> +# Disable that part of the warning because it is very noisy across the kernel and does
> +# not point out any real bugs.
> +KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
>  else



I'd rather want to fix all the call-sites (97 drivers?)
instead of having -Wno-pointer-to-enum-cast forever.

If it is tedious to fix them all for now, can we add it
into scripts/Makefile.extrawarn so that this is disabled
by default, but shows up with W=1 builds?

(When we fix most of them, we will be able to
make it a real warning.)


What do you think?

Thanks.




>  # These warnings generated too much noise in a regular build.
> --
> 2.25.1
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200308073400.23398-1-natechancellor%40gmail.com.



-- 
Best Regards
Masahiro Yamada
