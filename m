Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF9252741C
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 23:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiENVDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 17:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiENVDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 17:03:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D6AF63
        for <stable@vger.kernel.org>; Sat, 14 May 2022 14:03:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C80360B29
        for <stable@vger.kernel.org>; Sat, 14 May 2022 21:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBE0C340EE;
        Sat, 14 May 2022 21:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652562222;
        bh=YzDXHv7RRZXZuyKf2MLkhe4yQCslQ1nM/v7mBJ7qzz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FTQ+E0gGmBaLx4G4lVaLaBpSALp86j7cSn9hUcwWYTGNZNyEZ8jD5hNCwbtiNjCcR
         tjcDyZuNB4oj5Gu2F+x9OLbWj7Zg1Joo/X7BPsZCc1SlOxVM3E/+/FLP6kL5NQRTbb
         4YGXnqKadOeO5LzoEkcMn8Pk5loW+SyFr3jepnKkOfeABF40HS1a7y09cEtY4mguVT
         9gFuwGWDAx5gVl1sk2lpM5/h7SR7FMi0OGjpNMcnpuLrjPC776CAn4KTKzDhhoMVbn
         SXhkYf3S9+eofMz9xIq/xGSUXx5IPKqb6zV/kuh24T+6uvRQPivo3KICe+mSwwnJJe
         P+hm0H19fr6hw==
Date:   Sat, 14 May 2022 14:03:40 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19] MIPS: fix allmodconfig build with latest mkimage
Message-ID: <YoAZLPxTYsqEypGP@dev-arch.thelio-3990X>
References: <20220514153414.6190-1-sudip.mukherjee@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220514153414.6190-1-sudip.mukherjee@sifive.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 14, 2022 at 04:34:14PM +0100, Sudip Mukherjee wrote:
> From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> 
> With the latest mkimage from U-Boot 2021.04+ the allmodconfig build
> fails. 822564cd3aa1 ("MIPS: generic: Update node names to avoid unit
> addresses") was applied for similar build failure, but it was not
> applied to 'arch/mips/generic/board-ocelot_pcb123.its.S' as that was
> removed from upstream when the patch was applied.
> 
> Fixes: 822564cd3aa1 ("MIPS: generic: Update node names to avoid unit addresses")

Ah, fair enough. I missed this because the board file was renamed and
updated as part of commit 39249d776ca7 ("MIPS: mscc: add PCB120 to the
ocelot fitImage"), which was a part of 4.20... :) the upstream change
has this properly fixed and this diff matches so:

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> Cc: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> ---
>  arch/mips/generic/board-ocelot_pcb123.its.S | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/mips/generic/board-ocelot_pcb123.its.S b/arch/mips/generic/board-ocelot_pcb123.its.S
> index 5a7d5e1c878af..6dd54b7c2f076 100644
> --- a/arch/mips/generic/board-ocelot_pcb123.its.S
> +++ b/arch/mips/generic/board-ocelot_pcb123.its.S
> @@ -1,23 +1,23 @@
>  /* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
>  / {
>  	images {
> -		fdt@ocelot_pcb123 {
> +		fdt-ocelot_pcb123 {
>  			description = "MSCC Ocelot PCB123 Device Tree";
>  			data = /incbin/("boot/dts/mscc/ocelot_pcb123.dtb");
>  			type = "flat_dt";
>  			arch = "mips";
>  			compression = "none";
> -			hash@0 {
> +			hash {
>  				algo = "sha1";
>  			};
>  		};
>  	};
>  
>  	configurations {
> -		conf@ocelot_pcb123 {
> +		conf-ocelot_pcb123 {
>  			description = "Ocelot Linux kernel";
> -			kernel = "kernel@0";
> -			fdt = "fdt@ocelot_pcb123";
> +			kernel = "kernel";
> +			fdt = "fdt-ocelot_pcb123";
>  		};
>  	};
>  };
> -- 
> 2.30.2
> 
