Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D30B607B74
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 17:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiJUPuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 11:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiJUPtw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 11:49:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1420645B;
        Fri, 21 Oct 2022 08:49:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27022B82C4C;
        Fri, 21 Oct 2022 15:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDAAC433D6;
        Fri, 21 Oct 2022 15:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666367052;
        bh=q8ls2LNGHBE9YWymLdLMlQ2IxqZGMv1zYqPQcuccnGs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UrWLQAdqSLoknVsteHxzfPn6ANs22mAgP7iVgHdxb6FSWPq+xP2d8E1d1BTuDUpt7
         QevlJABcdtJtHhzv/c54bBVFI1BVfrIgm9suYSmsZVLdgEILvCsor06WtlakfOGg+H
         hlcZh+cIV10LpsKmYrV0toLf4MMwVU9K/Z8fDRPg=
Date:   Fri, 21 Oct 2022 17:44:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joe Korty <joe.korty@concurrent-rt.com>
Cc:     Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] arm64: arch_timer: XGene-1 has 31 bit, not 32 bit, arch
 timer.
Message-ID: <Y1K+Sgh1klccn5VV@kroah.com>
References: <20221021153424.GA25677@zipoli.concurrent-rt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021153424.GA25677@zipoli.concurrent-rt.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 21, 2022 at 11:34:24AM -0400, Joe Korty wrote:
> arm64: XGene-1 has a 31 bit, not a 32 bit, arch timer.
> 
> Fixes: 012f188504528b8cb32f441ac3bd9ea2eba39c9e ("clocksource/drivers/arm_arch_timer:
>   Work around broken CVAL implementations")
> 
> Testing:
>   On an 8-cpu Mustang, the following sequence no longer locks up the system:
> 
>      echo 0 >/proc/sys/kernel/watchdog
>      for i in {0..7}; do taskset -c $i echo hi there $i; done
> 
> Stable:
>   To be applied to 5.16 and above, once accepted by mainline.
> 
> Signed-off-by: Joe Korty <joe.korty@concurrent-rt.com>
> 
> Index: b/drivers/clocksource/arm_arch_timer.c
> ===================================================================
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -805,7 +805,7 @@ static u64 __arch_timer_check_delta(void
>  	const struct midr_range broken_cval_midrs[] = {
>  		/*
>  		 * XGene-1 implements CVAL in terms of TVAL, meaning
> -		 * that the maximum timer range is 32bit. Shame on them.
> +		 * that the maximum timer range is 31bit. Shame on them.
>  		 */
>  		MIDR_ALL_VERSIONS(MIDR_CPU_MODEL(ARM_CPU_IMP_APM,
>  						 APM_CPU_PART_POTENZA)),
> @@ -813,8 +813,8 @@ static u64 __arch_timer_check_delta(void
>  	};
>  
>  	if (is_midr_in_range_list(read_cpuid_id(), broken_cval_midrs)) {
> -		pr_warn_once("Broken CNTx_CVAL_EL1, limiting width to 32bits");
> -		return CLOCKSOURCE_MASK(32);
> +		pr_warn_once("Broken CNTx_CVAL_EL1, limiting width to 31bits");
> +		return CLOCKSOURCE_MASK(31);
>  	}
>  #endif
>  	return CLOCKSOURCE_MASK(arch_counter_get_width());

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
