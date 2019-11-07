Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C284CF241F
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 02:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfKGBZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 20:25:40 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41898 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbfKGBZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 20:25:40 -0500
Received: by mail-oi1-f195.google.com with SMTP id e9so499927oif.8
        for <stable@vger.kernel.org>; Wed, 06 Nov 2019 17:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MGf1G/Idf98+jw/3Ou5BEwGK66KdVONOwSI1GdIY6gk=;
        b=M0ssWjRBobxfWKaBwwLCqTSQ0mWBLINVZ7SKXHwBkJpuz65tBoHNLZG1DdIpEeMsrZ
         lt+bf1gcUy8X8L+EQ/pamaZKRrbvJzyG5+w6Hf40F+cVHayFBaFbvoPdK/kxs3TiQ9Rd
         ALuFh7usFL1WUkHc9qPwfJHpVQIuM124Tq7/2PYOrfjEmgnTxWl7UVh0jbvc7W2EV3PL
         Mg8Yt0EyO4vCpfw45aQqv4J4fXyRNDu4mV0gVVfMBiPK3OBKumk8sZ/oh6C+uBoRd55K
         yOWfkpzem5vEpHy0RPtOnHVxe+YSgPuRHXEHVhGEN4cEcX/d/gPEHHDQkiSnuhZDy6Kz
         DIyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MGf1G/Idf98+jw/3Ou5BEwGK66KdVONOwSI1GdIY6gk=;
        b=D9xMrzNT1z/a2GANAQ4cZxX6iu3fa7u6JAqf5YdcXu3E2Wv/Z0gH7ZnJHgrTubYVCi
         mQttd9h6uvCy0vRO2AAqN5bZNRfOs1pesmgZUbpPbmWxHuNg+PRWZG0F402dZPSoDJI1
         p4znlL95Br8aXdkW8AFfFi3whFgMw/l7XuacuSOnc3vwinew8qwy6i+oNg5ULbV+X+/g
         ugnM3gdIf1LLoOdWBAQekbr0EJiCtEYTW0r3DAj0YcM92iRRowy0eO3m5nKV08Ot+ROr
         gOlIT9qGNlzL8SuVb1DA98ANI42m5hWjWkl2a67pKobMpAIh7pgCx3pgcwKn30IkNsTW
         sA+A==
X-Gm-Message-State: APjAAAVY4m1FYUI9BPRnL3XhBGl0JoTGutiFrUbwp4amHxGDTnhFHwmH
        mmuSCfKdY6mnpKaPhZ64uPprzVXx+6s2DU1WYcmrgA==
X-Google-Smtp-Source: APXvYqw6efiJ0PRxdXQPobN4uLlaNjVFitxn3Vfc1xdL/4tlbdvE69PO+yIpW5h94B0crbZydjt09kDflTuKR59Nq9c=
X-Received: by 2002:aca:4fce:: with SMTP id d197mr959325oib.142.1573089937164;
 Wed, 06 Nov 2019 17:25:37 -0800 (PST)
MIME-Version: 1.0
References: <20191106225131.3543616-1-guro@fb.com> <20191107002204.GA96548@cmpxchg.org>
In-Reply-To: <20191107002204.GA96548@cmpxchg.org>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 6 Nov 2019 17:25:26 -0800
Message-ID: <CALvZod5=g230Lwnjh7qXyLkoknZJpOiv-nLJ4XYC9rSSzL=e6w@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 6, 2019 at 4:22 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Wed, Nov 06, 2019 at 02:51:30PM -0800, Roman Gushchin wrote:
> > We've encountered a rcu stall in get_mem_cgroup_from_mm():
> >
> >  rcu: INFO: rcu_sched self-detected stall on CPU
> >  rcu: 33-....: (21000 ticks this GP) idle=6c6/1/0x4000000000000002 softirq=35441/35441 fqs=5017
> >  (t=21031 jiffies g=324821 q=95837) NMI backtrace for cpu 33
> >  <...>
> >  RIP: 0010:get_mem_cgroup_from_mm+0x2f/0x90
> >  <...>
> >  __memcg_kmem_charge+0x55/0x140
> >  __alloc_pages_nodemask+0x267/0x320
> >  pipe_write+0x1ad/0x400
> >  new_sync_write+0x127/0x1c0
> >  __kernel_write+0x4f/0xf0
> >  dump_emit+0x91/0xc0
> >  writenote+0xa0/0xc0
> >  elf_core_dump+0x11af/0x1430
> >  do_coredump+0xc65/0xee0
> >  ? unix_stream_sendmsg+0x37d/0x3b0
> >  get_signal+0x132/0x7c0
> >  do_signal+0x36/0x640
> >  ? recalc_sigpending+0x17/0x50
> >  exit_to_usermode_loop+0x61/0xd0
> >  do_syscall_64+0xd4/0x100
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > The problem is caused by an exiting task which is associated with
> > an offline memcg. We're iterating over and over in the
> > do {} while (!css_tryget_online()) loop, but obviously the memcg won't
> > become online and the exiting task won't be migrated to a live memcg.
> >
> > Let's fix it by switching from css_tryget_online() to css_tryget().
> >
> > As css_tryget_online() cannot guarantee that the memcg won't go
> > offline, the check is usually useless, except some rare cases
> > when for example it determines if something should be presented
> > to a user.
> >
> > A similar problem is described by commit 18fa84a2db0e ("cgroup: Use
> > css_tryget() instead of css_tryget_online() in task_get_css()").
> >
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Cc: stable@vger.kernel.org
> > Cc: Tejun Heo <tj@kernel.org>
>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>
> The bug aside, it doesn't matter whether the cgroup is online for the
> callers. It used to matter when offlining needed to evacuate all
> charges from the memcg, and so needed to prevent new ones from showing
> up, but we don't care now.

Should get_mem_cgroup_from_current() and get_mem_cgroup_from_page() be
switched to css_tryget() as well then?
