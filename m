Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0413CD641E
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 15:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbfJNN3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 09:29:51 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42861 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729752AbfJNN3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 09:29:51 -0400
Received: by mail-lf1-f66.google.com with SMTP id c195so11810629lfg.9
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 06:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vx0bTQblXCEkZh40hFYicIOm471j1IuoGfojlu4EM7I=;
        b=x97gQJhCNW7POvJoNfOTmKXpi+DYAEhqFNuSfdmKCk5s3gPNAHgPlTaIsMeEHi+Ex6
         0wpqP43Z40KA2/ePbqep58ZiZx16uQInAMgkjXxZ5eXOc5HLftj78V4nxaaNZ2EBp0N8
         CCzgzzOFt30IZwQDFCH8h5mmVy3NFxwi8JhUtt+K6YVW9qafasD+Y3r4jA9huZ99xezY
         phoslUrhuN4tIonhWw6MH/0GFAtSU7DgAmcuEgD1cVU1t61J34b+q1w89bjOx1QaC0SD
         LwOWVB5/ycOZF5BrlrvimMloRLy4wpOYBUfqAN6RvS4S0aD7JNwbLU/bjKXs0d2fCFKn
         Xczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vx0bTQblXCEkZh40hFYicIOm471j1IuoGfojlu4EM7I=;
        b=Hx2beapMIbQAYc4n0Vt49JRbjSabTwSUs9gPQywcFMgIN5w8cYd1vewXUSjHbJZpyb
         Dxh8YhmlyXZ9XEikUG9eGlujZbLn3EOZBnmuGqL3plCLxWTJqzdwNlkQ08ss8tm4Famj
         qhI/qyRof5R095/XntepCrUD8UhegjijCSNUUDWcesEBlyS6VsZl0YbDYKALuIcqPrzt
         zUOUTEW1mtgnAXu/85lNDjtuiMegJZyL1SujY218Z7qXodAtvxJSuKurxreGlLSacIH8
         gEns8Iv0VRgA3yJYj/dcJsMQSXmTtIJcvs52NvpFF+1gCb8WckmPwCI8pwwHrZd6tEyZ
         N+9A==
X-Gm-Message-State: APjAAAXXwycXBh9iC9d7QeIhgAsZvrzVzMF6UxslKnKm/KOGX3+gcAWK
        Kw8l86DSEH5SGDQtR2rE6rvR1M8TUCYVYPZuVzWR/A==
X-Google-Smtp-Source: APXvYqw0N6ijWxFVf5Lhgio1Ri3sVsPFQzPFiGqd7Gl4mwg58QXvvFjfJjrzPrMDPmAwpGE5EZjoaiYB+xaVCsZNMF4=
X-Received: by 2002:ac2:4d1b:: with SMTP id r27mr17103620lfi.133.1571059789198;
 Mon, 14 Oct 2019 06:29:49 -0700 (PDT)
MIME-Version: 1.0
References: <20191014114710.22142-1-valentin.schneider@arm.com> <20191014121648.GA53234@google.com>
In-Reply-To: <20191014121648.GA53234@google.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Mon, 14 Oct 2019 15:29:37 +0200
Message-ID: <CAKfTPtDoBrE=npY_Ay1pucdXsW1yQr1UiaCGq1DXKa2VmNqcUg@mail.gmail.com>
Subject: Re: [PATCH] sched/topology: Disable sched_asym_cpucapacity on domain destruction
To:     Quentin Perret <qperret@google.com>
Cc:     Valentin Schneider <valentin.schneider@arm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Quentin Perret <qperret@qperret.net>,
        "# v4 . 16+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Oct 2019 at 14:16, Quentin Perret <qperret@google.com> wrote:
>
> Hi Valentin,
>
> On Monday 14 Oct 2019 at 12:47:10 (+0100), Valentin Schneider wrote:
> > While the static key is correctly initialized as being disabled, it will
> > remain forever enabled once turned on. This means that if we start with an
> > asymmetric system and hotplug out enough CPUs to end up with an SMP system,
> > the static key will remain set - which is obviously wrong. We should detect
> > this and turn off things like misfit migration and EAS wakeups.
>
> FWIW we already clear the EAS static key properly (based on the sd
> pointer, not the static key), so this is really only for the
> capacity-aware stuff.
>
> > Having that key enabled should also mandate
> >
> >   per_cpu(sd_asym_cpucapacity, cpu) != NULL
> >
> > for all CPUs, but this is obviously not true with the above.
> >
> > On top of that, sched domain rebuilds first lead to attaching the NULL
> > domain to the affected CPUs, which means there will be a window where the
> > static key is set but the sd_asym_cpucapacity shortcut points to NULL even
> > if asymmetry hasn't been hotplugged out.
> >
> > Disable the static key when destroying domains, and let
> > build_sched_domains() (re) enable it as needed.
> >
> > Cc: <stable@vger.kernel.org>
> > Fixes: df054e8445a4 ("sched/topology: Add static_key for asymmetric CPU capacity optimizations")
> > Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
> > ---
> >  kernel/sched/topology.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> > index b5667a273bf6..c49ae57a0611 100644
> > --- a/kernel/sched/topology.c
> > +++ b/kernel/sched/topology.c
> > @@ -2123,7 +2123,8 @@ static void detach_destroy_domains(const struct cpumask *cpu_map)
> >  {
> >       int i;
> >
> > +     static_branch_disable_cpuslocked(&sched_asym_cpucapacity);
> > +
> >       rcu_read_lock();
> >       for_each_cpu(i, cpu_map)
> >               cpu_attach_domain(NULL, &def_root_domain, i);
>
> So what happens it you have mutiple root domains ? You might skip
> build_sched_domains() for one of them and end up not setting the static
> key when you should no ?

good point

>
> I suppose an alternative would be to play with static_branch_inc() /
> static_branch_dec() from build_sched_domains() or something along those
> lines.
>
> Thanks,
> Quentin
