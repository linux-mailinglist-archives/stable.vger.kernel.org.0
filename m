Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588342CC2C9
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 17:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgLBQw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 11:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgLBQw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 11:52:58 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA59C0613CF;
        Wed,  2 Dec 2020 08:52:18 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id q16so4657498edv.10;
        Wed, 02 Dec 2020 08:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LiNmU7BMmDbZPdUfzJLb+NEIQsKFVUYnEPByABPW0ZM=;
        b=IfPgSMZfwDqavuC8jGBVPewwZ215U5oWF1yh+yB1tbL46TGnujBNcAEUZXCl8drhZm
         CI0qxg22j8qOBB77ckWzYearund6wrFkIeHS9RGJsXf33xzer+zY7Rlw8ggXwdmXI+kg
         hn/scJvsWSy3q1+VV4AXGvxrKCIIZgNQ/pDEySfQfjOP6TEi9CRBXjJjFFXvCuLT4mt1
         KeW8WWbL8rCuArtbwV/6BDvbL4lUpvjCY1aXWTp5vuv+gyN8GfbITfLt0lMS4hDkZn8k
         KnTwVWQWBInB04D2a2DSlQF2qxb0iTmmWs3sAjH7PS4mdM6eBC9VHE/mOKyoelF3Fw/w
         PQbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LiNmU7BMmDbZPdUfzJLb+NEIQsKFVUYnEPByABPW0ZM=;
        b=QPt+sbNDwdZyi0vuUF0/W5ktkGdK9/QZ8+MET7x5fwm2QYxn//jaeMBBg+JEANRjFk
         3qOvWjKD4AeL5oNFtGzbskZmNK9oA9aOgOgKMC/HF5IUX/EQ4BnuzMrb17GIUFRfIc21
         dpSRM/zrf3zgkkLwXNlBAYTGF8N7/lRavcXug+33psWNeCiJ7P0FmkwgMsUvypWxfuLU
         A8aoJE0XqHPadKfQT6S0AhoB88NuxRT9/Q5+Bumh+Uro95reBGYdcxttXyF+fUT2vGd6
         x2LjR3jZtbEtHrEao/Yctog1Xbhpvg2D6Yy4PH2i8eR+Q/VcRQpRzv2EiSTbvkg+1mLo
         FD3A==
X-Gm-Message-State: AOAM5300fUq+zP2cxWRdgukGZVgyBAUZf0PFT0n1QDRuAE8gb/50mIYA
        aUwJGU02FJ/RRinLpGpP5rxkPWHlkWMohe9LwDs=
X-Google-Smtp-Source: ABdhPJzMXyscgUl8ikyyLBp+w8GDUWOZlaeYQdw2CkdV2SoX4eAzCRdXY3pw42ByLCebhS8W8Kl/hBmLlbOBMcUN0u0=
X-Received: by 2002:a05:6402:1c8a:: with SMTP id cy10mr792361edb.151.1606927937103;
 Wed, 02 Dec 2020 08:52:17 -0800 (PST)
MIME-Version: 1.0
References: <20201201212553.52164-1-shy828301@gmail.com> <CALvZod7wPdiS5Gyqa9d-CeAYhZ1nS=0+ANu4-CZxzOje-VJHHw@mail.gmail.com>
In-Reply-To: <CALvZod7wPdiS5Gyqa9d-CeAYhZ1nS=0+ANu4-CZxzOje-VJHHw@mail.gmail.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Wed, 2 Dec 2020 08:52:05 -0800
Message-ID: <CAHbLzkoLdnexMEt0Qvs0WoXrMGeFp68G6aWbLzwgJ9Uf1n6xzg@mail.gmail.com>
Subject: Re: [v3 PATCH] mm: list_lru: set shrinker map bit when child nr_items
 is not zero
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Roman Gushchin <guro@fb.com>, Kirill Tkhai <ktkhai@virtuozzo.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 2, 2020 at 7:01 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Tue, Dec 1, 2020 at 1:25 PM Yang Shi <shy828301@gmail.com> wrote:
> >
> > When investigating a slab cache bloat problem, significant amount of
> > negative dentry cache was seen, but confusingly they neither got shrunk
> > by reclaimer (the host has very tight memory) nor be shrunk by dropping
> > cache.  The vmcore shows there are over 14M negative dentry objects on lru,
> > but tracing result shows they were even not scanned at all.  The further
> > investigation shows the memcg's vfs shrinker_map bit is not set.  So the
> > reclaimer or dropping cache just skip calling vfs shrinker.  So we have
> > to reboot the hosts to get the memory back.
> >
> > I didn't manage to come up with a reproducer in test environment, and the
> > problem can't be reproduced after rebooting.  But it seems there is race
> > between shrinker map bit clear and reparenting by code inspection.  The
> > hypothesis is elaborated as below.
> >
> > The memcg hierarchy on our production environment looks like:
> >                 root
> >                /    \
> >           system   user
> >
> > The main workloads are running under user slice's children, and it creates
> > and removes memcg frequently.  So reparenting happens very often under user
> > slice, but no task is under user slice directly.
> >
> > So with the frequent reparenting and tight memory pressure, the below
> > hypothetical race condition may happen:
> >
> >        CPU A                            CPU B
> > reparent
> >     dst->nr_items == 0
> >                                  shrinker:
> >                                      total_objects == 0
> >     add src->nr_items to dst
> >     set_bit
> >                                      retrun SHRINK_EMPTY
>
> return
>
> >                                      clear_bit
> > child memcg offline
> >     replace child's kmemcg_id to
>
> with
>
> >     parent's (in memcg_offline_kmem())
> >                                   list_lru_del() between shrinker runs
> >                                      see parent's kmemcg_id
> >                                      dec dst->nr_items
> > reparent again
> >     dst->nr_items may go negative
> >     due to concurrent list_lru_del()
> >
> >                                  The second run of shrinker:
> >                                      read nr_items without any
> >                                      synchronization, so it may
> >                                      see intermediate negative
> >                                      nr_items then total_objects
> >                                      may return 0 conincidently
>
> coincidently
>
> >
> >                                      keep the bit cleared
> >     dst->nr_items != 0
> >     skip set_bit
> >     add scr->nr_item to dst
> >
> > After this point dst->nr_item may never go zero, so reparenting will not
> > set shrinker_map bit anymore.  And since there is no task under user
> > slice directly, so no new object will be added to its lru to set the
> > shrinker map bit either.  That bit is kept cleared forever.
> >
> > How does list_lru_del() race with reparenting?  It is because
> > reparenting replaces childen's kmemcg_id to parent's without protecting
>
> children's
>
> > from nlru->lock, so list_lru_del() may see parent's kmemcg_id but
> > actually deleting items from child's lru, but dec'ing parent's nr_items,
> > so the parent's nr_items may go negative as commit
> > 2788cf0c401c268b4819c5407493a8769b7007aa ("memcg: reparent list_lrus and
> > free kmemcg_id on css offline") says.
> >
> > Since it is impossible that dst->nr_items goes negative and
> > src->nr_items goes zero at the same time, so it seems we could set the
> > shrinker map bit iff src->nr_items != 0.  We could synchronize
> > list_lru_count_one() and reparenting with nlru->lock, but it seems
> > checking src->nr_items in reparenting is the simplest and avoids lock
> > contention.
> >
> > Fixes: fae91d6d8be5 ("mm/list_lru.c: set bit in memcg shrinker bitmap on first list_lru item appearance")
> > Suggested-by: Roman Gushchin <guro@fb.com>
> > Reviewed-by: Roman Gushchin <guro@fb.com>
> > Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> > Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
> > Cc: Shakeel Butt <shakeelb@google.com>
> > Cc: <stable@vger.kernel.org> v4.19+
> > Signed-off-by: Yang Shi <shy828301@gmail.com>
>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>

Thanks for finding those spelling errors. Will fix in v4.
