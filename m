Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB43F74E6
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 14:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfKKNaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 08:30:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28446 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727216AbfKKNai (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 08:30:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573479037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=rcIPx/5ogsYeXG7OzIvC6+U0YsBC2zFglCGdLOXfT5M=;
        b=dcs045wzc/+XsBgMH7DxUi8/fvuRp4KASdkepL2ixaqvXKZyEX6dMrL21IgDhSNtd/4i+5
        LFdQTDkTtwn91HN5Z3pu0FjiPtvLgY28tYNYXKVj3r4iiQ6AlMvxbzewsQN/hldutfdO7u
        y3ck5Z/FeSjwQLO6z6+ugeMpGbAJhOw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-x4XZhbQBNryVCCi-1kmrFA-1; Mon, 11 Nov 2019 08:30:34 -0500
Received: by mail-wm1-f70.google.com with SMTP id f16so6858679wmb.2
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 05:30:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e+cTauSYxvUARdKLAc5A7RMT6Ok2c2ubkvwx/ni9mok=;
        b=Km35+f0EUhLmmjxVSmSJcMx0+KW9n58FQTw3kizkz+lsuIOpY75XSIE+zkhjJdsaZO
         Xy8aNlbecd2Y63MWddsCSsvRwg3rRhgZb038A75JtEZae/RS27yXRYmr9U5I9TWtMMxj
         JzIZyy017q9ZnGgVMlRqZUCcKkgPPwaY/iPfDUt+L6ooQ+J0t6BcBlBPguTjKPEU7Axn
         1MRpeNCuUSmKxYNwT6vvrDiNsxIW9UF0elHt039Lnaj6M/C8CdD1cdCXII0YC47ivNaG
         OG9S5sWlEVVbNJ9TYQp3IY8BZFFCS3IUMUEoQy0Cy+z8ZDgvB9wgrroR4GgQe59XYLcP
         32Gg==
X-Gm-Message-State: APjAAAUpYIHvU3VFDXDMNggZEEJaXuMi+igXmTEqn1lL6Ns5eejcYl21
        6nacxpm6a9MTi1bQWM1iISTPFXKE/mvq7F5ET/jfEJ+kIU0gzVEEdNmjqI2kkzNMkNzv4EmumtO
        tBT/YGcaDetCSjLjP
X-Received: by 2002:a1c:814b:: with SMTP id c72mr21525083wmd.167.1573479033173;
        Mon, 11 Nov 2019 05:30:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqwp88fUA9D9DG2jgjImcScFjHKuZOp3iwIpo8VnWaraYdMBrBUgxC9lbkl1AvxOj6Xvb+BXbg==
X-Received: by 2002:a1c:814b:: with SMTP id c72mr21525041wmd.167.1573479032767;
        Mon, 11 Nov 2019 05:30:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id m15sm17278510wrq.97.2019.11.11.05.30.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 05:30:32 -0800 (PST)
Subject: Re: [PATCH v2] KVM: X86: Fix initialization of MSR
 lists(msrs_to_save[], emulated_msrs[] and msr_based_features[])
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20191106063520.1915-1-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <72f9e7f2-d57f-7c63-3bb1-34f0353d5aa6@redhat.com>
Date:   Mon, 11 Nov 2019 14:30:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191106063520.1915-1-chenyi.qiang@intel.com>
Content-Language: en-US
X-MC-Unique: x4XZhbQBNryVCCi-1kmrFA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/11/19 07:35, Chenyi Qiang wrote:
> The three MSR lists(msrs_to_save[], emulated_msrs[] and
> msr_based_features[]) are global arrays of kvm.ko, which are
> adjusted (copy supported MSRs forward to override the unsupported MSRs)
> when insmod kvm-{intel,amd}.ko, but it doesn't reset these three arrays
> to their initial value when rmmod kvm-{intel,amd}.ko. Thus, at the next
> installation, kvm-{intel,amd}.ko will do operations on the modified
> arrays with some MSRs lost and some MSRs duplicated.
>=20
> So define three constant arrays to hold the initial MSR lists and
> initialize msrs_to_save[], emulated_msrs[] and msr_based_features[]
> based on the constant arrays.
>=20
> Cc: stable@vger.kernel.org
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v2:
>  - define initial MSR lists with static const.
>  - change the dynamic allocation of supported MSR lists to static allocat=
ion.
>=20
>  arch/x86/kvm/x86.c | 51 +++++++++++++++++++++++++---------------------
>  1 file changed, 28 insertions(+), 23 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 89621025577a..0b4b6db5b13f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1138,13 +1138,15 @@ EXPORT_SYMBOL_GPL(kvm_rdpmc);
>   * List of msr numbers which we expose to userspace through KVM_GET_MSRS
>   * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
>   *
> - * This list is modified at module load time to reflect the
> + * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features)
> + * extract the supported MSRs from the related const lists.
> + * msrs_to_save is selected from the msrs_to_save_all to reflect the
>   * capabilities of the host cpu. This capabilities test skips MSRs that =
are
> - * kvm-specific. Those are put in emulated_msrs; filtering of emulated_m=
srs
> + * kvm-specific. Those are put in emulated_msrs_all; filtering of emulat=
ed_msrs
>   * may depend on host virtualization features rather than host cpu featu=
res.
>   */
> =20
> -static u32 msrs_to_save[] =3D {
> +static const u32 msrs_to_save_all[] =3D {
>  =09MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
>  =09MSR_STAR,
>  #ifdef CONFIG_X86_64
> @@ -1185,9 +1187,10 @@ static u32 msrs_to_save[] =3D {
>  =09MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
>  };
> =20
> +static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
>  static unsigned num_msrs_to_save;
> =20
> -static u32 emulated_msrs[] =3D {
> +static const u32 emulated_msrs_all[] =3D {
>  =09MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
>  =09MSR_KVM_SYSTEM_TIME_NEW, MSR_KVM_WALL_CLOCK_NEW,
>  =09HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
> @@ -1226,7 +1229,7 @@ static u32 emulated_msrs[] =3D {
>  =09 * by arch/x86/kvm/vmx/nested.c based on CPUID or other MSRs.
>  =09 * We always support the "true" VMX control MSRs, even if the host
>  =09 * processor does not, so I am putting these registers here rather
> -=09 * than in msrs_to_save.
> +=09 * than in msrs_to_save_all.
>  =09 */
>  =09MSR_IA32_VMX_BASIC,
>  =09MSR_IA32_VMX_TRUE_PINBASED_CTLS,
> @@ -1245,13 +1248,14 @@ static u32 emulated_msrs[] =3D {
>  =09MSR_KVM_POLL_CONTROL,
>  };
> =20
> +static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
>  static unsigned num_emulated_msrs;
> =20
>  /*
>   * List of msr numbers which are used to expose MSR-based features that
>   * can be used by a hypervisor to validate requested CPU features.
>   */
> -static u32 msr_based_features[] =3D {
> +static const u32 msr_based_features_all[] =3D {
>  =09MSR_IA32_VMX_BASIC,
>  =09MSR_IA32_VMX_TRUE_PINBASED_CTLS,
>  =09MSR_IA32_VMX_PINBASED_CTLS,
> @@ -1276,6 +1280,7 @@ static u32 msr_based_features[] =3D {
>  =09MSR_IA32_ARCH_CAPABILITIES,
>  };
> =20
> +static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
>  static unsigned int num_msr_based_features;
> =20
>  static u64 kvm_get_arch_capabilities(void)
> @@ -5131,19 +5136,19 @@ static void kvm_init_msr_list(void)
>  =09unsigned i, j;
> =20
>  =09BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED !=3D 4,
> -=09=09=09 "Please update the fixed PMCs in msrs_to_save[]");
> +=09=09=09 "Please update the fixed PMCs in msrs_to_saved_all[]");
> =20
>  =09perf_get_x86_pmu_capability(&x86_pmu);
> =20
> -=09for (i =3D j =3D 0; i < ARRAY_SIZE(msrs_to_save); i++) {
> -=09=09if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
> +=09for (i =3D j =3D 0; i < ARRAY_SIZE(msrs_to_save_all); i++) {
> +=09=09if (rdmsr_safe(msrs_to_save_all[i], &dummy[0], &dummy[1]) < 0)
>  =09=09=09continue;
> =20
>  =09=09/*
>  =09=09 * Even MSRs that are valid in the host may not be exposed
>  =09=09 * to the guests in some cases.
>  =09=09 */
> -=09=09switch (msrs_to_save[i]) {
> +=09=09switch (msrs_to_save_all[i]) {
>  =09=09case MSR_IA32_BNDCFGS:
>  =09=09=09if (!kvm_mpx_supported())
>  =09=09=09=09continue;
> @@ -5171,17 +5176,17 @@ static void kvm_init_msr_list(void)
>  =09=09=09break;
>  =09=09case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B: {
>  =09=09=09if (!kvm_x86_ops->pt_supported() ||
> -=09=09=09=09msrs_to_save[i] - MSR_IA32_RTIT_ADDR0_A >=3D
> +=09=09=09=09msrs_to_save_all[i] - MSR_IA32_RTIT_ADDR0_A >=3D
>  =09=09=09=09intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
>  =09=09=09=09continue;
>  =09=09=09break;
>  =09=09case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
> -=09=09=09if (msrs_to_save[i] - MSR_ARCH_PERFMON_PERFCTR0 >=3D
> +=09=09=09if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=3D
>  =09=09=09    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>  =09=09=09=09continue;
>  =09=09=09break;
>  =09=09case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 1=
7:
> -=09=09=09if (msrs_to_save[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=3D
> +=09=09=09if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=3D
>  =09=09=09    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>  =09=09=09=09continue;
>  =09=09}
> @@ -5189,31 +5194,31 @@ static void kvm_init_msr_list(void)
>  =09=09=09break;
>  =09=09}
> =20
> -=09=09if (j < i)
> -=09=09=09msrs_to_save[j] =3D msrs_to_save[i];
> +=09=09if (j <=3D i)
> +=09=09=09msrs_to_save[j] =3D msrs_to_save_all[i];

J is always <=3D i, so we can remove the ifs.

>  =09=09j++;
>  =09}
>  =09num_msrs_to_save =3D j;
> =20
> -=09for (i =3D j =3D 0; i < ARRAY_SIZE(emulated_msrs); i++) {
> -=09=09if (!kvm_x86_ops->has_emulated_msr(emulated_msrs[i]))
> +=09for (i =3D j =3D 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
> +=09=09if (!kvm_x86_ops->has_emulated_msr(emulated_msrs_all[i]))
>  =09=09=09continue;
> =20
> -=09=09if (j < i)
> -=09=09=09emulated_msrs[j] =3D emulated_msrs[i];
> +=09=09if (j <=3D i)
> +=09=09=09emulated_msrs[j] =3D emulated_msrs_all[i];
>  =09=09j++;
>  =09}
>  =09num_emulated_msrs =3D j;
> =20
> -=09for (i =3D j =3D 0; i < ARRAY_SIZE(msr_based_features); i++) {
> +=09for (i =3D j =3D 0; i < ARRAY_SIZE(msr_based_features_all); i++) {
>  =09=09struct kvm_msr_entry msr;
> =20
> -=09=09msr.index =3D msr_based_features[i];
> +=09=09msr.index =3D msr_based_features_all[i];
>  =09=09if (kvm_get_msr_feature(&msr))
>  =09=09=09continue;
> =20
> -=09=09if (j < i)
> -=09=09=09msr_based_features[j] =3D msr_based_features[i];
> +=09=09if (j <=3D i)
> +=09=09=09msr_based_features[j] =3D msr_based_features_all[i];
>  =09=09j++;
>  =09}
>  =09num_msr_based_features =3D j;
>=20

Queued, thanks.

Paolo

