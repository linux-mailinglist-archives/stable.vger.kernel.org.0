Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D966C2D005F
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 05:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgLFEIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 23:08:32 -0500
Received: from condef-09.nifty.com ([202.248.20.74]:26792 "EHLO
        condef-09.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgLFEIZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Dec 2020 23:08:25 -0500
Received: from conssluserg-06.nifty.com ([10.126.8.85])by condef-09.nifty.com with ESMTP id 0B62nHxM032311;
        Sun, 6 Dec 2020 11:49:17 +0900
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id 0B62mwFa003670;
        Sun, 6 Dec 2020 11:48:59 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 0B62mwFa003670
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1607222939;
        bh=v6uiEMpk8vJVMRmSYb8LkEirAfPFsPFdo7sZs2oeOis=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XdECLHBYbSL/0PnUm3c/oH/kUEZ2KReY8luCdFgPicIvGyjIiqeVLQxkys3wQ5ajj
         m3AG4GsBmqaCf7HM/OPjTSfGjEBsv5iq2E5d/03TAZhrM8xRX2rXNQQfijm3kRlvL1
         +ND4H0DjAaiUOSzfzgw0VknqMPl3ZkKNjqieWLtcn31q53Z1aqNbafgamDHNNhpr24
         knGm2GVrRli3yP71HkFh2b3P4ttC5dyqs+7wQZyau3ognJuHILWTwJ3d8AlGUvPtIM
         U1HOysnBpWu9p6OcS2qBFeeIdlnSdHhVxlDXE/GnxfW39bHDOLqmmzQuEe4qdol6ZY
         9BAZBsaM/e3dQ==
X-Nifty-SrcIP: [209.85.215.174]
Received: by mail-pg1-f174.google.com with SMTP id e23so6060351pgk.12;
        Sat, 05 Dec 2020 18:48:59 -0800 (PST)
X-Gm-Message-State: AOAM530ZAxvOhekKbEf7zUSGx1L/+JNlF4RdqOtcBEdRyyPkvIrAonxI
        MxVDbSY0VP2hEnZkHzMdE1BxUF8ieC3z8KA1RKc=
X-Google-Smtp-Source: ABdhPJy0n0PbwLiEFJPDOdIhUBC40dp1Ku/JtLvcI3ttj1aa7A8y7bWkJCMS2pNbiNuVHg/eq9ckuSheCkdYCtN8IWw=
X-Received: by 2002:aa7:9501:0:b029:155:3b11:d5c4 with SMTP id
 b1-20020aa795010000b02901553b11d5c4mr10162846pfp.76.1607222938202; Sat, 05
 Dec 2020 18:48:58 -0800 (PST)
MIME-Version: 1.0
References: <20201203230955.1482058-1-arnd@kernel.org>
In-Reply-To: <20201203230955.1482058-1-arnd@kernel.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Sun, 6 Dec 2020 11:48:21 +0900
X-Gmail-Original-Message-ID: <CAK7LNAR50sq8O-5yg1O7760JAd3-GPHSLGGG=7kPtm9dbDDqwg@mail.gmail.com>
Message-ID: <CAK7LNAR50sq8O-5yg1O7760JAd3-GPHSLGGG=7kPtm9dbDDqwg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: avoid static_assert for genksyms
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Arnd Bergmann <arnd@arndb.de>, stable <stable@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 4, 2020 at 8:10 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> genksyms does not know or care about the _Static_assert() built-in,
> and sometimes falls back to ignoring the later symbols, which causes
> undefined behavior such as
>
> WARNING: modpost: EXPORT symbol "ethtool_set_ethtool_phy_ops" [vmlinux] version generation failed, symbol will not be versioned.
> ld: net/ethtool/common.o: relocation R_AARCH64_ABS32 against `__crc_ethtool_set_ethtool_phy_ops' can not be used when making a shared object
> net/ethtool/common.o:(_ftrace_annotated_branch+0x0): dangerous relocation: unsupported relocation
>
> Redefine static_assert for genksyms to avoid that.


Please tell the CONFIG options needed to reproduce this.
I do not see it.


>
> Cc: stable@vger.kernel.org
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/linux/build_bug.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/include/linux/build_bug.h b/include/linux/build_bug.h
> index e3a0be2c90ad..7bb66e15b481 100644
> --- a/include/linux/build_bug.h
> +++ b/include/linux/build_bug.h
> @@ -77,4 +77,9 @@
>  #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
>  #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
>
> +#ifdef __GENKSYMS__
> +/* genksyms gets confused by _Static_assert */
> +#define _Static_assert(expr, ...)
> +#endif
> +
>  #endif /* _LINUX_BUILD_BUG_H */
> --
> 2.27.0
>


-- 
Best Regards
Masahiro Yamada
