Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2342B554F
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 00:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730963AbgKPXlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 18:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730945AbgKPXly (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 18:41:54 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEC8C0613D3
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 15:41:54 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id i8so1961505pfk.10
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 15:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q6oT/iaJpuUzbJsO3ZOoSLXJmJdPmOezInw0gF4IJ28=;
        b=DaGY52y2S53RfC36H5AiJH5A419IlvPKioPWUhj1fz1ee9KTimKZDJrmWgb9v776ET
         /gwm9XOeX0BJZikJIRY2/UxXgYgquVvhQpNrFV9XiB3qeL7RefN2AprNWMpLRtxOxzh/
         cEls2g7rxSNDVIvusRCwaQNeTXxi720q64jwxbjjYoBdqrs14vxzI0lX+DaArhZWJvkT
         WUQOjJO9Sx2tTPiyKzbVFjdPpaXTpnQN+CsR7FFBk1TEPMkBAqU6nHxQ/P0Zl6adCwuQ
         iWqm5vwTuaud25e3h4ZXeTqdYz5ypSBmKJ2FlwNnr1RTathlitsBCuYUyGKuRDxrr+HC
         AKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q6oT/iaJpuUzbJsO3ZOoSLXJmJdPmOezInw0gF4IJ28=;
        b=PioRt/aLHHTL32AP/fr0LrfUxwah9fC9b0Qn6sGBHxtdnQ8IuOf6C7IxzfQ0W/9shV
         YD0faCzRRcxUq46Fa6JR8y3Yy93EDMV7hiK1F9D/Wn1P21uG9cOpgme0If6hT85VgFtM
         HOaOap7Wv51SmOHhYVM1G9sAbEMvLhh5Dr6Op7ItBFN1x60kj2LpUkQtpP/bv8b+GPPv
         CApd1dQqHz0JQE43B+dYZPQOwYizK+JaWMWoZgr0q72jBUlsTw2Pj278uG7SNbozgUKP
         kNK4UDZw3lcQMUMX8acpqjbe7wUzMRypCtQxG95c39wb9rgTpH3wJQOCvqde7a6YIO83
         eHXw==
X-Gm-Message-State: AOAM533KtfhYgbGjHhILGn7APyVhk3M8h8I1AEoNGnuuUhm6nw+4DsgU
        e3oxVBmt5psFdKpMFwvOXj7cJTz/vYI4LrECRdeO8w==
X-Google-Smtp-Source: ABdhPJwVHouTg7EVX4W0i+4378wI412Q2tEtRHUYdk7lrZpa4Bigm1LcPNbScK1zq4PEp4tG+BUF6n3Mdrpfjn0WHQs=
X-Received: by 2002:a17:90b:d91:: with SMTP id bg17mr1379665pjb.25.1605570113934;
 Mon, 16 Nov 2020 15:41:53 -0800 (PST)
MIME-Version: 1.0
References: <CAKwvOd=9iqLgdtAWe2h-9n=KUWm_rjCCJJYeop8PS6F+AA0VtA@mail.gmail.com>
 <20201109183528.1391885-1-ndesaulniers@google.com>
In-Reply-To: <20201109183528.1391885-1-ndesaulniers@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 16 Nov 2020 15:41:42 -0800
Message-ID: <CAKwvOdnxAr7UdjUiuttj=bz1_voK1qUvpOvSY35qOZ60+E8LBA@mail.gmail.com>
Subject: Re: [PATCH v3] Kbuild: do not emit debug info for assembly with LLVM_IAS=1
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-toolchains@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Dmitry Golovin <dima@golovin.in>,
        Alistair Delva <adelva@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Masahiro, have you had time to review v3 of this patch?

On Mon, Nov 9, 2020 at 10:35 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Clang's integrated assembler produces the warning for assembly files:
>
> warning: DWARF2 only supports one section per compilation unit
>
> If -Wa,-gdwarf-* is unspecified, then debug info is not emitted for
> assembly sources (it is still emitted for C sources).  This will be
> re-enabled for newer DWARF versions in a follow up patch.
>
> Enables defconfig+CONFIG_DEBUG_INFO to build cleanly with
> LLVM=1 LLVM_IAS=1 for x86_64 and arm64.
>
> Cc: <stable@vger.kernel.org>
> Link: https://github.com/ClangBuiltLinux/linux/issues/716
> Reported-by: Dmitry Golovin <dima@golovin.in>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Suggested-by: Dmitry Golovin <dima@golovin.in>
> Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
> Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
> Reviewed-by: Fangrui Song <maskray@google.com>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  Makefile | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index f353886dbf44..7e899d356902 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -826,7 +826,9 @@ else
>  DEBUG_CFLAGS   += -g
>  endif
>
> +ifneq ($(LLVM_IAS),1)
>  KBUILD_AFLAGS  += -Wa,-gdwarf-2
> +endif
>
>  ifdef CONFIG_DEBUG_INFO_DWARF4
>  DEBUG_CFLAGS   += -gdwarf-4
> --
> 2.29.2.222.g5d2a92d10f8-goog
>


-- 
Thanks,
~Nick Desaulniers
