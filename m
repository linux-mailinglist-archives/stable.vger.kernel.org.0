Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC762CAD14
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 21:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgLAUNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 15:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbgLAUND (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 15:13:03 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64717C0613CF;
        Tue,  1 Dec 2020 12:12:23 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id y22so5306774edv.1;
        Tue, 01 Dec 2020 12:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IdV9WVEGceglx0cHy6mJTuBEPbUl8WbSuNfkxhy/hFI=;
        b=ZApU1Pr1AK5m//dB82jNhtcePYVRdsMambAex44ZT//E3HokkRxe0KnZMzVqrYLXy4
         094p3ntx6uM2pZ7jQmpO/ghxk/vJdryp8ubgahnvJDCQD72yWSr8MhQnEcPRqMUGO7Ts
         3NddvLIGhVCdQfmVEfjk1ohJr7sl1Qp4OpvGYBH02nZbqIH3lKs8QxfIORTQvoWfIyjn
         oyuoniM63fRz2tmiUksrrIL3lTw9ccGn8Xm0hbb1EWZKU/enHzJ42raBb9fv5H/6p0q/
         /fFO+IZoNi1+OU7TAUxJ8e740BDo8C4ayZQRfX/jB05SzUbg6MSpxhuWU9lM8vRIhF9v
         s0HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IdV9WVEGceglx0cHy6mJTuBEPbUl8WbSuNfkxhy/hFI=;
        b=s4nvrT6aA44CD0KB0/y6kiWGM+FsbfAy1e5vgXj0dqdAShRKT97XCNtLy0Gmfr7k77
         213QE9oxVVyd+enWwAF3ETD6ejtOc446xUyq1eQTeA+diF+Lbd5172hiKroV+TeL32W8
         DaRWn5DtuR32B7CUUzcpRKaFemEQwabRDRmIgOGloreW/wLnHByIVPWw1i04viXWrvDn
         KZnEgWhTsksPioWd2ymCH9FR4+g/nalM3oS402Zg74hwLjBbuKxHowzSZ2wKoicDjF6G
         MVBAchjFJdGolR2Guo05oloLyCQT20/jAgn7qofl/cHvwXHJ7RtpDyWtGwg9a9rZOk0r
         pKzw==
X-Gm-Message-State: AOAM532Dw/pMJgiFGp6M02309eSaod9+uCl9ny7HQF+FwnT+KkAEC1sn
        2ulDrskO8smQCFkbJajwwGDEoVO0324KQy1WS2k=
X-Google-Smtp-Source: ABdhPJyATAeb+MblLObtQdU7abWws/96CS4xUE/lb4MGbR6iWKI5njKri/U4o1oQW8hb3nqLLscPzOQ+uNPdzurJ3XY=
X-Received: by 2002:a05:6402:746:: with SMTP id p6mr4859514edy.313.1606853542105;
 Tue, 01 Dec 2020 12:12:22 -0800 (PST)
MIME-Version: 1.0
References: <20201201174449.51435-1-shy828301@gmail.com> <20201201195232.GC1375014@carbon.DHCP.thefacebook.com>
In-Reply-To: <20201201195232.GC1375014@carbon.DHCP.thefacebook.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Tue, 1 Dec 2020 12:12:07 -0800
Message-ID: <CAHbLzkpn6vdRKPP-b0NwPQFDQNeDrtUyD3N65QBVLsYetaJSkg@mail.gmail.com>
Subject: Re: [v2 PATCH] mm: list_lru: set shrinker map bit when child nr_items
 is not zero
To:     Roman Gushchin <guro@fb.com>
Cc:     Kirill Tkhai <ktkhai@virtuozzo.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 1, 2020 at 11:52 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Tue, Dec 01, 2020 at 09:44:49AM -0800, Yang Shi wrote:
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
> >     CPU A                            CPU B                         CPU C
> > reparent
> >     dst->nr_items == 0
> >                                  shrinker:
> >                                      total_objects == 0
> >     add src->nr_items to dst
> >     set_bit
> >                                      retrun SHRINK_EMPTY
> >                                      clear_bit
> > child memcg offline
> >     replace child's kmemcg_id to
> >     parent's (in memcg_offline_kmem())
> >                                                                  list_lru_del()
> >                                                                      see parent's kmemcg_id
> >                                                                      dec dst->nr_items
> > reparent again
> >     dst->nr_items may go negative
> >     due to concurrent list_lru_del()
> >     on CPU C
> >                                  The second run of shrinker:
> >                                      read nr_items without any
> >                                      synchronization, so it may
> >                                      see intermediate negative
> >                                      nr_items then total_objects
> >                                      may return 0 conincidently
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
> > from nlru->lock, so list_lru_del() may see parent's kmemcg_id but
> > actually deleting items from child's lru, but dec'ing parent's nr_items,
> > so the parent's nr_items may go negative as commit
> > 2788cf0c401c268b4819c5407493a8769b7007aa ("memcg: reparent list_lrus and
> > free kmemcg_id on css offline") says.
> >
> > Can we move kmemcg_id replacement after reparenting?  No, because the
> > race with list_lru_del() may result in negative src->nr_items, but it
> > will never be fixed.  So the shrinker may never return SHRINK_EMPTY then
> > keep the shrinker map bit set always.  The shrinker will be always
> > called for nonsense.
> >
> > Can we synchronize list_lru_del() and reparenting?  Yes, it could be
> > done.  But it seems we need introduce a new lock or use nlru->lock.  But
> > it sounds complicated to move kmemcg_id replacement code under nlru->lock.
> > And list_lru_del() may be called quite often to exacerbate some hot
> > path, i.e. dentry kill.
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
> > Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> > Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
> > Cc: Shakeel Butt <shakeelb@google.com>
> > Cc: <stable@vger.kernel.org> v4.19+
> > Signed-off-by: Yang Shi <shy828301@gmail.com>
>
> Hi Yang!
>
> Code-wise it looks good to me. Thank you for updating!
>
> I think the commit log can be simplified a bit: you don't really need 3 CPUs
> to reproduce the problem. Also, IMO the section about fixing the problem by
> introducing an additional synchronization can be dropped, but it's up to you.

Yes, don't have to have 3 CPUs. Will simplify the commit log.

>
> With the updated commit log, please feel to add
> Reviewed-by: Roman Gushchin <guro@fb.com> .

Thanks!

>
> Thank you!
