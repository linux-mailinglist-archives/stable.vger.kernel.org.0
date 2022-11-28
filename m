Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2269363AECC
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbiK1RYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbiK1RYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:24:49 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BD51F623
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 09:24:48 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id b12so18052924wrn.2
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 09:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RLQGyNQToAQOqzdT6njwVnHNhOX2lYC7Tz9OdPpVdh8=;
        b=lKbcZRnCAiijH6V6tB7Kp7WQkDV5SieT/CyG6h3CJbUhNLHYGMGWFIdTUt1ykwWcF0
         DDAcqwfmVlSYYbnVJSLtSPs5JEtKUG5WngT4dlh533Tf+BkP9rL1MLLIDo+Xcak4fvC3
         RiBWuLWsTuwkk6iJkko+eD+aiJalVReeN6ieKVthfqB79n4GToCiUXP2BQX4AaQl8ud5
         Wq+uJVpFVTXfpw0jNPUGhg6/g0kKax46zjwfkUabEOUVK+EvP8MCgIoVgnCxJGTxd7Sb
         /fi8vl6n0l/ksnZadCiGfUMhCFK6eNFyiFERQnUV2eiOeHAIY75iug/mNBIpAcyZd98s
         mueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RLQGyNQToAQOqzdT6njwVnHNhOX2lYC7Tz9OdPpVdh8=;
        b=W9Vk2kr5Bcx+F4WbPigYDlpNfQwVjKs1DasWnLyDXj+jcbBPAG4p1TxLV9uGg2U0PA
         6AvpXSvDi8zmdNNjUh2rVUhUeTOKPU5dawbsVXDjduxBRhlELkxpuFCnahy6yr5IbRYO
         +i6HZi30I53CMK0Ft2U8/IZCERVtIo/Q91hjktfupZbPwqSfLw4llGcHZK1i0KjCCfle
         A5SPtd1NubZwZ7EKrqGUlYxe1A6o0vCrcbT+5LW69GnHQ3IgCzZwEqrWgw1iv7Z+e6ya
         jE7VSzG1YfQBQXVgigcyUh5+nl+OtBW7ckHJP70q036Iui4Aeu2G1OOOpjHGv6emLTnc
         MkkA==
X-Gm-Message-State: ANoB5pkT6060KZG5MPz8JfaCHc8z0ArmfQYKTPuYEejuGj+ZVdAk2qSU
        EBB6DcXI8k/yTbXDSmzCJo53NKEZ8HF7Aw==
X-Google-Smtp-Source: AA0mqf73u7YTUN38d47tkMCgJ3HTwaL3lwmPkMs3bb23ZnTlngKbUmsjZC/DaNjwgyOfZfqB1olFNg==
X-Received: by 2002:adf:f54d:0:b0:242:9e6:ea4d with SMTP id j13-20020adff54d000000b0024209e6ea4dmr8748434wrp.251.1669656287112;
        Mon, 28 Nov 2022 09:24:47 -0800 (PST)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id n38-20020a05600c3ba600b003c6bbe910fdsm26696417wms.9.2022.11.28.09.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 09:24:46 -0800 (PST)
Date:   Mon, 28 Nov 2022 17:24:42 +0000
From:   Vincent Donnefort <vdonnefort@google.com>
To:     Greg KH <gregkh@kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: pkvm: Fixup boot mode to reflect that the
 kernel resumes from EL1
Message-ID: <Y4Tu2tdEBEvrFaAJ@google.com>
References: <20221108100138.3887862-1-vdonnefort@google.com>
 <Y4TgCOFgjMWuTTWe@google.com>
 <Y4Ttk97B2Cpr9/yC@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4Ttk97B2Cpr9/yC@kroah.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 28, 2022 at 06:19:15PM +0100, Greg KH wrote:
> On Mon, Nov 28, 2022 at 04:21:28PM +0000, Vincent Donnefort wrote:
> > On Tue, Nov 08, 2022 at 10:01:38AM +0000, Vincent Donnefort wrote:
> > > From: Marc Zyngier <maz@kernel.org>
> > > 
> > > The kernel has an awfully complicated boot sequence in order to cope
> > > with the various EL2 configurations, including those that "enhanced"
> > > the architecture. We go from EL2 to EL1, then back to EL2, staying
> > > at EL2 if VHE capable and otherwise go back to EL1.
> > > 
> > > Here's a paracetamol tablet for you.
> > > 
> > > The cpu_resume path follows the same logic, because coming up with
> > > two versions of a square wheel is hard.
> > > 
> > > However, things aren't this straightforward with pKVM, as the host
> > > resume path is always proxied by the hypervisor, which means that
> > > the kernel is always entered at EL1. Which contradicts what the
> > > __boot_cpu_mode[] array contains (it obviously says EL2).
> > > 
> > > This thus triggers a HVC call from EL1 to EL2 in a vain attempt
> > > to upgrade from EL1 to EL2 VHE, which we are, funnily enough,
> > > reluctant to grant to the host kernel. This is also completely
> > > unexpected, and puzzles your average EL2 hacker.
> > > 
> > > Address it by fixing up the boot mode at the point the host gets
> > > deprivileged. is_hyp_mode_available() and co already have a static
> > > branch to deal with this, making it pretty safe.
> > > 
> > > Cc: <stable@vger.kernel.org> # 5.15+
> > > Reported-by: Vincent Donnefort <vdonnefort@google.com>
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > Tested-by: Vincent Donnefort <vdonnefort@google.com>
> > > 
> > > --- 
> > > 
> > > This patch doesn't have an upstream version. It's been fixed by the side
> > > effect of another upstream patch. see conversation [1]
> > > 
> > > [1] https://lore.kernel.org/all/20221011165400.1241729-1-maz@kernel.org/
> > > 
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 4cb265e15361..3fe816c244ce 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -2000,6 +2000,17 @@ static int pkvm_drop_host_privileges(void)
> > >  	 * once the host stage 2 is installed.
> > >  	 */
> > >  	static_branch_enable(&kvm_protected_mode_initialized);
> > > +
> > > +	/*
> > > +	 * Fixup the boot mode so that we don't take spurious round
> > > +	 * trips via EL2 on cpu_resume. Flush to the PoC for a good
> > > +	 * measure, so that it can be observed by a CPU coming out of
> > > +	 * suspend with the MMU off.
> > > +	 */
> > > +	__boot_cpu_mode[0] = __boot_cpu_mode[1] = BOOT_CPU_MODE_EL1;
> > > +	dcache_clean_poc((unsigned long)__boot_cpu_mode,
> > > +			 (unsigned long)(__boot_cpu_mode + 2));
> > > +
> > >  	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
> > >  	return ret;
> > >  }
> > > -- 
> > > 2.38.1.431.g37b22c650d-goog
> > >
> > 
> > Hi Greg,
> > 
> > Any chance to pick this fix for 5.15?
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>

Sadly this patch doesn't have an upstream version equivalent. The reason is it's
been fixed as a side effect of another feature introduction, hence the
stable-only fix made by Marc. [1]

Not sure how to handle that case.
