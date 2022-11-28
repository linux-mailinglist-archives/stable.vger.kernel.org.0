Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D0863AEBC
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbiK1RT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbiK1RTZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:19:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B64CC43
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 09:19:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D43E8B80E16
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 17:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EE0C433D7;
        Mon, 28 Nov 2022 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669655960;
        bh=GKrwFG47uuI68IwLnqCBvFNmxzWhCIAouRio/txqXsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cmzat6KSBj8xwnk1T6vwKP2jNRnAQU/UL6YRjoOjwo+RraNImg00WjuXMULGYhMbE
         mgYuqo2zif3ZUS+nASdY6c3/Z33Qs1/Qr4QmNDwdx/phA10Qam22Gb+unnLAM53c/o
         9C2a5vbsVd9KeZiv3ZeuIQACuhKcK7XlNqrEC6X1ddVHxrA6Jsa320KEbptgmB5jJx
         abISNwWovqC51K+50nyZkDLQncK6q1MUCQ8oz5GTIM6yU9IXxS3w0Y5WOln8IuQGTk
         mL2Qhn8SPH/w/wX++Y6tRWx3soTkST1GggRveyMYuOg59NQbqCiK8rmqiBnxYBvIXV
         oIdS8s/p9OC6A==
Date:   Mon, 28 Nov 2022 18:19:15 +0100
From:   Greg KH <gregkh@kernel.org>
To:     Vincent Donnefort <vdonnefort@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: pkvm: Fixup boot mode to reflect that the
 kernel resumes from EL1
Message-ID: <Y4Ttk97B2Cpr9/yC@kroah.com>
References: <20221108100138.3887862-1-vdonnefort@google.com>
 <Y4TgCOFgjMWuTTWe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4TgCOFgjMWuTTWe@google.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 28, 2022 at 04:21:28PM +0000, Vincent Donnefort wrote:
> On Tue, Nov 08, 2022 at 10:01:38AM +0000, Vincent Donnefort wrote:
> > From: Marc Zyngier <maz@kernel.org>
> > 
> > The kernel has an awfully complicated boot sequence in order to cope
> > with the various EL2 configurations, including those that "enhanced"
> > the architecture. We go from EL2 to EL1, then back to EL2, staying
> > at EL2 if VHE capable and otherwise go back to EL1.
> > 
> > Here's a paracetamol tablet for you.
> > 
> > The cpu_resume path follows the same logic, because coming up with
> > two versions of a square wheel is hard.
> > 
> > However, things aren't this straightforward with pKVM, as the host
> > resume path is always proxied by the hypervisor, which means that
> > the kernel is always entered at EL1. Which contradicts what the
> > __boot_cpu_mode[] array contains (it obviously says EL2).
> > 
> > This thus triggers a HVC call from EL1 to EL2 in a vain attempt
> > to upgrade from EL1 to EL2 VHE, which we are, funnily enough,
> > reluctant to grant to the host kernel. This is also completely
> > unexpected, and puzzles your average EL2 hacker.
> > 
> > Address it by fixing up the boot mode at the point the host gets
> > deprivileged. is_hyp_mode_available() and co already have a static
> > branch to deal with this, making it pretty safe.
> > 
> > Cc: <stable@vger.kernel.org> # 5.15+
> > Reported-by: Vincent Donnefort <vdonnefort@google.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Tested-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > --- 
> > 
> > This patch doesn't have an upstream version. It's been fixed by the side
> > effect of another upstream patch. see conversation [1]
> > 
> > [1] https://lore.kernel.org/all/20221011165400.1241729-1-maz@kernel.org/
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 4cb265e15361..3fe816c244ce 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -2000,6 +2000,17 @@ static int pkvm_drop_host_privileges(void)
> >  	 * once the host stage 2 is installed.
> >  	 */
> >  	static_branch_enable(&kvm_protected_mode_initialized);
> > +
> > +	/*
> > +	 * Fixup the boot mode so that we don't take spurious round
> > +	 * trips via EL2 on cpu_resume. Flush to the PoC for a good
> > +	 * measure, so that it can be observed by a CPU coming out of
> > +	 * suspend with the MMU off.
> > +	 */
> > +	__boot_cpu_mode[0] = __boot_cpu_mode[1] = BOOT_CPU_MODE_EL1;
> > +	dcache_clean_poc((unsigned long)__boot_cpu_mode,
> > +			 (unsigned long)(__boot_cpu_mode + 2));
> > +
> >  	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
> >  	return ret;
> >  }
> > -- 
> > 2.38.1.431.g37b22c650d-goog
> >
> 
> Hi Greg,
> 
> Any chance to pick this fix for 5.15?

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
