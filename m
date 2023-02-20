Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942EE69CA78
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 13:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjBTMHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 07:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBTMHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 07:07:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56D716305
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 04:07:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53EA3B80CB4
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 12:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60702C433D2;
        Mon, 20 Feb 2023 12:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676894850;
        bh=SKksstwZMT+y7mXSL4UHuSxuzEc6iReAP6GSiFJMUSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=far9znXKKXnSemr4D9zuFGh3+NyM5MN359CWEph8glQapikXk1Fs9rQdEtQ7S5LVf
         p2DnP92L7m4QovYYWwPxQizCvNNMKw0GOuYVRGKn80l3fXjyfOZpVbg0miTgYKqPgA
         P5y8ZCTJly8m0QHCkKDzY1LO3qenEL0Val2H4GCF9vIZvmQYlHTORQ7TfJ/88TcvSs
         mIK5HjLNdiFqfw3E1JbpwVNId1o3ZZVdY9xLziO5J7tqvp7DLhEz1hY1qyK3vIpt9v
         TeJsxaRoufh2Tba2yIvE4pP4Ow58Y0r0UMIq2QzWEjmNB/oNRVM+4FHZTmpsN6S22v
         PoniGJl8uVozQ==
Date:   Mon, 20 Feb 2023 04:07:27 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     KP Singh <kpsingh@kernel.org>
Cc:     security@kernel.org, pjt@google.com, evn@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
        kim.phillips@amd.com, alexandre.chartre@oracle.com,
        daniel.sneddon@linux.intel.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/speculation: Fix user-mode spectre-v2 protection
 with KERNEL_IBRS
Message-ID: <20230220120727.jevdpdi4w74kqliu@treble>
References: <20230220103930.1963742-1-kpsingh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230220103930.1963742-1-kpsingh@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 11:39:30AM +0100, KP Singh wrote:
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1132,6 +1132,19 @@ static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
>  	       mode == SPECTRE_V2_EIBRS_LFENCE;
>  }
>  
> +static inline bool spectre_v2_user_no_stibp(enum spectre_v2_mitigation mode)
> +{
> +	/* When IBRS or enhanced IBRS is enabled, STIBP is not needed.
> +	 *
> +	 * However, With KERNEL_IBRS, the IBRS bit is cleared on return
> +	 * to user and the user-mode code needs to be able to enable protection
> +	 * from cross-thread training, either by always enabling STIBP or
> +	 * by enabling it via prctl.
> +	 */
> +	return (spectre_v2_in_ibrs_mode(mode) &&
> +		!cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS));
> +}

The comments and code confused me, they both seem to imply some
distinction between IBRS and KERNEL_IBRS, but in the kernel those are
functionally the same thing.  e.g., the kernel doesn't have a user IBRS
mode.

And, unless I'm missing some subtlety here, it seems to be a convoluted
way of saying that eIBRS doesn't need STIBP in user space.

It would be simpler to just call it spectre_v2_in_eibrs_mode().

static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
{
	return mode == SPECTRE_V2_EIBRS ||
	       mode == SPECTRE_V2_EIBRS_RETPOLINE ||
	       mode == SPECTRE_V2_EIBRS_LFENCE;
}

And then spectre_v2_in_ibrs_mode() could be changed to call that:

static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
{
	return spectre_v2_in_eibrs_mode(mode) || mode == SPECTRE_V2_IBRS;
}

> @@ -1496,6 +1504,7 @@ static void __init spectre_v2_select_mitigation(void)
>  		break;
>  
>  	case SPECTRE_V2_IBRS:
> +		pr_err("enabling KERNEL_IBRS");

Why?

>  		setup_force_cpu_cap(X86_FEATURE_KERNEL_IBRS);
>  		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED))
>  			pr_warn(SPECTRE_V2_IBRS_PERF_MSG);
> @@ -2327,7 +2336,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)
>  
>  static char *stibp_state(void)
>  {
> -	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
> +	if (spectre_v2_user_no_stibp(spectre_v2_enabled))
>  		return "";

This seems like old cruft, can we just remove this check altogether?  In
the eIBRS case, spectre_v2_user_stibp will already have its default of
SPECTRE_V2_USER_NONE.

-- 
Josh
