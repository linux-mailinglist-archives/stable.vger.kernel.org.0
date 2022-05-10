Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AC05213F3
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 13:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240450AbiEJLlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 07:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241134AbiEJLlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 07:41:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88551E0138;
        Tue, 10 May 2022 04:37:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 329CB61919;
        Tue, 10 May 2022 11:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2037C385A6;
        Tue, 10 May 2022 11:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652182631;
        bh=Yj6ouDcGjaidRSIAT9DJ46QXtOOqTQvc/8T4ao11gnw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h6lq0lZ3JRCepnAaDmp6/yY6PBcVoa8nFuz9Kpb4Z3IS8z13+fuGmxzg64etup/fw
         GUCs/lCwG7jqiZoh/K8YCM6jTOb8rw69H4iHrE3RrAdn+jhuL1DngWZkqu210VbilX
         ENp4WD0gFVJ4icgwz5GPx/5FkDbfZcdllpYE+4C4=
Date:   Tue, 10 May 2022 13:37:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, Kyle Huey <me@kylehuey.com>
Cc:     stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        Keno Fischer <keno@juliacomputing.com>
Subject: Re: [PATCH 5.4] KVM: x86/svm: Account for family 17h event
 renumberings in amd_pmc_perf_hw_id
Message-ID: <YnpOZAfLdJ6cj5b9@kroah.com>
References: <20220508165434.119000-1-khuey@kylehuey.com>
 <29767a7d-d887-1a0c-296e-5bed220f1c9e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <29767a7d-d887-1a0c-296e-5bed220f1c9e@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 09, 2022 at 01:41:20PM +0200, Paolo Bonzini wrote:
> On 5/8/22 18:54, Kyle Huey wrote:
> > From: Kyle Huey <me@kylehuey.com>
> > 
> > commit 5eb849322d7f7ae9d5c587c7bc3b4f7c6872cd2f upstream
> > 
> > Zen renumbered some of the performance counters that correspond to the
> > well known events in perf_hw_id. This code in KVM was never updated for
> > that, so guest that attempt to use counters on Zen that correspond to the
> > pre-Zen perf_hw_id values will silently receive the wrong values.
> > 
> > This has been observed in the wild with rr[0] when running in Zen 3
> > guests. rr uses the retired conditional branch counter 00d1 which is
> > incorrectly recognized by KVM as PERF_COUNT_HW_STALLED_CYCLES_BACKEND.
> > 
> > [0] https://rr-project.org/
> > 
> > Signed-off-by: Kyle Huey <me@kylehuey.com>
> > Message-Id: <20220503050136.86298-1-khuey@kylehuey.com>
> > Cc: stable@vger.kernel.org
> > [Check guest family, not host. - Paolo]
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > [Backport to 5.4: adjusted context]
> > Signed-off-by: Kyle Huey <me@kylehuey.com>
> > ---
> >   arch/x86/kvm/pmu_amd.c | 28 +++++++++++++++++++++++++---
> >   1 file changed, 25 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
> > index 6bc656abbe66..3ccfd1abcbad 100644
> > --- a/arch/x86/kvm/pmu_amd.c
> > +++ b/arch/x86/kvm/pmu_amd.c
> > @@ -44,6 +44,22 @@ static struct kvm_event_hw_type_mapping amd_event_mapping[] = {
> >   	[7] = { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
> >   };
> > +/* duplicated from amd_f17h_perfmon_event_map. */
> > +static struct kvm_event_hw_type_mapping amd_f17h_event_mapping[] = {
> > +	[0] = { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
> > +	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
> > +	[2] = { 0x60, 0xff, PERF_COUNT_HW_CACHE_REFERENCES },
> > +	[3] = { 0x64, 0x09, PERF_COUNT_HW_CACHE_MISSES },
> > +	[4] = { 0xc2, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
> > +	[5] = { 0xc3, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
> > +	[6] = { 0x87, 0x02, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
> > +	[7] = { 0x87, 0x01, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
> > +};
> > +
> > +/* amd_pmc_perf_hw_id depends on these being the same size */
> > +static_assert(ARRAY_SIZE(amd_event_mapping) ==
> > +	     ARRAY_SIZE(amd_f17h_event_mapping));
> > +
> >   static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
> >   {
> >   	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
> > @@ -130,17 +146,23 @@ static unsigned amd_find_arch_event(struct kvm_pmu *pmu,
> >   				    u8 event_select,
> >   				    u8 unit_mask)
> >   {
> > +	struct kvm_event_hw_type_mapping *event_mapping;
> >   	int i;
> > +	if (guest_cpuid_family(pmc->vcpu) >= 0x17)
> > +		event_mapping = amd_f17h_event_mapping;
> > +	else
> > +		event_mapping = amd_event_mapping;
> > +
> >   	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
> > -		if (amd_event_mapping[i].eventsel == event_select
> > -		    && amd_event_mapping[i].unit_mask == unit_mask)
> > +		if (event_mapping[i].eventsel == event_select
> > +		    && event_mapping[i].unit_mask == unit_mask)
> >   			break;
> >   	if (i == ARRAY_SIZE(amd_event_mapping))
> >   		return PERF_COUNT_HW_MAX;
> > -	return amd_event_mapping[i].event_type;
> > +	return event_mapping[i].event_type;
> >   }
> >   /* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Thanks,
> 
> Paolo
> 

Wait, how was this tested?

It breaks the build:

arch/x86/kvm/pmu_amd.c: In function ‘amd_find_arch_event’:
arch/x86/kvm/pmu_amd.c:152:32: error: ‘pmc’ undeclared (first use in this function); did you mean ‘pmu’?
  152 |         if (guest_cpuid_family(pmc->vcpu) >= 0x17)
      |                                ^~~
      |                                pmu


I'll do the obvious fixup, but this is odd.  Always at least test-build
your changes...

thanks,

greg k-h
