Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44732C6B71
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 19:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732265AbgK0SNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 13:13:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732442AbgK0SNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 13:13:18 -0500
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CA2522250
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 18:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606500797;
        bh=1bo6H9+/KQJ6VWNzr+NXNTKVa7Q21pKSbzsXSkioxfc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=yk7nAQ8/WRulmAUdFGobbdczXVBW2mFmEp10IrSfmIjjxAsbwfaFpzB1ku3OYw51I
         fWbbFkNem/7R5M2S4CB48qAsLmaFicDeIS0i+MRS1UJpOR4zOe0I3Faiy1q2MQ7TCI
         4RUFLcHZtA4pt3ggkkcIaxHB7kylJ/ozNNVQ4zaA=
Received: by mail-wm1-f49.google.com with SMTP id v14so257786wml.1
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 10:13:17 -0800 (PST)
X-Gm-Message-State: AOAM531ILb9IuYZE4RNYjJSyuq8qr/rrY6fCuFYEcJm47U2JD5tSXhUf
        UR9d1J5MfcHzhlDne43r9mcQ8jTa+T+AOdFDtpvY4A==
X-Google-Smtp-Source: ABdhPJwuK0ObJ3lq9tHj2zI493p7it0lhkV8QgcGO4JpQeedx4Jt0eN4+9mE0Dn0wZhe0GqKtkPtNZOWzMKzOrhdgis=
X-Received: by 2002:a1c:7e87:: with SMTP id z129mr10547148wmc.176.1606500793991;
 Fri, 27 Nov 2020 10:13:13 -0800 (PST)
MIME-Version: 1.0
References: <20201126155246.25961-1-jack@suse.cz>
In-Reply-To: <20201126155246.25961-1-jack@suse.cz>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 27 Nov 2020 10:13:01 -0800
X-Gmail-Original-Message-ID: <CALCETrVaj6rnvqX2cxj3u++hg_XZD-Zo4iYUPTFDiwaO49xDrg@mail.gmail.com>
Message-ID: <CALCETrVaj6rnvqX2cxj3u++hg_XZD-Zo4iYUPTFDiwaO49xDrg@mail.gmail.com>
Subject: Re: [PATCH] fanotify: Fix fanotify_mark() on 32-bit x86
To:     Jan Kara <jack@suse.cz>, linux-arch <linux-arch@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Brian Gerst <brgerst@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 26, 2020 at 7:52 AM Jan Kara <jack@suse.cz> wrote:
>
> Commit converting syscalls taking 64-bit arguments to new scheme of compa=
t
> handlers omitted converting fanotify_mark(2) which then broke the
> syscall for 32-bit x86 builds. Add missed conversion. It is somewhat
> cumbersome since we need to keep the original compat handler for all the
> other 32-bit archs.
>

This is stupendously ugly.  I'm not really sure how this is supposed
to work on any 32-bit arch.  I'm also not sure whether we should
expect the SYSCALL_DEFINE macros to figure this out by themselves.

At the very least, the native arm 32 and arm64 compat cases should get test=
ed.

Al and Christoph, you're probably a lot more familiar than I am with
the nasty details of syscall ABI with 64-bit arguments.

> CC: Brian Gerst <brgerst@gmail.com>
> Suggested-by: Borislav Petkov <bp@suse.de>
> Reported-by: Pawe=C5=82 Jasiak <pawel@jasiak.xyz>
> Reported-and-tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Fixes: 121b32a58a3a ("x86/entry/32: Use IA32-specific wrappers for syscal=
ls taking 64-bit arguments")
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  arch/x86/entry/syscalls/syscall_32.tbl | 2 +-
>  fs/notify/fanotify/fanotify_user.c     | 7 ++++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> I plan to queue this fix into my tree next week. I'd be happy if someone =
with
> x86 ABI knowledge checks whether I've got the patch right (especially var=
ious
> config variants) because it was mostly a guesswork of me & Boris ;). Than=
ks!
>
> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/sysc=
alls/syscall_32.tbl
> index 0d0667a9fbd7..b2ec6ff88307 100644
> --- a/arch/x86/entry/syscalls/syscall_32.tbl
> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
> @@ -350,7 +350,7 @@
>  336    i386    perf_event_open         sys_perf_event_open
>  337    i386    recvmmsg                sys_recvmmsg_time32             c=
ompat_sys_recvmmsg_time32
>  338    i386    fanotify_init           sys_fanotify_init
> -339    i386    fanotify_mark           sys_fanotify_mark               c=
ompat_sys_fanotify_mark
> +339    i386    fanotify_mark           sys_ia32_fanotify_mark
>  340    i386    prlimit64               sys_prlimit64
>  341    i386    name_to_handle_at       sys_name_to_handle_at
>  342    i386    open_by_handle_at       sys_open_by_handle_at           c=
ompat_sys_open_by_handle_at
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fano=
tify_user.c
> index 3e01d8f2ab90..ba38f0fec4d0 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -1292,8 +1292,13 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, u=
nsigned int, flags,
>         return do_fanotify_mark(fanotify_fd, flags, mask, dfd, pathname);
>  }
>
> -#ifdef CONFIG_COMPAT
> +#if defined(CONFIG_COMPAT) || defined(CONFIG_X86_32) || \
> +    defined(CONFIG_IA32_EMULATION)
> +#if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
> +SYSCALL_DEFINE6(ia32_fanotify_mark,
> +#elif CONFIG_COMPAT
>  COMPAT_SYSCALL_DEFINE6(fanotify_mark,
> +#endif
>                                 int, fanotify_fd, unsigned int, flags,
>                                 __u32, mask0, __u32, mask1, int, dfd,
>                                 const char  __user *, pathname)
> --
> 2.16.4
>
