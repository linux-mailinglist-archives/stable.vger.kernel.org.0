Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00302CC039
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 16:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgLBPB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 10:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgLBPB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 10:01:56 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1909BC0613D4
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 07:01:10 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id f18so4067358ljg.9
        for <stable@vger.kernel.org>; Wed, 02 Dec 2020 07:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+AY9trJkRf9cxwS80EFbb5/8Q9oqK1NT5wAK/bAfyuA=;
        b=hHA2aVTI1aAvsxPGY7CXBZa7EJEfdZXG9AAhz0Nk13+0/vviSbyGTsSFlI83PX2W/A
         9EsuDVKyc8xiQWKiDtM8DET2BvFmo6Wy8cxFwVp0JYcKHURDgVCKP/heXChSAG3UpKG4
         xXnGshxq35QveZnKgL0IIrTyxR/N4NMxQBgK91eo1dEXELFUxibZtmlsiWYa04ArX7Bp
         lp+Dtk4KOj8SMtS114AM94kpYaaJ6rD3CoD8YAdNRASkUmfXneFJmB5sLRlBysAZ8Ac2
         4daGWY4A54FU0CWuRVRGoaSAUPKVHqQnKzVSqUEy3kklbK839ZH2GgbD/eoc0bD/iDs5
         o1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+AY9trJkRf9cxwS80EFbb5/8Q9oqK1NT5wAK/bAfyuA=;
        b=kCEJ5Ompo5d22dCbsGGTyHfmTUmNnwNM6wFMJ9N79nmbPK7OjxxgW5szyozkkqPz6P
         s+ihEtZ9Z3K2L6A7fDnARp0xhw42gvo+HWozP1wj49/EB0tQ18teavMDHqISrQcQUskS
         xKT2sIt4yDU3LA/DgrruvDN30ztaEN+fn7sgmepBnZ2+GyXRJyBJRoGjMtSe17zzRR1a
         RYAKHUFwUXsIHLneGmbciJUhcw5skGGlDYS/fbBDOEzJ2pkoIwieZQ7+QeQjUnqG+iJ2
         Xhs8MqtY81jNY0S3gZ8XokVehKdSnZeCmZy42t7jLNYhjhksY3CnfUBdmrWmBmomVYp1
         ca7g==
X-Gm-Message-State: AOAM5310MHcemKmlsCFgr2/MMWxk+gd0OyPn7D0o/Lm4xwVo2AzzRVlc
        27Vgei5ToabqPvo4u4eMVQwuiTsChjaehN7UPEFWuw==
X-Google-Smtp-Source: ABdhPJxCyzHAm5pT+CZ4HMd6KgPW+J/acp0DUaYmvYc1AvRHOWzot9DSea2SXFKuHuYOpuRzWYMWE0gc2tQT+lJIsCA=
X-Received: by 2002:a2e:9746:: with SMTP id f6mr1273915ljj.270.1606921267017;
 Wed, 02 Dec 2020 07:01:07 -0800 (PST)
MIME-Version: 1.0
References: <20201201212553.52164-1-shy828301@gmail.com>
In-Reply-To: <20201201212553.52164-1-shy828301@gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 2 Dec 2020 07:00:55 -0800
Message-ID: <CALvZod7wPdiS5Gyqa9d-CeAYhZ1nS=0+ANu4-CZxzOje-VJHHw@mail.gmail.com>
Subject: Re: [v3 PATCH] mm: list_lru: set shrinker map bit when child nr_items
 is not zero
To:     Yang Shi <shy828301@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>, Kirill Tkhai <ktkhai@virtuozzo.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 1, 2020 at 1:25 PM Yang Shi <shy828301@gmail.com> wrote:
>
> When investigating a slab cache bloat problem, significant amount of
> negative dentry cache was seen, but confusingly they neither got shrunk
> by reclaimer (the host has very tight memory) nor be shrunk by dropping
> cache.  The vmcore shows there are over 14M negative dentry objects on lru,
> but tracing result shows they were even not scanned at all.  The further
> investigation shows the memcg's vfs shrinker_map bit is not set.  So the
> reclaimer or dropping cache just skip calling vfs shrinker.  So we have
> to reboot the hosts to get the memory back.
>
> I didn't manage to come up with a reproducer in test environment, and the
> problem can't be reproduced after rebooting.  But it seems there is race
> between shrinker map bit clear and reparenting by code inspection.  The
> hypothesis is elaborated as below.
>
> The memcg hierarchy on our production environment looks like:
>                 root
>                /    \
>           system   user
>
> The main workloads are running under user slice's children, and it creates
> and removes memcg frequently.  So reparenting happens very often under user
> slice, but no task is under user slice directly.
>
> So with the frequent reparenting and tight memory pressure, the below
> hypothetical race condition may happen:
>
>        CPU A                            CPU B
> reparent
>     dst->nr_items == 0
>                                  shrinker:
>                                      total_objects == 0
>     add src->nr_items to dst
>     set_bit
>                                      retrun SHRINK_EMPTY

return

>                                      clear_bit
> child memcg offline
>     replace child's kmemcg_id to

with

>     parent's (in memcg_offline_kmem())
>                                   list_lru_del() between shrinker runs
>                                      see parent's kmemcg_id
>                                      dec dst->nr_items
> reparent again
>     dst->nr_items may go negative
>     due to concurrent list_lru_del()
>
>                                  The second run of shrinker:
>                                      read nr_items without any
>                                      synchronization, so it may
>                                      see intermediate negative
>                                      nr_items then total_objects
>                                      may return 0 conincidently

coincidently

>
>                                      keep the bit cleared
>     dst->nr_items != 0
>     skip set_bit
>     add scr->nr_item to dst
>
> After this point dst->nr_item may never go zero, so reparenting will not
> set shrinker_map bit anymore.  And since there is no task under user
> slice directly, so no new object will be added to its lru to set the
> shrinker map bit either.  That bit is kept cleared forever.
>
> How does list_lru_del() race with reparenting?  It is because
> reparenting replaces childen's kmemcg_id to parent's without protecting

children's

> from nlru->lock, so list_lru_del() may see parent's kmemcg_id but
> actually deleting items from child's lru, but dec'ing parent's nr_items,
> so the parent's nr_items may go negative as commit
> 2788cf0c401c268b4819c5407493a8769b7007aa ("memcg: reparent list_lrus and
> free kmemcg_id on css offline") says.
>
> Since it is impossible that dst->nr_items goes negative and
> src->nr_items goes zero at the same time, so it seems we could set the
> shrinker map bit iff src->nr_items != 0.  We could synchronize
> list_lru_count_one() and reparenting with nlru->lock, but it seems
> checking src->nr_items in reparenting is the simplest and avoids lock
> contention.
>
> Fixes: fae91d6d8be5 ("mm/list_lru.c: set bit in memcg shrinker bitmap on first list_lru item appearance")
> Suggested-by: Roman Gushchin <guro@fb.com>
> Reviewed-by: Roman Gushchin <guro@fb.com>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: <stable@vger.kernel.org> v4.19+
> Signed-off-by: Yang Shi <shy828301@gmail.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
