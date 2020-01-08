Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60CDF134023
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 12:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgAHLRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 06:17:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbgAHLRq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 06:17:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DA132077B;
        Wed,  8 Jan 2020 11:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578482265;
        bh=dUAiD4fz4U5Vi/KXyAnmpsUcxs1UCPj6MWowtcKytXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EOtiU4mY1tSDntNEhfBR8cZOFpimKo0u2XC0xmkW171V002EGduU4upv+9V5ZnWYN
         UxP/kIeHaR6OLNKHZi8Ex0oanTHy4iZSzkoGZcljH00TgNRkUPBBvpbke2GimPmO7Z
         Hs6s8+PlA2CuEVgR3IKbctxv+JvJXycvs0hQbTU0=
Date:   Wed, 8 Jan 2020 07:51:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 65/74] coresight: tmc-etf: Do not call
 smp_processor_id from preemptible
Message-ID: <20200108065120.GD2278146@kroah.com>
References: <20200107205135.369001641@linuxfoundation.org>
 <20200107205228.054429793@linuxfoundation.org>
 <20200107230825.GA26430@ubuntu-m2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107230825.GA26430@ubuntu-m2-xlarge-x86>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 04:08:25PM -0700, Nathan Chancellor wrote:
> On Tue, Jan 07, 2020 at 09:55:30PM +0100, Greg Kroah-Hartman wrote:
> > From: Suzuki K Poulose <suzuki.poulose@arm.com>
> > 
> > [ Upstream commit 024c1fd9dbcc1d8a847f1311f999d35783921b7f ]
> > 
> > During a perf session we try to allocate buffers on the "node" associated
> > with the CPU the event is bound to. If it is not bound to a CPU, we
> > use the current CPU node, using smp_processor_id(). However this is unsafe
> > in a pre-emptible context and could generate the splats as below :
> > 
> >  BUG: using smp_processor_id() in preemptible [00000000] code: perf/2544
> >  caller is tmc_alloc_etf_buffer+0x5c/0x60
> >  CPU: 2 PID: 2544 Comm: perf Not tainted 5.1.0-rc6-147786-g116841e #344
> >  Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development Platform, BIOS EDK II Feb  1 2019
> >  Call trace:
> >   dump_backtrace+0x0/0x150
> >   show_stack+0x14/0x20
> >   dump_stack+0x9c/0xc4
> >   debug_smp_processor_id+0x10c/0x110
> >   tmc_alloc_etf_buffer+0x5c/0x60
> >   etm_setup_aux+0x1c4/0x230
> >   rb_alloc_aux+0x1b8/0x2b8
> >   perf_mmap+0x35c/0x478
> >   mmap_region+0x34c/0x4f0
> >   do_mmap+0x2d8/0x418
> >   vm_mmap_pgoff+0xd0/0xf8
> >   ksys_mmap_pgoff+0x88/0xf8
> >   __arm64_sys_mmap+0x28/0x38
> >   el0_svc_handler+0xd8/0x138
> >   el0_svc+0x8/0xc
> > 
> > Use NUMA_NO_NODE hint instead of using the current node for events
> > not bound to CPUs.
> > 
> > Fixes: 2e499bbc1a929ac ("coresight: tmc: implementing TMC-ETF AUX space API")
> > Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: stable <stable@vger.kernel.org> # 4.7+
> > Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> > Link: https://lore.kernel.org/r/20190620221237.3536-4-mathieu.poirier@linaro.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/hwtracing/coresight/coresight-tmc-etf.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/drivers/hwtracing/coresight/coresight-tmc-etf.c b/drivers/hwtracing/coresight/coresight-tmc-etf.c
> > index 336194d059fe..329a201c0c19 100644
> > --- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
> > +++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
> > @@ -308,9 +308,7 @@ static void *tmc_alloc_etf_buffer(struct coresight_device *csdev, int cpu,
> >  	int node;
> >  	struct cs_buffers *buf;
> >  
> > -	if (cpu == -1)
> > -		cpu = smp_processor_id();
> > -	node = cpu_to_node(cpu);
> > +	node = (event->cpu == -1) ? NUMA_NO_NODE : cpu_to_node(event->cpu);
> 
> This breaks the build on 4.14 (and I believe 4.19 from the looks of it)
> because the event variable is not available without
> commit a0f08a6a9fee ("coresight: Communicate perf event to sink buffer
> allocation functions") from upstream. I am not sure how this should be
> fixed (either backporting the above commit or changing this one somehow)
> but it should be dropped in the meantime.

Ok, now dropped from both trees, thanks.

greg k-h
