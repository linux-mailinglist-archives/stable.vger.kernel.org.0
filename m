Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76B91F69A3
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 16:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgFKOKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 10:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgFKOKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 10:10:00 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5365C08C5C1;
        Thu, 11 Jun 2020 07:09:59 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0bef00e16d68ab941b81be.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:ef00:e16d:68ab:941b:81be])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E0E081EC02AC;
        Thu, 11 Jun 2020 16:09:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1591884597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=JU5IVpy1hwebQASLTWrwgg71St1itM4pRG6bPPA0pxI=;
        b=ohP+4Y0r6eetmXUM/0YQ7W1ZbY0uQqHyv+KTkfyjr4J9kJtD+2eavOfM92CifFx8dFUY5/
        +SuICaXRTVHLLvaRxjlFfXwXotYUvswnx8Uylb6o7Szla0KlQDB7cKPYHBjphzDWvJhEFb
        Padg0/tPzalZtwPoKGEVml4x26mITzc=
Date:   Thu, 11 Jun 2020 16:09:51 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Anthony Steinhauser <asteinhauser@google.com>
Cc:     linux-tip-commits@vger.kernel.org,
        Anthony Steinhauser <asteinhauser@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [tip: x86/urgent] x86/speculation: Avoid force-disabling IBPB
 based on STIBP and enhanced IBRS.
Message-ID: <20200611140951.GD30352@zn.tnic>
References: <159169282952.17951.3529693809120577424.tip-bot2@tip-bot2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <159169282952.17951.3529693809120577424.tip-bot2@tip-bot2>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 08:53:49AM -0000, tip-bot2 for Anthony Steinhauser wrote:
> @@ -672,23 +665,36 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
>  		pr_info("mitigation: Enabling %s Indirect Branch Prediction Barrier\n",
>  			static_key_enabled(&switch_mm_always_ibpb) ?
>  			"always-on" : "conditional");
> +
> +		spectre_v2_user_ibpb = mode;
>  	}
>  
> -	/* If enhanced IBRS is enabled no STIBP required */
> -	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
> +	/*
> +	 * If enhanced IBRS is enabled or SMT impossible, STIBP is not
> +	 * required.
> +	 */
> +	if (!smt_possible || spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
>  		return;
>  
>  	/*
> -	 * If SMT is not possible or STIBP is not available clear the STIBP
> -	 * mode.
> +	 * At this point, an STIBP mode other than "off" has been set.
> +	 * If STIBP support is not being forced, check if STIBP always-on
> +	 * is preferred.
> +	 */
> +	if (mode != SPECTRE_V2_USER_STRICT &&
> +	    boot_cpu_has(X86_FEATURE_AMD_STIBP_ALWAYS_ON))
> +		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
> +
> +	/*
> +	 * If STIBP is not available, clear the STIBP mode.
>  	 */
> -	if (!smt_possible || !boot_cpu_has(X86_FEATURE_STIBP))
> +	if (!boot_cpu_has(X86_FEATURE_STIBP))
>  		mode = SPECTRE_V2_USER_NONE;

Can we merge this test into the one above? Diff ontop:

---
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 8d57562b1d2c..05b3163e1b8c 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -673,7 +673,9 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 	 * If enhanced IBRS is enabled or SMT impossible, STIBP is not
 	 * required.
 	 */
-	if (!smt_possible || spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
+	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
+	    !smt_possible ||
+	    spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
 		return;
 
 	/*
@@ -685,12 +687,6 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 	    boot_cpu_has(X86_FEATURE_AMD_STIBP_ALWAYS_ON))
 		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
 
-	/*
-	 * If STIBP is not available, clear the STIBP mode.
-	 */
-	if (!boot_cpu_has(X86_FEATURE_STIBP))
-		mode = SPECTRE_V2_USER_NONE;
-
 	spectre_v2_user_stibp = mode;
 
 set_mode:

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
