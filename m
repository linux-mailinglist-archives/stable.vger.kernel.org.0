Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1C05216B8
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242314AbiEJNRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242331AbiEJNPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:15:36 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFCB4132B
        for <stable@vger.kernel.org>; Tue, 10 May 2022 06:11:21 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id dk23so32864731ejb.8
        for <stable@vger.kernel.org>; Tue, 10 May 2022 06:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/5Je+gr1ANg5VIzz70gRjs0gYFd+rcTLXC1AqkpfTJY=;
        b=QXcbwtm5cMGu+zdPjzNWSbltKcj8bYl1I2/T145qoeJ1JDl/NUHtHJhyT9vs1rWljO
         nNUV8iz82uFserkIp57Q6K1BA88tOIQEEvL3ub6mKekQo+s+ewOQSU6YXzEY/Jl/jBln
         1DzZgk3dq9NqSwSF5orJVXoNVUYMM/KuLNAENesBpnLsG/zVJviikiDvgnu35OsrD94V
         Lor2UJ+t0lCse6cRJcwKLsCXsusEA06n0liRh2RO4dzBsM80rsrACzlwe0WMiTPi77lC
         Mg5Jqt1LNy3GPwceJKX+BX2jHXL9COhOU7xBxnVqicUkMMA3xkoYhMUwbpUdvRuM5zSO
         vsLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/5Je+gr1ANg5VIzz70gRjs0gYFd+rcTLXC1AqkpfTJY=;
        b=mbsRXM4zhCqlJdR6POvx4X3H+3gJTdvUEUYuZjb3Vq8Ua2W0KWuK7q04n9In+stT/K
         M9X0OkMDU2wI3WnLI0URm1C+TnpBwjYlOnV4HQgnPhNAQpFTKH9Ow0fUmbBepUSwdzHB
         b0uGWb+3RTnLc3me75wwjflLZJjpJUbYiTjlVHhAQbmfHwQC8m4wuAjaS8NTsRMGipif
         zHtE84gjSezRGw5/YZN0SJf/MajhU0Idkbfy/cScRjiipcmI1zs/MojZiBpI15DH/WVH
         b97z9I2VZIRNNR4ERvVDLWuQt/3PHH5pC4h2OlP1I2O2Z8RoJIjj+eq+VBXdxgq8tgTe
         YE1A==
X-Gm-Message-State: AOAM5339SiTwkHF0/w7BKeiv4/9iu8OXbwb5sC7AA01AX8D/i/25BltN
        JBzkskS4tiGjRPMxX87yJxq9flPF/66hHgvdtq3rQQ==
X-Google-Smtp-Source: ABdhPJy6IMSdsw0VypSVNtuIFwfbk17LxavWMVy6UACasvO5W/s4XuMHcpNu8Gz94e81MREVRqIHzqukETSaITe3mRc=
X-Received: by 2002:a17:906:3adb:b0:6b7:876c:d11b with SMTP id
 z27-20020a1709063adb00b006b7876cd11bmr19333476ejd.250.1652188280279; Tue, 10
 May 2022 06:11:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220508165434.119000-1-khuey@kylehuey.com> <29767a7d-d887-1a0c-296e-5bed220f1c9e@redhat.com>
 <YnpOZAfLdJ6cj5b9@kroah.com> <YnpOsDgrwCBsMs35@kroah.com>
In-Reply-To: <YnpOsDgrwCBsMs35@kroah.com>
From:   Kyle Huey <me@kylehuey.com>
Date:   Tue, 10 May 2022 06:11:06 -0700
Message-ID: <CAP045Aq6vJxMJaVFjAX7gqQkBbMRArZJhea3U6LJVQEQB9Ea4Q@mail.gmail.com>
Subject: Re: [PATCH 5.4] KVM: x86/svm: Account for family 17h event
 renumberings in amd_pmc_perf_hw_id
To:     Greg KH <gregkh@linuxfoundation.org>
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
        "Robert O'Callahan" <robert@ocallahan.org>,
        Keno Fischer <keno@juliacomputing.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 4:38 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, May 10, 2022 at 01:37:08PM +0200, Greg KH wrote:
> > On Mon, May 09, 2022 at 01:41:20PM +0200, Paolo Bonzini wrote:
> > > On 5/8/22 18:54, Kyle Huey wrote:
> > > > From: Kyle Huey <me@kylehuey.com>
> > > >
> > > > commit 5eb849322d7f7ae9d5c587c7bc3b4f7c6872cd2f upstream
> > > >
> > > > Zen renumbered some of the performance counters that correspond to =
the
> > > > well known events in perf_hw_id. This code in KVM was never updated=
 for
> > > > that, so guest that attempt to use counters on Zen that correspond =
to the
> > > > pre-Zen perf_hw_id values will silently receive the wrong values.
> > > >
> > > > This has been observed in the wild with rr[0] when running in Zen 3
> > > > guests. rr uses the retired conditional branch counter 00d1 which i=
s
> > > > incorrectly recognized by KVM as PERF_COUNT_HW_STALLED_CYCLES_BACKE=
ND.
> > > >
> > > > [0] https://rr-project.org/
> > > >
> > > > Signed-off-by: Kyle Huey <me@kylehuey.com>
> > > > Message-Id: <20220503050136.86298-1-khuey@kylehuey.com>
> > > > Cc: stable@vger.kernel.org
> > > > [Check guest family, not host. - Paolo]
> > > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > [Backport to 5.4: adjusted context]
> > > > Signed-off-by: Kyle Huey <me@kylehuey.com>
> > > > ---
> > > >   arch/x86/kvm/pmu_amd.c | 28 +++++++++++++++++++++++++---
> > > >   1 file changed, 25 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
> > > > index 6bc656abbe66..3ccfd1abcbad 100644
> > > > --- a/arch/x86/kvm/pmu_amd.c
> > > > +++ b/arch/x86/kvm/pmu_amd.c
> > > > @@ -44,6 +44,22 @@ static struct kvm_event_hw_type_mapping amd_even=
t_mapping[] =3D {
> > > >           [7] =3D { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEN=
D },
> > > >   };
> > > > +/* duplicated from amd_f17h_perfmon_event_map. */
> > > > +static struct kvm_event_hw_type_mapping amd_f17h_event_mapping[] =
=3D {
> > > > + [0] =3D { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
> > > > + [1] =3D { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
> > > > + [2] =3D { 0x60, 0xff, PERF_COUNT_HW_CACHE_REFERENCES },
> > > > + [3] =3D { 0x64, 0x09, PERF_COUNT_HW_CACHE_MISSES },
> > > > + [4] =3D { 0xc2, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
> > > > + [5] =3D { 0xc3, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
> > > > + [6] =3D { 0x87, 0x02, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
> > > > + [7] =3D { 0x87, 0x01, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
> > > > +};
> > > > +
> > > > +/* amd_pmc_perf_hw_id depends on these being the same size */
> > > > +static_assert(ARRAY_SIZE(amd_event_mapping) =3D=3D
> > > > +      ARRAY_SIZE(amd_f17h_event_mapping));
> > > > +
> > > >   static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_ty=
pe type)
> > > >   {
> > > >           struct kvm_vcpu *vcpu =3D pmu_to_vcpu(pmu);
> > > > @@ -130,17 +146,23 @@ static unsigned amd_find_arch_event(struct kv=
m_pmu *pmu,
> > > >                                       u8 event_select,
> > > >                                       u8 unit_mask)
> > > >   {
> > > > + struct kvm_event_hw_type_mapping *event_mapping;
> > > >           int i;
> > > > + if (guest_cpuid_family(pmc->vcpu) >=3D 0x17)
> > > > +         event_mapping =3D amd_f17h_event_mapping;
> > > > + else
> > > > +         event_mapping =3D amd_event_mapping;
> > > > +
> > > >           for (i =3D 0; i < ARRAY_SIZE(amd_event_mapping); i++)
> > > > -         if (amd_event_mapping[i].eventsel =3D=3D event_select
> > > > -             && amd_event_mapping[i].unit_mask =3D=3D unit_mask)
> > > > +         if (event_mapping[i].eventsel =3D=3D event_select
> > > > +             && event_mapping[i].unit_mask =3D=3D unit_mask)
> > > >                           break;
> > > >           if (i =3D=3D ARRAY_SIZE(amd_event_mapping))
> > > >                   return PERF_COUNT_HW_MAX;
> > > > - return amd_event_mapping[i].event_type;
> > > > + return event_mapping[i].event_type;
> > > >   }
> > > >   /* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
> > >
> > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > >
> > > Thanks,
> > >
> > > Paolo
> > >
> >
> > Wait, how was this tested?
> >
> > It breaks the build:
> >
> > arch/x86/kvm/pmu_amd.c: In function =E2=80=98amd_find_arch_event=E2=80=
=99:
> > arch/x86/kvm/pmu_amd.c:152:32: error: =E2=80=98pmc=E2=80=99 undeclared =
(first use in this function); did you mean =E2=80=98pmu=E2=80=99?
> >   152 |         if (guest_cpuid_family(pmc->vcpu) >=3D 0x17)
> >       |                                ^~~
> >       |                                pmu
> >
> >
> > I'll do the obvious fixup, but this is odd.  Always at least test-build
> > your changes...
>
> Hm, no, I don't know what the correct fix is here.  I'll wait for a
> fixed up (and tested) patch to be resubmited please.
>
> thanks,
>
> greg k-h

Sorry, I tested an earlier version without the guest_cpuid_family fix
that Paolo made when he committed my patch, and of course that's the
hang up here. I'll get this fixed up for you.

- Kyle
