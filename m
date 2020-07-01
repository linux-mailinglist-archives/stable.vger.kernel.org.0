Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B853211571
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 23:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgGAVyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 17:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgGAVyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 17:54:15 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71AAC08C5C1
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 14:54:15 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 67so7501190pfg.5
        for <stable@vger.kernel.org>; Wed, 01 Jul 2020 14:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=v5zVZ/qvFqC9c5KWODDkon7op7M6c9UcQbidcfKUSJo=;
        b=do3tiN8/mgOvufCjiIyA0hAaKP/t2BK/YbcCG4ZA6ZPwLartM/JweQmBEu5qrg4Eoh
         +vWtOaXuS+hNM5Rr67ANRROc1a44DoyXQiINBMdPiriKhq2qUEjMOBt1mdGO7zS7CpWH
         1zHoySWrueIKVnQfjCjmPc5jWgygbBS2iZ1NEIYhbhLoTa6PPT6hs/aTYVtWoLwNz5QR
         fIUjo/hivywPkn+14TXv/+b8a64j4QQYULf5RVYFCoEcvUaHz4pRe/mfb9BSK2MwVtve
         AQkGlve7pl+Cb5JC9773HeULhBo2SWrVpAFdmg7uJQo9v0dMpm5RiZqi+O6oSehYj/S4
         bRWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=v5zVZ/qvFqC9c5KWODDkon7op7M6c9UcQbidcfKUSJo=;
        b=iK+2/+4uIlXCyOhfsRe5zL7LvPnpcYo9PWrFX5wxyG2SZ6NU2sjVfLYSM7iFM2w33Y
         9zgHBxLuoqOiyUNyqKYY4Y4m2Onfh9GPfWHbOykfov1NL4dl+TLk/DeCK/IDzzI3idw7
         oDtBgpt0tdpt1KBGSQmDqzGj3hw2dUtbEOl0YH4DVELAVv7ZNz8xUlYrXc2r/fbegLgl
         NkinK5yFPNDKAkKlGlNKuE2VydAlvVaBJCMPMwwivMOuTUAnpGFxN3KWUFtuGUtfrVPn
         heAr+p/uEpmKKPq1DhNVCoHJqPnG/7sDKcAg8yigVG0YIc7ugqPTSYM9/lkLjdrlCS7q
         FXVA==
X-Gm-Message-State: AOAM5313kB+dParuE4TDPcEPjRPUOP7Eu1+58/tJYXJlvf2w86UerM+B
        1pesHCPpwKWOCCl3bKud3nqqsj8mjBX9FEERBwXDqA==
X-Google-Smtp-Source: ABdhPJxvei3SEdwwDFxCRX5wBgi47iw6HZKseNBFuAwL/eiz8+hprxS/VH5D7zYNl7207gGKduRfos/0EslLWzb2GMM=
X-Received: by 2002:a63:a119:: with SMTP id b25mr21262941pgf.10.1593640455007;
 Wed, 01 Jul 2020 14:54:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200622231536.7jcshis5mdn3vr54@google.com> <20200625184752.73095-1-ndesaulniers@google.com>
In-Reply-To: <20200625184752.73095-1-ndesaulniers@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 1 Jul 2020 14:54:02 -0700
Message-ID: <CAKwvOd=cum+BNHOk2djXx5JtAcCBwq2Bxy=j5ucRd2RcLWwDZQ@mail.gmail.com>
Subject: Re: [PATCH v2] vmlinux.lds: add PGO and AutoFDO input sections
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>, Jian Cai <jiancai@google.com>,
        Luis Lozano <llozano@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Arnd,
I usually wait longer to bump threads for review, but we have a
holiday in the US so we're off tomorrow and Friday.
scripts/get_maintainer.pl recommend you for this patch.  Would you
take a look at it for us, please?

On Thu, Jun 25, 2020 at 11:48 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Basically, consider .text.{hot|unlikely|unknown}.* part of .text, too.
>
> When compiling with profiling information (collected via PGO
> instrumentations or AutoFDO sampling), Clang will separate code into
> .text.hot, .text.unlikely, or .text.unknown sections based on profiling
> information. After D79600 (clang-11), these sections will have a
> trailing `.` suffix, ie.  .text.hot., .text.unlikely., .text.unknown..
>
> When using -ffunction-sections together with profiling infomation,
> either explicitly (FGKASLR) or implicitly (LTO), code may be placed in
> sections following the convention:
> .text.hot.<foo>, .text.unlikely.<bar>, .text.unknown.<baz>
> where <foo>, <bar>, and <baz> are functions.  (This produces one section
> per function; we generally try to merge these all back via linker script
> so that we don't have 50k sections).
>
> For the above cases, we need to teach our linker scripts that such
> sections might exist and that we'd explicitly like them grouped
> together, otherwise we can wind up with code outside of the
> _stext/_etext boundaries that might not be mapped properly for some
> architectures, resulting in boot failures.
>
> If the linker script is not told about possible input sections, then
> where the section is placed as output is a heuristic-laiden mess that's
> non-portable between linkers (ie. BFD and LLD), and has resulted in many
> hard to debug bugs.  Kees Cook is working on cleaning this up by adding
> --orphan-handling=3Dwarn linker flag used in ARCH=3Dpowerpc to additional
> architectures. In the case of linker scripts, borrowing from the Zen of
> Python: explicit is better than implicit.
>
> Also, ld.bfd's internal linker script considers .text.hot AND
> .text.hot.* to be part of .text, as well as .text.unlikely and
> .text.unlikely.*. I didn't see support for .text.unknown.*, and didn't
> see Clang producing such code in our kernel builds, but I see code in
> LLVM that can produce such section names if profiling information is
> missing. That may point to a larger issue with generating or collecting
> profiles, but I would much rather be safe and explicit than have to
> debug yet another issue related to orphan section placement.
>
> Cc: stable@vger.kernel.org
> Link: https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dcommitdiff;h=
=3Dadd44f8d5c5c05e08b11e033127a744d61c26aee
> Link: https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dcommitdiff;h=
=3D1de778ed23ce7492c523d5850c6c6dbb34152655
> Link: https://reviews.llvm.org/D79600
> Link: https://bugs.chromium.org/p/chromium/issues/detail?id=3D1084760
> Reported-by: Jian Cai <jiancai@google.com>
> Debugged-by: Luis Lozano <llozano@google.com>
> Suggested-by: F=C4=81ng-ru=C3=AC S=C3=B2ng <maskray@google.com>
> Tested-by: Luis Lozano <llozano@google.com>
> Tested-by: Manoj Gupta <manojgupta@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
> Changes V1 -> V2:
> * Add .text.unknown.*.  It's not strictly necessary for us yet, but I
>   really worry that it could become a problem for us. Either way, I'm
>   happy to drop for a V3, but I'm suggesting we not.
> * Beef up commit message.
> * Drop references to LLD; the LLVM change had nothing to do with LLD.
>   I've realized I have a Pavlovian-response to changes from F=C4=81ng-ru=
=C3=AC
>   that I associate with LLD.  I'm seeking professional help for my
>   ailment. Forgive me.
> * Add link to now public CrOS bug.
>
>  include/asm-generic/vmlinux.lds.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmli=
nux.lds.h
> index d7c7c7f36c4a..245c1af4c057 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -560,7 +560,10 @@
>   */
>  #define TEXT_TEXT                                                      \
>                 ALIGN_FUNCTION();                                       \
> -               *(.text.hot TEXT_MAIN .text.fixup .text.unlikely)       \
> +               *(.text.hot .text.hot.*)                                \
> +               *(TEXT_MAIN .text.fixup)                                \
> +               *(.text.unlikely .text.unlikely.*)                      \
> +               *(.text.unknown .text.unknown.*)                        \
>                 NOINSTR_TEXT                                            \
>                 *(.text..refcount)                                      \
>                 *(.ref.text)                                            \
> --
> 2.27.0.111.gc72c7da667-goog
>


--=20
Thanks,
~Nick Desaulniers
