Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164A051177D
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 14:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbiD0Lmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 07:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbiD0Lmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 07:42:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5631443FF;
        Wed, 27 Apr 2022 04:39:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59BDAB82661;
        Wed, 27 Apr 2022 11:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8164CC385A7;
        Wed, 27 Apr 2022 11:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651059563;
        bh=2sWnLCR+U6Be8jUQ4LsxtzrdL5oobmBn93Gw4sAdZKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VnsJfc82XM9uRr35ILSZsetBkTvhm2NdcP3ufkx3/Ayk8er14pdR6y1v72tX8bUSd
         G2xO/m9DHcLUQRBfCbTF0ayJJ0SU+hku9gWQa9HmQlCiXtjTH+rtWssGkKK/5pF2xn
         XtIabWKeA0zVFQU3zcbc0WS1pIyRL8i/6GwbH88E=
Date:   Wed, 27 Apr 2022 13:39:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/53] 4.19.240-rc1 review
Message-ID: <YmkrZ5t2cb1JSHR8@kroah.com>
References: <20220426081735.651926456@linuxfoundation.org>
 <20220426200000.GB9427@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426200000.GB9427@duo.ucw.cz>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 10:00:00PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.240 release.
> > There are 53 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> > Anything received after that time might be too late.
> 
> I still see problems on socfpga:
> 
> [    1.227759]  mmcblk0: p1 p2 p3
> [    1.269825] Micrel KSZ9031 Gigabit PHY stmmac-0:01: attached PHY driver [Micrel KSZ9031 Gigabit PHY] (mii_bus:phy_addr=stmmac-0:01, irq=POLL)
> [    1.284600] socfpga-dwmac ff702000.ethernet eth0: No Safety Features support found
> [    1.292374] socfpga-dwmac ff702000.ethernet eth0: registered PTP clock
> [    1.299247] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [    5.444552] Unable to handle kernel NULL pointer dereference at virtual address 00000000
> [    5.452609] pgd = (ptrval)
> [    5.455322] [00000000] *pgd=00000000
> [    5.458890] Internal error: Oops: 805 [#1] SMP ARM
> [    5.463660] Modules linked in:
> [    5.466708] CPU: 0 PID: 766 Comm: kworker/0:2 Not tainted 4.19.240-rc1-g5e5c9d690926 #1
> [    5.474674] Hardware name: Altera SOCFPGA
> [    5.478679] Workqueue: events_power_efficient phy_state_machine
> [    5.484579] PC is at socfpga_dwmac_fix_mac_speed+0x3c/0xbc
> [    5.490044] LR is at arm_heavy_mb+0x2c/0x48
> [    5.494208] pc : [<c05d9a2c>]    lr : [<c01182e8>]    psr: 60000013
> [    5.500446] sp : ee84de58  ip : ee84de48  fp : ee84de7c
> [    5.505648] r10: 00000001  r9 : ee8fb800  r8 : 00000000
> [    5.510848] r7 : 00000000  r6 : 000003e8  r5 : eebe4000  r4 : eeb0a880
> [    5.517343] r3 : 00000001  r2 : 00000730  r1 : 00000000  r0 : eeb0a880
> [    5.523842] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> [    5.530945] Control: 10c5387d  Table: 0000404a  DAC: 00000051
> [    5.536665] Process kworker/0:2 (pid: 766, stack limit = 0x(ptrval))
> [    5.542989] Stack: (0xee84de58 to 0xee84e000)
> [    5.547328] de40:                                                       ee8fb800 eebe4000
> [    5.555470] de60: eebe5000 eebe4538 00610c8c eebe4500 ee84deb4 ee84de80 c05cd084 c05d99fc
> [    5.563613] de80: c07058f0 c018fabc eebe4000 ee8fb800 eebe4000 ee8fba90 00000000 00000000
> [    5.571756] dea0: c0c77830 00000000 ee84decc ee84deb8 c05baf3c c05ccef0 ee8fba64 ee8fb800
> [    5.579899] dec0: ee84def4 ee84ded0 c05b921c c05baf08 ee8fba64 ef1cda80 ef7d2fc0 ef7d6500
> [    5.588041] dee0: 00000000 c0c77830 ee84df34 ee84def8 c013e18c c05b8ee0 ef7d2fc0 ef7d2fc0
> [    5.596183] df00: 00000008 ef7d2fd8 c0c02d00 ef1cda80 ef1cda94 ef7d2fc0 00000008 ef7d2fd8
> [    5.604327] df20: c0c02d00 ef7d2fc0 ee84df74 ee84df38 c013f178 c013df74 c013f118 c09e2128
> [    5.612469] df40: c0c77250 ffffe000 ee84df74 ef375140 ef3b9900 00000000 ee84c000 ef1cda80
> [    5.620612] df60: c013f118 ef127e74 ee84dfac ee84df78 c0144ac8 c013f124 ef37515c ef37515c
> [    5.628754] df80: ee84dfac ef3b9900 c014495c 00000000 00000000 00000000 00000000 00000000
> [    5.636896] dfa0: 00000000 ee84dfb0 c01010e8 c0144968 00000000 00000000 00000000 00000000
> [    5.645038] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [    5.653180] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
> [    5.661317] Backtrace: 
> [    5.663767] [<c05d99f0>] (socfpga_dwmac_fix_mac_speed) from [<c05cd084>] (stmmac_adjust_link+0x1a0/0x21c)
> [    5.673294]  r9:eebe4500 r8:00610c8c r7:eebe4538 r6:eebe5000 r5:eebe4000 r4:ee8fb800
> [    5.681009] [<c05ccee4>] (stmmac_adjust_link) from [<c05baf3c>] (phy_link_change+0x40/0x4c)
> [    5.689323]  r10:00000000 r9:c0c77830 r8:00000000 r7:00000000 r6:ee8fba90 r5:eebe4000
> [    5.697116]  r4:ee8fb800
> [    5.699644] [<c05baefc>] (phy_link_change) from [<c05b921c>] (phy_state_machine+0x348/0x580)
> [    5.708042]  r5:ee8fb800 r4:ee8fba64
> [    5.711610] [<c05b8ed4>] (phy_state_machine) from [<c013e18c>] (process_one_work+0x224/0x518)
> [    5.720098]  r9:c0c77830 r8:00000000 r7:ef7d6500 r6:ef7d2fc0 r5:ef1cda80 r4:ee8fba64
> [    5.727811] [<c013df68>] (process_one_work) from [<c013f178>] (worker_thread+0x60/0x5ac)
> [    5.735866]  r10:ef7d2fc0 r9:c0c02d00 r8:ef7d2fd8 r7:00000008 r6:ef7d2fc0 r5:ef1cda94
> [    5.743658]  r4:ef1cda80
> [    5.746187] [<c013f118>] (worker_thread) from [<c0144ac8>] (kthread+0x16c/0x174)
> [    5.753551]  r10:ef127e74 r9:c013f118 r8:ef1cda80 r7:ee84c000 r6:00000000 r5:ef3b9900
> [    5.761342]  r4:ef375140
> [    5.763869] [<c014495c>] (kthread) from [<c01010e8>] (ret_from_fork+0x14/0x2c)
> [    5.771057] Exception stack(0xee84dfb0 to 0xee84dff8)
> [    5.776087] dfa0:                                     00000000 00000000 00000000 00000000
> [    5.784229] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [    5.792370] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [    5.798955]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c014495c
> [    5.806747]  r4:ef3b9900
> [    5.809273] Code: e59394b8 f57ff04e ebecfa24 e3a03001 (e1c830b0) 
> [    5.815374] ---[ end trace 922ea6407635ba6b ]---
> 
> https://lava.ciplatform.org/scheduler/job/669257
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/2377419824

Can you run git bisect?
