Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964192AC3D2
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 19:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgKIS2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 13:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729533AbgKIS2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 13:28:32 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F8CC0613D4
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 10:28:32 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id c66so3232106pfa.4
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 10:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AESt3W/kjM4jiN20NLWIgosAY6GP/k+vLstE0r9o34Q=;
        b=C1w6G7M31fHVbecbMQlBp4J7QPuWQGBIvz7oIpHr94J1cvJNAnpGnMP5SmlxUL7oMd
         KjAWlBAnsN826+vHXMtA2qAcTlZVgbFco84ylE34hf/Z2k9M/pIplwYvo6ukb6QX9S5p
         +vDwhTzaLJKyDZLzSwkIjIvndKnRrvXg7csjiClz+J+LiIT897Mvgrf8WmFcrig1+6Wu
         W6PnU8D2wQ+oJNng90HIsOWX43IdeSxU6INanULB1TPhWFsTyWs67lmOqDF1+Fhk0hE3
         8mqxYVUN3w3E9DPfrIfJTC8URWMCJcfk3BESZ+OIjjOLGNK+/1YOEkqdYnVHP1HPF50q
         SVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AESt3W/kjM4jiN20NLWIgosAY6GP/k+vLstE0r9o34Q=;
        b=juhMaA5dET5sDOcfC1t7C2oe6/jJRVpwHrYKCoY5OZyYBkOv7rrozWC5QZ7z73ivqM
         Np5UgxEGhVYhBoAawBo5RgQjcpQP2uVTXcfZ/KyYIyQpuXsnUtBt+3dxVRzOD8ewxc42
         nNUjCjOiAm+3p8JlGToXaphcHr3+MR6+VyNnHUjzXNUpGkklN96C6lucRiz//HILTEfB
         7gcyBLSzRbJ9cWbwyJ24QEhuAdqpEBxMDnq8u8yHqgXj1obzJPzfrNPOHDbY7cng3NoY
         qmP6kSyD/mbE1MV3syNcYpZgGbs+nLj2+tPjTM4T5aoITq9BJp/2Yv9TBNBGx6mj8CzV
         LTpQ==
X-Gm-Message-State: AOAM530r9Wb32lStiCLRVHGdC5ZlZUg8ZqqKzudn70w6yQEbMbpjgt7k
        QQGhMvQpdvQTkh8GlrRqwfXjAtWlLmXRchWpaDTLXg==
X-Google-Smtp-Source: ABdhPJxEVbvvQD0TUGfUYwecby+wjRtpcQ0XyosDH737x/2hG3nwp5yeeMSu7vRsTmyFzq/pVWVU6Bhp3h/73d3qfpE=
X-Received: by 2002:a65:4b81:: with SMTP id t1mr14317420pgq.263.1604946511533;
 Mon, 09 Nov 2020 10:28:31 -0800 (PST)
MIME-Version: 1.0
References: <CAK7LNAST0Ma4bGGOA_HATzYAmRhZG=x_X=8p_9dKGX7bYc2FMA@mail.gmail.com>
 <20201104005343.4192504-1-ndesaulniers@google.com> <20201104005343.4192504-3-ndesaulniers@google.com>
 <20201105065844.GA3243074@ubuntu-m3-large-x86>
In-Reply-To: <20201105065844.GA3243074@ubuntu-m3-large-x86>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 9 Nov 2020 10:28:21 -0800
Message-ID: <CAKwvOd=9iqLgdtAWe2h-9n=KUWm_rjCCJJYeop8PS6F+AA0VtA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] Kbuild: do not emit debug info for assembly with LLVM_IAS=1
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-toolchains@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Dmitry Golovin <dima@golovin.in>,
        Alistair Delva <adelva@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 4, 2020 at 10:58 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Tue, Nov 03, 2020 at 04:53:41PM -0800, Nick Desaulniers wrote:
> > Clang's integrated assembler produces the warning for assembly files:
> >
> > warning: DWARF2 only supports one section per compilation unit
> >
> > If -Wa,-gdwarf-* is unspecified, then debug info is not emitted.  This
>
> Is this something that should be called out somewhere? If I understand
> this correctly, LLVM_IAS=1 + CONFIG_DEBUG_INFO=y won't work? Maybe this
> should be handled in Kconfig?

Specifically, debug info will not be emitted, for assembler source
files. It will still be emitted for C source files (via -gdwarf-*).
-Wa,-gdwarf-* only affects assembler file sources.

>
> > will be re-enabled for new DWARF versions in a follow up patch.
> >
> > Enables defconfig+CONFIG_DEBUG_INFO to build cleanly with
> > LLVM=1 LLVM_IAS=1 for x86_64 and arm64.
> >
> > Cc: <stable@vger.kernel.org>
> > Link: https://github.com/ClangBuiltLinux/linux/issues/716
> > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> > Suggested-by: Dmitry Golovin <dima@golovin.in>
>
> If you happen to respin, Dmitry deserves a Reported-by tag too :)

Sure.

>
> > Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
>
> Regardless of the other two comments, this is fine as is as a fix for
> stable to unblock Android + CrOS since we have been running something
> similar to it in CI:
>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
>
> > ---
> >  Makefile | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/Makefile b/Makefile
> > index f353886dbf44..75b1a3dcbf30 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -826,7 +826,9 @@ else
> >  DEBUG_CFLAGS += -g
> >  endif
> >
> > +ifndef LLVM_IAS
>
> Nit: this should probably match the existing LLVM_IAS check

Sure, will send a v3.  Going to just send this for now, as it's
blocking some downstream work I'm trying to get done in Android.

>
> ifneq ($(LLVM_IAS),1)
>
> >  KBUILD_AFLAGS        += -Wa,-gdwarf-2
> > +endif
> >
> >  ifdef CONFIG_DEBUG_INFO_DWARF4
> >  DEBUG_CFLAGS += -gdwarf-4
> > --
> > 2.29.1.341.ge80a0c044ae-goog
> >



-- 
Thanks,
~Nick Desaulniers
