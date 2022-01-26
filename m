Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A4B49D012
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 17:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236507AbiAZQxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 11:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243341AbiAZQxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 11:53:21 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A05DC06161C;
        Wed, 26 Jan 2022 08:53:20 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id m11so16065edi.13;
        Wed, 26 Jan 2022 08:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yMCR+EXKge9hen5RQObBZwVGVHUPBvemW8pcttH5ZO0=;
        b=IkEvYfQOI3Zx6Igawua9mn3i1veqQWdgKp+06ExpqDtWBuxvZnD5pf/aTUqEuWCQYk
         hwmyWiaeTyPG+nmwAmcJexeZNAaa9xL/16MAlgrV8nAkwFLaugBZpz9m9EVgSb3eZ1Np
         JsdwzpYxEGeKAkJLyVfbn8o/L/Xk5J8V4zmXx8GPhat3rDHBqN0UlQ2bAShJ4qHQ+2dD
         bmfeqMx+NKz+a/HhobeGxqhOCnYZCujYcUD/oSOD/EqgReWsUoF3wZacE49E56qVclG/
         rNL4RWkPcUFsUtASUdnFj88X6fg6T7XNI72GPIgPACYoY9RVDEvh7B6j9yMgHLE76Dc9
         yDww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yMCR+EXKge9hen5RQObBZwVGVHUPBvemW8pcttH5ZO0=;
        b=KfrVGGIy22i7jxQSf6QicnS/H+caet4jdUJxVxyoPl02lRMYHqEV6LJP3QkCrxkT4/
         CrJDPqQRnZGgdJLhJdK0Bw7vIX1mMgYJAPku1v9DydrILGV8eDDNu4zferwEVhXTU/M6
         RjyGhIoexBSJPtBhxMzEfLdqIS7qJv1nfAxWioUPhZas7ElI1lng+yR+BIdEUBEZlnVC
         QxMivVtk8UTaKfa5AgQlRFD602CUrHz0HQoKoJFLC2TqPO0Y0MJ0jCMPFgW2MoBZLtnR
         qEJ4AcMSzDNqDMGqHuaOhPnOUkQijqVrqHcgtOQ3BOChjpDJIJAZ7ayfa+YwLuexDUtj
         f5QQ==
X-Gm-Message-State: AOAM531jg1qGV2WvNwBXHW2w7asQkiV5B87faecFWIgRtymzL5fNPvfE
        qxEgyOOr98vNYdVFH02ifRXpTdv6ZBMz1y1lBTs=
X-Google-Smtp-Source: ABdhPJzivxlBNUz+a7RinXUcIWuV4Xgj19ciAH9xKeP04EYHcdAtwIWVijN24TiR/G/c7rVd/n4BnKZJiXLdcesNIOU=
X-Received: by 2002:a05:6402:11c9:: with SMTP id j9mr25438514edw.385.1643215998924;
 Wed, 26 Jan 2022 08:53:18 -0800 (PST)
MIME-Version: 1.0
References: <20220120202805.3369-1-shy828301@gmail.com> <af603cbe-4a38-9947-5e6d-9a9328b473fb@redhat.com>
 <CAG48ez1xuZdELb=5ed1i0ruoFu5kAaWsf0LgRXEGhrDAcHz8fw@mail.gmail.com>
 <f7f82234-7599-9e39-1108-f8fbe2c1efc9@redhat.com> <CAG48ez17d3p53tSfuDTNCaANyes8RNNU-2i+eFMqkMwuAbRT4Q@mail.gmail.com>
 <5b4e2c29-8f1a-5a68-d243-a30467cc02d4@redhat.com>
In-Reply-To: <5b4e2c29-8f1a-5a68-d243-a30467cc02d4@redhat.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Wed, 26 Jan 2022 08:53:06 -0800
Message-ID: <CAHbLzkqLTkVJk+z8wpa03ponf7k30=Sx6qULwsGsvr5cq5d1aw@mail.gmail.com>
Subject: Re: [v2 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry
To:     David Hildenbrand <david@redhat.com>
Cc:     Jann Horn <jannh@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 3:57 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 26.01.22 12:48, Jann Horn wrote:
> > On Wed, Jan 26, 2022 at 12:38 PM David Hildenbrand <david@redhat.com> wrote:
> >> On 26.01.22 12:29, Jann Horn wrote:
> >>> On Wed, Jan 26, 2022 at 11:51 AM David Hildenbrand <david@redhat.com> wrote:
> >>>> On 20.01.22 21:28, Yang Shi wrote:
> >>>>> The syzbot reported the below BUG:
> >>>>>
> >>>>> kernel BUG at include/linux/page-flags.h:785!
> > [...]
> >>>>> RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
> >>>>> RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
> > [...]
> >>>> Does this point at the bigger issue that reading the mapcount without
> >>>> having the page locked is completely unstable?
> >>>
> >>> (See also https://lore.kernel.org/all/CAG48ez0M=iwJu=Q8yUQHD-+eZDg6ZF8QCF86Sb=CN1petP=Y0Q@mail.gmail.com/
> >>> for context.)
> >>
> >> Thanks for the pointer.
> >>
> >>>
> >>> I'm not sure what you mean by "unstable". Do you mean "the result is
> >>> not guaranteed to still be valid when the call returns", "the result
> >>> might not have ever been valid", or "the call might crash because the
> >>> page's state as a compound page is unstable"?
> >>
> >> A little bit of everything :)
> > [...]
> >>> In case you mean "the result might not have ever been valid":
> >>> Yes, even with this patch applied, in theory concurrent THP splits
> >>> could cause us to count some page mappings twice. Arguably that's not
> >>> entirely correct.
> >>
> >> Yes, the snapshot is not atomic and, thereby, unreliable. That what I
> >> mostly meant as "unstable".
> >>
> >>>
> >>> In case you mean "the call might crash because the page's state as a
> >>> compound page could concurrently change":
> >>
> >> I think that's just a side-product of the snapshot not being "correct",
> >> right?
> >
> > I guess you could see it that way? The way I look at it is that
> > page_mapcount() is designed to return a number that's at least as high
> > as the number of mappings (rarely higher due to races), and using
> > page_mapcount() on an unlocked page is legitimate if you're fine with
> > the rare double-counting of references. In my view, the problem here
> > is:
> >
> > There are different types of references to "struct page" - some of
> > them allow you to call page_mapcount(), some don't. And in particular,
> > get_page() doesn't give you a reference that can be used with
> > page_mapcount(), but locking a (real, non-migration) PTE pointing to
> > the page does give you such a reference.
>
> I assume the point is that as long as the page cannot be unmapped
> because you block it from getting unmapped (PT lock), the compound page
> cannot get split. As long as the page cannot get unmapped from that page
> table you should have at least a mapcount of 1.

If you mean holding ptl could prevent THP from splitting, then it is
not true since you may be in the middle of THP split just exactly like
the race condition solved by this patch.

Just page lock or elevated page refcount could serialize against THP
split AFAIK.

>
> But yeah, using the mapcount of a page that is not even mapped
> (migration entry) is clearly wrong.
>
> To summarize: reading the mapcount on an unlocked page will easily
> return a wrong result and the result should not be relied upon. reading
> the mapcount of a migration entry is dangerous and certainly wrong.

Depends on your usecase. Some just want to get a snapshot, just like
smaps, they don't care.

>
> --
> Thanks,
>
> David / dhildenb
>
