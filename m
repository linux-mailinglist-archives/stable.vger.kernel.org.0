Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E11D67C3CB
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 05:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjAZEQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 23:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjAZEQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 23:16:30 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E4659767;
        Wed, 25 Jan 2023 20:16:29 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id z31so410778pfw.4;
        Wed, 25 Jan 2023 20:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=07QdDjlFnnB4dSf8b57rQCr3F+vMDNJ5JQASGfmsw8g=;
        b=q5EFW+tkPHgJ8BKeZkiI7dd1VHI4tuRSK0dNkbAs5uFbJeBHOASqyOpRT9cpU+qbas
         sfUDDqpi1/bBxrhXA1xj8dOiyuHi2rwSRGbAmnuEx3k41mVgEO9EqqwTpLwvP5Oj5YKK
         9X/BFsG6JjIjxBgH2fiuF/Ycv5bTRPSeE9+GWtixNSN6ynqorbO/sCwFqrFeOaR80aFX
         bfRW1v579JzT4Zxf2GxqFevlDjiYaV61CuKA+Vv620C84e9/UqRPcpXwtSlLeu/9AHjr
         VLQUEkt6Ui9Qmp7Zl6AoR3MUThI2eHnloaZCmuMTjd5CAYXZr90XuN9hLBXSGOtyiU54
         L2DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=07QdDjlFnnB4dSf8b57rQCr3F+vMDNJ5JQASGfmsw8g=;
        b=f+QFCjis93OEG4Cjrw5GFUtP+zePt7VJWiCIbANIYSAxmPSLt/sMyALDcopViKrsoG
         gsfpjcvIN2yvat200KlldBpbNY+dEFw7mx0UL4V/0bSH8snK88bqGg59RcoplHtorJ7Y
         yAFqrqlB3TIzTvHK4spQiSgztshrSu+WJBRd3Fxyl/jbiTGFK+3TgrPahJ8aFq9Rc24f
         7B6XP/jWtPhJR0EAlCmhYIinxgG1rAtYytm3azmBdXZw91gOls5RooDyhBfpG2PEMwPF
         12ClaORCCfOofWzLZGvVpgsV36VHaKkZ144xjLPy1rOYPsZbLDY/4fpRsP5LjmmsjvCw
         Ho1Q==
X-Gm-Message-State: AFqh2kqQUrTHesdPlbktUixPWhUQWvJEYNzLUJVZtvGn78kIyNiGAGVq
        Pb2qIR6vQiFx+htIHQa1FQVtzpKQWB7jjhCxpo8=
X-Google-Smtp-Source: AMrXdXvsZQkvJqlBdXneG/UaTcvq8rFhl2G64Hq+ejSQeSOSIJohzNv0UHJwwev7zo3bk8Kd5VFBQcWhv7gHLHbkTL8=
X-Received: by 2002:a63:2f06:0:b0:478:e97b:7a1 with SMTP id
 v6-20020a632f06000000b00478e97b07a1mr3644965pgv.113.1674706588504; Wed, 25
 Jan 2023 20:16:28 -0800 (PST)
MIME-Version: 1.0
References: <20230124173126.3492345-1-joel@joelfernandes.org>
 <20230124225628.GZ2948950@paulmck-ThinkPad-P17-Gen-1> <CAABZP2wa_ZTHUr9tH_6OSpr+TgNACo4kMu3eawsGV5qkCDoAKg@mail.gmail.com>
In-Reply-To: <CAABZP2wa_ZTHUr9tH_6OSpr+TgNACo4kMu3eawsGV5qkCDoAKg@mail.gmail.com>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Thu, 26 Jan 2023 12:16:17 +0800
Message-ID: <CAABZP2wk-RiAV4CzG+6cn7=twvgtw-YGt5bLB4qw8gOWU01kkw@mail.gmail.com>
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

On Wed, Jan 25, 2023 at 8:13 AM Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
>
> On Wed, Jan 25, 2023 at 6:56 AM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Tue, Jan 24, 2023 at 05:31:26PM +0000, Joel Fernandes (Google) wrote:
> > > For CONFIG_NO_HZ_FULL systems, the tick_do_timer_cpu cannot be offlined.
> > > However, cpu_is_hotpluggable() still returns true for those CPUs. This causes
> > > torture tests that do offlining to end up trying to offline this CPU causing
> > > test failures. Such failure happens on all architectures.
> > >
> > > Fix it by asking the opinion of the nohz subsystem on whether the CPU can
> > > be hotplugged.
> > >
> > > [ Apply Frederic Weisbecker feedback on refactoring tick_nohz_cpu_down(). ]
> > >
> > > For drivers/base/ portion:
> > > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >
> > > Cc: Frederic Weisbecker <frederic@kernel.org>
> > > Cc: "Paul E. McKenney" <paulmck@kernel.org>
> > > Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > > Cc: Will Deacon <will@kernel.org>
> > > Cc: Marc Zyngier <maz@kernel.org>
> > > Cc: rcu <rcu@vger.kernel.org>
> > > Cc: stable@vger.kernel.org
> > > Fixes: 2987557f52b9 ("driver-core/cpu: Expose hotpluggability to the rest of the kernel")
> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> >
> > Queued for further review and testing, thank you both!
> >
> > It might be a few hours until it becomes publicly visible, but it will
> > get there.
> A new round of rcutorture test on fixed linux-5.15.y[3] has been
> performed in the PPC VM of Open Source Lab of Oregon State University
> [1], which will last about 29 hours. The test result on original
> linux-5.15.y is at [2].
From the result of [1], the HOTPLUG failure reports have been
eliminated, but a new kernel null point bug related to scsi module has
been reported [4] ;-(
[    5.178733][    C1] BUG: Kernel NULL pointer dereference on read at
0x00000008
...
[    5.231013][    C1] [c00000001ff9fca0] [c0000000009ffbc8]
scsi_end_request+0xd8/0x1f0 (unreliable)^M
[    5.234961][    C1] [c00000001ff9fcf0] [c000000000a00e68]
scsi_io_completion+0x88/0x700^M
[    5.237863][    C1] [c00000001ff9fda0] [c0000000009f5028]
scsi_finish_command+0xe8/0x150^M
[    5.240089][    C1] [c00000001ff9fdf0] [c000000000a00c70]
scsi_complete+0x90/0x140^M
[    5.242481][    C1] [c00000001ff9fe20] [c0000000007e5170]
blk_complete_reqs+0x80/0xa0^M
[    5.245187][    C1] [c00000001ff9fe50] [c000000000f0b5d0]
__do_softirq+0x1e0/0x4e0^M
[    5.248479][    C1] [c00000001ff9ff90] [c0000000000170e8]
do_softirq_own_stack+0x48/0x60^M
[    5.250919][    C1] [c00000000a5e7c40] [c00000000a5e7c80]
0xc00000000a5e7c80^M
[    5.253792][    C1] [c00000000a5e7c70] [c0000000001534c0]
do_softirq+0xb0/0xc0^M
[    5.256824][    C1] [c00000000a5e7ca0] [c0000000001535ac]
__local_bh_enable_ip+0xdc/0x110^M
[    5.259414][    C1] [c00000000a5e7cc0] [c0000000001d75e8]
irq_forced_thread_fn+0xc8/0xf0^M
[    5.261921][    C1] [c00000000a5e7d00] [c0000000001d7ae4]
irq_thread+0x1b4/0x2a0^M
[    5.265298][    C1] [c00000000a5e7da0] [c00000000017d8c8]
kthread+0x1a8/0x1d0^M
[    5.269184][    C1] [c00000000a5e7e10] [c00000000000cee4]
ret_from_kernel_thread+0x5c/0x64^M

But when I invoked [5]  by hand, the bug did not show again [6].

[4] http://140.211.169.189/linux-stable-rc/tools/testing/selftests/rcutorture/res/2023.01.25-00.04.30-torture/results-clocksourcewd-2/TREE03/console.log
[5] http://140.211.169.189/linux-stable-rc/tools/testing/selftests/rcutorture/res/2023.01.25-00.04.30-torture/results-clocksourcewd-2/TREE03/qemu-cmd
[6] http://140.211.169.189/linux-stable-rc/tools/testing/selftests/rcutorture/res/2023.01.25-00.04.30-torture/results-clocksourcewd-2/TREE03/console.zzy.log

I think the bug is not caused by Joel's patch, there must be some
other reason. I am starting the 29 hours' rcutorture test again. And I
can give ssh access to you if you are interested in it.

Sorry for the inconvenience that I bring

Thanks
Zhouyi
>
> [1] http://140.211.169.189/linux-stable-rc/tools/testing/selftests/rcutorture/res/2023.01.25-00.04.30-torture/
> [2] http://140.211.169.189/linux-stable-rc/tools/testing/selftests/rcutorture/res/2023.01.18-13.22.39-torture/
> [3] http://140.211.169.189/linux-stable-rc/
>
> Happy to benefit the community and this is a fruitful learning journey ;-)
>
> Cheers
> Zhouyi
> >
> >                                                         Thanx, Paul
> >
> > > ---
> > > Sorry, resending with CC to stable.
> > >
> > >  drivers/base/cpu.c       |  3 ++-
> > >  include/linux/tick.h     |  2 ++
> > >  kernel/time/tick-sched.c | 11 ++++++++---
> > >  3 files changed, 12 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> > > index 55405ebf23ab..450dca235a2f 100644
> > > --- a/drivers/base/cpu.c
> > > +++ b/drivers/base/cpu.c
> > > @@ -487,7 +487,8 @@ static const struct attribute_group *cpu_root_attr_groups[] = {
> > >  bool cpu_is_hotpluggable(unsigned int cpu)
> > >  {
> > >       struct device *dev = get_cpu_device(cpu);
> > > -     return dev && container_of(dev, struct cpu, dev)->hotpluggable;
> > > +     return dev && container_of(dev, struct cpu, dev)->hotpluggable
> > > +             && tick_nohz_cpu_hotpluggable(cpu);
> > >  }
> > >  EXPORT_SYMBOL_GPL(cpu_is_hotpluggable);
> > >
> > > diff --git a/include/linux/tick.h b/include/linux/tick.h
> > > index bfd571f18cfd..9459fef5b857 100644
> > > --- a/include/linux/tick.h
> > > +++ b/include/linux/tick.h
> > > @@ -216,6 +216,7 @@ extern void tick_nohz_dep_set_signal(struct task_struct *tsk,
> > >                                    enum tick_dep_bits bit);
> > >  extern void tick_nohz_dep_clear_signal(struct signal_struct *signal,
> > >                                      enum tick_dep_bits bit);
> > > +extern bool tick_nohz_cpu_hotpluggable(unsigned int cpu);
> > >
> > >  /*
> > >   * The below are tick_nohz_[set,clear]_dep() wrappers that optimize off-cases
> > > @@ -280,6 +281,7 @@ static inline void tick_nohz_full_add_cpus_to(struct cpumask *mask) { }
> > >
> > >  static inline void tick_nohz_dep_set_cpu(int cpu, enum tick_dep_bits bit) { }
> > >  static inline void tick_nohz_dep_clear_cpu(int cpu, enum tick_dep_bits bit) { }
> > > +static inline bool tick_nohz_cpu_hotpluggable(unsigned int cpu) { return true; }
> > >
> > >  static inline void tick_dep_set(enum tick_dep_bits bit) { }
> > >  static inline void tick_dep_clear(enum tick_dep_bits bit) { }
> > > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > > index 9c6f661fb436..63e3e8ebcd64 100644
> > > --- a/kernel/time/tick-sched.c
> > > +++ b/kernel/time/tick-sched.c
> > > @@ -510,7 +510,7 @@ void __init tick_nohz_full_setup(cpumask_var_t cpumask)
> > >       tick_nohz_full_running = true;
> > >  }
> > >
> > > -static int tick_nohz_cpu_down(unsigned int cpu)
> > > +bool tick_nohz_cpu_hotpluggable(unsigned int cpu)
> > >  {
> > >       /*
> > >        * The tick_do_timer_cpu CPU handles housekeeping duty (unbound
> > > @@ -518,8 +518,13 @@ static int tick_nohz_cpu_down(unsigned int cpu)
> > >        * CPUs. It must remain online when nohz full is enabled.
> > >        */
> > >       if (tick_nohz_full_running && tick_do_timer_cpu == cpu)
> > > -             return -EBUSY;
> > > -     return 0;
> > > +             return false;
> > > +     return true;
> > > +}
> > > +
> > > +static int tick_nohz_cpu_down(unsigned int cpu)
> > > +{
> > > +     return tick_nohz_cpu_hotpluggable(cpu) ? 0 : -EBUSY;
> > >  }
> > >
> > >  void __init tick_nohz_init(void)
> > > --
> > > 2.39.1.405.gd4c25cc71f-goog
> > >
