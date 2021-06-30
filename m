Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48BEE3B7B8E
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 04:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhF3CgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 22:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbhF3CgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 22:36:25 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343BAC061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 19:33:57 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id l26-20020a4ac61a0000b029024c94215d77so228746ooq.11
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 19:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h8cE7J+p1yXlo5Tel5fJy/AbTdFi4uMpW965ALmB+gg=;
        b=mS1cLyfggpA/fv8zL2BME1GeknBN9Pj0UCdJu4QD/oR2rm+4cQaAzpbS2hvW4Xgczb
         T4iCXV7eKicC5tyzW44ghZRQW7ihyjNlm9nARemkNFBnRoIYLXI4+vw0S/XBaXvYcqgA
         XsofofkUv0GcDJJL/n8orH8hHAsDRmzjyah0iMbc/ag91z6MFvbLv8+ikuPSELs/+6Mj
         nBzVk8ebaU0Eav/vTBcpE4kpotSlKbVx4/QnN5mWPhDiw8qmQn9SkEHI+JZNapa9VNth
         u25A89mCYJK2F3I8Xw55eA//3/WLNEGG161B/Ucg4asNQ4+727H0sPH8vbPvHq9kueiJ
         biLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h8cE7J+p1yXlo5Tel5fJy/AbTdFi4uMpW965ALmB+gg=;
        b=fdjja9leUHKIsLwDnmv+itJfAg0g5gFSa2gL0t5RcoA954bAAU/LpWMPd/GCKyPqLm
         wHFBqizm9cHikGPxUwnbOG6jcBjDOyERNQsRPxOgGe6Bl8Jfs1LiBZkPcwdte4Qk/P6O
         lSUSpmmvo25o8y3Ar7OgYraBX6v9IRIW+HlbRWN2Y0J58pxhrKuiNB1E/XJug3kKqwTq
         8UOrnFfYbg1WW55tkAG5QhzQLJjWESr3H3KcxDM/Qq85zQVZAeEg27cdvZXhU8f1wUx0
         HSTOBcHBXZia33ou47OVUWRsrC6iN774GuvrUPJmDEBpfTAL92lFkJqN2DPNDgR6jPj3
         dGqg==
X-Gm-Message-State: AOAM531D5L3ERLp7CHzUWAH8XcZuD9ZJq7lFmnCDJpL3aRMwed0QVaTz
        yqZAJ3nzErasYAXC/EbljfaGenhtDAf6OeKFxaY=
X-Google-Smtp-Source: ABdhPJxvJ6ZG/pOVRXXltUBiZhS0SnPeA51u3dO9WyuhYbuT2JyJXEB1dXuKZkJuh5LzglMhWTE4/ZsTRh4/1mAgNSY=
X-Received: by 2002:a4a:956f:: with SMTP id n44mr6619718ooi.54.1625020420951;
 Tue, 29 Jun 2021 19:33:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210629104024.2293615-1-gregkh@linuxfoundation.org> <382e353f-7489-d8c8-5711-a2d99b0b7f0@google.com>
In-Reply-To: <382e353f-7489-d8c8-5711-a2d99b0b7f0@google.com>
From:   Qiang Liu <cyruscyliu@gmail.com>
Date:   Wed, 30 Jun 2021 10:33:29 +0800
Message-ID: <CAAKa2jn6LB14BYXJWoVoqgcqrjTYwJgLdDCa8mir=jOw6x5ZDA@mail.gmail.com>
Subject: Re: [PATCH] nds32: fix up stack guard gap
To:     Hugh Dickins <hughd@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        iLifetruth <yixiaonn@gmail.com>, Michal Hocko <mhocko@suse.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, Jun 30, 2021 at 4:33 AM Hugh Dickins <hughd@google.com> wrote:
>
> On Tue, 29 Jun 2021, Greg Kroah-Hartman wrote:
>
> > Commit 1be7107fbe18 ("mm: larger stack guard gap, between vmas") fixed
> > up almost all architectures to deal with the stack guard gap, but forgit
> > nds32.
> >
> > Resolve this by properly fixing up the nsd32's version of
> > arch_get_unmapped_area()
> >
> > Reported-by: iLifetruth <yixiaonn@gmail.com>
> > Cc: Nick Hu <nickhu@andestech.com>
> > Cc: Greentime Hu <green.hu@gmail.com>
> > Cc: Vincent Chen <deanbo422@gmail.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Hugh Dickins <hughd@google.com>
> > Cc: Qiang Liu <cyruscyliu@gmail.com>
> > Cc: stable <stable@vger.kernel.org>
> > Fixes: 1be7107fbe18 ("mm: larger stack guard gap, between vmas")
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Acked-by: Hugh Dickins <hughd@google.com>
>
> but it's a bit unfair to say that commit forgot nds32:
> nds32 came into the tree nearly a year later.
Could we use "not forward ported to"?

>
> > ---
> >  arch/nds32/mm/mmap.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/nds32/mm/mmap.c b/arch/nds32/mm/mmap.c
> > index c206b31ce07a..1bdf5e7d1b43 100644
> > --- a/arch/nds32/mm/mmap.c
> > +++ b/arch/nds32/mm/mmap.c
> > @@ -59,7 +59,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
> >
> >               vma = find_vma(mm, addr);
> >               if (TASK_SIZE - len >= addr &&
> > -                 (!vma || addr + len <= vma->vm_start))
> > +                 (!vma || addr + len <= vm_start_gap(vma)))
> >                       return addr;
> >       }
> >
> > --
> > 2.32.0
> >
> >
