Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D565B3E0F0D
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 09:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238127AbhHEHXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 03:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhHEHXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 03:23:01 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9B2C061765;
        Thu,  5 Aug 2021 00:22:46 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id cl16-20020a17090af690b02901782c35c4ccso3554719pjb.5;
        Thu, 05 Aug 2021 00:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sdEhGwSMHSFcETnrssOjxJt7GUyt8BDJ8v9Gq3oiaCE=;
        b=SQEP547kPE+uiURQZZkZ3QNjgXCYp4ylk3sHIpYBLw77vpW8yLozRPLCBgLfTMLB+6
         bmLkUOailtcmYG4rORPtRLlZOs/xurQRKCyYWK0H5LJ3aEpVDSwink958WXiZ3bprRPd
         qQWgTfQQdcKw/ZRZ5Wit7nTIqT9NINUTxFlhphQVheddJZaNnkeYdthg48ZWYyN3ZjVD
         uamDB/wAgQnbIa3ja/qUxTM8at6HyWxwWusymuzC9nZMYiV8lzuBcTDcFxx3hPl1lUcI
         UOhALH65vslb1Jm4ghIaZOYd7LZatCUkgHYzvxI3ICVb9DHAZwnJDprvt/A+hffTaC0a
         e4bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sdEhGwSMHSFcETnrssOjxJt7GUyt8BDJ8v9Gq3oiaCE=;
        b=RiBDxPzFIF2uAOLSp5OSDeaTdkfMCrW854CCixDVntgkXaoZ2vZa3iwOPxQDC9i/r9
         G9i7D10cQoLt/JgOOMrj1BLXHVEUVaG2Q9AnCC/jYkq+phTeTNcOo/8lBikTnCUjsgRX
         /wMvPnj2YcZd18D2LN20afJEVFFF/w6AyzoQSRdwmRdWEmhzipiho6V48/smFCNuu1w3
         uyYYwjyG19OEYcXd7n5m4ExTFhKr+HvfnmNpBbIKwRdjz/BA7EzKFyMUpZ1w3Oij397y
         vAFHKcS6PILf9vDEeeDIp7B1DAcfgfUUbVwQDhHbwSo3JV+KkdWi3RXe9lfeWjNoRR2e
         emkw==
X-Gm-Message-State: AOAM533OBIGip+qQTxhMmCLBG31Qgj0WNKIwW59Yr7JI+wsrW8P2R7av
        4/K0hzH7kMTq0sCHXzspwYM=
X-Google-Smtp-Source: ABdhPJxVsxN2PL8NnSAJUndqI63UYfDViV/6Gpxcx+NSk7NU8PdrEZV1Gv10xLgC0pCZkCfD+15rOA==
X-Received: by 2002:a63:e350:: with SMTP id o16mr451560pgj.98.1628148166575;
        Thu, 05 Aug 2021 00:22:46 -0700 (PDT)
Received: from pek-khao-d2 (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id n1sm6877076pgt.63.2021.08.05.00.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 00:22:45 -0700 (PDT)
Date:   Thu, 5 Aug 2021 15:22:35 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: schedutil: Use kobject release() method to free
 sugov_tunables
Message-ID: <YQuRuwg5KZfkaAog@pek-khao-d2>
References: <20210715095337.19453-1-haokexin@gmail.com>
 <CAJZ5v0i1Rv3dJk2CJ_Kz+BCg_G0BvzsyJmZXTJHirJrmqxo-9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HO3chbKfu7S7M06Z"
Content-Disposition: inline
In-Reply-To: <CAJZ5v0i1Rv3dJk2CJ_Kz+BCg_G0BvzsyJmZXTJHirJrmqxo-9g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HO3chbKfu7S7M06Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 04, 2021 at 06:54:10PM +0200, Rafael J. Wysocki wrote:
> On Thu, Jul 15, 2021 at 11:56 AM Kevin Hao <haokexin@gmail.com> wrote:
> >
> > The struct sugov_tunables is protected by the kobject, so we can't free
> > it directly. Otherwise we would get a call trace like this:
> >   ODEBUG: free active (active state 0) object type: timer_list hint: de=
layed_work_timer_fn+0x0/0x30
> >   WARNING: CPU: 3 PID: 720 at lib/debugobjects.c:505 debug_print_object=
+0xb8/0x100
> >   Modules linked in:
> >   CPU: 3 PID: 720 Comm: a.sh Tainted: G        W         5.14.0-rc1-nex=
t-20210715-yocto-standard+ #507
> >   Hardware name: Marvell OcteonTX CN96XX board (DT)
> >   pstate: 40400009 (nZcv daif +PAN -UAO -TCO BTYPE=3D--)
> >   pc : debug_print_object+0xb8/0x100
> >   lr : debug_print_object+0xb8/0x100
> >   sp : ffff80001ecaf910
> >   x29: ffff80001ecaf910 x28: ffff00011b10b8d0 x27: ffff800011043d80
> >   x26: ffff00011a8f0000 x25: ffff800013cb3ff0 x24: 0000000000000000
> >   x23: ffff80001142aa68 x22: ffff800011043d80 x21: ffff00010de46f20
> >   x20: ffff800013c0c520 x19: ffff800011d8f5b0 x18: 0000000000000010
> >   x17: 6e6968207473696c x16: 5f72656d6974203a x15: 6570797420746365
> >   x14: 6a626f2029302065 x13: 303378302f307830 x12: 2b6e665f72656d69
> >   x11: ffff8000124b1560 x10: ffff800012331520 x9 : ffff8000100ca6b0
> >   x8 : 000000000017ffe8 x7 : c0000000fffeffff x6 : 0000000000000001
> >   x5 : ffff800011d8c000 x4 : ffff800011d8c740 x3 : 0000000000000000
> >   x2 : ffff0001108301c0 x1 : ab3c90eedf9c0f00 x0 : 0000000000000000
> >   Call trace:
> >    debug_print_object+0xb8/0x100
> >    __debug_check_no_obj_freed+0x1c0/0x230
> >    debug_check_no_obj_freed+0x20/0x88
> >    slab_free_freelist_hook+0x154/0x1c8
> >    kfree+0x114/0x5d0
> >    sugov_exit+0xbc/0xc0
> >    cpufreq_exit_governor+0x44/0x90
> >    cpufreq_set_policy+0x268/0x4a8
> >    store_scaling_governor+0xe0/0x128
> >    store+0xc0/0xf0
> >    sysfs_kf_write+0x54/0x80
> >    kernfs_fop_write_iter+0x128/0x1c0
> >    new_sync_write+0xf0/0x190
> >    vfs_write+0x2d4/0x478
> >    ksys_write+0x74/0x100
> >    __arm64_sys_write+0x24/0x30
> >    invoke_syscall.constprop.0+0x54/0xe0
> >    do_el0_svc+0x64/0x158
> >    el0_svc+0x2c/0xb0
> >    el0t_64_sync_handler+0xb0/0xb8
> >    el0t_64_sync+0x198/0x19c
> >   irq event stamp: 5518
> >   hardirqs last  enabled at (5517): [<ffff8000100cbd7c>] console_unlock=
+0x554/0x6c8
> >   hardirqs last disabled at (5518): [<ffff800010fc0638>] el1_dbg+0x28/0=
xa0
> >   softirqs last  enabled at (5504): [<ffff8000100106e0>] __do_softirq+0=
x4d0/0x6c0
> >   softirqs last disabled at (5483): [<ffff800010049548>] irq_exit+0x1b0=
/0x1b8
> >
> > So add a release() method for sugov_tunables_ktype to release the
> > sugov_tunables safely.
> >
> > Fixes: 9bdcb44e391d ("cpufreq: schedutil: New governor based on schedul=
er utilization data")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Kevin Hao <haokexin@gmail.com>
> > ---
> >  kernel/sched/cpufreq_schedutil.c | 23 ++++++++++++-----------
> >  1 file changed, 12 insertions(+), 11 deletions(-)
> >
> > diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_sc=
hedutil.c
> > index 57124614363d..ac171496da4b 100644
> > --- a/kernel/sched/cpufreq_schedutil.c
> > +++ b/kernel/sched/cpufreq_schedutil.c
> > @@ -537,9 +537,17 @@ static struct attribute *sugov_attrs[] =3D {
> >  };
> >  ATTRIBUTE_GROUPS(sugov);
> >
> > +static void sugov_tunables_free(struct kobject *kobj)
> > +{
> > +       struct gov_attr_set *attr_set =3D container_of(kobj, struct gov=
_attr_set, kobj);
> > +
> > +       kfree(to_sugov_tunables(attr_set));
> > +}
> > +
> >  static struct kobj_type sugov_tunables_ktype =3D {
> >         .default_groups =3D sugov_groups,
> >         .sysfs_ops =3D &governor_sysfs_ops,
> > +       .release =3D &sugov_tunables_free,
> >  };
> >
> >  /********************** cpufreq governor interface *******************=
**/
> > @@ -639,14 +647,6 @@ static struct sugov_tunables *sugov_tunables_alloc=
(struct sugov_policy *sg_polic
> >         return tunables;
> >  }
> >
> > -static void sugov_tunables_free(struct sugov_tunables *tunables)
>=20
> Rename this to sugov_clear_global_tunables() and make it take no argument=
s.

OK.

>=20
> > -{
> > -       if (!have_governor_per_policy())
> > -               global_tunables =3D NULL;
> > -
> > -       kfree(tunables);
>=20
> Drop just this one line from it.

OK.

>=20
> > -}
> > -
> >  static int sugov_init(struct cpufreq_policy *policy)
> >  {
> >         struct sugov_policy *sg_policy;
> > @@ -707,7 +707,8 @@ static int sugov_init(struct cpufreq_policy *policy)
> >  fail:
> >         kobject_put(&tunables->attr_set.kobj);
> >         policy->governor_data =3D NULL;
> > -       sugov_tunables_free(tunables);
>=20
> And call sugov_clear_global_tunables() instead of the above from here
> and analogously below.

Will do.

Thanks,
Kevin

>=20
> > +       if (!have_governor_per_policy())
> > +               global_tunables =3D NULL;
> >
> >  stop_kthread:
> >         sugov_kthread_stop(sg_policy);
> > @@ -733,8 +734,8 @@ static void sugov_exit(struct cpufreq_policy *polic=
y)
> >
> >         count =3D gov_attr_set_put(&tunables->attr_set, &sg_policy->tun=
ables_hook);
> >         policy->governor_data =3D NULL;
> > -       if (!count)
> > -               sugov_tunables_free(tunables);
> > +       if (!count && !have_governor_per_policy())
> > +               global_tunables =3D NULL;
> >
> >         mutex_unlock(&global_tunables_lock);
> >
> > --

--HO3chbKfu7S7M06Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAmELkboACgkQk1jtMN6u
sXFHJggAnI+KYroWOLzZiBYrUxI4xuemtwxDFy9hyH9za6gTZ5tq2RiGYiqypjWt
xqdM4Q6GH27wN2yWkYcXNH0c9wtn/RyYQk2AbVX1cUhjrBj3wXSXqUy/uUeKsohm
aIDc0Onddc/n6MMzhzsrM0RONpeWNWiNfgB31c8iRYvKf93ScFaM0r61rCUDsocv
hwyOendK1JZl0vgxyf/MEFGYx4GBDj6sq1v8v68GNC1rP2ZK/fMqQ9nA7kmMvPPm
Sqx9TIdCOkvvWx+Xwqggm8RpxwVhhrUZSTbhKiTsYnH40S1u/79Y9z/JyynJ42wR
HHIkQ6bpNULxzI8fzPp8fBrYhTjhmg==
=+sY7
-----END PGP SIGNATURE-----

--HO3chbKfu7S7M06Z--
