Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9AB352016
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 21:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhDATr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 15:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbhDATrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 15:47:25 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8783C061788
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 12:47:25 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id j198so2927356ybj.11
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 12:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=apM991fcSzCvxwtBXbERhXcPo06u2NcSXVhXFrtKV00=;
        b=TJ6yRcs7/F+2BvmvNKprIwFoMgYMbWh480ndLABBp0juXVh2ZGBUuvuz1buktyB14w
         7xq89lWufQjLlBuXpCHyqUGBObvQQzPVEYMOlCYzSbyciFwTo68cjXK6zV6g8VyMSsPA
         PFhlsU9toLUL7vPMG9GtOe2iJpR7dFGkxOEQtH4ppukpLl+d8bcFOV71LOQzVf69KHCb
         PZZ5ueSMNHPrvgcEfVfSff1dRpbMXnBriAiJDO02/3NMRRmTBs4rr7WgQJw82o7WX8q2
         e6e4ie7dVH+3dYBbfmQqMQnFY433jTjVp/LHXLPzINeg3jvPjoV34mui1dgOJgg2ECj+
         4kKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=apM991fcSzCvxwtBXbERhXcPo06u2NcSXVhXFrtKV00=;
        b=RfhqEpaoltPqlJySeMJDuh2PB4c3X7klzjA3eACop7NemxHy/HbHOB8V6IhedIADcd
         CTsnh+/o5f06NszhwrI3RhdDqMjX8gPErFcm0Wzoykw6GtTqbNJr9ViFQIDElzQVtCFZ
         UFisIyNZ3Yt8f57up1RLrwP76TCMeFDjgJySfEd/9t92mkSOHqfmvdAmUMqi/tiaNgh7
         6bXvxdHwszN3Um+hI0OMCQZdj6wbWD/YzPH4yhddZo6beBZ+Yhrto7fAaHPV+hUyP0cX
         qgxEUXRGW7HZ4L6Tvvp0cvhT2+M+Opt886rgi6ShzbFFRKk5yBqCsNoCcgBblBr4uaXC
         GZoA==
X-Gm-Message-State: AOAM530qKPeQDJvBXeQ/EC2pZJErPLmiyH8yfJRTUGD+6o3RmffAe5Dk
        oEm3pUe0gXU4HwD5P10u8L8vYTsOYQYhpGhfLWm/wUL2kOk=
X-Google-Smtp-Source: ABdhPJyq6aKnmG2A7Si4ZLOB+gj583IhyHClIDbpZy/gCj/QYdL7b4iuDo+gvH4J2QHnLDJF4hzy7NNomu+zV265/hw=
X-Received: by 2002:a25:c801:: with SMTP id y1mr14487864ybf.250.1617306444108;
 Thu, 01 Apr 2021 12:47:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210401181741.168763-1-surenb@google.com> <20210401181741.168763-2-surenb@google.com>
 <YGYhJxFpfCx9VqZS@kroah.com>
In-Reply-To: <YGYhJxFpfCx9VqZS@kroah.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Thu, 1 Apr 2021 12:47:13 -0700
Message-ID: <CAJuCfpG18PvjmcMma_rKSBRfUHui3TJ73w8f+fDmzv3Vi__HMA@mail.gmail.com>
Subject: Re: [PATCH 1/5] mm: reuse only-pte-mapped KSM page in do_wp_page()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, Jann Horn <jannh@google.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Shaohua Li <shli@fb.com>, Nadav Amit <namit@vmware.com>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>,
        Rik van Riel <riel@surriel.com>,
        Huang Ying <ying.huang@intel.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 1, 2021 at 12:38 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Apr 01, 2021 at 11:17:37AM -0700, Suren Baghdasaryan wrote:
> > From: Kirill Tkhai <ktkhai@virtuozzo.com>
> >
> > Add an optimization for KSM pages almost in the same way that we have
> > for ordinary anonymous pages.  If there is a write fault in a page,
> > which is mapped to an only pte, and it is not related to swap cache; the
> > page may be reused without copying its content.
> >
> > [ Note that we do not consider PageSwapCache() pages at least for now,
> >   since we don't want to complicate __get_ksm_page(), which has nice
> >   optimization based on this (for the migration case). Currenly it is
> >   spinning on PageSwapCache() pages, waiting for when they have
> >   unfreezed counters (i.e., for the migration finish). But we don't want
> >   to make it also spinning on swap cache pages, which we try to reuse,
> >   since there is not a very high probability to reuse them. So, for now
> >   we do not consider PageSwapCache() pages at all. ]
> >
> > So in reuse_ksm_page() we check for 1) PageSwapCache() and 2)
> > page_stable_node(), to skip a page, which KSM is currently trying to
> > link to stable tree.  Then we do page_ref_freeze() to prohibit KSM to
> > merge one more page into the page, we are reusing.  After that, nobody
> > can refer to the reusing page: KSM skips !PageSwapCache() pages with
> > zero refcount; and the protection against of all other participants is
> > the same as for reused ordinary anon pages pte lock, page lock and
> > mmap_sem.
> >
> > [akpm@linux-foundation.org: replace BUG_ON()s with WARN_ON()s]
> > Link: http://lkml.kernel.org/r/154471491016.31352.1168978849911555609.stgit@localhost.localdomain
> > Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> > Reviewed-by: Yang Shi <yang.shi@linux.alibaba.com>
> > Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
> > Cc: Hugh Dickins <hughd@google.com>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Cc: Christian Koenig <christian.koenig@amd.com>
> > Cc: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
> > Cc: Rik van Riel <riel@surriel.com>
> > Cc: Huang Ying <ying.huang@intel.com>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > ---
> >  include/linux/ksm.h |  7 +++++++
> >  mm/ksm.c            | 30 ++++++++++++++++++++++++++++--
> >  mm/memory.c         | 16 ++++++++++++++--
> >  3 files changed, 49 insertions(+), 4 deletions(-)
>
> You forgot to put the git commit id of the upstream commit in here
> somewhere so we can properly reference it and track it.
>
> When/if you resend this, please add it to all of the commits.

Will do. Thanks!

>
> thanks,
>
> greg k-h
