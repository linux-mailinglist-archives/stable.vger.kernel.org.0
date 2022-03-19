Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167D14DE6F5
	for <lists+stable@lfdr.de>; Sat, 19 Mar 2022 09:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238027AbiCSISf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Mar 2022 04:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbiCSISe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Mar 2022 04:18:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E905C23193D;
        Sat, 19 Mar 2022 01:17:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84C8260DB4;
        Sat, 19 Mar 2022 08:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78192C340EC;
        Sat, 19 Mar 2022 08:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647677834;
        bh=XKOQjqIaURxgBzAC86d2mUm8wd3h7T9RaXyq8DIm5MU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=herOR2Ypvi98+mCJGFrD9bfd8rZH/+UE7Gad4k5Zda5Vt8fIyMEQRsFmqxukYcOSn
         CArPvPGzHu2n+UY5I8Pd3d1L9Q79yiZltv0OesnYPuV/LjOo2pynTvOaAFBOeOXEwK
         7gC8Om8TZrwu3CACnuwqKBhjm7USf5gOx89IlLj4=
Date:   Sat, 19 Mar 2022 09:17:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     James Morse <james.morse@arm.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: fixup for [PATCH 5.4 18/43] arm64 entry: Add macro for reading
 symbol address from the trampoline
Message-ID: <YjWRhoKQAbojIGu2@kroah.com>
References: <YjSxfK6bmH4P9IQl@kroah.com>
 <20220318173713.2320567-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318173713.2320567-1-james.morse@arm.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 18, 2022 at 05:37:13PM +0000, James Morse wrote:
> __sdei_asm_trampoline_next_handler shouldn't have its own name as the
> tramp_data_read_var takes the symbol name, and generates the name for
> the value in the data page if CONFIG_RANDOMIZE_BASE is clear.
> 
> This means when CONFIG_RANDOMIZE_BASE is clear, this code won't compile
> as __sdei_asm_trampoline_next_handler doesn't exist.
> 
> Use the proper name, and let the macro do its thing.
> 
> Reported-by: Florian Fainelli <f.fainelli@gmail.com>
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  arch/arm64/kernel/entry.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index e4b5a15c2e2e..cfc0bb6c49f7 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -1190,7 +1190,7 @@ __entry_tramp_data_start:
>  __entry_tramp_data_vectors:
>  	.quad	vectors
>  #ifdef CONFIG_ARM_SDE_INTERFACE
> -__entry_tramp_data___sdei_asm_trampoline_next_handler:
> +__entry_tramp_data___sdei_asm_handler:
>  	.quad	__sdei_asm_handler
>  #endif /* CONFIG_ARM_SDE_INTERFACE */
>  	.popsection				// .rodata
> @@ -1319,7 +1319,7 @@ ENTRY(__sdei_asm_entry_trampoline)
>  	 */
>  1:	str	x4, [x1, #(SDEI_EVENT_INTREGS + S_ORIG_ADDR_LIMIT)]
>  
> -	tramp_data_read_var     x4, __sdei_asm_trampoline_next_handler
> +	tramp_data_read_var     x4, __sdei_asm_handler
>  	br	x4
>  ENDPROC(__sdei_asm_entry_trampoline)
>  NOKPROBE(__sdei_asm_entry_trampoline)
> -- 
> 2.30.2
> 

Thanks, now queued up.

greg k-h
