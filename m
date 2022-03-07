Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFB34D0452
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 17:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiCGQm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 11:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiCGQm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 11:42:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79522DAAD;
        Mon,  7 Mar 2022 08:42:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52D4060FFD;
        Mon,  7 Mar 2022 16:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C7AC340EF;
        Mon,  7 Mar 2022 16:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646671322;
        bh=cCeFcTKoA0HdFbg50sKHYVPHLCgp/zrKFa5N/0XGs3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nAVxDee35AASEIEtky1C9I/DubZYctIAJpp05hvPqjBtN73TaKDo+3j8mZc0yegqe
         15r++axCcsInReG+C4hshNfZZ8K2qeEe3bDifuVsqmRqhCcLlnkjTBvwpIcuYrAww+
         D7zbZ08oxOkX5xzUB8xgGXDpCevZXEFAVK7y4EHI=
Date:   Mon, 7 Mar 2022 17:41:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/262] 5.15.27-rc1 review
Message-ID: <YiY1151bYrq+AvHM@kroah.com>
References: <20220307091702.378509770@linuxfoundation.org>
 <24c54a05-bb80-a128-d0ba-a78c6d5d101c@roeck-us.net>
 <YiYw3hV2r8DTa7fb@kroah.com>
 <e23ebf8b-5227-cc97-d166-797a4e852cd2@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e23ebf8b-5227-cc97-d166-797a4e852cd2@roeck-us.net>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 07, 2022 at 08:34:48AM -0800, Guenter Roeck wrote:
> On 3/7/22 08:20, Greg Kroah-Hartman wrote:
> > On Mon, Mar 07, 2022 at 06:36:22AM -0800, Guenter Roeck wrote:
> > > On 3/7/22 01:15, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.15.27 release.
> > > > There are 262 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > 
> > > In addition to other reported build errors:
> > > 
> > > Building mips:allmodconfig ... failed
> > > --------------
> > > Error log:
> > > drivers/net/hamradio/mkiss.c:35: error: "END" redefined
> > 
> > That is odd, I don't see any changes to that driver, nor any MIPS
> > changes that touch "END".
> > 
> > I don't even see "END" in the diff anywhere.
> > 
> > Any chance you can bisect?
> > 
> 
> git bisect start 'HEAD' 'v5.15.26'
> # bad: [20ab3ebe56f306d821cf1c6858cf29f4d2e0075a] drm/amd/display: Fix stream->link_enc unassigned during stream removal
> git bisect bad 20ab3ebe56f306d821cf1c6858cf29f4d2e0075a
> # bad: [2f01eec30992529350bae197f73d71136b35e3b1] Input: ti_am335x_tsc - fix STEPCONFIG setup for Z2
> git bisect bad 2f01eec30992529350bae197f73d71136b35e3b1
> # good: [d369b344b4fb5a6ab9f72bacece674526761b885] arm64: Mark start_backtrace() notrace and NOKPROBE_SYMBOL
> git bisect good d369b344b4fb5a6ab9f72bacece674526761b885
> # good: [46f46f14bd45acdabcfb1d9f3b648f4a27d18c08] bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC
> git bisect good 46f46f14bd45acdabcfb1d9f3b648f4a27d18c08
> # bad: [5b0c543b875e976e74c347b2d009c6519a6d2939] KVM: s390: Ensure kvm_arch_no_poll() is read once when blocking vCPU
> git bisect bad 5b0c543b875e976e74c347b2d009c6519a6d2939
> # bad: [58452f46ddb11fbe5b5f31d93a979d57efdad4b1] PCI: rcar: Check if device is runtime suspended instead of __clk_is_enabled()
> git bisect bad 58452f46ddb11fbe5b5f31d93a979d57efdad4b1
> # bad: [d6ab8da0cb6234fbc4fd240b9d7470b4c03d5df9] signal: In get_signal test for signal_group_exit every time through the loop
> git bisect bad d6ab8da0cb6234fbc4fd240b9d7470b4c03d5df9
> # bad: [53863a048566989e87f8bb306e835f940a10ed73] MIPS: fix local_{add,sub}_return on MIPS64
> git bisect bad 53863a048566989e87f8bb306e835f940a10ed73
> # first bad commit: [53863a048566989e87f8bb306e835f940a10ed73] MIPS: fix local_{add,sub}_return on MIPS64
> 
> The problem is the innocent looking
> 
>  #include <linux/atomic.h>
> +#include <asm/asm.h>
>  #include <asm/cmpxchg.h>
> 
> in that patch. Reverting it fixes the problem. Alternatively, you could apply
> commit 16517829f2e0 ("hamradio: fix macro redefine warning").

Ah, that works better, I'll go queue that one up, thanks!

greg k-h
