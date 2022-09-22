Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C555E6C8F
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 22:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbiIVUBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 16:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiIVUBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 16:01:22 -0400
X-Greylist: delayed 604 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 22 Sep 2022 13:00:30 PDT
Received: from rhlx01.hs-esslingen.de (rhlx01.hs-esslingen.DE [IPv6:2001:7c0:700::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA0836781;
        Thu, 22 Sep 2022 13:00:30 -0700 (PDT)
Received: by rhlx01.hs-esslingen.de (Postfix, from userid 102)
        id A8BA6277FBA8; Thu, 22 Sep 2022 21:42:15 +0200 (CEST)
Date:   Thu, 22 Sep 2022 21:42:15 +0200
From:   Andreas Mohr <andi@lisas.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     K Prateek Nayak <kprateek.nayak@amd.com>,
        linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, bp@alien8.de, tglx@linutronix.de,
        andi@lisas.de, puwen@hygon.cn, mario.limonciello@amd.com,
        peterz@infradead.org, rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Message-ID: <Yyy6l94G0O2B7Yh1@rhlx01.hs-esslingen.de>
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <20e78a49-25df-c83d-842e-1d624655cfd7@intel.com>
 <0885eecb-042f-3b74-2965-7d657de59953@amd.com>
 <88c17568-8694-940a-0f1f-9d345e8dcbdb@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <88c17568-8694-940a-0f1f-9d345e8dcbdb@intel.com>
X-Priority: none
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Sep 22, 2022 at 10:01:46AM -0700, Dave Hansen wrote:
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 16a1663d02d4..9f40917c49ef 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -531,10 +531,27 @@ static void wait_for_freeze(void)
>  	/* No delay is needed if we are in guest */
>  	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
>  		return;
> +	/*
> +	 * Modern (>=Nehalem) Intel systems use ACPI via intel_idle,
> +	 * not this code.  Assume that any Intel systems using this
> +	 * are ancient and may need the dummy wait.  This also assumes
> +	 * that the motivating chipset issue was Intel-only.
> +	 */
> +	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> +		return;
>  #endif
> -	/* Dummy wait op - must do something useless after P_LVL2 read
> -	   because chipsets cannot guarantee that STPCLK# signal
> -	   gets asserted in time to freeze execution properly. */

16 years ago,
I did my testing on a VIA 8233/8235 chipset (AMD Athlon/Duron) system......
(plus reading VIA spec PDFs which mentioned "STPCLK#" etc.).




AFAIR I was doing kernel profiling (via oprofile, IIRC)
for painful performance hotspots (read: I/O accesses etc.), and
this was one resulting place which I stumbled over.
And if I'm not completely mistaken,
that dummy wait I/O op *was* needed (else "nice" effects)
on my system (put loud and clear: *non*-Intel).



So one can see where my profiling effort went
(*optimizing* things, not degrading them)
--> hints that current Zen3-originating effort is not
about a regression in the "regression bug" sense -
merely a (albeit rather appreciable/sizeable... congrats!)
performance deterioration vs.
an optimal (currently non-achieved) software implementation state
(also: of PORT-based handling [vs. MWAIT], mind you!).


I still have that VIA hardware, but inactive
(had the oh-so-usual capacitors issue :( ).


Sorry for sabotaging your current fix efforts ;-) -
but thank you very much for your work/discussion
in this very central/hotpath area! (this extends to all of you...)

Greetings

Andreas Mohr
