Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03196B3E68
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCJLwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjCJLwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:52:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9870F733A2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:52:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 503E5B821BD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C75C433D2;
        Fri, 10 Mar 2023 11:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678449132;
        bh=vgNPpObDGsrC/ienNIEAoro78lSNVNRQtRKPK0+RD7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N5TQDNxBCnG5mP+Jnt0B/GkhcZniZdHvf8jvZfOV3k0+OfVxFzGxwtokEtmVPwGiB
         OMrC2PTpib1mQw4RW2R7Lh7+HU6Z9CVnJ4SioeoM1g0YzgRn3RggDIW0Tzn74pGDtq
         SyQt4bjLcp83zcOPmZOPGnmd7IjSc8YJk1SFvrzE=
Date:   Fri, 10 Mar 2023 12:52:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vasily Gorbik <gor@linux.ibm.com>
Cc:     stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH stable 4.14 4.19 0/2] Fix s390 static key early usage
Message-ID: <ZAsZ6YPlgCXhDaPU@kroah.com>
References: <cover.thread-194e16.your-ad-here.call-01678297576-ext-9970@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.thread-194e16.your-ad-here.call-01678297576-ext-9970@work.hours>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 08, 2023 at 07:12:24PM +0100, Vasily Gorbik wrote:
> Commit e4f74400308c ("s390/archrandom: simplify back to earlier design
> and initialize earlier") has been backported to stable releases including
> 4.14 and 4.19.
> Backport for 4.19
> Link: https://lore.kernel.org/all/20220704102416.326257-1-Jason@zx2c4.com/
> Backport for 4.14
> Link: https://lore.kernel.org/all/20220704102819.337213-1-Jason@zx2c4.com/
> 
> Unfortunately on stable 4.14 and stable 4.19 it missed dependencies which
> results in kernel warning and panic:
> [    0.202386] static_key_enable_cpuslocked(): static key 's390_arch_random_available+0x0/0x10' used before call to jump_label_init()
> [    0.202400] WARNING: CPU: 0 PID: 0 at kernel/jump_label.c:131 static_key_enable_cpuslocked+0x56/0xc8
> [    0.202432] Modules linked in:
> [    0.202451] CPU: 0 PID: 0 Comm: swapper Not tainted 4.19.275-25331-g5504146b2053 #2
> [    0.202467] Hardware name: IBM 3931 A01 701 (KVM/Linux)
> [    0.202485] Krnl PSW : (____ptrval____) (____ptrval____) (static_key_enable_cpuslocked+0x56/0xc8)
> [    0.202504]            R:0 T:1 IO:0 EX:0 Key:0 M:0 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> [    0.202526] Krnl GPRS: 00000000fffd3474 000000000133074c 0000000000000076 0000000000eaaab2
> [    0.202544]            0000000000000000 000000008e64b4cd ffffffffffffffff 0000000000000000
> [    0.202561]            0000003d13b13b13 0000000000f2eb88 0000000001113018 0000000002008488
> [    0.202579]            0000000001372380 0000000000bea608 00000000002e36ea 0000000000f0fe20
> [    0.202600] Krnl Code: 00000000002e36de: c0200059cf3b        larl    %r2,0000000000e1d554
> [    0.202600]            00000000002e36e4: c0e50045cf06        brasl   %r14,0000000000b9d4f0
> [    0.202600]           #00000000002e36ea: a7f40001            brc     15,00000000002e36ec
> [    0.202600]           >00000000002e36ee: c0e5fff33089        brasl   %r14,0000000000149800
> [    0.202600]            00000000002e36f4: 5810c000            l       %r1,0(%r12)
> [    0.202600]            00000000002e36f8: ec1c000c007e        cij     %r1,0,12,00000000002e3710
> [    0.202600]            00000000002e36fe: 5810c000            l       %r1,0(%r12)
> [    0.202600]            00000000002e3702: ec180029017e        cij     %r1,1,8,00000000002e3754
> [    0.202636] Call Trace:
> [    0.202654] ([<00000000002e36ea>] static_key_enable_cpuslocked+0x52/0xc8)
> [    0.202672]  [<00000000002e3858>] static_key_enable+0x38/0x48
> [    0.202691]  [<00000000010b0a52>] setup_arch+0xb72/0xb80
> [    0.202709]  [<00000000010aa966>] start_kernel+0x7e/0x540
> [    0.202728]  [<000000000010008a>] startup_continue+0x8a/0x300
> 
> [    0.207861] Jump label code mismatch at random_init+0x60/0x1a8 [00000000010f72f8]
> [    0.207882] Found:    c0 f4 00 00 00 21
> [    0.207899] Expected: c0 04 00 00 00 01
> [    0.207916] New:      c0 04 00 00 00 00
> [    0.207935] Kernel panic - not syncing: Corrupted kernel text
> [    0.207950] CPU: 0 PID: 0 Comm: swapper Tainted: G        W         4.19.275-25331-g5504146b2053 #2
> [    0.207967] Hardware name: IBM 3931 A01 701 (KVM/Linux)
> [    0.207984] Call Trace:
> [    0.208002] ([<0000000000113f6a>] show_stack+0x8a/0xd8)
> [    0.208021]  [<0000000000badcba>] dump_stack+0xaa/0xe8
> [    0.208038]  [<0000000000b9d68c>] panic+0x12c/0x270
> [    0.208055]  [<0000000000b9d1c0>] dump_fault_info.isra.0+0x0/0x330
> [    0.208073]  [<000000000011ec10>] __jump_label_transform+0x98/0xc8
> [    0.208090]  [<00000000010c5810>] jump_label_init+0xd8/0x138
> [    0.208112]  [<00000000010aaace>] start_kernel+0x1e6/0x540
> [    0.208130]  [<000000000010008a>] startup_continue+0x8a/0x300
> 
> The following 2 patches are needed to solve the issue.
> 
> Vasily Gorbik (2):
>   s390/maccess: add no DAT mode to kernel_write
>   s390/setup: init jump labels before command line parsing
> 
>  arch/s390/kernel/setup.c |  1 +
>  arch/s390/mm/maccess.c   | 16 +++++++++++-----
>  2 files changed, 12 insertions(+), 5 deletions(-)

Both now queued up, thanks.

greg k-h
