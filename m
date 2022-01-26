Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E133A49D16C
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 19:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiAZSHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 13:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244147AbiAZSHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 13:07:49 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15B8C061748
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 10:07:48 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id e9so795649ljq.1
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 10:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e6GlIwf2gQF3ITti5q/SlwCwbOwNxQ4Vmm6ghQbKw6g=;
        b=Ua1tzA6BRz4Kicy3wWXE4baxIRed4b9N+oLT8SW2I9QdF1CllcC4jq2nAn5zWd10IO
         NRGiqajhZhjSigz6UU0a1JEOJou2zOPJ12aECIZ9bjc8mfmO0BauwNMsuq04vVIodApe
         IHoHDZhgNwNhnqgs3I9PsX7XKNZH1bfLcGbAjDEEmBsdWnRJLrk392k4up2kfQWxGBGK
         ZE4p0xGXNI2SGwMhgAwQMHa42mmsoHGdVIudHFz4d01ODNhzl2n8r9F9WWgY8V6Vrxgp
         HvvR2P09koQ/4fm1aRPs7B8PGp9XZEqJKfuuPaWHYVph0twQVUqPMaLvRxCGSEexEdlU
         tOWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e6GlIwf2gQF3ITti5q/SlwCwbOwNxQ4Vmm6ghQbKw6g=;
        b=3CVt695RghUMTzgW2GGZ6ePdrkxFsobFvZ1zD9dq0T48STGjlxXw/JjbLqTa44Jo5x
         +bQWncv2rHIyysTh3xaZLaxr3jHV0684oYppgeWTux99ZZ4/3NloA1SYuyc/w7Xwqu6R
         /CPTnwt4NfKuHTF56OkMzz64FAVFFoNrWXerSM72anlVigJ/u/7+V7fcTyLna0IzIcMR
         69q3yY7vsYPwjixYQZADcmRUnj/9Vq7UobnF/+5SRROTFLNysMQYlpZ/ehNiDK4AkXLn
         DWwtQ+GqhDHS4sX1U5SwpGba7n14t8jFau5u8wLXQGVfbE6Dus7dR8UukVpXmc7Xf2mX
         FRXA==
X-Gm-Message-State: AOAM5304o3d9UwQX6yI16NefpPzcD5yKQkMQD3ru1oMHhLTY5N+3/dOv
        JGpgSvZ54bh+iwPBjYz9R9wDZ4UDtR8Bu3OrjH3y+Q==
X-Google-Smtp-Source: ABdhPJzaM9QfYFgak03rWnAuv3xprmvfFYLw+Tw36FXo3pPPNnx5IxgcrSkUkrR/bJPmAwTO2cPPsNjs7CeXngEv/vg=
X-Received: by 2002:a05:651c:984:: with SMTP id b4mr153763ljq.235.1643220466896;
 Wed, 26 Jan 2022 10:07:46 -0800 (PST)
MIME-Version: 1.0
References: <20220126175747.3270945-1-keescook@chromium.org>
In-Reply-To: <20220126175747.3270945-1-keescook@chromium.org>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 26 Jan 2022 19:07:20 +0100
Message-ID: <CAG48ez3hN8+zNCmLVP0yU0A5op6BAS+A-rs05aiLm4RQvzzBpg@mail.gmail.com>
Subject: Re: [PATCH] fs/binfmt_elf: Add padding NULL when argc == 0
To:     Kees Cook <keescook@chromium.org>
Cc:     Ariadne Conill <ariadne@dereferenced.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 6:58 PM Kees Cook <keescook@chromium.org> wrote:
> Quoting Ariadne Conill:
>
> "In several other operating systems, it is a hard requirement that the
> first argument to execve(2) be the name of a program, thus prohibiting
> a scenario where argc < 1. POSIX 2017 also recommends this behaviour,
> but it is not an explicit requirement[1]:
>
>     The argument arg0 should point to a filename string that is
>     associated with the process being started by one of the exec
>     functions.
> ...
> Interestingly, Michael Kerrisk opened an issue about this in 2008[2],
> but there was no consensus to support fixing this issue then.
> Hopefully now that CVE-2021-4034 shows practical exploitative use[3]
> of this bug in a shellcode, we can reconsider."
>
> An examination of existing[4] users of execve(..., NULL, NULL) shows
> mostly test code, or example rootkit code. While rejecting a NULL argv
> would be preferred, it looks like the main cause of userspace confusion
> is an assumption that argc >= 1, and buggy programs may skip argv[0]
> when iterating. To protect against userspace bugs of this nature, insert
> an extra NULL pointer in argv when argc == 0, so that argv[1] != envp[0].
>
> Note that this is only done in the argc == 0 case because some userspace
> programs expect to find envp at exactly argv[argc]. The overlap of these
> two misguided assumptions is believed to be zero.

Will this result in the executed program being told that argc==0 but
having an extra NULL pointer on the stack?
If so, I believe this breaks the x86-64 ABI documented at
https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf - page 29,
figure 3.9 describes the layout of the initial process stack.

Actually, does this even work? Can a program still properly access its
environment variables when invoked with argc==0 with this patch
applied? AFAIU the way userspace locates envv on x86-64 is by
calculating 8*(argc+1)?
