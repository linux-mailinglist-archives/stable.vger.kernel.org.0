Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894E54DC387
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 11:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiCQKFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 06:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiCQKFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 06:05:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E1EBF52F;
        Thu, 17 Mar 2022 03:03:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F0CB1CE2259;
        Thu, 17 Mar 2022 10:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5AFC340E9;
        Thu, 17 Mar 2022 10:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647511421;
        bh=GXCQ54BJM97k7KKyXZtBG5FGnu1uCHY2JbllZ5NIchg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k1S7FS2cEFIA602M9SKdyjbIIDZkJkGEkz60gEq/YUnfDXz/hh/D4b53B7Arv3ZzW
         ZYkwMaDmQ5W6NmHJeUfVamZNZU4m0KxOUWS8L0XogppEl9P5GO9Ko82bBv1K/GwL+g
         FJ+BSsH3UNLy2LCxqfkudqSplEgxdnb2J8FW1x8I=
Date:   Thu, 17 Mar 2022 11:03:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     James Morse <james.morse@arm.com>
Cc:     stable@vger.kernel.org, pavel@denx.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [stable:PATCH v5.10.105] arm64: kvm: Fix copy-and-paste error in
 bhb templates for v5.10 stable
Message-ID: <YjMHefyJIHBj5tak@kroah.com>
References: <20220315135720.1302143-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315135720.1302143-1-james.morse@arm.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 01:57:20PM +0000, James Morse wrote:
> KVM's infrastructure for spectre mitigations in the vectors in v5.10 and
> earlier is different, it uses templates which are used to build a set of
> vectors at runtime.
> 
> There are two copy-and-paste errors in the templates: __spectre_bhb_loop_k24
> should loop 24 times and __spectre_bhb_loop_k32 32.
> 
> Fix these.
> 
> Reported-by: Pavel Machek <pavel@denx.de>
> Link: https://lore.kernel.org/all/20220310234858.GB16308@amd/
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  arch/arm64/kvm/hyp/smccc_wa.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/smccc_wa.S b/arch/arm64/kvm/hyp/smccc_wa.S
> index 24b281912463..533b0aa73256 100644
> --- a/arch/arm64/kvm/hyp/smccc_wa.S
> +++ b/arch/arm64/kvm/hyp/smccc_wa.S
> @@ -68,7 +68,7 @@ SYM_DATA_START(__spectre_bhb_loop_k24)
>  	esb
>  	sub	sp, sp, #(8 * 2)
>  	stp	x0, x1, [sp, #(8 * 0)]
> -	mov	x0, #8
> +	mov	x0, #24
>  2:	b	. + 4
>  	subs	x0, x0, #1
>  	b.ne	2b
> @@ -85,7 +85,7 @@ SYM_DATA_START(__spectre_bhb_loop_k32)
>  	esb
>  	sub	sp, sp, #(8 * 2)
>  	stp	x0, x1, [sp, #(8 * 0)]
> -	mov	x0, #8
> +	mov	x0, #32
>  2:	b	. + 4
>  	subs	x0, x0, #1
>  	b.ne	2b
> -- 
> 2.30.2
> 

Thanks, now queued up!

greg k-h
