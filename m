Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B88D6CCD4E
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 00:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjC1WhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 18:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjC1WhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 18:37:12 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291131BEF
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:37:11 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a19cf1b8ddso61545ad.0
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680043030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G8/ShPdlrxP6qoJ+7uZdUIPgjUJdB7QJCFSyrMp059E=;
        b=KNXZEz2ZEMKAPaLwXU1Kki9OMtoysRO3T/RzTvfWh8XZWMaXOvNcM+wkeIC6dtJ5TZ
         wTY38lxLtmw8mrr4IjrM9qXZyZhnutJpWJ4GLMkSO9JPQQvPYSqvJ/Ef9HTP7ows7GwC
         +wCiGO226xh36SCvNe5K6HQNjhM1NpqN8+C4AZ99WRWY8o5BZCAzJMF7m0QbOTku+T3t
         jxDIXvHh15Rwj1k7rmYNIMw9UfJvqVv3kZGby/yuvyj4v++AD28gU8U4fVaHC0vwMcqN
         yVvYhtDncbccjAfuVE0IpBr22ScOjcjx9bzTf2Z/jiUKCWvH+DuaTbhemEhUAp/uCQgF
         LrKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680043030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G8/ShPdlrxP6qoJ+7uZdUIPgjUJdB7QJCFSyrMp059E=;
        b=DvG3v/ziaIV2Lb9jYqhhT2y6F6wB4fqHtT47vApYsZ4OljSfwe+dolluWoJoVLLjz5
         tQZg7jJZFn0dnutH3vXDJZ0fGQsdU5Q6cuGUTJnw5IYB8/Pz293p4ZNhD+4pAnJXdCa/
         ZtZByG6xs//9ZL9SbCgJb8lYh+k48izIZ4rmLbCXZVrCJTxS0DgP/Cuhpr6U5eSiOiHz
         UmUGendGRX8TMmuWRQa2O3jwSUqiGy8qYDgVbxwwREvUhY23QKID7JQMfhbogOgW44V3
         RASp0+UXNKgNrYHIFHA4vJYQjbuyZvjwhjZ1kkd1sDh9j4U3ByJCgLjPkm7MuD4rxXld
         XLuw==
X-Gm-Message-State: AAQBX9cuA45JmNWgzA+drVi/o9bKLDl4xokDe9UedWQQNjv0v6TdUlll
        xf9hnZoEBaUOgCpzLO8G142MaQ==
X-Google-Smtp-Source: AKy350YCoGK/+fC7AlbxKOkWGrBOSv48LQpBuyFHfbSM2pf0T1HtCbEr1VNX7X89EIsR+5FL52xqUw==
X-Received: by 2002:a17:902:7616:b0:1a2:185a:cf7 with SMTP id k22-20020a170902761600b001a2185a0cf7mr32108pll.9.1680043030342;
        Tue, 28 Mar 2023 15:37:10 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id l62-20020a632541000000b004fb10399da2sm20483906pgl.56.2023.03.28.15.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 15:37:09 -0700 (PDT)
Date:   Tue, 28 Mar 2023 15:37:05 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v1] KVM: arm64: PMU: Restore the guest's EL0 event
 counting after migration
Message-ID: <20230328223705.3thlifihm6q3wfcm@google.com>
References: <20230328034725.2051499-1-reijiw@google.com>
 <86pm8tw2ts.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86pm8tw2ts.wl-maz@kernel.org>
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On Tue, Mar 28, 2023 at 12:08:31PM +0100, Marc Zyngier wrote:
> On Tue, 28 Mar 2023 04:47:25 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> > 
> > Currently, with VHE, KVM enables the EL0 event counting for the
> > guest on vcpu_load() or KVM enables it as a part of the PMU
> > register emulation process, when needed.  However, in the migration
> > case (with VHE), the same handling is lacking.  So, enable it on the
> > first KVM_RUN with VHE (after the migration) when needed.
> 
> It wasn't completely clear to me how the migration case was affected
> by this until I started digging into the call stack:
> 
> At load-time, the PMCR_EL0 effects haven't been propagated yet (the
> events haven't been created, as this is what kvm_pmu_handle_pmcr()
> does on first run). So there is an ordering inversion between
> kvm_pmu_handle_pmcr() and kvm_vcpu_pmu_restore_guest().
> 
> Moving the latter call into the former fixes the issue, completely
> emulating an extra write to PMCR_EL0.
> 
> I think it would be worth capturing some of the above in the commit
> message so that it doesn't get lost...

I agree with that. I will add the explanation in the commit message,
and will post v2.

> 
> > 
> > Fixes: d0c94c49792c ("KVM: arm64: Restore PMU configuration on first run")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/pmu-emul.c | 1 +
> >  arch/arm64/kvm/sys_regs.c | 1 -
> >  2 files changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index c243b10f3e15..5eca0cdd961d 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -558,6 +558,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
> >  		for_each_set_bit(i, &mask, 32)
> >  			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
> >  	}
> > +	kvm_vcpu_pmu_restore_guest(vcpu);
> >  }
> >  
> >  static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 1b2c161120be..34688918c811 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -794,7 +794,6 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >  		if (!kvm_supports_32bit_el0())
> >  			val |= ARMV8_PMU_PMCR_LC;
> >  		kvm_pmu_handle_pmcr(vcpu, val);
> > -		kvm_vcpu_pmu_restore_guest(vcpu);
> >  	} else {
> >  		/* PMCR.P & PMCR.C are RAZ */
> >  		val = __vcpu_sys_reg(vcpu, PMCR_EL0)
> 
> With the nitpicking above addressed, and should this go into 6.3 as a
> fix:
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>

Thank you!
Reiji


> 
> I can otherwise take it into 6.4, depending on what Oliver decides to
> do.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
