Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52013F2567
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 03:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfKGC20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 21:28:26 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33866 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbfKGC2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 21:28:25 -0500
Received: by mail-ot1-f67.google.com with SMTP id t4so696657otr.1
        for <stable@vger.kernel.org>; Wed, 06 Nov 2019 18:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wS6OdC+S2z/PBQgR4YDbDDYhyL0XvvxGi7c5qPyDE0Y=;
        b=uSDVaazM9cyqGwRXCwrtjFi/nHUtZ2J26+AP1pK5t+J0d+/Tj7/Z1yUPw5jdywtHtw
         9HQP5ZcwqS0nMABJOIGE5EnPGMvomAgZELvKeJYd8O3dlqz9ZYsSGyWRiBuBUoSeBl6U
         vCRHFFi3U5GslJ40zsWHEcZlIrh6664iU/1LGaiAmEtJtacFVvswhNjlN0e3klHMBTdv
         YXlYs16vjS6IC9YLlku6Q2dYcySVxTO6pVtV7DLXuTbP5LimO/KlLarf7UmNGnKq8Hln
         uz0tuIjijpI1f8Z2Ul6YaCIva9zraCKef9iJ0Egiw+E6ilQSWVpHbCqAfn2vS/AAeTAj
         MeCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wS6OdC+S2z/PBQgR4YDbDDYhyL0XvvxGi7c5qPyDE0Y=;
        b=HzL3Ydp9e9nq7b3DvFhQOK/Bx4eo5PeSaqUyMwkTKSF9szUmdmcAb8u+GXMbHbzaeF
         RymdqhcnZBcm+vn046yJnXqMTfznZK1uqvQ1MA4+3WKP6q2Eqf6XOzJrBCuY4peEWZLX
         LBZ9oQMR7CWLp0oYIWP6jsbaz876UA0XfyIJ5DgijYV/n3IygrwfYU6VgEVjMzbewBUb
         2cRAQg5MJ8iNMnI5o+cEjxY3aQXZ6+6jR7yxu3XKz73zhzf2nvXcy5xRC2pXUHhPLEW4
         9pLhnA2ueZawXhRIKdmUmXI1XuNlfzRunZeeq98r/TL6xjrl92H4L3fy6SbU8XaeXrr6
         6f6Q==
X-Gm-Message-State: APjAAAUDMmlmfNbQ/38Y3qb0JGEeB57XmDV/iCvKojXyPkOYXoYawyOB
        DBDQbIxNoeVZzmv3UvrtC0JA+MocgcjFl139rOHctQ==
X-Google-Smtp-Source: APXvYqxM3DVIoAFqmXRE/YkhMyMJgK2jWrlkdOL0UapC3KZIYGFGZxk0cHboKIbfF893h/cqlowss7WaPRbfFTJZrKk=
X-Received: by 2002:a9d:5e10:: with SMTP id d16mr812912oti.191.1573093704582;
 Wed, 06 Nov 2019 18:28:24 -0800 (PST)
MIME-Version: 1.0
References: <20191106225131.3543616-1-guro@fb.com> <20191107002204.GA96548@cmpxchg.org>
 <CALvZod5=g230Lwnjh7qXyLkoknZJpOiv-nLJ4XYC9rSSzL=e6w@mail.gmail.com>
 <20191107014307.GA1158@castle.dhcp.thefacebook.com> <CALvZod43v4Xx6YzhN8ku3=YrPVGJoK-8mUejg1f29a1jxL1-ug@mail.gmail.com>
In-Reply-To: <CALvZod43v4Xx6YzhN8ku3=YrPVGJoK-8mUejg1f29a1jxL1-ug@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 6 Nov 2019 18:28:13 -0800
Message-ID: <CALvZod7ucfCd+TodJVt2oJEKaWg827h9VCEDBJw4+iwnC1BnAw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()
To:     Roman Gushchin <guro@fb.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 6, 2019 at 6:21 PM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Wed, Nov 6, 2019 at 5:43 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Wed, Nov 06, 2019 at 05:25:26PM -0800, Shakeel Butt wrote:
> > > On Wed, Nov 6, 2019 at 4:22 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > >
> > > > On Wed, Nov 06, 2019 at 02:51:30PM -0800, Roman Gushchin wrote:
> > > > > We've encountered a rcu stall in get_mem_cgroup_from_mm():
> > > > >
> > > > >  rcu: INFO: rcu_sched self-detected stall on CPU
> > > > >  rcu: 33-....: (21000 ticks this GP) idle=6c6/1/0x4000000000000002 softirq=35441/35441 fqs=5017
> > > > >  (t=21031 jiffies g=324821 q=95837) NMI backtrace for cpu 33
> > > > >  <...>
> > > > >  RIP: 0010:get_mem_cgroup_from_mm+0x2f/0x90
> > > > >  <...>
> > > > >  __memcg_kmem_charge+0x55/0x140
> > > > >  __alloc_pages_nodemask+0x267/0x320
> > > > >  pipe_write+0x1ad/0x400
> > > > >  new_sync_write+0x127/0x1c0
> > > > >  __kernel_write+0x4f/0xf0
> > > > >  dump_emit+0x91/0xc0
> > > > >  writenote+0xa0/0xc0
> > > > >  elf_core_dump+0x11af/0x1430
> > > > >  do_coredump+0xc65/0xee0
> > > > >  ? unix_stream_sendmsg+0x37d/0x3b0
> > > > >  get_signal+0x132/0x7c0
> > > > >  do_signal+0x36/0x640
> > > > >  ? recalc_sigpending+0x17/0x50
> > > > >  exit_to_usermode_loop+0x61/0xd0
> > > > >  do_syscall_64+0xd4/0x100
> > > > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > >
> > > > > The problem is caused by an exiting task which is associated with
> > > > > an offline memcg. We're iterating over and over in the
> > > > > do {} while (!css_tryget_online()) loop, but obviously the memcg won't
> > > > > become online and the exiting task won't be migrated to a live memcg.
> > > > >
> > > > > Let's fix it by switching from css_tryget_online() to css_tryget().
> > > > >
> > > > > As css_tryget_online() cannot guarantee that the memcg won't go
> > > > > offline, the check is usually useless, except some rare cases
> > > > > when for example it determines if something should be presented
> > > > > to a user.
> > > > >
> > > > > A similar problem is described by commit 18fa84a2db0e ("cgroup: Use
> > > > > css_tryget() instead of css_tryget_online() in task_get_css()").
> > > > >
> > > > > Signed-off-by: Roman Gushchin <guro@fb.com>

Forgot to add:

Reviewed-by: Shakeel Butt <shakeeb@google.com>

> > > > > Cc: stable@vger.kernel.org
> > > > > Cc: Tejun Heo <tj@kernel.org>
> > > >
> > > > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > > >
> > > > The bug aside, it doesn't matter whether the cgroup is online for the
> > > > callers. It used to matter when offlining needed to evacuate all
> > > > charges from the memcg, and so needed to prevent new ones from showing
> > > > up, but we don't care now.
> > >
> > > Should get_mem_cgroup_from_current() and get_mem_cgroup_from_page() be
> > > switched to css_tryget() as well then?
> >
> > In those case it can't cause a rcu stall, so it's not a so urgent.
> > But you are right, we should probably do the same here. I'll look
> > at all remaining callers and prepare the patchset.
> >
> > I'll also probably rename it to css_tryget_if_online() to make obvious
> > that it doesn't hold the cgroup from being onlined.
> >
>
> SGTM
