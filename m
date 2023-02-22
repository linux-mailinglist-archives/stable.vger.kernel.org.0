Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D04069ED46
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 04:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjBVDIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 22:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbjBVDI1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 22:08:27 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6514EFE;
        Tue, 21 Feb 2023 19:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677035272; x=1708571272;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=0G4HTjnORojrosrwDqf7UQux+AF9fkIdrXVnsvTlaEs=;
  b=a7DTpsVZv5oiXUBXHaWVeYsPDzIZNSwmwnvnx4HRtd3eGnX+PKTmh10a
   QSUykwH/MN67S3xGHnNdYq/zuK5VlLQKjOR4hDJwyNdF100Km6IsA252j
   IViN23nMn3+cQ7zmAeQuNYKRxL6b200UsZQpPAmAKViPDjfdFe8KFECIR
   8+VkPF1BCIAF6n81kV616YxVhke/2S+uq3WLduxEO4QMx8o5S0KBcuX/K
   tPPsyVqxQF7bVQgY7a4nyNWVCK6N9afWdPAoLtsB+tQMFlqbpGX0H94zL
   6entPEpTiuf251KVvxSPKzzsU5eyLcmwy3oGw5teIK/UQUjfJ1XrQjJ2k
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="395303611"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="395303611"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 19:07:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="760788522"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="760788522"
Received: from erodrig5-mobl2.amr.corp.intel.com (HELO desk) ([10.212.242.195])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 19:07:31 -0800
Date:   Tue, 21 Feb 2023 19:07:28 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     KP Singh <kpsingh@kernel.org>
Cc:     linux-kernel@vger.kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        corbet@lwn.net, bp@suse.de, linyujun809@huawei.com,
        jmattson@google.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy
 IBRS
Message-ID: <20230222030728.v4ldlndtnx6gqd6x@desk>
References: <20230221184908.2349578-1-kpsingh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230221184908.2349578-1-kpsingh@kernel.org>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 07:49:07PM +0100, KP Singh wrote:
> Setting the IBRS bit implicitly enables STIBP to protect against
> cross-thread branch target injection. With enhanced IBRS, the bit it set
> once and is not cleared again. However, on CPUs with just legacy IBRS,
> IBRS bit set on user -> kernel and cleared on kernel -> user (a.k.a
> KERNEL_IBRS). Clearing this bit also disables the implicitly enabled
> STIBP, thus requiring some form of cross-thread protection in userspace.
> 
> Enable STIBP, either opt-in via prctl or seccomp, or always on depending
> on the choice of mitigation selected via spectre_v2_user.
> 
> Reported-by: José Oliveira <joseloliveira11@gmail.com>
> Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
> Reviewed-by: Alexandra Sandulescu <aesa@google.com>
> Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
> Cc: stable@vger.kernel.org
> Signed-off-by: KP Singh <kpsingh@kernel.org>
> ---
>  arch/x86/kernel/cpu/bugs.c | 33 ++++++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 85168740f76a..5be6075d8e36 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1124,14 +1124,30 @@ spectre_v2_parse_user_cmdline(void)
>  	return SPECTRE_V2_USER_CMD_AUTO;
>  }
>  
> -static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
> +static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
>  {
> -	return mode == SPECTRE_V2_IBRS ||
> -	       mode == SPECTRE_V2_EIBRS ||
> +	return mode == SPECTRE_V2_EIBRS ||
>  	       mode == SPECTRE_V2_EIBRS_RETPOLINE ||
>  	       mode == SPECTRE_V2_EIBRS_LFENCE;
>  }
>  
> +static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
> +{
> +	return spectre_v2_in_eibrs_mode(mode) || mode == SPECTRE_V2_IBRS;
> +}
> +
> +static inline bool spectre_v2_user_needs_stibp(enum spectre_v2_mitigation mode)
> +{
> +	/*
> +	 * enhanced IBRS also protects against user-mode attacks as the IBRS bit

Maybe:
	 * Enhanced IBRS mode also protects against cross-thread user-to-user
	 * attacks as the IBRS bit

> +	 * remains always set which implicitly enables cross-thread protections.
> +	 * However, In legacy IBRS mode, the IBRS bit is set only in kernel
> +	 * and cleared on return to userspace. This disables the implicit
> +	 * cross-thread protections and STIBP is needed.
> +	 */
> +	return !spectre_v2_in_eibrs_mode(mode);
> +}
> +
>  static void __init
>  spectre_v2_user_select_mitigation(void)
>  {
> @@ -1193,13 +1209,8 @@ spectre_v2_user_select_mitigation(void)
>  			"always-on" : "conditional");
>  	}
>  
> -	/*
> -	 * If no STIBP, IBRS or enhanced IBRS is enabled, or SMT impossible,
> -	 * STIBP is not required.
> -	 */
> -	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
> -	    !smt_possible ||
> -	    spectre_v2_in_ibrs_mode(spectre_v2_enabled))
> +	if (!boot_cpu_has(X86_FEATURE_STIBP) || !smt_possible ||
> +	    !spectre_v2_user_needs_stibp(spectre_v2_enabled))

As pointed out in other discussions, it will be great if can get rid of
eIBRS check, and do what the user asked for; or atleast print a warning
about not setting STIBP bit explicitly.

>  		return;
>  
>  	/*
> @@ -2327,7 +2338,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)
>  
>  static char *stibp_state(void)
>  {
> -	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
> +	if (!spectre_v2_user_needs_stibp(spectre_v2_enabled))

Decoupling STIBP and eIBRS will also get rid of this check.

>  		return "";
