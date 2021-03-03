Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A86D32C83C
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377173AbhCDAfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388006AbhCCUXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 15:23:17 -0500
X-Greylist: delayed 4964 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 03 Mar 2021 12:22:37 PST
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EFDC061756;
        Wed,  3 Mar 2021 12:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NJRVHOfY/wAjmUPZBNz4qgJex3zmcTXiYgWDUNlTG8o=; b=eqA9t6kzaBOgSsX6JWQ6bNyGRh
        UgYeALN9opyR6KuSqGmP4uzPf+k1oBK6TCyU6a/1fX501vYjGmCpXFSWywGvkaonbPZhEayT++4iZ
        oODGrrJEmiuUlswEbZ3fyg6gI9kYBFgn9UR+KDU3zx1LGek7KNREdgasXMr6iw6BLvLokSybzj3o0
        FNG0+dPAVRHOOozCESR//7yz71L+9+0rl3yqiyPbu8P6DvpStpnaONCATRQi3TmBKlvyzIITN694t
        lEto28QgNJ950rVl1iEY2vdIbNKBUcYGt3oxMUUHAEyvaVM0uFuclcgYh+03KSaFH8kTFiBm0BULu
        IrCyN89A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lHXzy-006Opo-Az; Wed, 03 Mar 2021 20:21:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 795C73017B7;
        Wed,  3 Mar 2021 21:21:31 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3FB8320B10DC6; Wed,  3 Mar 2021 21:21:31 +0100 (CET)
Date:   Wed, 3 Mar 2021 21:21:31 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     Vince Weaver <vincent.weaver@maine.edu>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, eranian@google.com,
        ak@linux.intel.com, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "perf/x86: Allow zero PEBS status with only
 single active event"
Message-ID: <YD/vy2RnkWZYiJHP@hirez.programming.kicks-ass.net>
References: <1614778938-93092-1-git-send-email-kan.liang@linux.intel.com>
 <YD/cnnuh/AHOL8hV@hirez.programming.kicks-ass.net>
 <9484ab6e-a6e5-bb72-106f-ed904e50fc0c@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9484ab6e-a6e5-bb72-106f-ed904e50fc0c@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 02:53:00PM -0500, Liang, Kan wrote:
> On 3/3/2021 1:59 PM, Peter Zijlstra wrote:
> > On Wed, Mar 03, 2021 at 05:42:18AM -0800, kan.liang@linux.intel.com wrote:

> > > +++ b/arch/x86/events/intel/ds.c
> > > @@ -2000,18 +2000,6 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
> > >   			continue;
> > >   		}
> > > -		/*
> > > -		 * On some CPUs the PEBS status can be zero when PEBS is
> > > -		 * racing with clearing of GLOBAL_STATUS.
> > > -		 *
> > > -		 * Normally we would drop that record, but in the
> > > -		 * case when there is only a single active PEBS event
> > > -		 * we can assume it's for that event.
> > > -		 */
> > > -		if (!pebs_status && cpuc->pebs_enabled &&
> > > -			!(cpuc->pebs_enabled & (cpuc->pebs_enabled-1)))
> > > -			pebs_status = cpuc->pebs_enabled;
> > 
> > Wouldn't something like:
> > 
> > 			pebs_status = p->status = cpus->pebs_enabled;
> > 
> 
> I didn't consider it as a potential solution in this patch because I don't
> think it's a proper way that SW modifies the buffer, which is supposed to be
> manipulated by the HW.

Right, but then HW was supposed to write sane values and it doesn't do
that either ;-)

> It's just a personal preference. I don't see any issue here. We may try it.

So I mostly agree with you, but I think it's a shame to unsupport such
chips, HSW is still a plenty useable chip today.


