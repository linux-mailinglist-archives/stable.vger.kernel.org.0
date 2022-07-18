Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C7257849A
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 15:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbiGRN7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 09:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234598AbiGRN7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 09:59:31 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C8DB7EB;
        Mon, 18 Jul 2022 06:59:30 -0700 (PDT)
Received: from quatroqueijos (unknown [177.9.88.15])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 2669F3F3B3;
        Mon, 18 Jul 2022 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1658152767;
        bh=xFPr+Ir1M1sYvHhLVgHi83pNFLpZG64mc5pSEsF5Zl4=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=S3KgtisG0rqdzTWuFuW3u7Y08r/SzTqtBY9upFvqY3xxGWVrq39TSAMKVhKWz/Y51
         YBc85T6/6sGRmuLcXWXOrmj834Jume876AT6AFqrK3WQuDsGrOyMX3Mg/C+PV54uMM
         3Kc8m/J6HMq3lJZ0/2vGgrC0cjHS8IafjaGfNtTK+NxOihryDfQMrvf5dDR3HgKE9z
         Gzsp5jM8rFR71bRZL1S15BpigJlcx92onY0OCmQhKC0UNBZ0DkRcBggmItjAsr1CLH
         xakqvreNfBpNdHTwPMktw6eVzyds7GQgN2qu+ijh/Zcn+U0bjKEdO8aPm5rjZpDGPO
         MnowHRq2rjzJA==
Date:   Mon, 18 Jul 2022 10:59:18 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        x86@kernel.org, ardb@kernel.org, tglx@linutronix.de,
        gregkh@linuxfoundation.org, torvalds@linux-foundation.org,
        Guenter Roeck <linux@roeck-us.net>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>, stable@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [PATCH] efi/x86: use naked RET on mixed mode call wrapper
Message-ID: <YtVnNnyDjt2vrWiR@quatroqueijos>
References: <20220715194550.793957-1-cascardo@canonical.com>
 <YtVG8VBmFikS6GMn@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtVG8VBmFikS6GMn@worktop.programming.kicks-ass.net>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 18, 2022 at 01:41:37PM +0200, Peter Zijlstra wrote:
> On Fri, Jul 15, 2022 at 04:45:50PM -0300, Thadeu Lima de Souza Cascardo wrote:
> > When running with return thunks enabled under 32-bit EFI, the system
> > crashes with:
> > 
> > [    0.137688] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> > [    0.138136] BUG: unable to handle page fault for address: 000000005bc02900
> > [    0.138136] #PF: supervisor instruction fetch in kernel mode
> > [    0.138136] #PF: error_code(0x0011) - permissions violation
> > [    0.138136] PGD 18f7063 P4D 18f7063 PUD 18ff063 PMD 190e063 PTE 800000005bc02063
> > [    0.138136] Oops: 0011 [#1] PREEMPT SMP PTI
> > [    0.138136] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.19.0-rc6+ #166
> > [    0.138136] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> > [    0.138136] RIP: 0010:0x5bc02900
> > [    0.138136] Code: Unable to access opcode bytes at RIP 0x5bc028d6.
> > [    0.138136] RSP: 0018:ffffffffb3203e10 EFLAGS: 00010046
> > [    0.138136] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000048
> > [    0.138136] RDX: 000000000190dfac RSI: 0000000000001710 RDI: 000000007eae823b
> > [    0.138136] RBP: ffffffffb3203e70 R08: 0000000001970000 R09: ffffffffb3203e28
> > [    0.138136] R10: 747563657865206c R11: 6c6977203a696665 R12: 0000000000001710
> > [    0.138136] R13: 0000000000000030 R14: 0000000001970000 R15: 0000000000000001
> > [    0.138136] FS:  0000000000000000(0000) GS:ffff8e013ca00000(0000) knlGS:0000000000000000
> > [    0.138136] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050033
> > [    0.138136] CR2: 000000005bc02900 CR3: 0000000001930000 CR4: 00000000000006f0
> > [    0.138136] Call Trace:
> > [    0.138136]  <TASK>
> > [    0.138136]  ? efi_set_virtual_address_map+0x9c/0x175
> > [    0.138136]  efi_enter_virtual_mode+0x4a6/0x53e
> > [    0.138136]  start_kernel+0x67c/0x71e
> > [    0.138136]  x86_64_start_reservations+0x24/0x2a
> > [    0.138136]  x86_64_start_kernel+0xe9/0xf4
> > [    0.138136]  secondary_startup_64_no_verify+0xe5/0xeb
> > [    0.138136]  </TASK>
> > 
> > That's because it cannot jump to the return thunk from the 32-bit code.
> > Using a naked RET and marking it as safe allows the system to proceed
> > booting.
> > 
> > Fixes: aa3d480315ba ("x86: Use return-thunk in asm code")
> > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> > Cc: <stable@vger.kernel.org>
> > ---
> > 
> > Does this leave one potential attack vector open? Perhaps, since this is
> > running under a different mapping (AFAIU), the risk is reduced? Or rather, the
> > attacker could attack using the firmware RETs anyway?
> > 
> > Alternatively, we could use IBPB when available when using the wrapper.
> > 
> > Thoughts?
> 
> What actual uarch are you running this on? Is this AMD hardware?
> 
> For Intel we'll enable IBRS for firmware if it is not otherwise enabled
> (upstream will always enable IBRS for the SKL family chips, but Thomas
> just posted the retbleed=stuff approach yesterday that will not)
> 
> On AMD I think you're stuck with IBPB, but that has to be issued
> *before* calling the firmware muck.
> 
> In either case, I think the patch as proposed is fine. But perhaps we
> want something like the below on top.
> 

I was testing this on Intel, because Guenter Roeck had reported such failures
when booting with 32-bit EFI. My patch fixes the boot problem, but then I asked
whether it would leave us vulnerable and, then, I was thinking about AMD
mostly, as you pointed out.

And I think you nailed what I had in mind for using IBPB when doing firmware
calls, and perhaps this is wanted even when we ignore this naked RET here.

There is a typo on your patch below, but I will give it a try and see if it
doesn't blow up on AMD systems without IBPB (by way of emulation).

Thanks.
Cascardo.

> ---
> Subject: x86/amd: Use IBPB for firmware calls
> 
> On AMD IBRS does not prevent Retbleed; as such use IBPB before a
> firmware call to flush the branch history state.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  arch/x86/include/asm/cpufeatures.h   |  1 +
>  arch/x86/include/asm/nospec-branch.h |  2 ++
>  arch/x86/kernel/cpu/bugs.c           | 11 ++++++++++-
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 00f5227c8459..a77b915d36a8 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -302,6 +302,7 @@
>  #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
>  #define X86_FEATURE_RETHUNK		(11*32+14) /* "" Use REturn THUNK */
>  #define X86_FEATURE_UNRET		(11*32+15) /* "" AMD BTB untrain return */
> +#define X86_FEATURE_USE_IBPB_FW		(11*32+16) /* "" Use IBPB during runtime firmware calls */
>  
>  /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
>  #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index 10a3bfc1eb23..f934dcdb7c0d 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -297,6 +297,8 @@ do {									\
>  	alternative_msr_write(MSR_IA32_SPEC_CTRL,			\
>  			      spec_ctrl_current() | SPEC_CTRL_IBRS,	\
>  			      X86_FEATURE_USE_IBRS_FW);			\
> +	altnerative_msr_write(MSR_IA32_PRED_CMD, PRED_CMD_IBPB,		\
> +			      X86_FEATURE_USE_IBPB_FW);			\
>  } while (0)
>  
>  #define firmware_restrict_branch_speculation_end()			\
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index aa34f908c39f..78c9082242a9 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1516,7 +1516,16 @@ static void __init spectre_v2_select_mitigation(void)
>  	 * the CPU supports Enhanced IBRS, kernel might un-intentionally not
>  	 * enable IBRS around firmware calls.
>  	 */
> -	if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_ibrs_mode(mode)) {
> +	if (boot_cpu_has_bug(X86_BUG_RETBLEED) &&
> +	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
> +	     boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)) {
> +
> +		if (retbleed_cmd != RETBLEED_CMD_IBPB) {
> +			setup_force_cpu_cap(X86_FEATURE_USE_IBPB_FW);
> +			pr_info("Enabling Speculation Barrier for firmware calls\n");
> +		}
> +
> +	} else if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_ibrs_mode(mode)) {
>  		setup_force_cpu_cap(X86_FEATURE_USE_IBRS_FW);
>  		pr_info("Enabling Restricted Speculation for firmware calls\n");
>  	}
