Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D5667A75D
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 01:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbjAYANY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 19:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjAYANY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 19:13:24 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BE5222F6;
        Tue, 24 Jan 2023 16:13:23 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d3so16367058plr.10;
        Tue, 24 Jan 2023 16:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSTatNvoL1PWK2UjEFKVB0HKYuuuNR78nTovJPiL0Pg=;
        b=kKj9gBT2PSv2fk/73U9FkkXvnfDrdDSFF2IsX9DaPcrxKerNLt7asIyeOgBglc759L
         lMTZVD17iUBMLVcbwT2feEWEmYvWUWSSALV2U+W0Z+GfB8yVBh1eSHFixkUvUoCUkrcT
         RJJhUjjUydWhoOcSZ5a8k+j4QJFAoQPgXainEQp/N71CxFt6ODZmROdyI4tLi0rHCGot
         kA94AzqqoHT42PnVmzdiOvBXZdmIl19PsbbcpCDIi5WZ2jSTW6yEirbsRG9WVnRKlY8c
         9/XYrFiH9uRc+1mAeleIZQ3m5X+asJtzDC+f5MPX4aTtFU/QNWc5lfogv7ZiG4c3EYKV
         cvGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZSTatNvoL1PWK2UjEFKVB0HKYuuuNR78nTovJPiL0Pg=;
        b=uo79s0gYe5WtLx7KzjPBhAtQqt7JLkPfPsdA/9TA5+iNLRVOrVD1jN9jpEhTWLWMaV
         yrU0xoezvI68cZMfgE5FiU9ZqYYFkxZz3Yh0JZmc6X4udAJHMf+/yGAYewdFCt8mDDJg
         /t2odaI+ODDfg7uX6m0GKmGL/M8Aoo1x5N3QxVTIQ3sf/qeeGIJipMJ1Mp9l6HcRerc8
         FIsj/c/1Q28WH5f6zB06pZZjaTRDmFNA3JICAfaoTV5dGXt3hZZGNHpnynhcGTVBosvL
         5AuZAoIBsw4arJ4igkORFBeQVjnc5iWFFfyfE1pOTEYBdYfOxLfKRwahcWY1mbW095Mp
         4OKA==
X-Gm-Message-State: AFqh2kp43ylu/yGg9y8UmADfPR/6oqavXOThR2NxekJfgDM1rpvSP3oC
        QoPxTmpPSJGb3gOOQUtzkQUCiRPNo8Yu9LQbd9s=
X-Google-Smtp-Source: AMrXdXttD0f0+DsZF8XWwSt6dGI/hhBcN0r6VpUyie6YYssmGiV70CSWgCxLwmclcMjhErDDJDfmCCDCVaOnOiAKyB8=
X-Received: by 2002:a17:90a:b791:b0:226:2a7c:9ba9 with SMTP id
 m17-20020a17090ab79100b002262a7c9ba9mr2995547pjr.128.1674605602473; Tue, 24
 Jan 2023 16:13:22 -0800 (PST)
MIME-Version: 1.0
References: <20230124173126.3492345-1-joel@joelfernandes.org> <20230124225628.GZ2948950@paulmck-ThinkPad-P17-Gen-1>
In-Reply-To: <20230124225628.GZ2948950@paulmck-ThinkPad-P17-Gen-1>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Wed, 25 Jan 2023 08:13:11 +0800
Message-ID: <CAABZP2wa_ZTHUr9tH_6OSpr+TgNACo4kMu3eawsGV5qkCDoAKg@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND] tick/nohz: Fix cpu_is_hotpluggable() by
 checking with nohz subsystem
To:     paulmck@kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        rcu <rcu@vger.kernel.org>, stable@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NORMAL_HTTP_TO_IP,
        NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 25, 2023 at 6:56 AM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Tue, Jan 24, 2023 at 05:31:26PM +0000, Joel Fernandes (Google) wrote:
> > For CONFIG_NO_HZ_FULL systems, the tick_do_timer_cpu cannot be offlined.
> > However, cpu_is_hotpluggable() still returns true for those CPUs. This causes
> > torture tests that do offlining to end up trying to offline this CPU causing
> > test failures. Such failure happens on all architectures.
> >
> > Fix it by asking the opinion of the nohz subsystem on whether the CPU can
> > be hotplugged.
> >
> > [ Apply Frederic Weisbecker feedback on refactoring tick_nohz_cpu_down(). ]
> >
> > For drivers/base/ portion:
> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > Cc: Frederic Weisbecker <frederic@kernel.org>
> > Cc: "Paul E. McKenney" <paulmck@kernel.org>
> > Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: rcu <rcu@vger.kernel.org>
> > Cc: stable@vger.kernel.org
> > Fixes: 2987557f52b9 ("driver-core/cpu: Expose hotpluggability to the rest of the kernel")
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
>
> Queued for further review and testing, thank you both!
>
> It might be a few hours until it becomes publicly visible, but it will
> get there.
A new round of rcutorture test on fixed linux-5.15.y[3] has been
performed in the PPC VM of Open Source Lab of Oregon State University
[1], which will last about 29 hours. The test result on original
linux-5.15.y is at [2].

[1] http://140.211.169.189/linux-stable-rc/tools/testing/selftests/rcutorture/res/2023.01.25-00.04.30-torture/
[2] http://140.211.169.189/linux-stable-rc/tools/testing/selftests/rcutorture/res/2023.01.18-13.22.39-torture/
[3] http://140.211.169.189/linux-stable-rc/

Happy to benefit the community and this is a fruitful learning journey ;-)

Cheers
Zhouyi
>
>                                                         Thanx, Paul
>
> > ---
> > Sorry, resending with CC to stable.
> >
> >  drivers/base/cpu.c       |  3 ++-
> >  include/linux/tick.h     |  2 ++
> >  kernel/time/tick-sched.c | 11 ++++++++---
> >  3 files changed, 12 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> > index 55405ebf23ab..450dca235a2f 100644
> > --- a/drivers/base/cpu.c
> > +++ b/drivers/base/cpu.c
> > @@ -487,7 +487,8 @@ static const struct attribute_group *cpu_root_attr_groups[] = {
> >  bool cpu_is_hotpluggable(unsigned int cpu)
> >  {
> >       struct device *dev = get_cpu_device(cpu);
> > -     return dev && container_of(dev, struct cpu, dev)->hotpluggable;
> > +     return dev && container_of(dev, struct cpu, dev)->hotpluggable
> > +             && tick_nohz_cpu_hotpluggable(cpu);
> >  }
> >  EXPORT_SYMBOL_GPL(cpu_is_hotpluggable);
> >
> > diff --git a/include/linux/tick.h b/include/linux/tick.h
> > index bfd571f18cfd..9459fef5b857 100644
> > --- a/include/linux/tick.h
> > +++ b/include/linux/tick.h
> > @@ -216,6 +216,7 @@ extern void tick_nohz_dep_set_signal(struct task_struct *tsk,
> >                                    enum tick_dep_bits bit);
> >  extern void tick_nohz_dep_clear_signal(struct signal_struct *signal,
> >                                      enum tick_dep_bits bit);
> > +extern bool tick_nohz_cpu_hotpluggable(unsigned int cpu);
> >
> >  /*
> >   * The below are tick_nohz_[set,clear]_dep() wrappers that optimize off-cases
> > @@ -280,6 +281,7 @@ static inline void tick_nohz_full_add_cpus_to(struct cpumask *mask) { }
> >
> >  static inline void tick_nohz_dep_set_cpu(int cpu, enum tick_dep_bits bit) { }
> >  static inline void tick_nohz_dep_clear_cpu(int cpu, enum tick_dep_bits bit) { }
> > +static inline bool tick_nohz_cpu_hotpluggable(unsigned int cpu) { return true; }
> >
> >  static inline void tick_dep_set(enum tick_dep_bits bit) { }
> >  static inline void tick_dep_clear(enum tick_dep_bits bit) { }
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > index 9c6f661fb436..63e3e8ebcd64 100644
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -510,7 +510,7 @@ void __init tick_nohz_full_setup(cpumask_var_t cpumask)
> >       tick_nohz_full_running = true;
> >  }
> >
> > -static int tick_nohz_cpu_down(unsigned int cpu)
> > +bool tick_nohz_cpu_hotpluggable(unsigned int cpu)
> >  {
> >       /*
> >        * The tick_do_timer_cpu CPU handles housekeeping duty (unbound
> > @@ -518,8 +518,13 @@ static int tick_nohz_cpu_down(unsigned int cpu)
> >        * CPUs. It must remain online when nohz full is enabled.
> >        */
> >       if (tick_nohz_full_running && tick_do_timer_cpu == cpu)
> > -             return -EBUSY;
> > -     return 0;
> > +             return false;
> > +     return true;
> > +}
> > +
> > +static int tick_nohz_cpu_down(unsigned int cpu)
> > +{
> > +     return tick_nohz_cpu_hotpluggable(cpu) ? 0 : -EBUSY;
> >  }
> >
> >  void __init tick_nohz_init(void)
> > --
> > 2.39.1.405.gd4c25cc71f-goog
> >
