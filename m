Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6972B43D5D4
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 23:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhJ0Ver (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 17:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbhJ0Vem (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 17:34:42 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E707C061767;
        Wed, 27 Oct 2021 14:32:16 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w12so15826637edd.11;
        Wed, 27 Oct 2021 14:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0eLs1vKCdD9fRUqUY5RcYH11tOWYmTj/mhP+WyCuSws=;
        b=bFn4mtu1GV4VL42GOaedj6+RTGWTSaRL10vA5lMTwhC9f/TSuaIgj4vt/kiSeQ0OG6
         fZ7xUcbnD42u3FPpAML/7jbHVZRVs5vYJ4dG/COcZsYuLhtJLwRuOT6RklhqOYU3xSwC
         LF6rdT+paQcIxhvWydHu3rpYUCbUgg+WGJWKx+9zyL4N1RD8BRrrT6omtw9lbGPHT0ui
         fAZvCDSwqDILwokQeYTIqPvq6xNGHPoF4xkS4cHJnY6kWyqnENKL2pVuAR6Xj/tiOdya
         8vGdaBx8VAVmMLjuT1/uh+3Vqb0cy73hZ2kpPm/es7QPo7SaiToP7Y3/HVXL1I9gMeXx
         tIsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0eLs1vKCdD9fRUqUY5RcYH11tOWYmTj/mhP+WyCuSws=;
        b=sieJ5aUag8Ltn68ftY5R5M/YIAFSpnCQxlLX5ZaWi5RIEc84cP7Rl/Mxr9lflazA4V
         rRM8t79dtYghQ/EWmv7996elBKnvDk/PeC/Fhb3y2KFFVmof8fLL0wE5qn3n3Q0Kn8S4
         VOZRMslwoXKYgVJW8sS7WhKMO6SVUPQRvHND14BRv/YOZcXe7UbspAwhLt1WmSek+xaP
         SkA++3MBxqS8uiLR/3Lddgy770Sv6wjeEArwkkKuGeKcIAI++nKuwdfabXgKl9Q7VESL
         tl1HirLzkAWcFG9QDnTd1xLYh1IX9RQWcAcwj6ZslAEYu8IfMWRmRK4fo6G/jwPNe3p2
         gWtQ==
X-Gm-Message-State: AOAM5330Po68zSzvVCQy8lDtyR8PDxJE4I0T8TsEwqJ//5kc4MSIMBnS
        BQbWAVUtinbfzbM3V76SHyHbkD1YwiLw6WjRIcSbf5SMq3s=
X-Google-Smtp-Source: ABdhPJxi08ueX1uJIQi3nNiPcLn92zuct9e+mWkRd0nfv01nssBA6LRbHDXqZtemi0VUtjzqzBhq3Z7fF4/sGrBMX7c=
X-Received: by 2002:a50:8d52:: with SMTP id t18mr489479edt.71.1635370334982;
 Wed, 27 Oct 2021 14:32:14 -0700 (PDT)
MIME-Version: 1.0
References: <20211027195221.3825-1-shy828301@gmail.com> <YXm7kHy8uTN1+RRc@casper.infradead.org>
In-Reply-To: <YXm7kHy8uTN1+RRc@casper.infradead.org>
From:   Yang Shi <shy828301@gmail.com>
Date:   Wed, 27 Oct 2021 14:32:02 -0700
Message-ID: <CAHbLzkrV1SuqZ8750yD6ZDM9D9uc8svrJ_gARrESq0kMspg+uw@mail.gmail.com>
Subject: Re: [PATCH] mm: khugepaged: skip huge page collapse for special files
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Hugh Dickins <hughd@google.com>, Hao Sun <sunhao.th@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Song Liu <songliubraving@fb.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 1:50 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Wed, Oct 27, 2021 at 12:52:21PM -0700, Yang Shi wrote:
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
> > -     }
> > +
> > +     /* Enabled via shmem mount options or sysfs settings. */
> > +     if (shmem_file(vma->vm_file))
> > +             return shmem_huge_enabled(vma);
>
> This doesn't make sense to me.  if vma->vm_file, we already returned,
> so this is dead code.

Yes, Song mentioned the same thing. Fixed by an incremental patch.

>
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
