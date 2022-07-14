Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F5E574BAA
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 13:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237839AbiGNLRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 07:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiGNLRg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 07:17:36 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E235F501A8;
        Thu, 14 Jul 2022 04:17:35 -0700 (PDT)
Received: from quatroqueijos (unknown [177.9.88.15])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 8339E3F382;
        Thu, 14 Jul 2022 11:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1657797453;
        bh=fWFv+RFz/llfCdkXnbXZ80kWIaRC3ju+kgm5LZk6q5I=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=JvEF/7/dJS41ORhT0juyMzcdB/gU0LGjiI0eDAc4tu7h8BYdfrlcW7V6QVzpXdjQW
         kmlUlVy7uIr1fmj+8lC+hf0Of7SErkTK472rC/IhhepgoIVDM0bt1O7bEPyUhpYtZu
         3rwX5oVJP3sjXIvheBxVGIlOEUsLCdOHOU34CtUfcGDOkipqNOj3vGB2Rcc/rk/GyA
         oTdw07yPg7/wXHQS6hbk+gjMkIrm0MvRPphfzqf+H3XX0HHEtMUb6cAYAwx7OUNcSQ
         r/Xu+fNamXRaKl1WUJTAbdiv7wSkee4CHOhRj1ZsMh4qYYBTTiWSREJRVGfNwc6YcK
         ccfsmxnCGHj3g==
Date:   Thu, 14 Jul 2022 08:17:26 -0300
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
Subject: Re: [PATCH] x86/bugs: Switch to "auto" when "ibrs" selected on
 Enhanced IBRS parts
Message-ID: <Ys/7RiC9Z++38tzq@quatroqueijos>
References: <0456b35fb9ef957d9a9138e0913fb1a3fd445dff.1657747493.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0456b35fb9ef957d9a9138e0913fb1a3fd445dff.1657747493.git.pawan.kumar.gupta@linux.intel.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 10:32:37PM -0700, Pawan Gupta wrote:
> Currently spectre_v2=ibrs forces write to MSR_IA32_SPEC_CTRL at every
> entry and exit. On Enhanced IBRS parts setting MSR_IA32_SPEC_CTRL[IBRS]
> only once at bootup is sufficient. MSR write at every kernel entry/exit
> incur unnecessary penalty that can be avoided.
> 
> When Enhanced IBRS feature is present, switch from "ibrs" to "auto" mode
> so that appropriate mitigation is selected.
> 
> Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
> Cc: stable@vger.kernel.org # 5.10+
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/bugs.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 0dd04713434b..7d7ebfdfbeda 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1303,6 +1303,12 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
>  		return SPECTRE_V2_CMD_AUTO;
>  	}
>  
> +	if (cmd == SPECTRE_V2_CMD_IBRS && boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
> +		pr_err("%s selected but CPU supports Enhanced IBRS. Switching to AUTO select\n",
> +		       mitigation_options[i].option);
> +		return SPECTRE_V2_CMD_AUTO;
> +	}
> +
>  	spec_v2_print_cond(mitigation_options[i].option,
>  			   mitigation_options[i].secure);
>  	return cmd;
> 
> base-commit: 72a8e05d4f66b5af7854df4490e3135168694b6b
> -- 
> 2.35.3
> 
> 

Shouldn't we just use the mitigation the user asked for if it is still
possible? We could add the warning advising the user that a different
mitigation could be used instead with less penalty, but if the user asked for
IBRS and that is available, it should be used.

One of the reasons for that is testing. I know it was useful enough for me and
it helped me find some bugs.

Cascardo.
