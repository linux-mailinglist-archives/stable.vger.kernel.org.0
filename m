Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C6C66DABF
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 11:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236448AbjAQKRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 05:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236731AbjAQKRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 05:17:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7404E18B27;
        Tue, 17 Jan 2023 02:17:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6CB5B8126A;
        Tue, 17 Jan 2023 10:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A813C433F0;
        Tue, 17 Jan 2023 10:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673950618;
        bh=tFX5ZU4Q5D44JoBgXvWOpc5HjwCKpEkVT0aIsph/94I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CGq/0peZJuO0PlmuiKT7p95kDn9/Q8KunfPZinkS8P6aiPxwgrze0A5/Mf9FLbPFJ
         j3zaYr0wmvckJIaetjZQAM4PRWTws/fxtIICKL7xyvTRzj6sJEtBm7Fp+ucmcFAe5w
         29U+xMhJdDCu25cm1sEslBfB443WB+oB/EwD7wxo=
Date:   Tue, 17 Jan 2023 11:16:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/658] 5.4.229-rc1 review
Message-ID: <Y8Z1mBZCwQuv/clZ@kroah.com>
References: <20230116154909.645460653@linuxfoundation.org>
 <20230116202025.GA3397667@roeck-us.net>
 <Y8Zt42qAQ2BQdxL2@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8Zt42qAQ2BQdxL2@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 17, 2023 at 10:44:03AM +0100, Greg Kroah-Hartman wrote:
> On Mon, Jan 16, 2023 at 12:20:25PM -0800, Guenter Roeck wrote:
> > Runtime:
> > 
> > Building ppc64:pseries:pseries_defconfig:smp2:net,pcnet:initrd ... running ......R... failed (crashed)
> > 
> > BUG: Kernel NULL pointer dereference at 0x00000000
> > Faulting instruction address: 0xc000000000046cc8
> > Oops: Kernel access of bad area, sig: 11 [#1]
> > BE SMP NR_CPUS=2048 NUMA pSeries
> > Modules linked in:
> > CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.19.270-rc1-00522-gc75d2b5524ab #1
> > NIP:  c000000000046cc8 LR: c000000000046ca4 CTR: 0000000000000000
> > REGS: c00000003e6878f0 TRAP: 0380   Not tainted  (4.19.270-rc1-00522-gc75d2b5524ab)
> > MSR:  8000000002009032 <SF,VEC,EE,ME,IR,DR,RI>  CR: 84000882  XER: 00000000
> > CFAR: c000000000162cf8 IRQMASK: 0
> > GPR00: c000000000046ca4 c00000003e687b70 c000000001772000 0000000000000000
> > GPR04: 0000000000000001 0000000000000001 c00000003e687990 00000000bc24d52c
> > GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000003
> > GPR12: 0000000024000882 c00000003ffff300 c000000000010e34 0000000000000000
> > GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
> > GPR20: 0000000000000000 0000000000000000 c00000000125eea8 0000000000000001
> > GPR24: c000000001379cd8 c000000001419f20 c0000000017b7d68 c0000000017b7d68
> > GPR28: 0000000000000000 0000000000000002 c00000000160efe8 c00000000168ac60
> > NIP [c000000000046cc8] .eeh_init+0x48/0x220
> > LR [c000000000046ca4] .eeh_init+0x24/0x220
> > Call Trace:
> > [c00000003e687b70] [c000000000046ca4] .eeh_init+0x24/0x220 (unreliable)
> > [c00000003e687c00] [c00000000001065c] .do_one_initcall+0x7c/0x430
> > [c00000003e687ce0] [c000000001394db4] .kernel_init_freeable+0x538/0x62c
> > [c00000003e687dc0] [c000000000010e4c] .kernel_init+0x18/0x14c
> > [c00000003e687e30] [c00000000000c0d0] .ret_from_kernel_thread+0x58/0x68
> > Instruction dump:
> > 3c62ffd7 38631c10 4811c021 60000000 2c030000 408201c8 3d22000b e92904e0
> > 2c290000 41820198 f8410028 e9290008 <e9490000> 7d4903a6 e8490008 4e800421
> > ---[ end trace 8912d02d3e80c4ae ]---
> 
> This is odd, and I don't know how to track that down.  Any hints?

Let me pull out some powerpc patches that are in this area and push out
a -rc2 to see if that resolves the issue.

thanks,

greg k-h
