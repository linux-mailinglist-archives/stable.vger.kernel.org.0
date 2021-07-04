Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2533BADB3
	for <lists+stable@lfdr.de>; Sun,  4 Jul 2021 17:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhGDPmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 11:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhGDPmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Jul 2021 11:42:43 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB93EC061574
        for <stable@vger.kernel.org>; Sun,  4 Jul 2021 08:40:06 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id h2so20374859edt.3
        for <stable@vger.kernel.org>; Sun, 04 Jul 2021 08:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aR0m64HeW1gtkHq8ZZxeKO2/pCX7wNNQkpb6dCYWvC8=;
        b=u606kjj0a6C9fMeiDMWZLB70p9UxGg8aCQlOcri6UE/6YXAoa/BSN5awecnpEI8sY6
         CReq3PAKQqzNOctkIBDv9e49CmVIJA4a+L15S8Rak3GEOHm31NuWsvg+e6YTZREWRdDt
         fyuhgtZihch1663UDE20/NrtCTSaSIqFL3Ie17AHfqhqwiwwzBYGf/KIX6B/j1Ts0Zy5
         3LsEZ7SytCXXqyQyrwxn5WnB9KtwojMSwlMYpsmsGk/vJmGxC0rFY6dZQJTJngo2tWCi
         tjaMSex/KvG2rhIc3mOTMSfujmxbdUeRRW0PtMq4ua7uyv1rmh8BrZRu4gUkrpOJ7UCx
         T2Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aR0m64HeW1gtkHq8ZZxeKO2/pCX7wNNQkpb6dCYWvC8=;
        b=ZmBOOn1kEaocOMdXg+ULmZbOIQtVoPsfUw9ZcBQhfwIH6m51DOIJRB5ikDU/ZQA27f
         1WpdpdgbsMuSHs5XO91rjpyUEMBz4lQHYvOp7HI8NvVSaY0AKgVFAVRVc46Ucv85TZ5l
         cPOEWRlmHe/JpyE9f4Upg1AO3hbXxXZRXCxnXc8nF11jPWObWk8iErKmDNzvJWbDMuPp
         wYexNMPIZ69wEWuf7hvpt/uu0ob8rIo1Gw2nTSxL/C+bL1tnIFFHDO/jemSC3+r4zOPI
         mCPLWoCWoFQpP8LYyVayXg7NYtNfsqmpzIXfoKen4Ecpg+m/3lDKdp6iAF3R5Gdhi1JK
         C5gg==
X-Gm-Message-State: AOAM533iNLQAM+ZEjl/80y/DOauopDwn0CS9DGeO67QTqz0wz5ILa0FB
        4NOv9e216WwFrpXoxyUUfw3jVG0UdEZZaOaZPI8=
X-Google-Smtp-Source: ABdhPJzTAjYZcBhcQWaT/Woz2xjU8jdKDKOTHfH76vNOgbXwnObuf8XjWcZnIDBwxWtsl56SWa+y/5sSeur1MyQiPbk=
X-Received: by 2002:a05:6402:216:: with SMTP id t22mr10942233edv.70.1625413205386;
 Sun, 04 Jul 2021 08:40:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210702225705.2477947-1-pcc@google.com> <20210702225705.2477947-2-pcc@google.com>
In-Reply-To: <20210702225705.2477947-2-pcc@google.com>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Sun, 4 Jul 2021 17:39:54 +0200
Message-ID: <CA+fCnZes=c5LOmctcth4Yjkx6bxnETVFNQgUVJ3uvbEtjRPTSg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] userfaultfd: do not untag user pointers
To:     Peter Collingbourne <pcc@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Alistair Delva <adelva@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        William McVicker <willmcvicker@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Mitch Phillips <mitchp@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 3, 2021 at 12:57 AM Peter Collingbourne <pcc@google.com> wrote:
>
> If a user program uses userfaultfd on ranges of heap memory, it may
> end up passing a tagged pointer to the kernel in the range.start
> field of the UFFDIO_REGISTER ioctl. This can happen when using an
> MTE-capable allocator, or on Android if using the Tagged Pointers
> feature for MTE readiness [1].
>
> When a fault subsequently occurs, the tag is stripped from the fault
> address returned to the application in the fault.address field
> of struct uffd_msg. However, from the application's perspective,
> the tagged address *is* the memory address, so if the application
> is unaware of memory tags, it may get confused by receiving an
> address that is, from its point of view, outside of the bounds of the
> allocation. We observed this behavior in the kselftest for userfaultfd
> [2] but other applications could have the same problem.
>
> Address this by not untagging pointers passed to the userfaultfd
> ioctls. Instead, let the system call fail. This will provide an
> early indication of problems with tag-unaware userspace code instead
> of letting the code get confused later, and is consistent with how
> we decided to handle brk/mmap/mremap in commit dcde237319e6 ("mm:
> Avoid creating virtual address aliases in brk()/mmap()/mremap()"),
> as well as being consistent with the existing tagged address ABI
> documentation relating to how ioctl arguments are handled.
>
> The code change is a revert of commit 7d0325749a6c ("userfaultfd:
> untag user pointers").
>
> [1] https://source.android.com/devices/tech/debug/tagged-pointers
> [2] tools/testing/selftests/vm/userfaultfd.c
>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Link: https://linux-review.googlesource.com/id/I761aa9f0344454c482b83fcfcce547db0a25501b
> Fixes: 63f0c6037965 ("arm64: Introduce prctl() options to control the tagged user addresses ABI")
> Cc: <stable@vger.kernel.org> # 5.4
> ---
>  Documentation/arm64/tagged-address-abi.rst | 25 +++++++++++++++-------
>  fs/userfaultfd.c                           | 22 +++++++++----------
>  2 files changed, 27 insertions(+), 20 deletions(-)
>
> diff --git a/Documentation/arm64/tagged-address-abi.rst b/Documentation/arm64/tagged-address-abi.rst
> index 459e6b66ff68..737f9d8565a2 100644
> --- a/Documentation/arm64/tagged-address-abi.rst
> +++ b/Documentation/arm64/tagged-address-abi.rst
> @@ -45,14 +45,23 @@ how the user addresses are used by the kernel:
>
>  1. User addresses not accessed by the kernel but used for address space
>     management (e.g. ``mprotect()``, ``madvise()``). The use of valid
> -   tagged pointers in this context is allowed with the exception of
> -   ``brk()``, ``mmap()`` and the ``new_address`` argument to
> -   ``mremap()`` as these have the potential to alias with existing
> -   user addresses.
> -
> -   NOTE: This behaviour changed in v5.6 and so some earlier kernels may
> -   incorrectly accept valid tagged pointers for the ``brk()``,
> -   ``mmap()`` and ``mremap()`` system calls.
> +   tagged pointers in this context is allowed with these exceptions:
> +
> +   - ``brk()``, ``mmap()`` and the ``new_address`` argument to
> +     ``mremap()`` as these have the potential to alias with existing
> +      user addresses.
> +
> +     NOTE: This behaviour changed in v5.6 and so some earlier kernels may
> +     incorrectly accept valid tagged pointers for the ``brk()``,
> +     ``mmap()`` and ``mremap()`` system calls.
> +
> +   - The ``range.start`` argument to the ``UFFDIO_REGISTER`` ``ioctl()``
> +     used on a file descriptor obtained from ``userfaultfd()``, as
> +     fault addresses subsequently obtained by reading the file descriptor
> +     will be untagged, which may otherwise confuse tag-unaware programs.
> +
> +     NOTE: This behaviour changed in v5.14 and so some earlier kernels may
> +     incorrectly accept valid tagged pointers for this system call.
>
>  2. User addresses accessed by the kernel (e.g. ``write()``). This ABI
>     relaxation is disabled by default and the application thread needs to
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index dd7a6c62b56f..7613efe002c1 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -1236,23 +1236,21 @@ static __always_inline void wake_userfault(struct userfaultfd_ctx *ctx,
>  }
>
>  static __always_inline int validate_range(struct mm_struct *mm,
> -                                         __u64 *start, __u64 len)
> +                                         __u64 start, __u64 len)
>  {
>         __u64 task_size = mm->task_size;
>
> -       *start = untagged_addr(*start);
> -
> -       if (*start & ~PAGE_MASK)
> +       if (start & ~PAGE_MASK)
>                 return -EINVAL;
>         if (len & ~PAGE_MASK)
>                 return -EINVAL;
>         if (!len)
>                 return -EINVAL;
> -       if (*start < mmap_min_addr)
> +       if (start < mmap_min_addr)
>                 return -EINVAL;
> -       if (*start >= task_size)
> +       if (start >= task_size)
>                 return -EINVAL;
> -       if (len > task_size - *start)
> +       if (len > task_size - start)
>                 return -EINVAL;
>         return 0;
>  }
> @@ -1313,7 +1311,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>                 vm_flags |= VM_UFFD_MINOR;
>         }
>
> -       ret = validate_range(mm, &uffdio_register.range.start,
> +       ret = validate_range(mm, uffdio_register.range.start,
>                              uffdio_register.range.len);
>         if (ret)
>                 goto out;
> @@ -1519,7 +1517,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>         if (copy_from_user(&uffdio_unregister, buf, sizeof(uffdio_unregister)))
>                 goto out;
>
> -       ret = validate_range(mm, &uffdio_unregister.start,
> +       ret = validate_range(mm, uffdio_unregister.start,
>                              uffdio_unregister.len);
>         if (ret)
>                 goto out;
> @@ -1668,7 +1666,7 @@ static int userfaultfd_wake(struct userfaultfd_ctx *ctx,
>         if (copy_from_user(&uffdio_wake, buf, sizeof(uffdio_wake)))
>                 goto out;
>
> -       ret = validate_range(ctx->mm, &uffdio_wake.start, uffdio_wake.len);
> +       ret = validate_range(ctx->mm, uffdio_wake.start, uffdio_wake.len);
>         if (ret)
>                 goto out;
>
> @@ -1708,7 +1706,7 @@ static int userfaultfd_copy(struct userfaultfd_ctx *ctx,
>                            sizeof(uffdio_copy)-sizeof(__s64)))
>                 goto out;
>
> -       ret = validate_range(ctx->mm, &uffdio_copy.dst, uffdio_copy.len);
> +       ret = validate_range(ctx->mm, uffdio_copy.dst, uffdio_copy.len);
>         if (ret)
>                 goto out;
>         /*
> @@ -1765,7 +1763,7 @@ static int userfaultfd_zeropage(struct userfaultfd_ctx *ctx,
>                            sizeof(uffdio_zeropage)-sizeof(__s64)))
>                 goto out;
>
> -       ret = validate_range(ctx->mm, &uffdio_zeropage.range.start,
> +       ret = validate_range(ctx->mm, uffdio_zeropage.range.start,
>                              uffdio_zeropage.range.len);
>         if (ret)
>                 goto out;
> --
> 2.32.0.93.g670b81a890-goog
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
