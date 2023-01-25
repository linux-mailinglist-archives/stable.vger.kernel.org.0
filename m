Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA30867AA9D
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 07:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbjAYG6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 01:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbjAYG6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 01:58:03 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFF4474DE
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 22:58:01 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id j9so15263591qtv.4
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 22:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cVAxh96Vqp2uiaD+qWz4OLfZOr/aM8a4vWmNsO8A4pc=;
        b=b0fZhs0CJgDv5mGGfm+Wy63LB8ohhfz6vt/azAnN2EAkjr6CvX607+xTTvBSLb2MeR
         rHCBoEbSNHdLF/cidE2XfN7CBTiZ1SmTCu4qk95cWG93OdmIOQL0VLvMqFDDIKqKJxDw
         L7sEW/R23lby9xtfKi+vXrWr9zGan7rgkIsj8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cVAxh96Vqp2uiaD+qWz4OLfZOr/aM8a4vWmNsO8A4pc=;
        b=MGzR9qkTI/sRw1+hb/5nr/ruNcVbB4zd2EDeTK7fwYFjYhI+FWX15VFSUFsDhyZOki
         bIAeEw5dKxHmnWFThMQBsTR+/Kn30XumQYKPlK5Hdc6WQs1K479D0s5x1enK/WJ3cJhS
         bTW9B0fq2AHNqLbJchmx0sh7jd3W3cooh3v0KG7WKshm8xouat4s56R670hKb/uJskZi
         LwHnb71nHYYdykGWsGM636afwTa1UjklfLYr7VDFTdAoqnVtUVT9IWS/RVdG6DoliIe4
         GVt2ESHKKXH9lXjgTKyLegdnCCRz9tM6IKxiXx9PxMXSZCjzFLWYpGJzfUxkqpb2teu3
         lTwQ==
X-Gm-Message-State: AFqh2kovhm8d+PMXYgqJB78DSgrWKFDNf5MIyYQP++Hc31jv6fRqOYhr
        9WOrdTZV83XFQCOI9F20jOxscrsU9mt4clOl
X-Google-Smtp-Source: AMrXdXsrFXlLYbRuEaSGZSyAWmARN6JsUs7dgbaLhQXC27+S1g8DgIF2Lae4OvlLn7TD3ME1qc4NeA==
X-Received: by 2002:ac8:4e0d:0:b0:3b6:3b9e:f0fd with SMTP id c13-20020ac84e0d000000b003b63b9ef0fdmr43032366qtw.26.1674629880532;
        Tue, 24 Jan 2023 22:58:00 -0800 (PST)
Received: from smtpclient.apple (c-98-249-43-138.hsd1.va.comcast.net. [98.249.43.138])
        by smtp.gmail.com with ESMTPSA id o17-20020ac841d1000000b003a5c6ad428asm2721408qtm.92.2023.01.24.22.57.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 22:57:59 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Joel Fernandes <joel@joelfernandes.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 RESEND] tick/nohz: Fix cpu_is_hotpluggable() by checking with nohz subsystem
Date:   Wed, 25 Jan 2023 01:57:49 -0500
Message-Id: <1F1F75F7-DAB2-4DCC-B366-E1AC45606816@joelfernandes.org>
References: <CAABZP2wa_ZTHUr9tH_6OSpr+TgNACo4kMu3eawsGV5qkCDoAKg@mail.gmail.com>
Cc:     paulmck@kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        rcu <rcu@vger.kernel.org>, stable@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <CAABZP2wa_ZTHUr9tH_6OSpr+TgNACo4kMu3eawsGV5qkCDoAKg@mail.gmail.com>
To:     Zhouyi Zhou <zhouzhouyi@gmail.com>
X-Mailer: iPhone Mail (20B101)
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NORMAL_HTTP_TO_IP,
        NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jan 24, 2023, at 7:13 PM, Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
>=20
> =EF=BB=BFOn Wed, Jan 25, 2023 at 6:56 AM Paul E. McKenney <paulmck@kernel.=
org> wrote:
>>=20
>>> On Tue, Jan 24, 2023 at 05:31:26PM +0000, Joel Fernandes (Google) wrote:=

>>> For CONFIG_NO_HZ_FULL systems, the tick_do_timer_cpu cannot be offlined.=

>>> However, cpu_is_hotpluggable() still returns true for those CPUs. This c=
auses
>>> torture tests that do offlining to end up trying to offline this CPU cau=
sing
>>> test failures. Such failure happens on all architectures.
>>>=20
>>> Fix it by asking the opinion of the nohz subsystem on whether the CPU ca=
n
>>> be hotplugged.
>>>=20
>>> [ Apply Frederic Weisbecker feedback on refactoring tick_nohz_cpu_down()=
. ]
>>>=20
>>> For drivers/base/ portion:
>>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>=20
>>> Cc: Frederic Weisbecker <frederic@kernel.org>
>>> Cc: "Paul E. McKenney" <paulmck@kernel.org>
>>> Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
>>> Cc: Will Deacon <will@kernel.org>
>>> Cc: Marc Zyngier <maz@kernel.org>
>>> Cc: rcu <rcu@vger.kernel.org>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 2987557f52b9 ("driver-core/cpu: Expose hotpluggability to the res=
t of the kernel")
>>> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
>>=20
>> Queued for further review and testing, thank you both!
>>=20
>> It might be a few hours until it becomes publicly visible, but it will
>> get there.
> A new round of rcutorture test on fixed linux-5.15.y[3] has been
> performed in the PPC VM of Open Source Lab of Oregon State University
> [1], which will last about 29 hours. The test result on original
> linux-5.15.y is at [2].
>=20
> [1] http://140.211.169.189/linux-stable-rc/tools/testing/selftests/rcutort=
ure/res/2023.01.25-00.04.30-torture/
> [2] http://140.211.169.189/linux-stable-rc/tools/testing/selftests/rcutort=
ure/res/2023.01.18-13.22.39-torture/
> [3] http://140.211.169.189/linux-stable-rc/
>=20
> Happy to benefit the community and this is a fruitful learning journey ;-)=


Thanks a lot Zhouyi! After testing something your reply can also optionally i=
nclude:

Tested-by: Zhouyi Zhou <zhouzhoui@gmail.com>

Thanks.

Have fun at the university. I miss my university days.

 - Joel


>=20
> Cheers
> Zhouyi
>>=20
>>                                                        Thanx, Paul
>>=20
>>> ---
>>> Sorry, resending with CC to stable.
>>>=20
>>> drivers/base/cpu.c       |  3 ++-
>>> include/linux/tick.h     |  2 ++
>>> kernel/time/tick-sched.c | 11 ++++++++---
>>> 3 files changed, 12 insertions(+), 4 deletions(-)
>>>=20
>>> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
>>> index 55405ebf23ab..450dca235a2f 100644
>>> --- a/drivers/base/cpu.c
>>> +++ b/drivers/base/cpu.c
>>> @@ -487,7 +487,8 @@ static const struct attribute_group *cpu_root_attr_g=
roups[] =3D {
>>> bool cpu_is_hotpluggable(unsigned int cpu)
>>> {
>>>      struct device *dev =3D get_cpu_device(cpu);
>>> -     return dev && container_of(dev, struct cpu, dev)->hotpluggable;
>>> +     return dev && container_of(dev, struct cpu, dev)->hotpluggable
>>> +             && tick_nohz_cpu_hotpluggable(cpu);
>>> }
>>> EXPORT_SYMBOL_GPL(cpu_is_hotpluggable);
>>>=20
>>> diff --git a/include/linux/tick.h b/include/linux/tick.h
>>> index bfd571f18cfd..9459fef5b857 100644
>>> --- a/include/linux/tick.h
>>> +++ b/include/linux/tick.h
>>> @@ -216,6 +216,7 @@ extern void tick_nohz_dep_set_signal(struct task_str=
uct *tsk,
>>>                                   enum tick_dep_bits bit);
>>> extern void tick_nohz_dep_clear_signal(struct signal_struct *signal,
>>>                                     enum tick_dep_bits bit);
>>> +extern bool tick_nohz_cpu_hotpluggable(unsigned int cpu);
>>>=20
>>> /*
>>>  * The below are tick_nohz_[set,clear]_dep() wrappers that optimize off-=
cases
>>> @@ -280,6 +281,7 @@ static inline void tick_nohz_full_add_cpus_to(struct=
 cpumask *mask) { }
>>>=20
>>> static inline void tick_nohz_dep_set_cpu(int cpu, enum tick_dep_bits bit=
) { }
>>> static inline void tick_nohz_dep_clear_cpu(int cpu, enum tick_dep_bits b=
it) { }
>>> +static inline bool tick_nohz_cpu_hotpluggable(unsigned int cpu) { retur=
n true; }
>>>=20
>>> static inline void tick_dep_set(enum tick_dep_bits bit) { }
>>> static inline void tick_dep_clear(enum tick_dep_bits bit) { }
>>> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
>>> index 9c6f661fb436..63e3e8ebcd64 100644
>>> --- a/kernel/time/tick-sched.c
>>> +++ b/kernel/time/tick-sched.c
>>> @@ -510,7 +510,7 @@ void __init tick_nohz_full_setup(cpumask_var_t cpuma=
sk)
>>>      tick_nohz_full_running =3D true;
>>> }
>>>=20
>>> -static int tick_nohz_cpu_down(unsigned int cpu)
>>> +bool tick_nohz_cpu_hotpluggable(unsigned int cpu)
>>> {
>>>      /*
>>>       * The tick_do_timer_cpu CPU handles housekeeping duty (unbound
>>> @@ -518,8 +518,13 @@ static int tick_nohz_cpu_down(unsigned int cpu)
>>>       * CPUs. It must remain online when nohz full is enabled.
>>>       */
>>>      if (tick_nohz_full_running && tick_do_timer_cpu =3D=3D cpu)
>>> -             return -EBUSY;
>>> -     return 0;
>>> +             return false;
>>> +     return true;
>>> +}
>>> +
>>> +static int tick_nohz_cpu_down(unsigned int cpu)
>>> +{
>>> +     return tick_nohz_cpu_hotpluggable(cpu) ? 0 : -EBUSY;
>>> }
>>>=20
>>> void __init tick_nohz_init(void)
>>> --
>>> 2.39.1.405.gd4c25cc71f-goog
>>>=20
