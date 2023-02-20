Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2235C69CA8D
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 13:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjBTMOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 07:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjBTMN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 07:13:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF0B1A67E;
        Mon, 20 Feb 2023 04:13:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83A7EB80C03;
        Mon, 20 Feb 2023 12:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971ECC433EF;
        Mon, 20 Feb 2023 12:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676895232;
        bh=H858yOx8NUQoy8dR556ttHgcbTm2syhGg76ezLDH0dY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pp1DJCpq5KblTCwODOc9AMcNY8x+aDn40BVimo9Ix+fD61/dtjB/B639dCtVrNpQk
         BRvpOdAn6qs7bNkTSCzZ0uFv6IqM/qyziDuqDRdM/RaE0G01H0dYYwPNZ8FLfoGAO0
         5nf6uFK2rSPH/yANJUoxzrmt57ia8kzB6ZpuE8SuG/eDTjjzR8Wmv9+UFA6rqO24Eb
         RMx3I+8nhpc2cXGzyBUCEa/ot5F1fHdhmJMgeRFLqm0+dRKnr2tZ6Nv5qc6xme4uku
         6EQOCz0M6dqgcYmgM9gBcG/+U6boMyvC2OALmfaJ/iNZgy6qo5aAiEjXUqU2YawGJ/
         5pnE2pEX2mVpw==
Date:   Mon, 20 Feb 2023 04:13:50 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     KP Singh <kpsingh@kernel.org>
Cc:     linux-kernel@vger.kernel.org, pjt@google.com, evn@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
        kim.phillips@amd.com, alexandre.chartre@oracle.com,
        daniel.sneddon@linux.intel.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] x86/speculation: Fix user-mode spectre-v2
 protection with KERNEL_IBRS
Message-ID: <20230220121350.aidsipw3kd4rsyss@treble>
References: <20230220120127.1975241-1-kpsingh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230220120127.1975241-1-kpsingh@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 01:01:27PM +0100, KP Singh wrote:
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
