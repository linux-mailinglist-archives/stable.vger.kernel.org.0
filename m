Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C45575887
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 02:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241106AbiGOALc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 20:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiGOALb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 20:11:31 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E0768725;
        Thu, 14 Jul 2022 17:11:30 -0700 (PDT)
Received: from quatroqueijos (unknown [177.9.88.15])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 7229F3F389;
        Fri, 15 Jul 2022 00:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1657843886;
        bh=YwXi59IygxdnRKMz2x3Yekg/0Hgu8GZDs/DudlkeAn8=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=DGMSldO0TMibI6Pbq2iTV3lmzZb5c+KEg1Avm05inreTZlkE9gBElpTAH54/307Hk
         o1gYtcZxZS7RLj6CS+PKe4bjZ56pZYmPqus7tOmUEItB0uwoIWp6rDJ5TjUeJ9+sDx
         mtFecqweUrQ1euhnDu/acRPTxwRMd2BJ1yNTLKXvqrXKSroNoMHggIj9nvI2BIyD4a
         K5WCGzPt3jPER4/lEvWnx7f7p8JTc1rj1/K3mbzBsxC/KeDRT35xwKhGQsztkZ+QN6
         z512dm/JXBdSQCNTx8xUpdRvyr0zIl+nG46R8bgWWyHmbbc84EqXKSHix+j2HJqflo
         kduHdqU8a+dGw==
Date:   Thu, 14 Jul 2022 21:11:18 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Josh Poimboeuf <jpoimboe@kernel.org>
Subject: Re: [PATCH v2] x86/bugs: Warn when "ibrs" mitigation is selected on
 Enhanced IBRS parts
Message-ID: <YtCwpjeRVu4LVOyF@quatroqueijos>
References: <0456b35fb9ef957d9a9138e0913fb1a3fd445dff.1657747493.git.pawan.kumar.gupta@linux.intel.com>
 <2a5eaf54583c2bfe0edc4fea64006656256cca17.1657814857.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a5eaf54583c2bfe0edc4fea64006656256cca17.1657814857.git.pawan.kumar.gupta@linux.intel.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 04:15:35PM -0700, Pawan Gupta wrote:
> IBRS mitigation for spectre_v2 forces write to MSR_IA32_SPEC_CTRL at
> every kernel entry/exit. On Enhanced IBRS parts setting
> MSR_IA32_SPEC_CTRL[IBRS] only once at boot is sufficient. MSR writes at
> every kernel entry/exit incur unnecessary performance loss.
> 
> When Enhanced IBRS feature is present, print a warning about this
> unnecessary performance loss.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Reviewed-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

> ---
> v1->v2: Instead of changing the mitigation, print a warning about the
>         perf loss.
> 
> v1: https://lore.kernel.org/lkml/0456b35fb9ef957d9a9138e0913fb1a3fd445dff.1657747493.git.pawan.kumar.gupta@linux.intel.com/
> 
>  arch/x86/kernel/cpu/bugs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 0dd04713434b..1c54fad3c54b 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -975,6 +975,7 @@ static inline const char *spectre_v2_module_string(void) { return ""; }
>  #define SPECTRE_V2_LFENCE_MSG "WARNING: LFENCE mitigation is not recommended for this CPU, data leaks possible!\n"
>  #define SPECTRE_V2_EIBRS_EBPF_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!\n"
>  #define SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS+LFENCE mitigation and SMT, data leaks possible via Spectre v2 BHB attacks!\n"
> +#define SPECTRE_V2_IBRS_PERF_MSG "WARNING: IBRS mitigation selected on Enhanced IBRS CPU, this may cause unnecessary performance loss\n"
>  
>  #ifdef CONFIG_BPF_SYSCALL
>  void unpriv_ebpf_notify(int new_state)
> @@ -1415,6 +1416,8 @@ static void __init spectre_v2_select_mitigation(void)
>  
>  	case SPECTRE_V2_IBRS:
>  		setup_force_cpu_cap(X86_FEATURE_KERNEL_IBRS);
> +		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED))
> +			pr_warn(SPECTRE_V2_IBRS_PERF_MSG);
>  		break;
>  
>  	case SPECTRE_V2_LFENCE:
> 
> base-commit: 4a57a8400075bc5287c5c877702c68aeae2a033d
> -- 
> 2.35.3
> 
> 
