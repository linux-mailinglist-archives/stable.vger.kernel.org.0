Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF7827F076
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388758AbfHBJ21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:28:27 -0400
Received: from cloudserver094114.home.pl ([79.96.170.134]:55229 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388741AbfHBJ21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 05:28:27 -0400
Received: from 79.184.255.110.ipv4.supernova.orange.pl (79.184.255.110) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.275)
 id 2774d927111a2d21; Fri, 2 Aug 2019 11:28:24 +0200
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "v4 . 18+" <stable@vger.kernel.org>,
        Doug Smythies <doug.smythies@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 2/2] cpufreq: intel_pstate: Implement ->resolve_freq()
Date:   Fri, 02 Aug 2019 11:28:24 +0200
Message-ID: <2676200.jfxhmTd764@kreacher>
In-Reply-To: <CAJZ5v0iqztRWyxf1cgiAN1dK4qTGwy9raaGOx5u3tfBTGUKOng@mail.gmail.com>
References: <7dedb6bd157b8183c693bb578e25e313cf4f451d.1564724511.git.viresh.kumar@linaro.org> <23e3dee8688f5a9767635b686bb7a9c0e09a4438.1564724511.git.viresh.kumar@linaro.org> <CAJZ5v0iqztRWyxf1cgiAN1dK4qTGwy9raaGOx5u3tfBTGUKOng@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Friday, August 2, 2019 11:17:55 AM CEST Rafael J. Wysocki wrote:
> On Fri, Aug 2, 2019 at 7:44 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >
> > Intel pstate driver exposes min_perf_pct and max_perf_pct sysfs files,
> > which can be used to force a limit on the min/max P state of the driver.
> > Though these files eventually control the min/max frequencies that the
> > CPUs will run at, they don't make a change to policy->min/max values.
> 
> That's correct.
> 
> > When the values of these files are changed (in passive mode of the
> > driver), it leads to calling ->limits() callback of the cpufreq
> > governors, like schedutil. On a call to it the governors shall
> > forcefully update the frequency to come within the limits.
> 
> OK, so the problem is that it is a bug to invoke the governor's ->limits()
> callback without updating policy->min/max, because that's what
> "limits" mean to the governors.
> 
> Fair enough.

AFAICS this can be addressed by adding PM QoS freq limits requests of each CPU to
intel_pstate in the passive mode such that changing min_perf_pct or max_perf_pct
will cause these requests to be updated.



