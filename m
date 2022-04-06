Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF9B4F5A0D
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 11:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbiDFJcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 05:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378966AbiDFJZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 05:25:50 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AF319EC67;
        Tue,  5 Apr 2022 23:14:30 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id p15so2070458ejc.7;
        Tue, 05 Apr 2022 23:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7EvvUNMzgAfvEmMUQKambJpGqvicJJUkQLHevLIHTJk=;
        b=c6d8Lkxxivu4q89L05kwnDQrSZNd+hFodTSh13Ih0L9wdNXt0QS6fqhZ30iW0NBskC
         sni6+ARnb3R8ZXkwl/Hy32inUJpWfwyzBLC7xo0/31ZOjQQTBVtNackrqMT8RXzxqSS1
         38CqFXMICw220xf0w9EO8QlZZzIfa8evzvBTws9vzFQjJBpqbYgDWA74cusCGLWO1xBR
         Z04Q7U/epkbls0WvlRJpG8VGnABHB42xjUsTzmfA+3pNsse1RH6N2vzfZ1ZrOLDqlZSW
         Vo/tu9eau0gG60irJRoiJTnwljWLhlKksITYJirJ5xZNqxS+5RtJ+EpCE48Wg7UieZTn
         Y1hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7EvvUNMzgAfvEmMUQKambJpGqvicJJUkQLHevLIHTJk=;
        b=eEqp3vEl8/xWGWElUI6b1Hd6B4s3aO7MKvILpUF0UJgqco2IYwuYU14/dMFQOWAf5Y
         p8JLlCiRpa4c3svQoWDpEkod+pqKy7UGlC1BMbIUHeYonuIvSRx2ngwANNKCBjWd9zPy
         MKzQIrr+CMu2yO+6egjo7IeaF9TTJSBUli9OXvMvDT2Lh0RxN0LE5NGSeK7NrdhR+cnl
         zKu0FDR8zNFAC/upWQppG2G/4pXvymR2tOglaadIYF4da3tKN9cIJ7q42xZSI1JP8Dw8
         psO/3LbR+5sm6bbzw1HsXmFa0uQawqSXm9EukiJ6KsdoUlr5wD22HE8wbAPj5lv0ICLz
         axEQ==
X-Gm-Message-State: AOAM533v2y+VphInvaGpzDP5H9Bx/UU5hMYxPWTbOSOsvgQHDbkYHr2z
        noauihCvfMJszKJAvmUL32yeOHizxbSJRSS76tU=
X-Google-Smtp-Source: ABdhPJyb1R2Z99hpIGJs2DcD9j+UJNBvyIxd1CsajGItG6smf1PaRCIFkI6k9ohyrH/LIEa/6OjEgFCrH0+CCnUwtZg=
X-Received: by 2002:a17:907:2cc5:b0:6e6:594f:faff with SMTP id
 hg5-20020a1709072cc500b006e6594ffaffmr6588800ejc.702.1649225668670; Tue, 05
 Apr 2022 23:14:28 -0700 (PDT)
MIME-Version: 1.0
References: <3d58dc946a4fa1cc696d05baad1cf05ae686a86d.1649115057.git.darren@os.amperecomputing.com>
 <YkupgBs1ybDmofrY@fedora> <CAGsJ_4yUJXvLsGAmZ6fpHmccMLanFVVSiod_Agr+Uqzcu83h1g@mail.gmail.com>
 <YkxYOxXDfJIDtcte@fedora>
In-Reply-To: <YkxYOxXDfJIDtcte@fedora>
From:   Barry Song <21cnbao@gmail.com>
Date:   Wed, 6 Apr 2022 18:14:16 +1200
Message-ID: <CAGsJ_4xgY27vZvBt8k4DaR0uJe8tRLgL=+M4-njrCM-KCuqscw@mail.gmail.com>
Subject: Re: [PATCH v4] topology: make core_mask include at least cluster_siblings
To:     Darren Hart <darren@os.amperecomputing.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        Carl Worth <carl@os.amperecomputing.com>,
        stable@vger.kernel.org, Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 6, 2022 at 2:55 AM Darren Hart
<darren@os.amperecomputing.com> wrote:
>
> On Tue, Apr 05, 2022 at 06:38:01PM +1200, Barry Song wrote:
> > On Tue, Apr 5, 2022 at 3:46 PM Darren Hart
> > <darren@os.amperecomputing.com> wrote:
> > >
> > > On Mon, Apr 04, 2022 at 04:40:37PM -0700, Darren Hart wrote:
> > > > Ampere Altra defines CPU clusters in the ACPI PPTT. They share a Sn=
oop
> > > > Control Unit, but have no shared CPU-side last level cache.
> > > >
> > > > cpu_coregroup_mask() will return a cpumask with weight 1, while
> > > > cpu_clustergroup_mask() will return a cpumask with weight 2.
> > > >
> > > > As a result, build_sched_domain() will BUG() once per CPU with:
> > > >
> > > > BUG: arch topology borken
> > > > the CLS domain not a subset of the MC domain
> > > >
> > > > The MC level cpumask is then extended to that of the CLS child, and=
 is
> > > > later removed entirely as redundant. This sched domain topology is =
an
> > > > improvement over previous topologies, or those built without
> > > > SCHED_CLUSTER, particularly for certain latency sensitive workloads=
.
> > > > With the current scheduler model and heuristics, this is a desirabl=
e
> > > > default topology for Ampere Altra and Altra Max system.
> > > >
> > > > Rather than create a custom sched domains topology structure and
> > > > introduce new logic in arch/arm64 to detect these systems, update t=
he
> > > > core_mask so coregroup is never a subset of clustergroup, extending=
 it
> > > > to cluster_siblings if necessary. Only do this if CONFIG_SCHED_CLUS=
TER
> > > > is enabled to avoid also changing the topology (MC) when
> > > > CONFIG_SCHED_CLUSTER is disabled.
> > > >
> > > > This has the added benefit over a custom topology of working for bo=
th
> > > > symmetric and asymmetric topologies. It does not address systems wh=
ere
> > > > the CLUSTER topology is above a populated MC topology, but these ar=
e not
> > > > considered today and can be addressed separately if and when they
> > > > appear.
> > > >
> > > > The final sched domain topology for a 2 socket Ampere Altra system =
is
> > > > unchanged with or without CONFIG_SCHED_CLUSTER, and the BUG is avoi=
ded:
> > > >
> > > > For CPU0:
> > > >
> > > > CONFIG_SCHED_CLUSTER=3Dy
> > > > CLS  [0-1]
> > > > DIE  [0-79]
> > > > NUMA [0-159]
> > > >
> > > > CONFIG_SCHED_CLUSTER is not set
> > > > DIE  [0-79]
> > > > NUMA [0-159]
> > > >
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Cc: Sudeep Holla <sudeep.holla@arm.com>
> > > > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > Cc: Will Deacon <will@kernel.org>
> > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > > > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > > > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > > > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > > > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > > > Cc: Carl Worth <carl@os.amperecomputing.com>
> > > > Cc: <stable@vger.kernel.org> # 5.16.x
> > > > Suggested-by: Barry Song <song.bao.hua@hisilicon.com>
> > > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > > > ---
> > > > v1: Drop MC level if coregroup weight =3D=3D 1
> > > > v2: New sd topo in arch/arm64/kernel/smp.c
> > > > v3: No new topo, extend core_mask to cluster_siblings
> > > > v4: Rebase on 5.18-rc1 for GregKH to pull. Add IS_ENABLED(CONFIG_SC=
HED_CLUSTER).
> > >
> > > A bit more context on the state of review:
> > >
> > > Several folks reviewed, but I didn't add their Reviewed-by since I ad=
ded the
> > > IS_ENABLED(CONFIG_SCHED_CLUSTER) test since they reviewed it last. Th=
is change
> > > preserves the stated intent of the change when CONFIG_SCHED_CLUSTER i=
s disabled.
> >
> > Everything still works even without IS_ENABLED(CONFIG_SCHED_CLUSTER), r=
ight?
> > Anyway, putting IS_ENABLED(CONFIG_SCHED_CLUSTER) seems to be right as
> > well.
>
> Hi Barry,
>
> Without the additional IS_ENABLED check, if CONFIG_SCHED_CLUSTER is disab=
led
> then rather than a topology of:
>
> DIE  [0-79]
> NUMA [0-159]
>
> We end up expanding the MC span and get:
>
> MC   [0-1]
> DIE  [0-79]
> NUMA [0-159]
>
> This isn't "bad", but it wasn't the stated intent, and I prefer users can=
 choose
> between the two by using the CONFIG_SCHED_CLUSTER option.
>
> > But it seems it is still a good choice to put all these reviewed-by
> > and acked-by you got in
> > v3? I don't  think the added IS_ENABLED will change their decisions.
>
> I think Sudeep is the only one that wrote the actual tag, and in my exper=
ience
> those tags should be explicitly volunteered rather than assumed, especial=
ly if a
> change is made, especially for Reviewed-by. [1] reinforces this with "Hen=
ce
> patch mergers will sometimes manually convert an acker=E2=80=99s =E2=80=
=9Cyep, looks good to me=E2=80=9D
> into an Acked-by: (but note that it is usually better to ask for an expli=
cit
> ack)."
>
> Greg, since I'm asking you to pull this - please let me know if I'm being=
 overly
> cautious with tags here.
>
> >
> > >
> > > Barry Song - Suggested this approach
>
> Can we add your Reviewed-by here Barry?

Yes, please.

I think you should add

Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
according to:
https://lore.kernel.org/lkml/e91bcc83-37c8-dcca-e088-8b3fcd737b2c@arm.com/

Acked-by: Sudeep Holla <sudeep.holla@arm.com>
according to:
https://lore.kernel.org/lkml/YiczzB92EcShyvLh@bogus/

>
> Thanks,
>
> Darren
>
> 1. https://www.kernel.org/doc/html/latest/process/submitting-patches.html=
#when-to-use-acked-by-cc-and-co-developed-by
>
> > > Vincent Guittot - informal review with reservations
> > > Sudeep Holla - Acked-by
> > > Dietmar Eggemann - informal review (added to Cc, apologies for the om=
ission Dietmar)
> > >
> > > All but Barry's recommendation captured in the v3 thread:
> > > https://lore.kernel.org/linux-arm-kernel/f1deaeabfd31fdf512ff6502f381=
86ef842c2b1f.1646413117.git.darren@os.amperecomputing.com/
> > >
> > > Thanks,
> > >
> > > >
> > > >  drivers/base/arch_topology.c | 9 +++++++++
> > > >  1 file changed, 9 insertions(+)
> > > >
> > > > diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topol=
ogy.c
> > > > index 1d6636ebaac5..5497c5ab7318 100644
> > > > --- a/drivers/base/arch_topology.c
> > > > +++ b/drivers/base/arch_topology.c
> > > > @@ -667,6 +667,15 @@ const struct cpumask *cpu_coregroup_mask(int c=
pu)
> > > >                       core_mask =3D &cpu_topology[cpu].llc_sibling;
> > > >       }
> > > >
> > > > +     /*
> > > > +      * For systems with no shared cpu-side LLC but with clusters =
defined,
> > > > +      * extend core_mask to cluster_siblings. The sched domain bui=
lder will
> > > > +      * then remove MC as redundant with CLS if SCHED_CLUSTER is e=
nabled.
> > > > +      */
> > > > +     if (IS_ENABLED(CONFIG_SCHED_CLUSTER) &&
> > > > +         cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibl=
ing))
> > > > +             core_mask =3D &cpu_topology[cpu].cluster_sibling;
> > > > +
> > > >       return core_mask;
> > > >  }
> > > >
> > > --
> > > Darren Hart
> > > Ampere Computing / OS and Kernel
> >

Thanks
Barry
