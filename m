Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1348B4793D6
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 19:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240418AbhLQSSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 13:18:17 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:34620 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240353AbhLQSSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 13:18:03 -0500
Date:   Fri, 17 Dec 2021 19:17:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639765080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TEEVSBa0yD1srn+NNPYTHxKzTyYk8uwfEdFuhOjc8e4=;
        b=spwuhbSBY5IJN67K5ahsw6f6aLyJj42W1lE+mgFtyyZ9GZXURuCPc2qOPlqM5Gw1LwTN2f
        pIDEH1P7+/oszl7gIS8FmbRuQSI7hsXkt5KBxP2YvTWV5IUan6TFb5ePk4MoFrwJHYb5uj
        BTgh/Q241L0wiKSi48bxTuzaZtkedV9LCzacp/Nq2tapyovDC4qERw4Wk7Lo74+NqzxH2a
        8lTDDNAO9r/wjG6PJ3U/eGmEvfzxJM9vJh/qyf6OINyCCeN5p5IPpZpPfi6eO87QG/M/On
        2ZH+s4WYo0KvDCCcHm2h3HiwuOP2nDecF7yXAoR7jrFKHILGGJCsXCNNKFbrlA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639765080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TEEVSBa0yD1srn+NNPYTHxKzTyYk8uwfEdFuhOjc8e4=;
        b=AJA7kqcx+8rZc6KmMwUnEpshc6md6AuKgFO8q1JBvtwNUT8kYtM6UoAWzJkacyM13NR3x3
        BALmx7/njbDaakCg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Song Liu <song@kernel.org>
Cc:     Yajun Deng <yajun.deng@linux.dev>, masahiroy@kernel.org,
        williams@redhat.com, Paul Menzel <pmenzel@molgen.mpg.de>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3] lib/raid6: Reduce high latency by using migrate
 instead of preempt
Message-ID: <YbzUVgPH9KDAMpA1@linutronix.de>
References: <20211217021610.12801-1-yajun.deng@linux.dev>
 <YbyTuRWkB0gYbn7x@linutronix.de>
 <CAPhsuW7GhYyfNOQg3VovU7cqC0nnRTbm1B7bFkWWa75k8YgHew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAPhsuW7GhYyfNOQg3VovU7cqC0nnRTbm1B7bFkWWa75k8YgHew@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-12-17 09:25:25 [-0800], Song Liu wrote:
> > The delay is a jiffy so it depends on CONFIG_HZ. You do benchmark for
> > the best algorithm and if you get preempted during that period then your
> > results may be wrong and you make a bad selection.
>=20
> With current code, the delay _should be_ 16 jiffies. However, the experim=
ent
> hits way longer latencies. I agree this may cause inaccurate benchmark re=
sults
> and thus suboptimal RAID algorithm.

Everything less than CONFIG_PREEMPT does not have an explicit
requirement for preemption so higher latencies are not unusual. *If*
this is a problem on <=3D PREEMPT_VOLUNTARY then a cond_resched() between
loops would be the usual thing to do. But only *if* it is a real problem
which I doubt. It is not a preemtible kernel after all=E2=80=A6

> I guess the key question is whether long latency at module loading time m=
atters.
> If that doesn't matter, we should just drop this.

Correct. And should this be problematic on PREEMPT_RT then I would
restrict CONFIG_RAID6_PQ_BENCHMARK to !PREEMPT_RT.

> Thanks,
> Song

Sebastian
