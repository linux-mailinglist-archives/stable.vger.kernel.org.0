Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78695FC023
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 07:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJLFdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 01:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLFdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 01:33:14 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D41866A6B;
        Tue, 11 Oct 2022 22:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665552793; x=1697088793;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wn1xstVhxQVmqi5Leuw/Fl+1hzRsJc8yGRMjVACxU48=;
  b=fzBJFS26KNCvG0jHyZdTS0ic1l9ZM6miCTydO8vOv9FFWFCA3W3vZkP/
   510fbwATdSpwOxBN8+0M+cPbC8Oiaz4jsOnUulkEMDUaXoc2B4HuKKhTA
   ujUYIVCM6kifAcaPOKrhPRQrxRoHMbambl/a/au8W+ZwP/gbhHRXpmHx9
   pn9dLjVEOjw62kRvVwcppXLgqhwixuXhjSLXSpR62eb4B+jiHA73EAVIx
   Oe5yQ6MsNhSsQxzsX4vESrkKx3q5khUBBbl1z8PKa22sKJsDXt5ZZdOtT
   Mdni6TB14+869uQ39KI0TtODh2YLDvnhzDBIwz7VhDy6pu6dWG6+SUWEA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="303442671"
X-IronPort-AV: E=Sophos;i="5.95,178,1661842800"; 
   d="scan'208";a="303442671"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 22:33:12 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="695339603"
X-IronPort-AV: E=Sophos;i="5.95,178,1661842800"; 
   d="scan'208";a="695339603"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 22:33:12 -0700
Message-ID: <cca662f039d4b152fd3471561180dca4b140b217.camel@linux.intel.com>
Subject: Re: [PATCH AUTOSEL 4.9 4/4] thermal: intel_powerclamp: Use
 get_cpu() instead of smp_processor_id() to avoid crash
From:   srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To:     Chen Yu <yu.c.chen@intel.com>, Pavel Machek <pavel@ucw.cz>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        rafael@kernel.org, daniel.lezcano@linaro.org,
        linux-pm@vger.kernel.org
Date:   Tue, 11 Oct 2022 22:33:11 -0700
In-Reply-To: <Y0VuKmt5BGfB6nAE@chenyu5-mobl1>
References: <20221009205508.1204042-1-sashal@kernel.org>
         <20221009205508.1204042-4-sashal@kernel.org>
         <20221011113646.GA12080@duo.ucw.cz> <Y0VuKmt5BGfB6nAE@chenyu5-mobl1>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-10-11 at 21:22 +0800, Chen Yu wrote:
> Hi Pavel,
> On 2022-10-11 at 13:36:46 +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> > > 
> > > [ Upstream commit 68b99e94a4a2db6ba9b31fe0485e057b9354a640 ]
> > > 
> > > When CPU 0 is offline and intel_powerclamp is used to inject
> > > idle, it generates kernel BUG:
> > > 
> > > BUG: using smp_processor_id() in preemptible [00000000] code:
> > > bash/15687
> > > caller is debug_smp_processor_id+0x17/0x20
> > > CPU: 4 PID: 15687 Comm: bash Not tainted 5.19.0-rc7+ #57
> > > Call Trace:
> > > <TASK>
> > > dump_stack_lvl+0x49/0x63
> > > dump_stack+0x10/0x16
> > > check_preemption_disabled+0xdd/0xe0
> > > debug_smp_processor_id+0x17/0x20
> > > powerclamp_set_cur_state+0x7f/0xf9 [intel_powerclamp]
> > > ...
> > > ...
> > > 
> > > Here CPU 0 is the control CPU by default and changed to the current
> > > CPU,
> > > if CPU 0 offlined. This check has to be performed under
> > > cpus_read_lock(),
> > > hence the above warning.
> > > 
> > > Use get_cpu() instead of smp_processor_id() to avoid this BUG.
> > 
> > This has exactly the same problem as smp_processor_id(), you just
> > worked around the warning. If it is okay that control_cpu contains
> > stale value, could we have a comment explaining why?
> > 
> May I know why does control_cpu have stale value? The control_cpu
> is a random picked online CPU which will be used later to collect
> statistics.
> As long as the control_cpu is online, it is valid IMO.
> 

I am also interested to know why this can be stale. The get_cpu() call
disables preemption. 

#define get_cpu()		({ preempt_disable();
__smp_processor_id(); })


Even if you change it to call debug_smp_processor_id() instead of
__smp_processor_id(), it will still not print warning as
preempt_count() will return 1.

If after the preemption is enabled if the CPU is offlined, there are
hotplug callbacks to handle.


Thanks,
Srinivas
 

> thanks,
> Chenyu
> > Thanks,
> >                                                                 Pavel
> >                                                                 
> > > +++ b/drivers/thermal/intel_powerclamp.c
> > > @@ -519,8 +519,10 @@ static int start_power_clamp(void)
> > >  
> > >         /* prefer BSP */
> > >         control_cpu = 0;
> > > -       if (!cpu_online(control_cpu))
> > > -               control_cpu = smp_processor_id();
> > > +       if (!cpu_online(control_cpu)) {
> > > +               control_cpu = get_cpu();
> > > +               put_cpu();
> > > +       }
> > >  
> > >         clamping = true;
> > >         schedule_delayed_work(&poll_pkg_cstate_work, 0);
> > > -- 
> > > 2.35.1
> > 
> > -- 
> > People of Russia, stop Putin before his war on Ukraine escalates.
> 
> 


