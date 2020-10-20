Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4EE2943C2
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 22:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409389AbgJTUQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 16:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391622AbgJTUQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 16:16:55 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8377EC0613CE
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 13:16:55 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o3so10664pgr.11
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 13:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=46RFYozjOUrCT47DTNQygaXDa0U+oyBU4TtGuU6XNI4=;
        b=GCHVRghA7TeXHOUfpK8XK0MgAeLsh6HEk8QgnUB8L2yCL2zOT3M6p5SwYT0wLxsnKG
         ZEaY9YWd86FRdLWyCHsCtvol72hfc0jItncd9ghOxvuhpi8g7ugEEtDsTNJ9ogWkSOMX
         vzJIaSmfV304rau7rEvZ98LpWLIP1sVdgEqEC7xjyMvHub870EJbjSIGnq7B9aYekCa/
         a/qBt2p813YIWeNZRHmJcndjfqdAio4yvWkjhGogr1bYvSy/f40UZmiNWh+HOReLSjm2
         NDPHNcC8KDwwWadxDamjweTZQ9zPQaOKLMADpJZ752+SomEr6LFbWxOchVr9XxfcMl3c
         mTmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=46RFYozjOUrCT47DTNQygaXDa0U+oyBU4TtGuU6XNI4=;
        b=RLIKZj0lKxOVfNxQLhZvH/w8FJ1kOLrkAFr2F9SN+Y9E0Lrfr11RrhlNrZFm8LNNwL
         zlrVlidrHbGSKnAZNWA7fvRLTsZg5AP2Ywv6ra/y8iMGpzYD3DM+xzSkEZn/BmLfPErB
         VbkMfvNM5y92tXqQsYfkP3vjGstppxSg0a3cH9J8wGQj+NG7VVnw5JWmRMOSPelz57Wi
         M1VCqzV9nxJNOyTzgYBF5mjjPXSMCbenuphvK04J+rDfqnTG7pUUCBM4wS2x3C9up8uB
         PIUeqBEfW6nUxMuKHiPtGSHc/aw3QPvBqez9qlvdL5VCdXrZNnesR7zvT0eUqNuEzWFE
         YvQg==
X-Gm-Message-State: AOAM530mKSum5Lxh0Y/gRUG89tYZ6JFmSBH10PWyS9J6wsB+uknrmDDB
        DNhaEqNIKve8ptsqOqXkqFcn/p9FsGrCb2yvG/8mbg==
X-Google-Smtp-Source: ABdhPJxhzEcDxnQbUj+JT015TazLvxkNXCfo9dZTKFxf4yePhzBsAZxDhe3cue6Irvla0qzlx31G36qNCtX49jixXDk=
X-Received: by 2002:a63:70d:: with SMTP id 13mr35019pgh.263.1603225014754;
 Tue, 20 Oct 2020 13:16:54 -0700 (PDT)
MIME-Version: 1.0
References: <20201016175339.2429280-1-ndesaulniers@google.com> <160319373854.2175971.17968938488121846972.b4-ty@kernel.org>
In-Reply-To: <160319373854.2175971.17968938488121846972.b4-ty@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 20 Oct 2020 13:16:43 -0700
Message-ID: <CAKwvOd=ZJjYOVubjHN6DFuopMP7jg9PAxGHhOPVu6KefPMNfkg@mail.gmail.com>
Subject: Re: [PATCH] arm64: link with -z norelro regardless of CONFIG_RELOCATABLE
To:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Kees Cook <keescook@chromium.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Smith <Peter.Smith@arm.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 20, 2020 at 10:57 AM Will Deacon <will@kernel.org> wrote:
>
> On Fri, 16 Oct 2020 10:53:39 -0700, Nick Desaulniers wrote:
> > With CONFIG_EXPERT=y, CONFIG_KASAN=y, CONFIG_RANDOMIZE_BASE=n,
> > CONFIG_RELOCATABLE=n, we observe the following failure when trying to
> > link the kernel image with LD=ld.lld:
> >
> > error: section: .exit.data is not contiguous with other relro sections
> >
> > ld.lld defaults to -z relro while ld.bfd defaults to -z norelro. This
> > was previously fixed, but only for CONFIG_RELOCATABLE=y.
>
> Applied to arm64 (for-next/core), thanks!
>
> [1/1] arm64: link with -z norelro regardless of CONFIG_RELOCATABLE
>       https://git.kernel.org/arm64/c/3b92fa7485eb

IF we wanted to go further and remove `-z norelro`, or even enable `-z
relro` for aarch64, then we would have to detangle some KASAN/GCOV
generated section discard spaghetti.  Fangrui did some more digging
and found that .fini_array.* sections were relro (read only after
relocations, IIUC), so adding them to EXIT_DATA
(include/asm-generic/vmlinux.lds.h) was causing them to get included
in .exit.data (arch/arm64/kernel/vmlinux.lds.S) making that relro.
There's some history here with commits:

- e41f501d39126 ("vmlinux.lds: account for destructor sections")
- 8dcf86caa1e3da ("vmlinux.lds.h: Fix incomplete .text.exit discards")
- d812db78288d7 ("vmlinux.lds.h: Avoid KASAN and KCSAN's unwanted sections")

It seems the following works for quite a few different
configs/toolchains I played with, but the big IF is whether enabling
`-z relro` is worthwhile?  If the kernel does respect that mapping,
then I assume that's a yes, but I haven't checked yet whether relro is
respected within the kernel (`grep -rn RELRO` turns up nothing
interesting).  I also haven't checked yet whether all supported
versions of GNU ld.bfd support -z relro (guessing not, since a quick
test warns: `aarch64-linux-gnu-ld: warning: -z relro ignored` for
v2.34.90.20200706, may be holding it wrong).

(Fangrui also filed https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97507
in regards to GCOV+GCC)

diff --git a/include/asm-generic/vmlinux.lds.h
b/include/asm-generic/vmlinux.lds.h
index cd14444bf600..64578c998e53 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -744,7 +744,6 @@

 #define EXIT_DATA                                                      \
        *(.exit.data .exit.data.*)                                      \
-       *(.fini_array .fini_array.*)                                    \
        *(.dtors .dtors.*)                                              \
        MEM_DISCARD(exit.data*)                                         \
        MEM_DISCARD(exit.rodata*)
@@ -995,6 +994,7 @@
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KCSAN)
 # ifdef CONFIG_CONSTRUCTORS
 #  define SANITIZER_DISCARDS                                           \
+       *(.fini_array .fini_array.*)                                    \
        *(.eh_frame)
 # else
 #  define SANITIZER_DISCARDS                                           \
@@ -1005,8 +1005,16 @@
 # define SANITIZER_DISCARDS
 #endif

+#if defined(CONFIG_GCOV_KERNEL) && defined(CONFIG_CC_IS_GCC)
+# define GCOV_DISCARDS                                                 \
+       *(.fini_array .fini_array.*)
+#else
+# define GCOV_DISCARDS
+#endif
+
 #define COMMON_DISCARDS
         \
        SANITIZER_DISCARDS                                              \
+       GCOV_DISCARDS                                                   \
        *(.discard)                                                     \
        *(.discard.*)                                                   \
        *(.modinfo)                                                     \
-- 
Thanks,
~Nick Desaulniers
