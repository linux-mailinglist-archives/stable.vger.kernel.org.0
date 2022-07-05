Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1593D56632D
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 08:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiGEG1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 02:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiGEG1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 02:27:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0D1A1AB
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 23:26:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C8996126B
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 06:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57917C341CD;
        Tue,  5 Jul 2022 06:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657002418;
        bh=9l+xemeTQL4sv8mX2GxZrBzP6Q+NWBDiXfJNctzijCU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UVhHz4j5/kBsxglaHyH4rdPkWNZxEyJxy/gHG9/PXhbj6B8CsEHvZHIPf/UWNVnPW
         Kd5wEVvkKU2o0uK3dWEBK/E0Cn6UDjf1q3CaJ9DWpOSlgV4h4hwxIo7lXgztPDzdno
         HjLoNToU9ZmkhsbVYiQGoStZwBDxeSApfYA1nwLM=
Date:   Tue, 5 Jul 2022 08:26:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wen Yang <wenyang@linux.alibaba.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Bin Yang <bin.yang@intel.com>,
        Mark Gross <mark.gross@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 4.19] x86/mm/cpa: Unconditionally avoid WBINDV when we can
Message-ID: <YsPZsIonf8QuedkT@kroah.com>
References: <20220705060209.22806-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705060209.22806-1-wenyang@linux.alibaba.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 05, 2022 at 02:02:07PM +0800, Wen Yang wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> commit ddd07b750382adc2b78fdfbec47af8a6e0d8ef37 upstream.
> 
> CAT has happened, WBINDV is bad (even before CAT blowing away the
> entire cache on a multi-core platform wasn't nice), try not to use it
> ever.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Reviewed-by: Dave Hansen <dave.hansen@intel.com>
> Cc: Bin Yang <bin.yang@intel.com>
> Cc: Mark Gross <mark.gross@intel.com>
> Link: https://lkml.kernel.org/r/20180919085947.933674526@infradead.org
> Cc: <stable@vger.kernel.org> # 4.19.x
> Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
> ---
>  arch/x86/mm/pageattr.c | 18 ++----------------
>  1 file changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 101f3ad0d6ad..ab87da7a6043 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -239,26 +239,12 @@ static void cpa_flush_array(unsigned long *start, int numpages, int cache,
>  			    int in_flags, struct page **pages)
>  {
>  	unsigned int i, level;
> -#ifdef CONFIG_PREEMPT
> -	/*
> -	 * Avoid wbinvd() because it causes latencies on all CPUs,
> -	 * regardless of any CPU isolation that may be in effect.
> -	 *
> -	 * This should be extended for CAT enabled systems independent of
> -	 * PREEMPT because wbinvd() does not respect the CAT partitions and
> -	 * this is exposed to unpriviledged users through the graphics
> -	 * subsystem.
> -	 */
> -	unsigned long do_wbinvd = 0;
> -#else
> -	unsigned long do_wbinvd = cache && numpages >= 1024; /* 4M threshold */
> -#endif
>  
>  	BUG_ON(irqs_disabled() && !early_boot_irqs_disabled);
>  
> -	on_each_cpu(__cpa_flush_all, (void *) do_wbinvd, 1);
> +	flush_tlb_all();
>  
> -	if (!cache || do_wbinvd)
> +	if (!cache)
>  		return;
>  
>  	/*
> -- 
> 2.19.1.6.gb485710b
> 

As stated before, I am not allowed to accept this due to it being a
requirement of a closed source kernel module.  Please do not keep
resending it hoping we will forget or I will have to add this to my
email filters.

thanks,

greg k-h
