Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BE659B8BF
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 07:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbiHVFf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 01:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiHVFf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 01:35:57 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548BE255B7
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 22:35:56 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso12895151pjk.0
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 22:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=QS6R5nZMIK6gA3aruuq42VvpoButXSF80ZMGO0OR8L0=;
        b=kKvvmUU2WSBCymUSA5+wbvHN1r2QYyYxauHAjmwr4b5D3khHa7EyE2dBFabTOhF4UT
         9/2P78WbU9LJE8Vo7cAa8/JHNTCs8BqYDwWt9zqFcDkCU0lRWHMWRD3/fX/ofzuQBfj5
         9gg+A0pngTHaBK3pfZpLUtID7LuxdYzugDAvi1yULyVGtJm9anD5IdcpYbbh2ts6O0IF
         R4j9yv7nbynfpgCNhMLzu/+Q7wQ65fnBtSK2qxoVdJ+lyAi4ws+3P82P4Teu7dWfbgwJ
         XHdfZRlIxeIHOKX/6vmNmDrYJlo3uvbwWr7CZL2R6mGrDbQzTt0Be2r0PzfJncVs3mMT
         54RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=QS6R5nZMIK6gA3aruuq42VvpoButXSF80ZMGO0OR8L0=;
        b=bxaLfsG0mIpym4BSLxGtrZ879ZBGFUkXSE9zZPqG2yr5pQpuLWaaifez0+J+FWkM2O
         OvvxmLc3bdkLQKcR98MejPWhFTTl4JFd3OOrOkhQZu+CsoVfMLvWXXJYZJ899p7UynNa
         9ObacbsfWs2i5K0tsF83Ffbjut35MpoFHsQhQhMDpPKvZU/3Gy9h5mTVtcqPq5+J9tev
         EELluC5Ag5WHyktwqnW16IvFVupyNAIunY63BeXVfo1pTiQnx3dgSAZ3xJBUUHEMWnY6
         UgF6VXzF53MxMt/bpkx+Re3AYrt6DRg7hBYNr8LKkDqHc1bjEp6wobmKq+aoY/QML09M
         Dm4g==
X-Gm-Message-State: ACgBeo0GznQoa2jwBv2v7ou1d5VQDnVLnB6HONReUmkiKXwSTNJyI3+l
        di+nQ9HhnOAEulozwAIGzPnMvdcLw2txuW+eVu8VMw==
X-Google-Smtp-Source: AA6agR7JBggyeN+ALMC17ITNb5ULT/kTmDt31iHyxtQJv1UdDcInVmjE6Truhipy96YiKUShdKsTNoXYiRJgBZAeV7A=
X-Received: by 2002:a17:902:c411:b0:170:91ff:884b with SMTP id
 k17-20020a170902c41100b0017091ff884bmr18722820plk.58.1661146555850; Sun, 21
 Aug 2022 22:35:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220819094952.2602066-1-jens.wiklander@linaro.org> <Yv9nr4/XQI0Tl4XO@kroah.com>
In-Reply-To: <Yv9nr4/XQI0Tl4XO@kroah.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Mon, 22 Aug 2022 07:35:44 +0200
Message-ID: <CAHUa44HGOQz+gb6wKG7gCQaXo4XvLMcXYd4Afkv2233qX+0r0A@mail.gmail.com>
Subject: Re: [PATCH v3] tee: add overflow check in register_shm_helper()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        Sumit Garg <sumit.garg@linaro.org>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        stable@vger.kernel.org, Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 12:36 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Aug 19, 2022 at 11:49:52AM +0200, Jens Wiklander wrote:
> > With special lengths supplied by user space, register_shm_helper() has
> > an integer overflow when calculating the number of pages covered by a
> > supplied user space memory region. This causes
> > internal_get_user_pages_fast() a helper function of
> > pin_user_pages_fast() to do a NULL pointer dereference.
> >
> > [   14.141620] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
> > [   14.142556] Mem abort info:
> > [   14.142829]   ESR = 0x0000000096000044
> > [   14.143237]   EC = 0x25: DABT (current EL), IL = 32 bits
> > [   14.143742]   SET = 0, FnV = 0
> > [   14.144052]   EA = 0, S1PTW = 0
> > [   14.144348]   FSC = 0x04: level 0 translation fault
> > [   14.144767] Data abort info:
> > [   14.145053]   ISV = 0, ISS = 0x00000044
> > [   14.145394]   CM = 0, WnR = 1
> > [   14.145766] user pgtable: 4k pages, 48-bit VAs, pgdp=000000004278e000
> > [   14.146279] [0000000000000010] pgd=0000000000000000, p4d=0000000000000000
> > [   14.147435] Internal error: Oops: 96000044 [#1] PREEMPT SMP
> > [   14.148026] Modules linked in:
> > [   14.148595] CPU: 1 PID: 173 Comm: optee_example_a Not tainted 5.19.0 #11
> > [   14.149204] Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
> > [   14.149832] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > [   14.150481] pc : internal_get_user_pages_fast+0x474/0xa80
> > [   14.151640] lr : internal_get_user_pages_fast+0x404/0xa80
> > [   14.152408] sp : ffff80000a88bb30
> > [   14.152711] x29: ffff80000a88bb30 x28: 0000fffff836d000 x27: 0000fffff836e000
> > [   14.153580] x26: fffffc0000000000 x25: fffffc0000f4a1c0 x24: ffff00000289fb70
> > [   14.154634] x23: ffff000002702e08 x22: 0000000000040001 x21: ffff8000097eec60
> > [   14.155378] x20: 0000000000f4a1c0 x19: 00e800007d287f43 x18: 0000000000000000
> > [   14.156215] x17: 0000000000000000 x16: 0000000000000000 x15: 0000fffff836cfb0
> > [   14.157068] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> > [   14.157747] x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
> > [   14.158576] x8 : ffff00000276ec80 x7 : 0000000000000000 x6 : 000000000000003f
> > [   14.159243] x5 : 0000000000000000 x4 : ffff000041ec4eac x3 : ffff000002774cb8
> > [   14.159977] x2 : 0000000000000004 x1 : 0000000000000010 x0 : 0000000000000000
> > [   14.160883] Call trace:
> > [   14.161166]  internal_get_user_pages_fast+0x474/0xa80
> > [   14.161763]  pin_user_pages_fast+0x24/0x4c
> > [   14.162227]  register_shm_helper+0x194/0x330
> > [   14.162734]  tee_shm_register_user_buf+0x78/0x120
> > [   14.163290]  tee_ioctl+0xd0/0x11a0
> > [   14.163739]  __arm64_sys_ioctl+0xa8/0xec
> > [   14.164227]  invoke_syscall+0x48/0x114
> > [   14.164653]  el0_svc_common.constprop.0+0x44/0xec
> > [   14.165130]  do_el0_svc+0x2c/0xc0
> > [   14.165498]  el0_svc+0x2c/0x84
> > [   14.165847]  el0t_64_sync_handler+0x1ac/0x1b0
> > [   14.166258]  el0t_64_sync+0x18c/0x190
> > [   14.166878] Code: 91002318 11000401 b900f7e1 f9403be1 (f820d839)
> > [   14.167666] ---[ end trace 0000000000000000 ]---
> >
> > Fix this by adding an overflow check when calculating the end of the
> > memory range. Also add an explicit call to access_ok() in
> > tee_shm_register_user_buf() to catch an invalid user space address
> > early.
> >
> > Fixes: 033ddf12bcf5 ("tee: add register user memory")
> > Cc: stable@vger.kernel.org
> > Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
> > Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
> > Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
> > Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
> > Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
>
> This conflicts with 573ae4f13f63 ("tee: add overflow check in
> register_shm_helper()") in Linus's tree :(
>

I'm sorry, I didn't notice that a fixed up version was already applied.

Thanks,
Jens
