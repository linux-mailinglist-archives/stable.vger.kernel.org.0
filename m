Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51E4524EA7
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 15:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354621AbiELNs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 09:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354483AbiELNsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 09:48:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4197C644D3;
        Thu, 12 May 2022 06:48:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF32A612EA;
        Thu, 12 May 2022 13:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0A8C34116;
        Thu, 12 May 2022 13:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652363302;
        bh=RNeaVXiU7WpdwCw8TVWzuw/Ov38t5FEYq7iQzFgfSj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Iv5xFPgzWaFn63Q703NSPzIfDaEkJM/dLkoS7ECqK5ta/vPfG2LXhhiV15rm5xgUL
         kJ4rknF48hDWcDN/6O4Xd4dU2xaGMsegoo4s8Tw92vO+i9KcHnDSHadNKx2KzemO26
         bxPFiH+t0+j27eF8QxuNYBySvp8wW1bNzR6E+HkY=
Date:   Thu, 12 May 2022 15:48:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kyle Huey <me@kylehuey.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        Robert O'Callahan <robert@ocallahan.org>,
        Keno Fischer <keno@juliacomputing.com>
Subject: Re: [PATCH 5.4] KVM: x86/svm: Account for family 17h event
 renumberings in amd_pmc_perf_hw_id
Message-ID: <Yn0QIxxeHFc8BIw6@kroah.com>
References: <20220508165434.119000-1-khuey@kylehuey.com>
 <29767a7d-d887-1a0c-296e-5bed220f1c9e@redhat.com>
 <YnpOZAfLdJ6cj5b9@kroah.com>
 <YnpOsDgrwCBsMs35@kroah.com>
 <CAP045Aq6vJxMJaVFjAX7gqQkBbMRArZJhea3U6LJVQEQB9Ea4Q@mail.gmail.com>
 <CAP045AoFcMeJBH7SWbLFJMYymqPJNKz9PDaYSwhSHYfbeByP8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP045AoFcMeJBH7SWbLFJMYymqPJNKz9PDaYSwhSHYfbeByP8Q@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 09:01:32AM -0700, Kyle Huey wrote:
> On Tue, May 10, 2022 at 6:11 AM Kyle Huey <me@kylehuey.com> wrote:
> >
> > On Tue, May 10, 2022 at 4:38 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, May 10, 2022 at 01:37:08PM +0200, Greg KH wrote:
> > > > On Mon, May 09, 2022 at 01:41:20PM +0200, Paolo Bonzini wrote:
> > > > > On 5/8/22 18:54, Kyle Huey wrote:
> > > > > > From: Kyle Huey <me@kylehuey.com>
> > > > > >
> > > > > > commit 5eb849322d7f7ae9d5c587c7bc3b4f7c6872cd2f upstream
> > > > > >
> > > > > > Zen renumbered some of the performance counters that correspond to the
> > > > > > well known events in perf_hw_id. This code in KVM was never updated for
> > > > > > that, so guest that attempt to use counters on Zen that correspond to the
> > > > > > pre-Zen perf_hw_id values will silently receive the wrong values.
> > > > > >
> > > > > > This has been observed in the wild with rr[0] when running in Zen 3
> > > > > > guests. rr uses the retired conditional branch counter 00d1 which is
> > > > > > incorrectly recognized by KVM as PERF_COUNT_HW_STALLED_CYCLES_BACKEND.
> > > > > >
> > > > > > [0] https://rr-project.org/
> > > > > >
> > > > > > Signed-off-by: Kyle Huey <me@kylehuey.com>
> > > > > > Message-Id: <20220503050136.86298-1-khuey@kylehuey.com>
> > > > > > Cc: stable@vger.kernel.org
> > > > > > [Check guest family, not host. - Paolo]
> > > > > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > > > [Backport to 5.4: adjusted context]
> > > > > > Signed-off-by: Kyle Huey <me@kylehuey.com>
> > > > > > ---
> > > > > >   arch/x86/kvm/pmu_amd.c | 28 +++++++++++++++++++++++++---
> > > > > >   1 file changed, 25 insertions(+), 3 deletions(-)
> > > > > >
> > > > > > diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
> > > > > > index 6bc656abbe66..3ccfd1abcbad 100644
> > > > > > --- a/arch/x86/kvm/pmu_amd.c
> > > > > > +++ b/arch/x86/kvm/pmu_amd.c
> > > > > > @@ -44,6 +44,22 @@ static struct kvm_event_hw_type_mapping amd_event_mapping[] = {
> > > > > >           [7] = { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
> > > > > >   };
> > > > > > +/* duplicated from amd_f17h_perfmon_event_map. */
> > > > > > +static struct kvm_event_hw_type_mapping amd_f17h_event_mapping[] = {
> > > > > > + [0] = { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
> > > > > > + [1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
> > > > > > + [2] = { 0x60, 0xff, PERF_COUNT_HW_CACHE_REFERENCES },
> > > > > > + [3] = { 0x64, 0x09, PERF_COUNT_HW_CACHE_MISSES },
> > > > > > + [4] = { 0xc2, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
> > > > > > + [5] = { 0xc3, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
> > > > > > + [6] = { 0x87, 0x02, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
> > > > > > + [7] = { 0x87, 0x01, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
> > > > > > +};
> > > > > > +
> > > > > > +/* amd_pmc_perf_hw_id depends on these being the same size */
> > > > > > +static_assert(ARRAY_SIZE(amd_event_mapping) ==
> > > > > > +      ARRAY_SIZE(amd_f17h_event_mapping));
> > > > > > +
> > > > > >   static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
> > > > > >   {
> > > > > >           struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
> > > > > > @@ -130,17 +146,23 @@ static unsigned amd_find_arch_event(struct kvm_pmu *pmu,
> > > > > >                                       u8 event_select,
> > > > > >                                       u8 unit_mask)
> > > > > >   {
> > > > > > + struct kvm_event_hw_type_mapping *event_mapping;
> > > > > >           int i;
> > > > > > + if (guest_cpuid_family(pmc->vcpu) >= 0x17)
> > > > > > +         event_mapping = amd_f17h_event_mapping;
> > > > > > + else
> > > > > > +         event_mapping = amd_event_mapping;
> > > > > > +
> > > > > >           for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
> > > > > > -         if (amd_event_mapping[i].eventsel == event_select
> > > > > > -             && amd_event_mapping[i].unit_mask == unit_mask)
> > > > > > +         if (event_mapping[i].eventsel == event_select
> > > > > > +             && event_mapping[i].unit_mask == unit_mask)
> > > > > >                           break;
> > > > > >           if (i == ARRAY_SIZE(amd_event_mapping))
> > > > > >                   return PERF_COUNT_HW_MAX;
> > > > > > - return amd_event_mapping[i].event_type;
> > > > > > + return event_mapping[i].event_type;
> > > > > >   }
> > > > > >   /* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
> > > > >
> > > > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > >
> > > > > Thanks,
> > > > >
> > > > > Paolo
> > > > >
> > > >
> > > > Wait, how was this tested?
> > > >
> > > > It breaks the build:
> > > >
> > > > arch/x86/kvm/pmu_amd.c: In function ‘amd_find_arch_event’:
> > > > arch/x86/kvm/pmu_amd.c:152:32: error: ‘pmc’ undeclared (first use in this function); did you mean ‘pmu’?
> > > >   152 |         if (guest_cpuid_family(pmc->vcpu) >= 0x17)
> > > >       |                                ^~~
> > > >       |                                pmu
> > > >
> > > >
> > > > I'll do the obvious fixup, but this is odd.  Always at least test-build
> > > > your changes...
> > >
> > > Hm, no, I don't know what the correct fix is here.  I'll wait for a
> > > fixed up (and tested) patch to be resubmited please.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Sorry, I tested an earlier version without the guest_cpuid_family fix
> > that Paolo made when he committed my patch, and of course that's the
> > hang up here. I'll get this fixed up for you.
> >
> > - Kyle
> 
> Hi Greg,
> 
> I've just sent a backport of Like Xu's "KVM: x86/pmu: Refactoring
> find_arch_event() to pmc_perf_hw_id()" for 5.4. It had to be trivially
> adjusted because kvm_x86_ops is a pointer on pre-5.7 kernels.
> 
> After you apply that, the patch that you applied here for 5.10 will
> apply to 5.4.

I do not know what I "applied here" at all, sorry.  Please realize we
deal with hundreds of stable patches a week.

Please send me a patch series of what I needs to be applied and I will
be glad to queue them up.

thanks,

greg k-h
