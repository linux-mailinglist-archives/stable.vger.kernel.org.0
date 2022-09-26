Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAE05EA7B2
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 15:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiIZNzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 09:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235122AbiIZNyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 09:54:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786A580519;
        Mon, 26 Sep 2022 05:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jOpbznQq1TexzS0cQB6vYt4+4yFj1cmjMb21VcAwnhk=; b=o/sYytLUDM+Vd1vccnhn2XqfHV
        f6OSdgpiDrbeBWn8ZBEegKKdGzSsdwYXq/KS4EW87EJEVH6wuwN43+curv1WaQ0azzbam0Dr2VfVN
        YhAtSfbpdw1CQ+SzSUULHaUQuwDS6IC3C/y5016A986PdHReO8D/CxioWTwqR0J+zBlHQOq+2YfNG
        ck+0O9CPWYGxjYlABBytMWWeBPmD05YWVZsD4PtSA0be5/ZOwBQ4mtwpz6viZn/g8qM3vlUx6NN9y
        2vG+hDLF/JkAntNvRO8SbIoPSZfGrysx+j61m5RbpTw1aNkY9W6K+5HfeovazTCiUrD8XZIu6Hivg
        kAonF4JA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ocmu1-00AQi8-8Q; Mon, 26 Sep 2022 12:08:01 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A6FEE3015B5;
        Mon, 26 Sep 2022 14:07:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8FC5429A13691; Mon, 26 Sep 2022 14:07:56 +0200 (CEST)
Date:   Mon, 26 Sep 2022 14:07:56 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     K Prateek Nayak <kprateek.nayak@amd.com>
Cc:     linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, bp@alien8.de, tglx@linutronix.de,
        andi@lisas.de, puwen@hygon.cn, mario.limonciello@amd.com,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] x86,acpi: Limit "Dummy wait" workaround to older AMD
 and Intel processors
Message-ID: <YzGWHMIsD7RBhEP+@hirez.programming.kicks-ass.net>
References: <20220923153801.9167-1-kprateek.nayak@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923153801.9167-1-kprateek.nayak@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 23, 2022 at 09:08:01PM +0530, K Prateek Nayak wrote:
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index ef4775c6db01..fcd3617ed315 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -460,5 +460,6 @@
>  #define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
>  #define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
>  #define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
> +#define X86_BUG_STPCLK			X86_BUG(29) /* STPCLK# signal does not get asserted in time during IOPORT based C-state entry */
>  
>  #endif /* _ASM_X86_CPUFEATURES_H */
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 48276c0e479d..8cb5887a53a3 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -988,6 +988,18 @@ static void init_amd(struct cpuinfo_x86 *c)
>  	if (!cpu_has(c, X86_FEATURE_XENPV))
>  		set_cpu_bug(c, X86_BUG_SYSRET_SS_ATTRS);
>  
> +	/*
> +	 * CPUs based on the Zen microarchitecture (Fam 17h onward) can
> +	 * guarantee that STPCLK# signal is asserted in time after the
> +	 * P_LVL2 read to freeze execution after an IOPORT based C-state
> +	 * entry. Among the older AMD processors, there has been at least
> +	 * one report of an AMD Athlon processor on a VIA chipset
> +	 * (circa 2006) having this issue. Mark all these older AMD
> +	 * processor families as being affected.
> +	 */
> +	if (c->x86 < 0x17)
> +		set_cpu_bug(c, X86_BUG_STPCLK);
> +
>  	/*
>  	 * Turn on the Instructions Retired free counter on machines not
>  	 * susceptible to erratum #1054 "Instructions Retired Performance
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 2d7ea5480ec3..96fe1320c238 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -696,6 +696,18 @@ static void init_intel(struct cpuinfo_x86 *c)
>  		((c->x86_model == INTEL_FAM6_ATOM_GOLDMONT)))
>  		set_cpu_bug(c, X86_BUG_MONITOR);
>  
> +	/*
> +	 * Intel chipsets prior to Nehalem used the ACPI processor_idle
> +	 * driver for C-state management. Some of these processors that
> +	 * used IOPORT based C-states could not guarantee that STPCLK#
> +	 * signal gets asserted in time after P_LVL2 read to freeze
> +	 * execution properly. Since a clear cut-off point is not known
> +	 * as to when this bug was solved, mark all the chipsets as
> +	 * being affected. Only the ones that use IOPORT based C-state
> +	 * transitions via the acpi_idle driver will be impacted.
> +	 */
> +	set_cpu_bug(c, X86_BUG_STPCLK);
> +
>  #ifdef CONFIG_X86_64
>  	if (c->x86 == 15)
>  		c->x86_cache_alignment = c->x86_clflush_size * 2;

Quiz time:

  #define X86_VENDOR_INTEL       0
  #define X86_VENDOR_CYRIX       1
  #define X86_VENDOR_AMD         2
  #define X86_VENDOR_UMC         3
  #define X86_VENDOR_CENTAUR     5
  #define X86_VENDOR_TRANSMETA   7
  #define X86_VENDOR_NSC         8
  #define X86_VENDOR_HYGON       9
  #define X86_VENDOR_ZHAOXIN     10
  #define X86_VENDOR_VORTEX      11
  #define X86_VENDOR_NUM         12
  #define X86_VENDOR_UNKNOWN     0xff

For how many of the above have you changed behaviour?

Not to mention that this is the gazillion-th time AMD has failed to
change HYGON in lock-step. That's Zen too -- deal with it.
