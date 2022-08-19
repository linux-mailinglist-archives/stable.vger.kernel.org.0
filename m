Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2575999D9
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 12:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347036AbiHSKgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 06:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245098AbiHSKgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 06:36:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF9AF2C8F;
        Fri, 19 Aug 2022 03:36:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4577BB8274C;
        Fri, 19 Aug 2022 10:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A501C433C1;
        Fri, 19 Aug 2022 10:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660905394;
        bh=XlLJ8l/1+WmR0BqWmHIhNjMDhoHHPr4K1bRmEQU2kEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FomLmqxAv/zaRTN+pz2QA0qNlNg47OdmOMbej4vQkDwfgws8O0+qrWQd8+vhz5Iui
         tkGSP13X8+R7Cxnljmp29Ew6xg3Tn+4U8XWD4NH0MC+HGkXLtHNVZrcTYqrwx/Vg72
         v1Tf/28IzxDy/z46ojAtb6FgvALHw2phf9/CJsrU=
Date:   Fri, 19 Aug 2022 12:36:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        Sumit Garg <sumit.garg@linaro.org>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        stable@vger.kernel.org, Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>
Subject: Re: [PATCH v3] tee: add overflow check in register_shm_helper()
Message-ID: <Yv9nr4/XQI0Tl4XO@kroah.com>
References: <20220819094952.2602066-1-jens.wiklander@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819094952.2602066-1-jens.wiklander@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 11:49:52AM +0200, Jens Wiklander wrote:
> With special lengths supplied by user space, register_shm_helper() has
> an integer overflow when calculating the number of pages covered by a
> supplied user space memory region. This causes
> internal_get_user_pages_fast() a helper function of
> pin_user_pages_fast() to do a NULL pointer dereference.
> 
> [   14.141620] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
> [   14.142556] Mem abort info:
> [   14.142829]   ESR = 0x0000000096000044
> [   14.143237]   EC = 0x25: DABT (current EL), IL = 32 bits
> [   14.143742]   SET = 0, FnV = 0
> [   14.144052]   EA = 0, S1PTW = 0
> [   14.144348]   FSC = 0x04: level 0 translation fault
> [   14.144767] Data abort info:
> [   14.145053]   ISV = 0, ISS = 0x00000044
> [   14.145394]   CM = 0, WnR = 1
> [   14.145766] user pgtable: 4k pages, 48-bit VAs, pgdp=000000004278e000
> [   14.146279] [0000000000000010] pgd=0000000000000000, p4d=0000000000000000
> [   14.147435] Internal error: Oops: 96000044 [#1] PREEMPT SMP
> [   14.148026] Modules linked in:
> [   14.148595] CPU: 1 PID: 173 Comm: optee_example_a Not tainted 5.19.0 #11
> [   14.149204] Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
> [   14.149832] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   14.150481] pc : internal_get_user_pages_fast+0x474/0xa80
> [   14.151640] lr : internal_get_user_pages_fast+0x404/0xa80
> [   14.152408] sp : ffff80000a88bb30
> [   14.152711] x29: ffff80000a88bb30 x28: 0000fffff836d000 x27: 0000fffff836e000
> [   14.153580] x26: fffffc0000000000 x25: fffffc0000f4a1c0 x24: ffff00000289fb70
> [   14.154634] x23: ffff000002702e08 x22: 0000000000040001 x21: ffff8000097eec60
> [   14.155378] x20: 0000000000f4a1c0 x19: 00e800007d287f43 x18: 0000000000000000
> [   14.156215] x17: 0000000000000000 x16: 0000000000000000 x15: 0000fffff836cfb0
> [   14.157068] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> [   14.157747] x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
> [   14.158576] x8 : ffff00000276ec80 x7 : 0000000000000000 x6 : 000000000000003f
> [   14.159243] x5 : 0000000000000000 x4 : ffff000041ec4eac x3 : ffff000002774cb8
> [   14.159977] x2 : 0000000000000004 x1 : 0000000000000010 x0 : 0000000000000000
> [   14.160883] Call trace:
> [   14.161166]  internal_get_user_pages_fast+0x474/0xa80
> [   14.161763]  pin_user_pages_fast+0x24/0x4c
> [   14.162227]  register_shm_helper+0x194/0x330
> [   14.162734]  tee_shm_register_user_buf+0x78/0x120
> [   14.163290]  tee_ioctl+0xd0/0x11a0
> [   14.163739]  __arm64_sys_ioctl+0xa8/0xec
> [   14.164227]  invoke_syscall+0x48/0x114
> [   14.164653]  el0_svc_common.constprop.0+0x44/0xec
> [   14.165130]  do_el0_svc+0x2c/0xc0
> [   14.165498]  el0_svc+0x2c/0x84
> [   14.165847]  el0t_64_sync_handler+0x1ac/0x1b0
> [   14.166258]  el0t_64_sync+0x18c/0x190
> [   14.166878] Code: 91002318 11000401 b900f7e1 f9403be1 (f820d839)
> [   14.167666] ---[ end trace 0000000000000000 ]---
> 
> Fix this by adding an overflow check when calculating the end of the
> memory range. Also add an explicit call to access_ok() in
> tee_shm_register_user_buf() to catch an invalid user space address
> early.
> 
> Fixes: 033ddf12bcf5 ("tee: add register user memory")
> Cc: stable@vger.kernel.org
> Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
> Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
> Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
> Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>

This conflicts with 573ae4f13f63 ("tee: add overflow check in
register_shm_helper()") in Linus's tree :(

