Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1851F1D75AF
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 12:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgERK47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 06:56:59 -0400
Received: from mail.baikalelectronics.com ([87.245.175.226]:46332 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgERK47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 06:56:59 -0400
Received: from localhost (unknown [127.0.0.1])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id B18DC8030875;
        Mon, 18 May 2020 10:56:54 +0000 (UTC)
X-Virus-Scanned: amavisd-new at baikalelectronics.ru
Received: from mail.baikalelectronics.ru ([127.0.0.1])
        by localhost (mail.baikalelectronics.ru [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 50YAqZGe6GZM; Mon, 18 May 2020 13:56:53 +0300 (MSK)
Date:   Mon, 18 May 2020 13:56:49 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, <linux-mips@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Yue Hu <huyue2@yulong.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 20/20] cpufreq: Return zero on success in boost sw
 setting
Message-ID: <20200518105649.gcv22l253lsuje7y@mobilestation>
References: <20200306124807.3596F80307C2@mail.baikalelectronics.ru>
 <20200518102415.k4c5qglodij5ac6h@vireshk-i7>
 <20200518103102.t3a3g4uxeeuwsnix@mobilestation>
 <5284478.EF2IWm2iUs@kreacher>
 <20200518104602.mjh2p5iltf2x4wmq@mobilestation>
 <CAJZ5v0imYcL3M80S1snJAqXQ=GsqbChij-6aWx=4L02TKVvrQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAJZ5v0imYcL3M80S1snJAqXQ=GsqbChij-6aWx=4L02TKVvrQg@mail.gmail.com>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 12:51:15PM +0200, Rafael J. Wysocki wrote:
> On Mon, May 18, 2020 at 12:46 PM Serge Semin
> <Sergey.Semin@baikalelectronics.ru> wrote:
> >
> > On Mon, May 18, 2020 at 12:41:19PM +0200, Rafael J. Wysocki wrote:
> > > On Monday, May 18, 2020 12:31:02 PM CEST Serge Semin wrote:
> > > > On Mon, May 18, 2020 at 03:54:15PM +0530, Viresh Kumar wrote:
> > > > > On 18-05-20, 12:22, Rafael J. Wysocki wrote:
> > > > > > On Monday, May 18, 2020 12:11:09 PM CEST Viresh Kumar wrote:
> > > > > > > On 18-05-20, 11:53, Rafael J. Wysocki wrote:
> > > > > > > > That said if you really only want it to return 0 on success, you may as well
> > > > > > > > add a ret = 0; statement (with a comment explaining why it is needed) after
> > > > > > > > the last break in the loop.
> > > > > > >
> > > > > > > That can be done as well, but will be a bit less efficient as the loop
> > > > > > > will execute once for each policy, and so the statement will run
> > > > > > > multiple times. Though it isn't going to add any significant latency
> > > > > > > in the code.
> > > > > >
> > > > > > Right.
> > > > > >
> > > > > > However, the logic in this entire function looks somewhat less than
> > > > > > straightforward to me, because it looks like it should return an
> > > > > > error on the first policy without a frequency table (having a frequency
> > > > > > table depends on the driver and that is the same for all policies, so it
> > > > > > is pointless to iterate any further in that case).
> > > > > >
> > > > > > Also, the error should not be -EINVAL, because that means "invalid
> > > > > > argument" which would be the state value.
> > > > > >
> > > > > > So I would do something like this:
> > > > > >
> > > > > > ---
> > > > > >  drivers/cpufreq/cpufreq.c |   11 ++++++-----
> > > > > >  1 file changed, 6 insertions(+), 5 deletions(-)
> > > > > >
> > > > > > Index: linux-pm/drivers/cpufreq/cpufreq.c
> > > > > > ===================================================================
> > > > > > --- linux-pm.orig/drivers/cpufreq/cpufreq.c
> > > > > > +++ linux-pm/drivers/cpufreq/cpufreq.c
> > > > > > @@ -2535,26 +2535,27 @@ EXPORT_SYMBOL_GPL(cpufreq_update_limits)
> > > > > >  static int cpufreq_boost_set_sw(int state)
> > > > > >  {
> > > > > >         struct cpufreq_policy *policy;
> > > > > > -       int ret = -EINVAL;
> > > > > >
> > > > > >         for_each_active_policy(policy) {
> > > > > > +               int ret;
> > > > > > +
> > > > > >                 if (!policy->freq_table)
> > > > > > -                       continue;
> > > > > > +                       return -ENXIO;
> > > > > >
> > > > > >                 ret = cpufreq_frequency_table_cpuinfo(policy,
> > > > > >                                                       policy->freq_table);
> > > > > >                 if (ret) {
> > > > > >                         pr_err("%s: Policy frequency update failed\n",
> > > > > >                                __func__);
> > > > > > -                       break;
> > > > > > +                       return ret;
> > > > > >                 }
> > > > > >
> > > > > >                 ret = freq_qos_update_request(policy->max_freq_req, policy->max);
> > > > > >                 if (ret < 0)
> > > > > > -                       break;
> > > > > > +                       return ret;
> > > > > >         }
> > > > > >
> > > > > > -       return ret;
> > > > > > +       return 0;
> > > > > >  }
> > > > > >
> > > > > >  int cpufreq_boost_trigger_state(int state)
> > > > >
> > > > > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> > > >
> > > > Ok. Thanks for the comments. Shall I resend the patch with update Rafael
> > > > suggests or you'll merge the Rafael's fix in yourself?
> > >
> > > I'll apply the fix directly, thanks!
> >
> > Great. Is it going to be available in the repo:
> > https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git/
> > ?
> 
> Yes, it is.  Please see the bleeding-edge branch in there, thanks!

No credits with at least Reported-by tag? That's sad.(

-Sergey
