Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6554596A8
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 11:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbfF1JAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 05:00:17 -0400
Received: from foss.arm.com ([217.140.110.172]:43156 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbfF1JAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 05:00:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6837E2B;
        Fri, 28 Jun 2019 02:00:16 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD1ED3F706;
        Fri, 28 Jun 2019 02:00:15 -0700 (PDT)
Date:   Fri, 28 Jun 2019 10:00:14 +0100
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
Message-ID: <20190628090013.GI34530@e119886-lin.cambridge.arm.com>
References: <20190627083525.37463-1-andrew.murray@arm.com>
 <20190627083525.37463-3-andrew.murray@arm.com>
 <20190628024529.GC20296@leoy-ThinkPad-X240s>
 <20190628083523.GG34530@e119886-lin.cambridge.arm.com>
 <20190628085154.GD32370@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628085154.GD32370@leoy-ThinkPad-X240s>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 04:51:54PM +0800, Leo Yan wrote:
> Hi Andrew,
> 
> On Fri, Jun 28, 2019 at 09:35:24AM +0100, Andrew Murray wrote:
> 
> [...]
> 
> > > > @@ -454,7 +458,8 @@ static void etm4_disable_hw(void *info)
> > > >  	control &= ~0x1;
> > > >  
> > > >  	/* make sure everything completes before disabling */
> > > > -	mb();
> > > > +	/* As recommended by 7.3.77 of ARM IHI 0064D */
> > > > +	dsb(sy);
> > > 
> > > Here the old code should be right, mb() is the same thing with
> > > dsb(sy).
> > > 
> > > So we don't need to change at here?
> > 
> > Correct - on arm64 there is no difference between mb and dsb(sy) so no
> > functional change on this hunk.
> > 
> > In repsonse to Suzuki's feedback on this patch, I've updated the commit
> > message to describe why I've made this change, as follows:
> >      
> > "On armv8 the mb macro is defined as dsb(sy) - Given that the etm4x is
> > only used on armv8 let's directly use dsb(sy) instead of mb(). This
> > removes some ambiguity and makes it easier to correlate the code with
> > the TRM."
> > 
> > Does that make sense?
> 
> On reason for preferring to use mb() rather than dsb(sy) is for
> compatibility cross different architectures (armv7, armv8, and
> so on ...).  Seems to me mb() is a general API and transparent for
> architecture's difference.
> 
> dsb(sy) is quite dependent on specific Arm architecture, e.g. some old
> Arm architecures might don't support dsb(sy); and we are not sure later
> it will change for new architectures.

Yes but please note that the KConfig for this driver depends on ARM64.

Thanks,

Andrew Murray

> 
> Thanks,
> Leo Yan
