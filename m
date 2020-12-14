Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7622DA433
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 00:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgLNXer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 18:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgLNXep (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 18:34:45 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F01C0617A6
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 15:34:05 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 131so13262633pfb.9
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 15:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vTHaU4vUZHFQDmOjKt/sYCJqlEwq0LLonv48w3qyuBE=;
        b=N2wdFH+342WgC1guNDProwMAfn7J5UJjpaNyTzCy66PIcspTEqZ549DIMM9pU/nDC1
         YU5Di/J1EUBxGMgrQuvQL2BDkgZZAROss0/kHbxVZa4ZIf/GlN9wzhXga+U9Xrs94ZJf
         TZaJZcnzHgATuiEfNdYFhyhnwLBICTrs67JKVvQFCrag47JgQi/isccG3II47J2UshMd
         fGkjGN4alzgKn5qqz5ZJlD3+r3UGsbeCBRLywalzEouM0sGkSMuRg+tnyt0Ly3kTnnE3
         xawDxHiWmzELNSAmhUzNbSJssithYKdwAa0CfUJP/lv5gn6KymdDBsPlI5P7BAnhC2Af
         0LzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vTHaU4vUZHFQDmOjKt/sYCJqlEwq0LLonv48w3qyuBE=;
        b=WyNoHpLF0BnxiOwxvC9ydBXgOjMJt/Ez7jZAyae21u0ccXqDuL64etgf1K3MPQ6a15
         89p2UO3+s3Q8YC0xr4eSjMjPFAUOHbfEJxXq4tSz/jWbeZhA5n0i9Dp/TUlGf8cFJ5PR
         mZkahnZD63JrDWum3LCpcl0p0gqPJjxAFXztkGOEPFsiguJUhqb83F2tRF0qJsdo1XYr
         C0L1GZkwFIpQqXTqBnZRVL8aK3Flu+EoZaUjfJdV2FWbbdhNVy04y8g1QHwD9BpOvKl+
         EB+XaQudkGA+hAQYOWgwQi035/WciK2J9/ev4fadTFYCDvuuBRu3DM8iZgb7nMjXQAcA
         LzUw==
X-Gm-Message-State: AOAM533BF2G5GKCBxDeMFFzYZsXywloXIHJpn5Vy2wtR0q6mQIF6dSoY
        ClXRUqOXGWhZ7Nj/xj1IRYyMqDxsUg9vMsOfjADvhg==
X-Google-Smtp-Source: ABdhPJxO+hPY5ifRP2HkdWoETy9hGtGoERGqaJZFlIZNWC8SrpsXDahAgArhyqKk2/38fn53m6OoMpQh2wR12Qr307c=
X-Received: by 2002:a63:a902:: with SMTP id u2mr26905202pge.263.1607988845055;
 Mon, 14 Dec 2020 15:34:05 -0800 (PST)
MIME-Version: 1.0
References: <20201016175339.2429280-1-ndesaulniers@google.com>
 <160319373854.2175971.17968938488121846972.b4-ty@kernel.org>
 <CAKwvOdnYcff_bcWZYkUC5qKso6EPRWrDgMAdn1KE1_YMCTy__A@mail.gmail.com> <20201214231827.GG8873@bubble.grove.modra.org>
In-Reply-To: <20201214231827.GG8873@bubble.grove.modra.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 14 Dec 2020 15:33:53 -0800
Message-ID: <CAKwvOdkP8vHidFPWczC24XwNHhQaXovQiQ43Yb6Csp_+kPR9XQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: link with -z norelro regardless of CONFIG_RELOCATABLE
To:     Alan Modra <amodra@gmail.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team <kernel-team@android.com>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Smith <Peter.Smith@arm.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 3:18 PM Alan Modra <amodra@gmail.com> wrote:
>
> On Mon, Dec 14, 2020 at 01:44:06PM -0800, Nick Desaulniers wrote:
> > aarch64-linux-gnu-ld: warning: -z norelro ignored
> >
> > So we set the emulation mode via -maarch64elf, and our preprocessed
>
> The default linker emulation for an aarch64-linux ld.bfd is
> -maarch64linux, the default for an aarch64-elf linker is
> -maarch64elf.  They are not equivalent.  If you choose -maarch64elf
> you get an emulation that doesn't support -z relro.
>
> Now I don't know why the kernel uses -maarch64elf so you shouldn't
> interpret my comment as a recommendation to use -maarch64linux
> instead.  That may have other unwanted effects.

Cool, thanks for the context.  The kernel currently has:

arch/arm64/Makefile:
...
ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
...
# Prefer the baremetal ELF build target, but not all toolchains include
# it so fall back to the standard linux version if needed.
LDFLAGS                += -EB $(call ld-option, -maarch64elfb, -maarch64linuxb)
...
else
...
# Same as above, prefer ELF but fall back to linux target if needed.
LDFLAGS                += -EL $(call ld-option, -maarch64elf, -maarch64linux)
...

Then
$ git log -S maarch64elf arch/arm64/Makefile
provides more context:
1. https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c931d34ea0853d41349e93f871bd3f17f1c03a6b
2. https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=96f95a17c1cfe65a002e525114d96616e91a8f2d
3. https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=38fc4248677552ce35efc09902fdcb06b61d7ef9

So it seems more that the kernel is relying on whichever emulation
targets are supported in local distros, not necessarily the semantic
differences between the two.  Since the kernel might be linked as
either, I'll send the patch described in my last post to add `-z
norelro` just when linking with LLD, since it sounds like it's only
possible to specify when -maarch64linux/-maarch64linuxb is used, which
is unlikely.
-- 
Thanks,
~Nick Desaulniers
