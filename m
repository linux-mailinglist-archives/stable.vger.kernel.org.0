Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDB72C6ED6
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 05:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgK1EtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 23:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732236AbgK1EnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 23:43:14 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F645C0613D1
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 20:43:04 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id t22so8198374ljk.0
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 20:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2n+TfLDFDLNm1diUWlliMMrU6aXYUGrKG5oiOA73RuM=;
        b=DZFcG9y/74Rgnw69MXCuU3qMI6EzY+pf5YpFecTcHNVSEQ75BzQf90ywijZmzbvqL4
         IeS+p3pMx9LKZ2VPJFx3lfvjm1qq/Lb5kp5VKlzpUSYDocCIjf0IU0YyiAC2lah+qOsp
         IITvrXAjJjCS6/ZIZrf3mYhg504gQelj5sOPdmzgmcOqgrsUc4y73dt7VFbWmzWxKwvM
         WN6UmB+tQTQGRMvugEDRucWgRyRjE44RM4IgzJfScPnmnMmgIGPDYbp9tgxErm6p6HE/
         iKV0vjyFoVEhZAnY1in2S26D9uQ8DodEnCv7evtARDytkGMAFl+8WJYbMEJRbEUes9le
         cYCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2n+TfLDFDLNm1diUWlliMMrU6aXYUGrKG5oiOA73RuM=;
        b=c9KDH3MRgwLFAaxF/S2aC70Vdi7tPYkg5tlxLJ3Le0riCP8ixte5vtIRhN8hYfNeVG
         8lTiXJ6EPOVcRlK1pQtl3y8NHbWKmgjZQ0ISRRN4EVf6BQ1ed1UJLgZzsoA1cewVXe9b
         /DS17cHQmFMkcmVrp5ElM7rvnSM2/BnAIX14Tsbi9AvawL0uC6R5q188tBJzkmI/XudQ
         S+Vf8cUVskq5u0GOndxF3FgTvvimZT5huVDJM/bJONA/Ye4VhcgMcBghi1pyqq6y9VvZ
         4ixfI9uXzagPDRzxPkzfbIpXihnt4Lx0+4v/bS7bMwfABYZlw7GOA3LKkS3dx2vw6hMr
         WE4w==
X-Gm-Message-State: AOAM530xgJrsOuKB6xvLJJWfBa74kn1GMYMCiXdIQLhpZa4Y9yV13LzR
        i3yw8YsZN+QumE9GrPkfJeqXmwM0uEORZEAI9y2VRg==
X-Google-Smtp-Source: ABdhPJznc/owu1hxJL41j5B5a6dDFIOdywzccIIq1gAUl367BYKTwf7Bu55aydheHRrc7/qx2xL6cFSIWrgqJpGJNyM=
X-Received: by 2002:a2e:240e:: with SMTP id k14mr5036822ljk.332.1606538582329;
 Fri, 27 Nov 2020 20:43:02 -0800 (PST)
MIME-Version: 1.0
References: <20201127041405.3459198-1-guro@fb.com> <CALvZod56VUdDQmvoHrYFz2mfW_j2C9M+06wcWoz4oCOFmNA4eA@mail.gmail.com>
 <20201127161828.GD840171@carbon.dhcp.thefacebook.com>
In-Reply-To: <20201127161828.GD840171@carbon.dhcp.thefacebook.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Fri, 27 Nov 2020 20:42:51 -0800
Message-ID: <CALvZod5X6QMs+X77E_81SqQ7FL4cNshqO+eG8c+XNjzrqEFaDA@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg/slab: fix obj_cgroup_charge() return value handling
To:     Roman Gushchin <guro@fb.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 8:18 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Thu, Nov 26, 2020 at 09:55:24PM -0800, Shakeel Butt wrote:
> > On Thu, Nov 26, 2020 at 8:14 PM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > Commit 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches
> > > for all allocations") introduced a regression into the handling of the
> > > obj_cgroup_charge() return value. If a non-zero value is returned
> > > (indicating of exceeding one of memory.max limits), the allocation
> > > should fail, instead of falling back to non-accounted mode.
> > >
> > > To make the code more readable, move memcg_slab_pre_alloc_hook()
> > > and memcg_slab_post_alloc_hook() calling conditions into bodies
> > > of these hooks.
> > >
> > > Fixes: 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for all allocations")
> > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  mm/slab.h | 40 ++++++++++++++++++++++++----------------
> > >  1 file changed, 24 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/mm/slab.h b/mm/slab.h
> > > index 59aeb0d9f11b..5dc89d8fb05e 100644
> > > --- a/mm/slab.h
> > > +++ b/mm/slab.h
> > > @@ -257,22 +257,32 @@ static inline size_t obj_full_size(struct kmem_cache *s)
> > >         return s->size + sizeof(struct obj_cgroup *);
> > >  }
> > >
> > > -static inline struct obj_cgroup *memcg_slab_pre_alloc_hook(struct kmem_cache *s,
> > > -                                                          size_t objects,
> > > -                                                          gfp_t flags)
> > > +/*
> > > + * Returns true if the allocation should fail.
> >
> > IMO returning false if the allocation should fail makes this more
> > clear. Otherwise the patch looks good to me.
>
> Ok, I agree. Here is an updated version.
>
> Thank you for looking in!
>
> --
>
> From 456ce03f1c91baf5e2441dce0649e09617437fe4 Mon Sep 17 00:00:00 2001
> From: Roman Gushchin <guro@fb.com>
> Date: Thu, 26 Nov 2020 07:39:57 -0800
> Subject: [PATCH v2] mm: memcg/slab: fix obj_cgroup_charge() return value
>  handling
>
> Commit 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches
> for all allocations") introduced a regression into the handling of the
> obj_cgroup_charge() return value. If a non-zero value is returned
> (indicating of exceeding one of memory.max limits), the allocation
> should fail, instead of falling back to non-accounted mode.
>
> To make the code more readable, move memcg_slab_pre_alloc_hook()
> and memcg_slab_post_alloc_hook() calling conditions into bodies
> of these hooks.
>
> Fixes: 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for all allocations")
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Shakeel Butt <shakeelb@google.com>
