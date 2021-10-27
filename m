Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F55343D314
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 22:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240542AbhJ0UrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 16:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234080AbhJ0UrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 16:47:17 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28749C061570;
        Wed, 27 Oct 2021 13:44:51 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z20so14233743edi.0;
        Wed, 27 Oct 2021 13:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m5TrXx7dXH1SiYJA1++6NEnaXYdCWIdktAUywsE4RX0=;
        b=akIAcR7MWOhUON05qRVFJjbKRt/PMu3/E/9T+JxeU7Cdm1VuLz4d/LGvKfG3S/a0fH
         LNEB27OEF7na0VvowXEp5i9bwoRpyEPrma4PibNukFiofQu557Y/4wU8Hng5UwMSoyWW
         PxBoS8W00M5/W4/6r1sbT7LYMdIBK3zJh7suxGcvEnOryHOP5EWF/k6Le1dD/ugLCvB6
         7zMz/0OT2BcEIPGSVm/VGInyDQwhpWBshY4Ht0RIZOdxyI9jFPRjlXgqnLNU98shbfg6
         LAkTSeyrZ+C/1/x7s/LevolGNlDjp25qerm2zFuxVeEsY4caEgsYrxIR9ks6i7n+l6Yc
         lsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m5TrXx7dXH1SiYJA1++6NEnaXYdCWIdktAUywsE4RX0=;
        b=XTcHu69jyBo03dk2w3mhCYaSGp2rHx8Su+fYIi1Ujmcejusa6goXrn2ztr1k7NN6o0
         b56Gq3oexBFuq+MfhO72lyiyWDJjFrXy5j3lhIr9MQaMmf/tpUwzLU8z4FKanUVGq8bV
         VZ2RC77U1DK+1B3t3s3T4Q4yipcZgK/UYgxaD1t9D4NixI2pWLNGVbfAfUGFyOTcLkUs
         cP9mnP0OfjUyGdNgM5xkfZ5bsHcqVYHReG8S4SFz8AMXPxb6I9b6G47+RMsEvQVfxNAo
         5TW+WvLuequcXcJYorAA1Yv0pCpbFtaxMdW5Z/XNcoIu5Oy9cLT6HAaq7rTjAxjyVZ0i
         QQWA==
X-Gm-Message-State: AOAM532R8/oIHgl4wsZaetRvNxJ9YmVtFuVoDYpvMSilcc2unlgOWlfz
        cNTEAh9VyfIWB/vi6L+9r/Wo2UsupsGcB0e6y1A=
X-Google-Smtp-Source: ABdhPJyrKkbFwY0S008XBn0rgHTRoSBKFT0NjTdmm5C5y13au5Cwmp9tzLsUj6X6JjZVTGAd7to5BEcXMZU5uJb3Huc=
X-Received: by 2002:aa7:de83:: with SMTP id j3mr211527edv.312.1635367489683;
 Wed, 27 Oct 2021 13:44:49 -0700 (PDT)
MIME-Version: 1.0
References: <20211027195221.3825-1-shy828301@gmail.com> <C8C6E50C-D300-40D4-AA5C-490F673BADFE@fb.com>
In-Reply-To: <C8C6E50C-D300-40D4-AA5C-490F673BADFE@fb.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Wed, 27 Oct 2021 13:44:37 -0700
Message-ID: <CAHbLzkqTW9U3VvTu1Ki5v_cLRC9gHW+znBukg_ycergE0JWj-A@mail.gmail.com>
Subject: Re: [PATCH] mm: khugepaged: skip huge page collapse for special files
To:     Song Liu <songliubraving@fb.com>
Cc:     Hugh Dickins <hughd@google.com>,
        "sunhao.th@gmail.com" <sunhao.th@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "andrea.righi@canonical.com" <andrea.righi@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 1:35 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Oct 27, 2021, at 12:52 PM, Yang Shi <shy828301@gmail.com> wrote:
> >
> > The read-only THP for filesystems would collapse THP for file opened
> > readonly and mapped with VM_EXEC, the intended usecase is to avoid TLB
> > miss for large text segment.  But it doesn't restrict the file types so
> > THP could be collapsed for non-regular file, for example, block device,
> > if it is opened readonly and mapped with EXEC permission.  This may
> > cause bugs, like [1] and [2].
> >
> > This is definitely not intended usecase, so just collapsing THP for regular
> > file in order to close the attack surface.
> >
> > [1] https://lore.kernel.org/lkml/CACkBjsYwLYLRmX8GpsDpMthagWOjWWrNxqY6ZLNQVr6yx+f5vA@mail.gmail.com/
> > [2] https://lore.kernel.org/linux-mm/000000000000c6a82505ce284e4c@google.com/
> >
> > Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> > Reported-by: Hao Sun <sunhao.th@gmail.com>
> > Reported-by: syzbot+aae069be1de40fb11825@syzkaller.appspotmail.com
> > Cc: Hao Sun <sunhao.th@gmail.com>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Cc: Song Liu <songliubraving@fb.com>
> > Cc: Andrea Righi <andrea.righi@canonical.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > Signed-off-by: Yang Shi <shy828301@gmail.com>
> > ---
> > The patch is basically based off the proposal from Hugh
> > (https://lore.kernel.org/linux-mm/a07564a3-b2fc-9ffe-3ace-3f276075ea5c@google.com/).
> > It seems Hugh is too busy to prepare the patch for formal submission (I
> > didn't hear from him by pinging him a couple of times on mailing list),
> > so I prepared the patch and added his SOB.
> >
> > mm/khugepaged.c | 17 ++++++++++-------
> > 1 file changed, 10 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 045cc579f724..e91b7271275e 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -445,22 +445,25 @@ static bool hugepage_vma_check(struct vm_area_struct *vma,
> >       if (!transhuge_vma_enabled(vma, vm_flags))
> >               return false;
> >
> > -     /* Enabled via shmem mount options or sysfs settings. */
> > -     if (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) {
> > +     if (vma->vm_file)
> >               return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
> >                               HPAGE_PMD_NR);
>
> Am I misreading this? If we return here for vma->vm_file, the following
> logic (shmem_file(), etc.) would be skipped, no?

Oh, yes, you are right. My mistake.

Andrew,

Could you please apply the below fix?

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e91b7271275e..26f1798c88d2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -445,9 +445,9 @@ static bool hugepage_vma_check(struct vm_area_struct *vma,
        if (!transhuge_vma_enabled(vma, vm_flags))
                return false;

-       if (vma->vm_file)
-               return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
-                               HPAGE_PMD_NR);
+       if (vma->vm_file && !IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) -
+                               vma->vm_pgoff, HPAGE_PMD_NR))
+               return false;

        /* Enabled via shmem mount options or sysfs settings. */
        if (shmem_file(vma->vm_file))

>
> Thanks,
> Song
>
> > -     }
> > +
> > +     /* Enabled via shmem mount options or sysfs settings. */
> > +     if (shmem_file(vma->vm_file))
> > +             return shmem_huge_enabled(vma);
> >
> >       /* THP settings require madvise. */
> >       if (!(vm_flags & VM_HUGEPAGE) && !khugepaged_always())
> >               return false;
> >
> > -     /* Read-only file mappings need to be aligned for THP to work. */
> > +     /* Only regular file is valid */
> >       if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && vma->vm_file &&
> > -         !inode_is_open_for_write(vma->vm_file->f_inode) &&
> >           (vm_flags & VM_EXEC)) {
> > -             return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
> > -                             HPAGE_PMD_NR);
> > +             struct inode *inode = vma->vm_file->f_inode;
> > +
> > +             return !inode_is_open_for_write(inode) &&
> > +                     S_ISREG(inode->i_mode);
> >       }
> >
> >       if (!vma->anon_vma || vma->vm_ops)
> > --
> > 2.26.2
> >
>
