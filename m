Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426865705BD
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 16:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiGKOgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 10:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGKOgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 10:36:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD0865D7D;
        Mon, 11 Jul 2022 07:36:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30C65B80FAE;
        Mon, 11 Jul 2022 14:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B25C34115;
        Mon, 11 Jul 2022 14:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657550194;
        bh=V6QwPdhvRlFZNf3VcUzFm9OphswgaGgjtz+UmgND7H0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rHbA9jkFoEINUY5zhlcGh04NP9luzwWnk/Nht835LvKS7Yb6v/19n3iLIgbh+YNHp
         YWHiCrCdaGHk4qW4xYorqAHgcF1Xq5aJlu9VkP1T2SERxvtasy1OInuiMxAknl+Pna
         3NQwCCL7hTE5wO+MO/7iuI5TbGWnrQojN4ZnlERs=
Date:   Mon, 11 Jul 2022 16:36:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/230] 5.15.54-rc1 review
Message-ID: <Ysw1cCYRwnpvhO7d@kroah.com>
References: <20220711090604.055883544@linuxfoundation.org>
 <7c552ad4-81e9-2abe-3114-dd55c924844c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c552ad4-81e9-2abe-3114-dd55c924844c@nvidia.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 01:43:59PM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 11/07/2022 10:04, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.54 release.
> > There are 230 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.54-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> 
> ...
> 
> > Mark Rutland <mark.rutland@arm.com>
> >      irqchip/gic-v3: Ensure pseudo-NMIs have an ISB between ack and handling
> 
> 
> The above change is missing a semi-colon and so is causing the following
> build error ...
> 
> drivers/irqchip/irq-gic-v3.c: In function 'gic_handle_nmi':
> drivers/irqchip/irq-gic-v3.c:666:2: error: expected ';' before 'err'
>   err = handle_domain_nmi(gic_data.domain, irqnr, regs);
>   ^~~

Ah, the original also didn't have the ; I'll go find the fix commit for
this...

> 
> > Hou Tao <houtao1@huawei.com>
> >      bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC
> 
> And the above commit is generating the following build error ...
> 
> arch/arm64/net/bpf_jit_comp.c: In function 'build_insn':
> arch/arm64/net/bpf_jit_comp.c:791:7: error: implicit declaration of function
> 'bpf_pseudo_func' [-Werror=implicit-function-declaration]
>    if (bpf_pseudo_func(insn))
>        ^~~~~~~~~~~~~~~

Thanks, will figure this one out and do a -rc2 release.

greg k-h
