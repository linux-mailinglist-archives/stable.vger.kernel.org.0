Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D633AE5417
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 21:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfJYTFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 15:05:49 -0400
Received: from smtprelay0017.hostedemail.com ([216.40.44.17]:50696 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725847AbfJYTFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 15:05:49 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id AE4838384364;
        Fri, 25 Oct 2019 19:05:47 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:69:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2692:2828:2911:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4425:5007:6117:6119:6120:7576:7901:10004:10400:10848:11026:11232:11658:11914:12043:12296:12297:12438:12555:12740:12760:12895:13069:13095:13255:13311:13357:13439:14181:14659:14721:21080:21212:21433:21451:21627:30034:30045:30054:30090:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.14.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: food96_326534c4f0a3f
X-Filterd-Recvd-Size: 2493
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Fri, 25 Oct 2019 19:05:46 +0000 (UTC)
Message-ID: <220d8f2c1b299d2e71fdcf50b98286aae5b0c6f2.camel@perches.com>
Subject: Re: [PATCH 3.16 47/47] KVM: x86/vPMU: refine kvm_pmu err msg when
 event creation failed
From:   Joe Perches <joe@perches.com>
To:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 25 Oct 2019 12:05:43 -0700
In-Reply-To: <lsq.1572026582.631294584@decadent.org.uk>
References: <lsq.1572026582.631294584@decadent.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-10-25 at 19:03 +0100, Ben Hutchings wrote:
> 3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

This seems more like an enhancement than a bug fix.

Is this really the type of patch that is appropriate
for stable?

> ------------------
> 
> From: Like Xu <like.xu@linux.intel.com>
> 
> commit 6fc3977ccc5d3c22e851f2dce2d3ce2a0a843842 upstream.
> 
> If a perf_event creation fails due to any reason of the host perf
> subsystem, it has no chance to log the corresponding event for guest
> which may cause abnormal sampling data in guest result. In debug mode,
> this message helps to understand the state of vPMC and we may not
> limit the number of occurrences but not in a spamming style.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [bwh: Backported to 3.16: adjust context]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  arch/x86/kvm/pmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -187,8 +187,8 @@ static void reprogram_counter(struct kvm
>  						 intr ? kvm_perf_overflow_intr :
>  						 kvm_perf_overflow, pmc);
>  	if (IS_ERR(event)) {
> -		printk_once("kvm: pmu event creation failed %ld\n",
> -				PTR_ERR(event));
> +		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
> +			    PTR_ERR(event), pmc->idx);
>  		return;
>  	}
>  
> 

