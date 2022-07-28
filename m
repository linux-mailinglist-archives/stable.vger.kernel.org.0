Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43C65842CE
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 17:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiG1PQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 11:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiG1PQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 11:16:52 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6ED54ACD;
        Thu, 28 Jul 2022 08:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AmUPpMsyzQAMiFXXvNrmIFoCDHFhaj7UZeTTQJGeCWw=; b=QoKQ9jXFdAB+rfISOb/LkuVmpk
        iONt7UX2u072T60dMWkSQGDHSMAddG7zT5nuBbMvlxIof5wCSIXY/3iBEUc2PGwiMCLinsOALEa1F
        V5+74tzg7h3bFrNSs7adRwGAH7CG2c1+MkPoYJ4+7iHQnkC0vP8HQbGGbLZEw6pcHj441I8Zl0heJ
        31JdQ764cl/RdnOVc55YwU6xL759EXVBwajIsfPG6yj1pAxLRbKhiHCBrhFIaevPlAlvOcVY7926t
        pEZXbbhWmxA8bip0HkbahXbzEbQjLLNoVN/9tzq0vMPEmFdpE8/mDmUPYi3FdHzBnMkZs/qb8Tp0D
        8Cn0Pqlg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oH5Fi-0018J0-UV; Thu, 28 Jul 2022 15:16:43 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id D180A98047B; Thu, 28 Jul 2022 17:16:40 +0200 (CEST)
Date:   Thu, 28 Jul 2022 17:16:40 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Dimitri John Ledkov <dimitri.ledkov@canonical.com>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/bugs: Do not enable IBPB at firmware entry when IBPB
 is not available
Message-ID: <YuKoWPRt56T+FE+s@worktop.programming.kicks-ass.net>
References: <20220728122602.2500509-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728122602.2500509-1-cascardo@canonical.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 28, 2022 at 09:26:02AM -0300, Thadeu Lima de Souza Cascardo wrote:
> Some cloud hypervisors do not provide IBPB on very recent CPU processors,
> including AMD processors affected by Retbleed.

That's a bug in the hypervisor.

> Fixes: 28a99e95f55c ("x86/amd: Use IBPB for firmware calls")

Fixes^WCreates-a-speculation-hole-in:

> Reported-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/x86/kernel/cpu/bugs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 6454bc767f0f..6761668100b9 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1520,6 +1520,7 @@ static void __init spectre_v2_select_mitigation(void)
>  	 * enable IBRS around firmware calls.
>  	 */
>  	if (boot_cpu_has_bug(X86_BUG_RETBLEED) &&
> +	    boot_cpu_has(X86_FEATURE_IBPB) &&
>  	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
>  	     boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)) {

At the very least we need a pr_warn() and something nasty in
retbleed_show_state() to warn the user their firmware calls are
vulnerable.

