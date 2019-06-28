Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2F95963A
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 10:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfF1If1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 04:35:27 -0400
Received: from foss.arm.com ([217.140.110.172]:42826 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbfF1If1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 04:35:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 318102B;
        Fri, 28 Jun 2019 01:35:26 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CBB233F706;
        Fri, 28 Jun 2019 01:35:25 -0700 (PDT)
Date:   Fri, 28 Jun 2019 09:35:24 +0100
From:   Andrew Murray <andrew.murray@arm.com>
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        coresight@lists.linaro.org, Sudeep Holla <sudeep.holla@arm.com>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Leach <mike.leach@linaro.org>
Subject: Re: [PATCH v2 2/5] coresight: etm4x: use explicit barriers on
 enable/disable
Message-ID: <20190628083523.GG34530@e119886-lin.cambridge.arm.com>
References: <20190627083525.37463-1-andrew.murray@arm.com>
 <20190627083525.37463-3-andrew.murray@arm.com>
 <20190628024529.GC20296@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628024529.GC20296@leoy-ThinkPad-X240s>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 10:45:29AM +0800, Leo Yan wrote:
> Hi Andrew,
> 
> On Thu, Jun 27, 2019 at 09:35:22AM +0100, Andrew Murray wrote:
> > Synchronization is recommended before disabling the trace registers
> > to prevent any start or stop points being speculative at the point
> > of disabling the unit (section 7.3.77 of ARM IHI 0064D).
> > 
> > Synchronization is also recommended after programming the trace
> > registers to ensure all updates are committed prior to normal code
> > resuming (section 4.3.7 of ARM IHI 0064D).
> > 
> > Let's ensure these syncronization points are present in the code
> > and clearly commented.
> > 
> > Note that we could rely on the barriers in CS_LOCK and
> > coresight_disclaim_device_unlocked or the context switch to user
> > space - however coresight may be of use in the kernel.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > CC: stable@vger.kernel.org
> > ---
> >  drivers/hwtracing/coresight/coresight-etm4x.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
> > index c89190d464ab..68e8e3954cef 100644
> > --- a/drivers/hwtracing/coresight/coresight-etm4x.c
> > +++ b/drivers/hwtracing/coresight/coresight-etm4x.c
> > @@ -188,6 +188,10 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
> >  		dev_err(etm_dev,
> >  			"timeout while waiting for Idle Trace Status\n");
> >  
> > +	/* As recommended by 4.3.7 of ARM IHI 0064D */
> > +	dsb(sy);
> > +	isb();
> > +
> 
> I read the spec, it recommends to use dsb/isb after accessing trace
> unit, so here I think dsb(sy) is the most safe way.
> 
> arm64 defines barrier in arch/arm64/include/asm/barrier.h:
> 
>   #define mb()            dsb(sy)
> 
> so here I suggest to use barriers:
> 
>   mb();
>   isb();
> 
> I wrongly assumed that mb() is for dmb operations, but actually it's
> defined for dsb operation.  So we should use it and this is a common
> function between arm64 and arm.
> 
> >  done:
> >  	CS_LOCK(drvdata->base);
> >  
> > @@ -454,7 +458,8 @@ static void etm4_disable_hw(void *info)
> >  	control &= ~0x1;
> >  
> >  	/* make sure everything completes before disabling */
> > -	mb();
> > +	/* As recommended by 7.3.77 of ARM IHI 0064D */
> > +	dsb(sy);
> 
> Here the old code should be right, mb() is the same thing with
> dsb(sy).
> 
> So we don't need to change at here?

Correct - on arm64 there is no difference between mb and dsb(sy) so no
functional change on this hunk.

In repsonse to Suzuki's feedback on this patch, I've updated the commit
message to describe why I've made this change, as follows:
     
"On armv8 the mb macro is defined as dsb(sy) - Given that the etm4x is
only used on armv8 let's directly use dsb(sy) instead of mb(). This
removes some ambiguity and makes it easier to correlate the code with
the TRM."

Does that make sense?

Thanks,

Andrew Murray

> 
> Thanks,
> Leo Yan
> 
> >  	isb();
> >  	writel_relaxed(control, drvdata->base + TRCPRGCTLR);
> >  
> > -- 
> > 2.21.0
> > 
> > _______________________________________________
> > CoreSight mailing list
> > CoreSight@lists.linaro.org
> > https://lists.linaro.org/mailman/listinfo/coresight
