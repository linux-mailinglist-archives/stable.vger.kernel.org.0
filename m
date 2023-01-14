Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504D766A9C2
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 07:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjANGz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 01:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjANGz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 01:55:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82ED1713
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 22:55:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54FF760B51
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 06:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A486C433D2;
        Sat, 14 Jan 2023 06:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673679353;
        bh=PCfqj1VM6bbbgBHUzBLOxNBFE0gQ4DCHqvvWf4061BU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1zcgTXblYKER4hBjyu71Nzb5yEo2iiBsBg+lr+sk41TUjrlkRkEUXDjUWh4BrQ95e
         CtLMHNZXkQSY/2E7WP9hCfk8OD24oLUivyR4LM41TOlh8adlXrR33wVjRNHTPc3qYu
         ysteUVaInA4Im7z3rkyvbhGPxnrb5YDoabdFC6/o=
Date:   Sat, 14 Jan 2023 07:55:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Verkamp <dverkamp@chromium.org>
Cc:     Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>,
        Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] x86: combine memmove FSRM and ERMS alternatives
Message-ID: <Y8JR857rdaozBOxT@kroah.com>
References: <20230113203217.1111227-1-dverkamp@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113203217.1111227-1-dverkamp@chromium.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 13, 2023 at 12:32:17PM -0800, Daniel Verkamp wrote:
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
