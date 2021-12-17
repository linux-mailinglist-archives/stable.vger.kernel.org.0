Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7C04792CA
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 18:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239869AbhLQRZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 12:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbhLQRZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 12:25:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7F0C061574;
        Fri, 17 Dec 2021 09:25:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCBCF6211E;
        Fri, 17 Dec 2021 17:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF70C36AEB;
        Fri, 17 Dec 2021 17:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639761937;
        bh=vE0YpjkE1tkyOeztdBZ5pI7QQw5/1v+yU3vEcY/raz8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WgedxMB0Hd1VcJeEqoXcOQ+z0ztmK2B19r+qb1IY5KTS6wZE8fXpaQHoOlg8TF6Qm
         vnFa+pXisXeIJpT5dol3i2L4dTNYEA2qmy2qONNPYeaZtCgE4c8BCf3P+UN7bI4qRR
         V0mptVH/qjz+s9u/86uSuXY66B6anGFhc8zLOFHoee4vN7YeVT7PLBoUCpXv66x9aN
         nEn0KKdxjVe83Zg4Z1NmSbfMYnKxNbTd08bHoJ8a6gdXcH5VJR+M3FeWxz1etWzo0i
         GILTtn8wGWBUeKXf3rzo7XiD4+RPpVGkpHaGd+PROdNuLGBsyog3pNjqWkX9AJ1kUL
         8pPDFAOdKZrcg==
Received: by mail-yb1-f177.google.com with SMTP id j2so8392480ybg.9;
        Fri, 17 Dec 2021 09:25:37 -0800 (PST)
X-Gm-Message-State: AOAM532zerZPYr27cHQm9f/sbsUCIl9T0UfwS9TDw4wK24TliTyEhcdq
        nzWy6z7+hDaCF4shwV+PD2dZUqQmmYljM0N4OKU=
X-Google-Smtp-Source: ABdhPJybp2+5dV6c7dNSrhhjovHGfTocr7kF6fBUspUhIiYb/qdytFJfbohRKocQoG6duQ65taSKR7vB7YnLs0iimNs=
X-Received: by 2002:a25:a283:: with SMTP id c3mr5921971ybi.219.1639761936377;
 Fri, 17 Dec 2021 09:25:36 -0800 (PST)
MIME-Version: 1.0
References: <20211217021610.12801-1-yajun.deng@linux.dev> <YbyTuRWkB0gYbn7x@linutronix.de>
In-Reply-To: <YbyTuRWkB0gYbn7x@linutronix.de>
From:   Song Liu <song@kernel.org>
Date:   Fri, 17 Dec 2021 09:25:25 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7GhYyfNOQg3VovU7cqC0nnRTbm1B7bFkWWa75k8YgHew@mail.gmail.com>
Message-ID: <CAPhsuW7GhYyfNOQg3VovU7cqC0nnRTbm1B7bFkWWa75k8YgHew@mail.gmail.com>
Subject: Re: [PATCH v3] lib/raid6: Reduce high latency by using migrate
 instead of preempt
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Yajun Deng <yajun.deng@linux.dev>, masahiroy@kernel.org,
        williams@redhat.com, Paul Menzel <pmenzel@molgen.mpg.de>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 5:42 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2021-12-17 10:16:10 [+0800], Yajun Deng wrote:
> > We found an abnormally high latency when executing modprobe raid6_pq, the
> > latency is greater than 1.2s when CONFIG_PREEMPT_VOLUNTARY=y, greater than
> > 67ms when CONFIG_PREEMPT=y, and greater than 16ms when CONFIG_PREEMPT_RT=y.
> >
> > How to reproduce:
> >  - Install cyclictest
> >      sudo apt install rt-tests
> >  - Run cyclictest example in one terminal
> >      sudo cyclictest -S -p 95 -d 0 -i 1000 -D 24h -m
> >  - Modprobe raid6_pq in another terminal
> >      sudo modprobe raid6_pq
> >
> > This is caused by ksoftirqd fail to scheduled due to disable preemption,
> > this time is too long and unreasonable.
> >
> > Reduce high latency by using migrate_disabl()/emigrate_enable() instead of
> > preempt_disable()/preempt_enable(), the latency won't greater than 100us.
> >
> > This patch beneficial for CONFIG_PREEMPT=y or CONFIG_PREEMPT_RT=y, but no
> > effect for CONFIG_PREEMPT_VOLUNTARY=y.
>
> Why does it matter? This is only during boot-up/ module loading or do I
> miss something?

Yes this only happens on boot-up and module loading.I don't know RT well
enough to tell whether latency during module loading is an issue.

> The delay is a jiffy so it depends on CONFIG_HZ. You do benchmark for
> the best algorithm and if you get preempted during that period then your
> results may be wrong and you make a bad selection.

With current code, the delay _should be_ 16 jiffies. However, the experiment
hits way longer latencies. I agree this may cause inaccurate benchmark results
and thus suboptimal RAID algorithm.

I guess the key question is whether long latency at module loading time matters.
If that doesn't matter, we should just drop this.

Thanks,
Song
