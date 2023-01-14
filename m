Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0163466A9C3
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 07:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjANG4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 01:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjANG4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 01:56:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA7E1712
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 22:56:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8956B60A13
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 06:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF8CC433EF;
        Sat, 14 Jan 2023 06:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673679361;
        bh=ODV8se4EnAIn/RCR4JITj4vSM0NeLoziOiafxbMiIYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NP6EGTOidnkIdioiUBf8K+8FwhXxwivLgj6cYLx+MdiKCS4JVMS2seCw+njJ77fub
         pKECUPP4mJVP4gRMUuLkFzXfqmKPkM8Pujwdrk2udLJwmq7RcTo/bmQIgLOQhz28QH
         L60VPV21M1L0+ySUzWaaBhjEk3NU7HRJP5113QSI=
Date:   Sat, 14 Jan 2023 07:55:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Verkamp <dverkamp@chromium.org>
Cc:     x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] x86: combine memmove FSRM and ERMS alternatives
Message-ID: <Y8JR++evOCwXD8Cf@kroah.com>
References: <20230113203427.1111689-1-dverkamp@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113203427.1111689-1-dverkamp@chromium.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 13, 2023 at 12:34:27PM -0800, Daniel Verkamp wrote:
> The x86-64 memmove code has two ALTERNATIVE statements in a row, one to
> handle FSRM ("Fast Short REP MOVSB"), and one to handle ERMS ("Enhanced
> REP MOVSB"). If either of these features is present, the goal is to jump
> directly to a REP MOVSB; otherwise, some setup code that handles short
> lengths is executed. The first comparison of a sequence of specific
> small sizes is included in the first ALTERNATIVE, so it will be replaced
> by NOPs if FSRM is set, and then (assuming ERMS is also set) execution
> will fall through to the JMP to a REP MOVSB in the next ALTERNATIVE.
> 
> The two ALTERNATIVE invocations can be combined into a single instance
> of ALTERNATIVE_2 to simplify and slightly shorten the code. If either
> FSRM or ERMS is set, the first instruction in the memmove_begin_forward
> path will be replaced with a jump to the REP MOVSB.
> 
> This also prevents a problem when FSRM is set but ERMS is not; in this
> case, the previous code would have replaced both ALTERNATIVEs with NOPs
> and skipped the first check for sizes less than 0x20 bytes. This
> combination of CPU features is arguably a firmware bug, but this patch
> makes the function robust against this badness.
> 
> Fixes: f444a5ff95dc ("x86/cpufeatures: Add support for fast short REP; MOVSB")
> Signed-off-by: Daniel Verkamp <dverkamp@chromium.org>
> ---
>  arch/x86/lib/memmove_64.S | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
> index 724bbf83eb5b..1fc36dbd3bdc 100644
> --- a/arch/x86/lib/memmove_64.S
> +++ b/arch/x86/lib/memmove_64.S
> @@ -38,8 +38,10 @@ SYM_FUNC_START(__memmove)
>  
>  	/* FSRM implies ERMS => no length checks, do the copy directly */
>  .Lmemmove_begin_forward:
> -	ALTERNATIVE "cmp $0x20, %rdx; jb 1f", "", X86_FEATURE_FSRM
> -	ALTERNATIVE "", "jmp .Lmemmove_erms", X86_FEATURE_ERMS
> +	ALTERNATIVE_2 \
> +		"cmp $0x20, %rdx; jb 1f", \
> +		"jmp .Lmemmove_erms", X86_FEATURE_FSRM, \
> +		"jmp .Lmemmove_erms", X86_FEATURE_ERMS
>  
>  	/*
>  	 * movsq instruction have many startup latency
> -- 
> 2.39.0.314.g84b9a713c41-goog
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
