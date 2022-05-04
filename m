Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17BBA51A15B
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 15:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350730AbiEDNyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 09:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235435AbiEDNyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 09:54:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7751D3E5C1;
        Wed,  4 May 2022 06:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C931619F1;
        Wed,  4 May 2022 13:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D280C385A4;
        Wed,  4 May 2022 13:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651672257;
        bh=ZHm4zRsrfroy4L8PmGFqSDzG1kyM2WEhmxfXu30nYJ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KbD0RzUSQXY1GOpppkVJACC+5dEQ+Oa6BSONKBAqkMFnH24ZxfCh/URltxKrp48hu
         4ERCzWc5JbR0Dwx1fMhtEe8hFatvMvFPHtXvknO90dVNHnSsAA6DP+s2JitpkPo6At
         OrCGkGJ4vybphxUx+3TNN39kypMQPCjpbDHgxLrLXO0D0uqMGyeAvQTrEorGKltQZv
         wSCJGoHL3Xhr/GKJNCePKYdZcNfU+ev30vTx+iFL2IyW2p3nFudZspWTVwNCmrsAwV
         ZughhxY3oVqmWBH4BVsZrBpYquVzPqjhD+qSdlbeyjbuUILkCdNpx5QMWOQaNicTj7
         E+esIMj4DGfZQ==
Date:   Wed, 4 May 2022 14:50:51 +0100
From:   Will Deacon <will@kernel.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     Elliot Berman <quic_eberman@quicinc.com>,
        "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Murali Nalajala <quic_mnalajal@quicinc.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] arm64: paravirt: Use RCU read locks to guard
 stolen_time
Message-ID: <20220504135050.GA20470@willie-the-truck>
References: <20220428183536.2866667-1-quic_eberman@quicinc.com>
 <20220504094507.GA20305@willie-the-truck>
 <c6689e42-e87c-0c0b-c7ff-40134406e080@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6689e42-e87c-0c0b-c7ff-40134406e080@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 04, 2022 at 03:38:47PM +0200, Juergen Gross wrote:
> On 04.05.22 11:45, Will Deacon wrote:
> > On Thu, Apr 28, 2022 at 11:35:36AM -0700, Elliot Berman wrote:
> > > diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
> > > index 75fed4460407..e724ea3d86f0 100644
> > > --- a/arch/arm64/kernel/paravirt.c
> > > +++ b/arch/arm64/kernel/paravirt.c
> > > @@ -52,7 +52,9 @@ early_param("no-steal-acc", parse_no_stealacc);
> > >   /* return stolen time in ns by asking the hypervisor */
> > >   static u64 para_steal_clock(int cpu)
> > >   {
> > > +	struct pvclock_vcpu_stolen_time *kaddr = NULL;
> > >   	struct pv_time_stolen_time_region *reg;
> > > +	u64 ret = 0;
> > >   	reg = per_cpu_ptr(&stolen_time_region, cpu);
> > > @@ -61,28 +63,38 @@ static u64 para_steal_clock(int cpu)
> > >   	 * online notification callback runs. Until the callback
> > >   	 * has run we just return zero.
> > >   	 */
> > > -	if (!reg->kaddr)
> > > +	rcu_read_lock();
> > > +	kaddr = rcu_dereference(reg->kaddr);
> > > +	if (!kaddr) {
> > > +		rcu_read_unlock();
> > >   		return 0;
> > > +	}
> > > -	return le64_to_cpu(READ_ONCE(reg->kaddr->stolen_time));
> > > +	ret = le64_to_cpu(READ_ONCE(kaddr->stolen_time));
> > 
> > Is this READ_ONCE() still required now?
> 
> Yes, as it might be called for another cpu than the current one.
> stolen_time might just be updated, so you want to avoid load tearing.

Ah yes, thanks. The lifetime of the structure is one thing, but the
stolen time field is updated much more regularly than the kaddr pointer.

So:

Acked-by: Will Deacon <will@kernel.org>

Cheers,

Will
