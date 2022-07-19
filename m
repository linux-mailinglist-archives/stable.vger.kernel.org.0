Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAB857A2C6
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 17:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239128AbiGSPPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 11:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239321AbiGSPPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 11:15:34 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E57550C3;
        Tue, 19 Jul 2022 08:15:24 -0700 (PDT)
Received: from zn.tnic (p200300ea97297609329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9729:7609:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A7AEA1EC050F;
        Tue, 19 Jul 2022 17:15:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1658243715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=19tyF3hcmEXgvgnp46r5wyMNhL+B65efr3ypQp+I6Lc=;
        b=bgi94v/2BF7PUNqG8xmemrFZBnufFiYdPdUaAnPFw21wpY2AenhYjpMtVIXjal1w+mzOf/
        /mJpaBLsrk1CG9OmmXyV1Mk42F2fLkopvrYioaM30O2wLjdfezvPIdmQCQWST61U2bwz0K
        8qYCxwZHFYMHLQZMFQVOq4Y1vdDkO/E=
Date:   Tue, 19 Jul 2022 17:15:11 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, brchuckz@netscape.net,
        jbeulich@suse.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: decouple pat and mtrr handling
Message-ID: <YtbKf51S4lTaziKm@zn.tnic>
References: <20220715142549.25223-1-jgross@suse.com>
 <20220715142549.25223-4-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220715142549.25223-4-jgross@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 04:25:49PM +0200, Juergen Gross wrote:
> Today PAT is usable only with MTRR being active, with some nasty tweaks
> to make PAT usable when running as Xen PV guest, which doesn't support
> MTRR.
> 
> The reason for this coupling is, that both, PAT MSR changes and MTRR
> changes, require a similar sequence and so full PAT support was added
> using the already available MTRR handling.
> 
> Xen PV PAT handling can work without MTRR, as it just needs to consume
> the PAT MSR setting done by the hypervisor without the ability and need
> to change it. This in turn has resulted in a convoluted initialization
> sequence and wrong decisions regarding cache mode availability due to
> misguiding PAT availability flags.
> 
> Fix all of that by allowing to use PAT without MTRR and by adding an
> environment dependent PAT init function.

Aha, there's the explanation I was looking for.

> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 0a1bd14f7966..3edfb779dab5 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -2408,8 +2408,8 @@ void __init cache_bp_init(void)
>  {
>  	if (IS_ENABLED(CONFIG_MTRR))
>  		mtrr_bp_init();
> -	else
> -		pat_disable("PAT support disabled because CONFIG_MTRR is disabled in the kernel.");
> +
> +	pat_cpu_init();
>  }
>  
>  void cache_ap_init(void)
> @@ -2417,7 +2417,8 @@ void cache_ap_init(void)
>  	if (cache_aps_delayed_init)
>  		return;
>  
> -	mtrr_ap_init();
> +	if (!mtrr_ap_init())
> +		pat_ap_init_nomtrr();
>  }

So I'm reading this as: if it couldn't init AP's MTRRs, init its PAT.

But currently, the code sets the MTRRs for the delayed case or when the
CPU is not online by doing ->set_all and in there it sets first MTRRs
and then PAT.

I think the code above should simply try the two things, one after the
other, independently from one another.

And I see you've added another stomp machine call for PAT only.

Now, what I think the design of all this should be, is:

you have a bunch of things you need to do at each point:

* cache_ap_init

* cache_aps_init

* ...

Now, in each those, you look at whether PAT or MTRR is supported and you
do only those which are supported.

Also, the rendezvous handler should do:

	if MTRR:
		do MTRR specific stuff

	if PAT:
		do PAT specific stuff

This way you have clean definitions of what needs to happen when and you
also do *only* the things that the platform supports, by keeping the
proper order of operations - I believe MTRRs first and then PAT.

This way we'll get rid of that crazy maze of who calls what and when.

But first we need to define those points where stuff needs to happen and
then for each point define what stuff needs to happen.

How does that sound?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
