Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B18D6A1FAF
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 17:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjBXQck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 11:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBXQcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 11:32:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF076A7BE
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 08:32:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B20061927
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 16:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C44C4339C;
        Fri, 24 Feb 2023 16:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677256350;
        bh=y4cwzKHY0rdTHSoLcGNukwvUgSVLhPLJhCFWCAL+0nA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HGMw2modbXaH+bULIX2yYhhekqM2zo3zzQehQx04dgqRH+qBMf1v0UCh6Vfdi/WxE
         diq19+GBoqYJ2D8/RaEknfd+XAx4Kr35xNmvMC1WsWj9yhcIpYVCXo8sehbSSemTQv
         iqcFYMLf8Rit6SiKMkKi4T1RPo7Fpq3xeR5crKlT3dEAtZzKLYBLc41tKN5OGgJx0/
         yPfQGg5YSmSpHfiC9GWxc6X2IuTVakse/LSiVTo/M1CMBjY2UC9ae6XkfAK9ewBLdP
         zyQS9YK/fFdYA2L2B8EJhhtA/CzS47IKuqW9ZRtDyGog8Zfam8lFkH6MR50B/jdCsv
         ekhqxZu5JnTAw==
Date:   Fri, 24 Feb 2023 09:32:27 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Conor Dooley <conor@kernel.org>
Cc:     palmer@dabbelt.com, Conor Dooley <conor.dooley@microchip.com>,
        naresh.kamboju@linaro.org, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v1 2/2] RISC-V: make TOOLCHAIN_NEEDS_SPEC_20191213 gas
 only
Message-ID: <Y/jmm0Q7ypzkUaXw@dev-arch.thelio-3990X>
References: <20230223220546.52879-1-conor@kernel.org>
 <20230223220546.52879-3-conor@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223220546.52879-3-conor@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Conor,

On Thu, Feb 23, 2023 at 10:05:46PM +0000, Conor Dooley wrote:
> From: Conor Dooley <conor.dooley@microchip.com>
> 
> Quoting the llvm docs:
> > Between versions 2.0 and 2.1 of the base I specification, a backwards
> > incompatible change was made to remove selected instructions and CSRs
> > from the base ISA. These instructions were grouped into a set of new
> > extensions, but were no longer required by the base ISA. (snip) LLVM
> > currently implements version 2.0 of the base specification. Thus,
> > instructions from these extensions are accepted as part of the base
> > ISA.
> 
> There is therefore no need (at present!) to carry out a $cc-option
> check, and instead just gate presence of zicsr and zifencei in march
> on the version of binutils that commit 6df2a016c0c8 ("riscv: fix build
> with binutils 2.38") highlights as the introduction of the requirement.
> 
> In fact, the status quo creates some issues with mixed llvm/binutils
> builds, specifically building with llvm-17 and ld from binutils-2.35.
> Odd combo you may think, but this is what tuxsuite's debian stable uses
> while testing 5.10 stable kernels as doesn't support LLD.
> 
> CC: stable@vger.kernel.org # needs RISC-V: move zicsr/zifencei spec version check to Kconfi

I think it would be better to drop this comment and just mark patch 1
for stable directly. However, if it remains, 'Kconfi' -> 'Kconfig' :)

> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Link: https://lore.kernel.org/all/CA+G9fYt9T=ELCLaB9byxaLW2Qf4pZcDO=huCA0D8ug2V2+irJQ@mail.gmail.com/
> Suggested-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

Thanks for helping getting down to the bottom of this!

> ---
>  arch/riscv/Kconfig | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 4eb0ef8314b3..c6902f4c5650 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -291,8 +291,7 @@ endchoice
>  config TOOLCHAIN_NEEDS_SPEC_20191213
>  	bool
>  	default y
> -	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zicsr_zifencei)
> -	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zicsr_zifencei)
> +	depends on AS_IS_GNU && AS_VERSION >= 23800
>  	help
>  	  Newer binutils versions default to ISA spec version 20191213 which
>  	  moves some instructions from the I extension to the Zicsr and Zifencei
> -- 
> 2.39.1
> 
