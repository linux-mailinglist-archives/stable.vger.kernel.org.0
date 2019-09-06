Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B877AB9BB
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 15:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391801AbfIFNto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 09:49:44 -0400
Received: from foss.arm.com ([217.140.110.172]:56446 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391079AbfIFNto (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 09:49:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C02B28;
        Fri,  6 Sep 2019 06:49:43 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3846B3F718;
        Fri,  6 Sep 2019 06:49:42 -0700 (PDT)
Date:   Fri, 6 Sep 2019 14:49:35 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH ARM64 v4.4 V3 12/44] arm64: cpufeature: Test 'matches'
 pointer to find the end of the list
Message-ID: <20190906134935.GA17375@lakrids.cambridge.arm.com>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
 <617ad445043f040c5ab986b9620b2ba7847b561e.1567077734.git.viresh.kumar@linaro.org>
 <20190902142741.GB9922@lakrids.cambridge.arm.com>
 <20190905074506.oxsw24xoex7gcfgm@vireshk-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905074506.oxsw24xoex7gcfgm@vireshk-i7>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 05, 2019 at 01:15:06PM +0530, Viresh Kumar wrote:
> On 02-09-19, 15:27, Mark Rutland wrote:
> > On Thu, Aug 29, 2019 at 05:03:57PM +0530, Viresh Kumar wrote:
> > > From: James Morse <james.morse@arm.com>
> > > 
> > > commit 644c2ae198412c956700e55a2acf80b2541f6aa5 upstream.
> > > 
> > > CPU feature code uses the desc field as a test to find the end of the list,
> > > this means every entry must have a description. This generates noise for
> > > entries in the list that aren't really features, but combinations of them.
> > > e.g.
> > > > CPU features: detected feature: Privileged Access Never
> > > > CPU features: detected feature: PAN and not UAO
> > > 
> > > These combination features are needed for corner cases with alternatives,
> > > where cpu features interact.
> > > 
> > > Change all walkers of the arm64_features[] and arm64_hwcaps[] lists to test
> > > 'matches' not 'desc', and only print 'desc' if it is non-NULL.
> > > 
> > > Signed-off-by: James Morse <james.morse@arm.com>
> > > Reviewed-by : Suzuki K Poulose <suzuki.poulose@arm.com>
> > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > > ---
> > >  arch/arm64/kernel/cpufeature.c | 12 ++++++------
> > >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > >From looking at my 4.9.y/{meltdown,spectre} banches on kernel.org [1,2],
> > and chasing the history v4.4..v4.9, there are a number of patches I'd
> > expect to have alongside this that I don't spot in this series:
> > 
> > * e3661b128e53ee281e1e7c589a5b647890bd6d7c ("arm64: Allow a capability to be checked on a single CPU")
> > * 8f4137588261d7504f4aa022dc9d1a1fd1940e8e ("arm64: Allow checking of a CPU-local erratum")
> > * 67948af41f2e6818edeeba5182811c704d484949 ("arm64: capabilities: Handle duplicate entries for a capability")
> > * edf298cfce47ab7279d03b5203ae2ef3a58e49db ("arm64: cpufeature: __this_cpu_has_cap() shouldn't stop early")
> 
> I also had to pick this one for cleaner rebase:
> 
> 752835019c15 arm64: HWCAP: Split COMPAT HWCAP table entries
> 
> > 
> > ... which IIUC are necessary for big.LITTLE to work correctly.
> 
> I have pushed the changes to my branch again with above 5 patches and
> some more reordering to match 4.9 log.

Thanks for this!

> > Have you verified this for big.LITTLE?
> 
> Not sure if we ever talked about this earlier, but here is the
> situation which I explained to Julien earlier.
> 
> I don't have access to the test-suite to verify that these patches
> indeed fix the spectre mitigations and I was asked to backport these
> and then ask for help from ARM to get these tested through the
> test-suite. I was expecting Julien to do that earlier.

Ok, thanks for providing this context.

As a heads-up, I'll be at LPC next week. While I'm there I won't be able
to test things, and I'm unlikely to find time to review, but I'll try to
do so ASAP once I return.

> Julien did ask me to verify few things earlier, which can be done
> without the test suite and was about checking that the new code paths
> are getting hit now or not, which I did.
> 
> I haven't tested these on big LITTLE, though I can get the branch
> through LAVA to get it tested on big LITTLE but I have no clue on what
> I should be looking for in results :)

I think it would be worthwhile to do that ASAP to make sure there are no
boot-time or run-time regressions. We can look at the logs later (or
re-run with some additional logging) to verify things are working as
expected.

> If there is some testing that can be done on my side for this, I sure
> can do it. But I would need help from you on that to know what exactly
> I need to check.

Sure. I'll have to take another look over the series to figure that out,
and as above I might not be able to do so until after LPC -- sorry!

Thanks,
Mark.
