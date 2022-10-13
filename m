Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871D35FD36C
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 05:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiJMDGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 23:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiJMDGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 23:06:08 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0088111D99E;
        Wed, 12 Oct 2022 20:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665630365; x=1697166365;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tNeojNscr5c32MRBReeGhpk00shSj74G49OF8ZSs0Dc=;
  b=nQb4bRMu8pOkJqZkzKsS7yrY/GITR6xbdy3RpFNbeFAEoPV60Q0scSdN
   AY+BFGXJCSTYJdR8LoQ7PX/+C2XaqKKAXX9LaHVuWx6GRdHIODiqbYGiZ
   tc9PlzLF88cyw7Oj3En2DCrl/YGdASAQtwzlS0l4R2IR62KW+hTHLUyJv
   EQgSuStA+vh/Y1WRkaXPdSqoJlN2On/ESANEL27Lj4WLf/QtuuBCx+o1p
   4O61UK9TPLp/iV41JdMa7w4WdBIekLE1Np632ZYdh3PXrdy4dkfOkgdUF
   ShD7+PmMg4UpOH/J0Wrj5S2fBozsBDFz3rM/uYnpNxPDRNmynIb7G9Mbf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="391270239"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="391270239"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 20:06:02 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="872150601"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="872150601"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 20:06:01 -0700
Message-ID: <731def9d99e6e199ed4b6e29119746121c41ca32.camel@linux.intel.com>
Subject: Re: [PATCH AUTOSEL 4.9 4/4] thermal: intel_powerclamp: Use
 get_cpu() instead of smp_processor_id() to avoid crash
From:   srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Chen Yu <yu.c.chen@intel.com>
Cc:     Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        daniel.lezcano@linaro.org, linux-pm@vger.kernel.org
Date:   Wed, 12 Oct 2022 20:06:01 -0700
In-Reply-To: <CAJZ5v0iHu3ZZuHeC7q6x4ZERaAu0pP2ubqzUv3v2upxLwOFXsg@mail.gmail.com>
References: <20221009205508.1204042-1-sashal@kernel.org>
         <20221009205508.1204042-4-sashal@kernel.org>
         <20221011113646.GA12080@duo.ucw.cz> <Y0VuKmt5BGfB6nAE@chenyu5-mobl1>
         <CAJZ5v0iHu3ZZuHeC7q6x4ZERaAu0pP2ubqzUv3v2upxLwOFXsg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-10-12 at 18:58 +0200, Rafael J. Wysocki wrote:
> On Tue, Oct 11, 2022 at 3:23 PM Chen Yu <yu.c.chen@intel.com> wrote:
> > 
> > Hi Pavel,
> > On 2022-10-11 at 13:36:46 +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> > > > 
> > > > [ Upstream commit 68b99e94a4a2db6ba9b31fe0485e057b9354a640 ]
> > > > 
> > > > When CPU 0 is offline and intel_powerclamp is used to inject
> > > > idle, it generates kernel BUG:
> > > > 
> > > > BUG: using smp_processor_id() in preemptible [00000000] code:
> > > > bash/15687
> > > > caller is debug_smp_processor_id+0x17/0x20
> > > > CPU: 4 PID: 15687 Comm: bash Not tainted 5.19.0-rc7+ #57
> > > > Call Trace:
> > > > <TASK>
> > > > dump_stack_lvl+0x49/0x63
> > > > dump_stack+0x10/0x16
> > > > check_preemption_disabled+0xdd/0xe0
> > > > debug_smp_processor_id+0x17/0x20
> > > > powerclamp_set_cur_state+0x7f/0xf9 [intel_powerclamp]
> > > > ...
> > > > ...
> > > > 
> > > > Here CPU 0 is the control CPU by default and changed to the
> > > > current CPU,
> > > > if CPU 0 offlined. This check has to be performed under
> > > > cpus_read_lock(),
> > > > hence the above warning.
> > > > 
> > > > Use get_cpu() instead of smp_processor_id() to avoid this BUG.
> > > 
> > > This has exactly the same problem as smp_processor_id(), you just
> > > worked around the warning. If it is okay that control_cpu
> > > contains
> > > stale value, could we have a comment explaining why?
> > > 
> > May I know why does control_cpu have stale value? The control_cpu
> > is a random picked online CPU which will be used later to collect
> > statistics.
> > As long as the control_cpu is online, it is valid IMO.
> 
> So this is confusing, because the code makes the impression that
> getting the number of the CPU running the code matters in some way,
> which isn't the case.
> 
> Something like cpumask_first(cpu_online_mask) should work as well if
> I'm not mistaken and it would be less confusing to use this instead
> IMO.
That should work as we are under hotplug lock anyway here.

Thanks,
Srinivas

