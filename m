Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102142D0C27
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 09:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgLGIys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 03:54:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgLGIys (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 03:54:48 -0500
X-Gm-Message-State: AOAM532bf0mTlIcQiqy8JRW8zlHdC3mrX2OzwzX3etiMlwCgC/irJDNe
        KfDHvi+YYd4aQ3JJSFSg+ngh+Ehra90zSPWC9pQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607331247;
        bh=gktlC3Key3lXSzbUIGuLemDVm9H2ePTn7aVTjMDQFuE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DFI+nyf+K475BNkwyXDokcxaGZTORl6vN4iYe5TO3AV5H0HeNN1sDglHXfsI//bnV
         oCJu+Q9GnKU12cNLQAbICZXBmwHRU/g2JOdHjvjcaGLCvyuGM6fXAuE1EtpJLJFRcd
         EjZc+Tot75mfEZBZMi+3W4x0MwZ2MlUQrUXQhELzHjq5J6aIofqHCM5siyq38Lcofs
         RlijJlWCXCAvP8Fjc0olhidpKysI6pUo/1oYYFUtHjYRun0k8HkB43r/PoipZ+CZrU
         7N/pcvJLpcRcnUe8Lae3+06gvthYHo4zP+VucYy22o5dHbgO6JAkUV+sEM0Ruc1/qf
         /ntaycMoPBWww==
X-Google-Smtp-Source: ABdhPJzEcm/AgtolbUOC3c+Nxy6pAlXPqCeo3FBjcFuAbi/LOMj4VOdKOBChywJ9sEMQJUkixB1RHEMv19toUcXXEi0=
X-Received: by 2002:aca:b809:: with SMTP id i9mr11642773oif.174.1607331246914;
 Mon, 07 Dec 2020 00:54:06 -0800 (PST)
MIME-Version: 1.0
References: <20201203230955.1482058-1-arnd@kernel.org> <CAK7LNAR50sq8O-5yg1O7760JAd3-GPHSLGGG=7kPtm9dbDDqwg@mail.gmail.com>
In-Reply-To: <CAK7LNAR50sq8O-5yg1O7760JAd3-GPHSLGGG=7kPtm9dbDDqwg@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 7 Dec 2020 09:53:55 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGUxTf_Mezgna0S1LAQ4ANMHtCqUqc995NPwAiOp+-6Eg@mail.gmail.com>
Message-ID: <CAMj1kXGUxTf_Mezgna0S1LAQ4ANMHtCqUqc995NPwAiOp+-6Eg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: avoid static_assert for genksyms
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Arnd Bergmann <arnd@arndb.de>, stable <stable@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 6 Dec 2020 at 03:49, Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> On Fri, Dec 4, 2020 at 8:10 AM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > genksyms does not know or care about the _Static_assert() built-in,
> > and sometimes falls back to ignoring the later symbols, which causes
> > undefined behavior such as
> >
> > WARNING: modpost: EXPORT symbol "ethtool_set_ethtool_phy_ops" [vmlinux] version generation failed, symbol will not be versioned.
> > ld: net/ethtool/common.o: relocation R_AARCH64_ABS32 against `__crc_ethtool_set_ethtool_phy_ops' can not be used when making a shared object
> > net/ethtool/common.o:(_ftrace_annotated_branch+0x0): dangerous relocation: unsupported relocation
> >
> > Redefine static_assert for genksyms to avoid that.
>
>
> Please tell the CONFIG options needed to reproduce this.
> I do not see it.
>

https://people.linaro.org/~ard.biesheuvel/randconfig-modversions-error
