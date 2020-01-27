Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F190514AC08
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 23:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgA0Wav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 17:30:51 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43144 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgA0Wav (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 17:30:51 -0500
Received: by mail-qk1-f194.google.com with SMTP id j20so11358056qka.10
        for <stable@vger.kernel.org>; Mon, 27 Jan 2020 14:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/xn6Inxb6zuojs0iU7vTmsWoRmbZmQqG7zN5KkIu1iw=;
        b=RXYubqq5Vbt9/Yqh8rRc3gW77GBTJ9ktqMwX5BzBMFzzOT2bfEFFer+ZATdml4q/L8
         yeUOXdIXzpuY6tZZqtw3VnhfsjSheZCS0/Gla/Xdu7BNRdS4IpGlq4doJ5Bkrzt4xX6A
         szH+cb+WI7yNz8moAdV/Kr2o5h5MW7f9s8NyngUeHka78W+CdMlAM41W/l19UsOM96tl
         XdWQ0NvsVIuflJlp87Lsp8b5jFxwqtmUOaizejZb+TkDnH1G1uVVvhWbqDycJoI1H35g
         WyAdOfAKKVRFvXixsNa5QQkHdeIC085SjF1Ebd1YCifclqVFWwV3CSQkl/gYtzNQtvlJ
         ll/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/xn6Inxb6zuojs0iU7vTmsWoRmbZmQqG7zN5KkIu1iw=;
        b=JWvfddcaQLHYAr2T/7eEcRKQFfNW9AQbWoTRdXjYju5klUsa89tcATAvh6VLZW/wP0
         k1w1qr53PfOORb7/0j4Qe22rGFK95l32i8txBtiHuFLt6WGHSyB/B7gdFqxEDyRdWQzY
         bNuG3vO9oLgHNDABwWzLO/RYFWCEr8MiaKsxsJbNZUs6nmFluSqcVhihdTFC6+h82MPg
         Eogrpj7XHmu4gvI6ssGocKVOntsZa0rAlMzr3yXtj8G8evMFE1XDS/oetos8sAPa9GTh
         9e5MCP42DafGCCGSPfi+f5OhiB54IsjzRCaCu7bSBX0/iJiSzxajkkAuEgrLJuiJgxBm
         y2UQ==
X-Gm-Message-State: APjAAAVYD5xNnf+xUSYZyf0xSV6tttz890A4Azt8+x6A79KTv712NfuT
        lHOjzqgJBylNe3sWjWQu/nkxhZJOh7d4xo5jT8wreA==
X-Google-Smtp-Source: APXvYqxCSQrirUnN+FZ82T0KdKjdeTod7OErds5KLF8UmezscEdKL2MJ9VbnHcnHl/RVaw2STHVzvy/g3A5rXPztxxQ=
X-Received: by 2002:a37:6794:: with SMTP id b142mr19240197qkc.216.1580164248519;
 Mon, 27 Jan 2020 14:30:48 -0800 (PST)
MIME-Version: 1.0
References: <20200127210014.5207-1-tkjos@google.com>
In-Reply-To: <20200127210014.5207-1-tkjos@google.com>
From:   Joel Fernandes <joelaf@google.com>
Date:   Mon, 27 Jan 2020 14:30:36 -0800
Message-ID: <CAJWu+orT-A5HVi97ccKwMvs9MvXWV0MZhsKcZDNS8r-gqRmcDA@mail.gmail.com>
Subject: Re: [PATCH] staging: android: ashmem: Disallow ashmem memory from
 being remapped
To:     Todd Kjos <tkjos@google.com>
Cc:     Suren Baghdasaryan <surenb@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve Hjonnevag <arve@android.com>,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martijn Coenen <maco@google.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Jann Horn <jannh@google.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 27, 2020 at 1:00 PM 'Todd Kjos' via kernel-team
<kernel-team@android.com> wrote:
>
> From: Suren Baghdasaryan <surenb@google.com>
>
> When ashmem file is being mmapped the resulting vma->vm_file points to the
> backing shmem file with the generic fops that do not check ashmem
> permissions like fops of ashmem do. Fix that by disallowing mapping
> operation for backing shmem file.

Looks good, but I think the commit message is confusing. I had to read
the code a couple times to understand what's going on since there are
no links to a PoC for the security issue, in the commit message. I
think a better message could have been:

 When ashmem file is mmapped, the resulting vma->vm_file points to the
 backing shmem file with the generic fops that do not check ashmem
 permissions like fops of ashmem do. If an mremap is done on the ashmem
 region, then the permission checks will be skipped. Fix that by disallowing
 mapping operation on the backing shmem file.

Or did I miss something?

thanks!

- Joel



>
> Reported-by: Jann Horn <jannh@google.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: stable <stable@vger.kernel.org> # 4.4,4.9,4.14,4.18,5.4
> Signed-off-by: Todd Kjos <tkjos@google.com>
> ---
>  drivers/staging/android/ashmem.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
> index 74d497d39c5a..c6695354b123 100644
> --- a/drivers/staging/android/ashmem.c
> +++ b/drivers/staging/android/ashmem.c
> @@ -351,8 +351,23 @@ static inline vm_flags_t calc_vm_may_flags(unsigned long prot)
>                _calc_vm_trans(prot, PROT_EXEC,  VM_MAYEXEC);
>  }
>
> +static int ashmem_vmfile_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       /* do not allow to mmap ashmem backing shmem file directly */
> +       return -EPERM;
> +}
> +
> +static unsigned long
> +ashmem_vmfile_get_unmapped_area(struct file *file, unsigned long addr,
> +                               unsigned long len, unsigned long pgoff,
> +                               unsigned long flags)
> +{
> +       return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
> +}
> +
>  static int ashmem_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> +       static struct file_operations vmfile_fops;
>         struct ashmem_area *asma = file->private_data;
>         int ret = 0;
>
> @@ -393,6 +408,19 @@ static int ashmem_mmap(struct file *file, struct vm_area_struct *vma)
>                 }
>                 vmfile->f_mode |= FMODE_LSEEK;
>                 asma->file = vmfile;
> +               /*
> +                * override mmap operation of the vmfile so that it can't be
> +                * remapped which would lead to creation of a new vma with no
> +                * asma permission checks. Have to override get_unmapped_area
> +                * as well to prevent VM_BUG_ON check for f_ops modification.
> +                */
> +               if (!vmfile_fops.mmap) {
> +                       vmfile_fops = *vmfile->f_op;
> +                       vmfile_fops.mmap = ashmem_vmfile_mmap;
> +                       vmfile_fops.get_unmapped_area =
> +                                       ashmem_vmfile_get_unmapped_area;
> +               }
> +               vmfile->f_op = &vmfile_fops;
>         }
>         get_file(asma->file);
>
> --
> 2.25.0.341.g760bfbb309-goog
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
