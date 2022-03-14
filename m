Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D4E4D7AD8
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 07:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbiCNGhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 02:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234712AbiCNGhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 02:37:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B335B3DA62;
        Sun, 13 Mar 2022 23:36:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C82DB80D31;
        Mon, 14 Mar 2022 06:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1DBC340E9;
        Mon, 14 Mar 2022 06:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647239759;
        bh=aVbMMJ1VfcBoCh49NksJD25dn7TRfZkkdfsctr9Rksk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Aru3va/n2U+njsRxdLOvUFJlsAvi5y8kJNpNjBf92aPhJdBJWJRsZVYqGKMzAIg0O
         z8aWP5tMyjJ1506b1I4jkA36MDxAvIc0i37dPntESDwCVPzNAdzKyxo8VoMlF59ZDc
         7riUO/IBWVgf3FFmdsdhI1NSgaYjrI8YkdP9qysU=
Date:   Mon, 14 Mar 2022 07:35:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "A. Wilcox" <awilfox@adelielinux.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [BUG] arm64/m1: Accessing SYS_ID_AA64ISAR2_EL1 causes early boot
 failure on 5.15.28, 5.16.14, 5.17
Message-ID: <Yi7iRSHaFGsYup1p@kroah.com>
References: <32EA0FE1-5254-4A41-B684-AA2DEC021110@adelielinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32EA0FE1-5254-4A41-B684-AA2DEC021110@adelielinux.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 13, 2022 at 10:59:01PM -0500, A. Wilcox wrote:
> Hello,
> 
> I’ve been testing kernel updates for the Adélie Linux distribution’s ARM64 port using a Parallels VM on a MacBook Pro (13-inch, M1, 2020).  When the kernel attempts to access SYS_ID_AA64ISAR2_EL1, it causes a fault as seen here booting 5.17.0-rc8:
> 
> 
> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410f0000]
> [    0.000000] Linux version 5.17.0-rc8-easy (awilcox@adelie-m1) (gcc (Adelie 8.3.0) 8.3.0, GNU ld (GNU Binutils) 2.32) #1 SMP Sun Mar 13 22:19:54 CDT 2022
> [    0.000000] Machine model: Parallels ARM Virtual Machine
> [    0.000000] earlycon: pl11 at MMIO 0x0000000002110000 (options '')
> [    0.000000] printk: bootconsole [pl11] enabled
> [    0.000000] efi: EFI v2.70 by EDK II
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] kernel BUG at arch/arm64/kernel/traps.c:498!
> [    0.000000] Internal error: Oops - BUG: 0 [#1] SMP
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.17.0-rc8-easy #1
> [    0.000000] Hardware name: Parallels ARM Virtual Machine (DT)
> [    0.000000] pstate: 004000c5 (nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [    0.000000] pc : do_undefinstr+0x4d0/0x5b0
> [    0.000000] lr : do_undefinstr+0x21c/0x5b0
> [    0.000000] sp : ffff800009763c00
> [    0.000000] x29: ffff800009763c00 x28: ffff800009773680 x27: ffff8000093d0108
> [    0.000000] x26: 0000000000000000 x25: ffff8000093d0108 x24: ffff8000091e5098
> [    0.000000] x23: 00000000404000c5 x22: ffff8000080805e8 x21: 0000000138cfd000
> [    0.000000] x20: ffff800009763c90 x19: ffff8000091e5098 x18: 0000000000000010
> [    0.000000] x17: 000000000000036f x16: 0000000000014000 x15: 0000000400000000
> [    0.000000] x14: 000000000000036f x13: 0000000400000000 x12: 000000000000036f
> [    0.000000] x11: 0000000400000000 x10: 00000000005b0000 x9 : 000000013fa50000
> [    0.000000] x8 : 0000000400000000 x7 : 0000000000000003 x6 : 0000000000000000
> [    0.000000] x5 : 0000000000000000 x4 : ffff800009911108 x3 : 0000000000000000
> [    0.000000] x2 : ffff800009775ac0 x1 : ffff800009911108 x0 : 00000000404000c5
> [    0.000000] Call trace:
> [    0.000000]  do_undefinstr+0x4d0/0x5b0
> [    0.000000]  el1_undef+0x2c/0x48
> [    0.000000]  el1h_64_sync_handler+0x8c/0xd0
> [    0.000000]  el1h_64_sync+0x78/0x7c
> [    0.000000]  __cpuinfo_store_cpu+0x70/0x230
> [    0.000000]  cpuinfo_store_boot_cpu+0x28/0x54
> [    0.000000]  smp_prepare_boot_cpu+0x2c/0x38
> [    0.000000]  start_kernel+0x490/0x918
> [    0.000000]  __primary_switched+0xc0/0xc8
> [    0.000000] Code: 54fff641 17ffffa6 a9025bf5 f9001bf7 (d4210000) 
> [    0.000000] ---[ end trace 0000000000000000 ]---
> 
> 
> Disabling the access of SYS_ID_AA64ISAR2_EL1 in __cpuinfo_store_cpu causes failure a bit later on; this trace is taken from a 5.15.28 tree:
> 
> 
> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410f0000]
> [    0.000000] Linux version 5.15.28-mc1-easy (awilcox@adelie-m1) (gcc (Adelie 8.3.0) 8.3.0, GNU ld (GNU Binutils) 2.32) #1 SMP Sun Mar 13 21:17:53 CDT 2022
> [    0.000000] Machine model: Parallels ARM Virtual Machine
> [    0.000000] earlycon: pl11 at MMIO 0x0000000002110000 (options '')
> [    0.000000] printk: bootconsole [pl11] enabled
> [    0.000000] efi: EFI v2.70 by EDK II
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] kernel BUG at arch/arm64/kernel/traps.c:498!
> [    0.000000] Internal error: Oops - BUG: 0 [#1] SMP
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.15.28-mc1-easy #1
> [    0.000000] Hardware name: Parallels ARM Virtual Machine (DT)
> [    0.000000] pstate: 004000c5 (nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [    0.000000] pc : do_undefinstr+0x4d0/0x5b0
> [    0.000000] lr : do_undefinstr+0x21c/0x5b0
> [    0.000000] sp : ffff8000097b3b30
> [    0.000000] x29: ffff8000097b3b30 x28: ffff8000097c3740 x27: 0000000000000020
> [    0.000000] x26: ffff800008e737b8 x25: ffff80000995f540 x24: ffff8000092595d8
> [    0.000000] x23: 00000000804000c5 x22: ffff800008126340 x21: 0000000138d6b000
> [    0.000000] x20: ffff8000097b3bc0 x19: ffff800009258b58 x18: 0000000000000010
> [    0.000000] x17: 000000000000036f x16: 0000000000014000 x15: 0000000000000025
> [    0.000000] x14: ffff8000097b3a40 x13: 00000000ffffffea x12: ffff800009808ea8
> [    0.000000] x11: 0000000000000003 x10: ffff8000097fce68 x9 : ffff8000097fcec0
> [    0.000000] x8 : 000000000000bfe8 x7 : c0000000fffff7ff x6 : 0000000000000001
> [    0.000000] x5 : 0000000000000000 x4 : ffff80000995f108 x3 : 0000000000000000
> [    0.000000] x2 : ffff8000097c5b38 x1 : ffff80000995f108 x0 : 00000000804000c5
> [    0.000000] Call trace:
> [    0.000000]  do_undefinstr+0x4d0/0x5b0
> [    0.000000]  el1_undef+0x2c/0x48
> [    0.000000]  el1h_64_sync_handler+0x8c/0xd0
> [    0.000000]  el1h_64_sync+0x78/0x7c
> [    0.000000]  is_spectre_bhb_affected+0x38/0xb8
> [    0.000000]  update_cpu_capabilities+0x74/0x128
> [    0.000000]  init_cpu_features+0x250/0x274
> [    0.000000]  cpuinfo_store_boot_cpu+0x48/0x54
> [    0.000000]  smp_prepare_boot_cpu+0x2c/0x38
> [    0.000000]  start_kernel+0x4c0/0x948
> [    0.000000]  __primary_switched+0xbc/0xc4
> [    0.000000] Code: 54fff641 17ffffa6 a9025bf5 f9001bf7 (d4210000) 
> [    0.000000] lrng_drng: ChaCha20 core initialized with first seeding
> [    0.000000] ---[ end trace 921bf73327f0869a ]—
> 
> 
> This is because detection of the clearbhb instruction support requires accessing SYS_ID_AA64ISAR2_EL1.  Commenting out the two uses of supports_clearbhb in the kernel now yields a successful boot.
> 
> Qemu developers seem to have found this issue as well[1] when trying to boot 5.17 using HVF, the Apple Hypervisor Framework.  This seems to be some sort of platform quirk on M1, or at least in HVF on M1.  I’m not sure what the best workaround would be for this.  SYS_ID_AA64ISAR2_EL1 seems to be something added in ARMv8.7, so perhaps access to it could be gated on that.  
> 
> Unfortunately, this code was just added to 5.15.28 and 5.16.14, so stable no longer boots on Parallels VM on M1.  I am unsure if this affects physical boot on Apple M1 or not.

What commit causes this problem?  It sounds like you narrowed this down
already, right?

thanks,

greg k-h
