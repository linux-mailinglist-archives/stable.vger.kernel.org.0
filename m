Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C863D57EA
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 12:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbhGZKRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 06:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbhGZKRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 06:17:21 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C69C061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 03:57:49 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id z7so10479368wrn.11
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 03:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1cDWyoRkKOnfxTxK/yf3LQCv2XExtPS1fOOG+9DGUHU=;
        b=ZdbSRi0TSFxo4f24hjy/ECtKNjhWxGsF1VgsmlzQMkx6Dqs0l5xt8L8i7YlIIciMjt
         oc14Cv2Ec81knB6YnbdCwOfW7pkYGmBqwdPhPB+oVCL5yss2y9mdTf1vJpL9g0lxLOSp
         9bq4CZ8U3i3M4Xle1RCwTao94FWfwG4PhHgAE6WkLYem7ptf6nIoJ2st151Boq3qJHVT
         vgDGxRr+TqjOVStYLtg505FDZljDwAzWzi32CoShXHHvyIFmw0qJBInqXM7mW/LHy7vq
         FH1/fB61y1te/lKrxHCMz83Q/vgxQOs+3sIfgCxRNQM3nsHCQibnUuX2hQEhtwqSases
         3sMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1cDWyoRkKOnfxTxK/yf3LQCv2XExtPS1fOOG+9DGUHU=;
        b=POr/e+X2V74gGN1dX+83k/jaitqilQqKFlwS7maHxiV1q0Ox98XNjDHVt1YHPVB/XC
         LhIQWoBW5HDGWpxFqSpfdHL9ceiZKxb3X1cb11mgNuEiIQB9wE6pPUhBPXMC8BiOT29G
         cBMxZ6fJhB97BjRDGB6QR8QyoiAOfJsAMLhKsZdDK+XHPgD38Blk1LkWtm87wrQvKUvz
         9rVQ3UrNq+N3/aAG2Cq8KbC2czn4TTC03XGgBFNG9WOCMyKFHTTBAg9Xt66SUDDzWdnq
         wtuqyE9XZepxHz3yf0oYsc8yZE4cC0AyUqwg41343D8T4t1rZZGOl70QIEUPCe0s3QkK
         t1Vg==
X-Gm-Message-State: AOAM530OC0qIy91burMEwogEhaimqHC5gwF9z398Z6x4y3s1dB0uY4EB
        ByOIZJCCc/QjuX7tW6h1sTs=
X-Google-Smtp-Source: ABdhPJwPCBbfECAgSffMnlbHSUZ5QEXNK2xahOraf90OxhcTicxddNcDyCMweEdA574UQrOW4BlmMw==
X-Received: by 2002:adf:de11:: with SMTP id b17mr14671925wrm.403.1627297068269;
        Mon, 26 Jul 2021 03:57:48 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.244])
        by smtp.gmail.com with ESMTPSA id h9sm35149655wmb.35.2021.07.26.03.57.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 03:57:47 -0700 (PDT)
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
References: <YP6OkehtVdkjKikL@debian>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: use-after-free" with v5.10.y caused by backport of a298232ee6b9
 ("io_uring: fix link timeout refs")
Message-ID: <d1ff5d9c-2e13-acc2-fd8f-a8f4f180a8bb@gmail.com>
Date:   Mon, 26 Jul 2021 11:57:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YP6OkehtVdkjKikL@debian>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 11:29 AM, Sudip Mukherjee wrote:
> Hi Pavel,
> 
> We had been running syzkaller on v5.10.y and a "use after free" is being
> reported for v5.10.43+ kernels.

"... # 5.12+", weird, but perhaps due to dependencies.
Thanks for letting know.


Greg, Sasha, should be same as reported for 5.12

https://www.spinics.net/lists/stable/msg485116.html

Can you try to apply it to 5.10 or should I resend?


> The syzkaller report is at: https://elisa-builder-00.iol.unh.edu/syzkaller/file?name=crashes%2fb23bc4ad436bbe4afc620d9503730ddd78c382c0%2freport19
> 
> The trace is:
> 
> refcount_t: underflow; use-after-free.
> WARNING: CPU: 1 PID: 8769 at lib/refcount.c:28 refcount_warn_saturate+0x103/0x1f0 lib/refcount.c:28
> Modules linked in:
> CPU: 1 PID: 8769 Comm: syz-executor.6 Not tainted 5.10.52 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> RIP: 0010:refcount_warn_saturate+0x103/0x1f0 lib/refcount.c:28
> Code: 1d d2 63 54 03 31 ff 89 de e8 c9 22 51 ff 84 db 75 a3 e8 90 29 51 ff 48 c7 c7 20 38 3b 84 c6 05 b2 63 54 03 01 e8 cc 0c c9 01 <0f> 0b eb 87 e8 74 29 51 ff 0f b6 1d 9b 63 54 03 31 ff 89 de e8 94
> RSP: 0018:ffff88804ec5f9f8 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000040000 RSI: ffffffff81293053 RDI: ffffed1009d8bf31
> RBP: ffff888048ceb41c R08: 0000000000000001 R09: ffff88806cf1ff9b
> R10: 0000000000000000 R11: 0000000000000001 R12: ffff888048ceb41c
> R13: 0000000000000000 R14: ffff888048ceb558 R15: ffff88800c857180
> FS:  00007f0e798e9700(0000) GS:ffff88806cf00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000558bbbc7d898 CR3: 0000000048fb6000 CR4: 0000000000350ee0
> Call Trace:
>  __refcount_sub_and_test include/linux/refcount.h:283 [inline]
>  __refcount_dec_and_test include/linux/refcount.h:315 [inline]
>  refcount_dec_and_test include/linux/refcount.h:333 [inline]
>  io_put_req+0xc6/0x100 fs/io_uring.c:2220
>  __io_queue_sqe+0x2b1/0xd00 fs/io_uring.c:6358
>  io_queue_sqe+0x5bc/0x1020 fs/io_uring.c:6403
>  io_queue_link_head fs/io_uring.c:6414 [inline]
>  io_submit_sqe fs/io_uring.c:6455 [inline]
>  io_submit_sqes+0x17b5/0x2310 fs/io_uring.c:6700
>  __do_sys_io_uring_enter+0x1092/0x1910 fs/io_uring.c:9092
>  do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x466609
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f0e798e9188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 0000000000466609
> RDX: 0000000000000000 RSI: 00000000000058ab RDI: 0000000000000004
> RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
> R13: 00007ffdbe4f1c5f R14: 00007f0e798e9300 R15: 0000000000022000
> irq event stamp: 1473
> hardirqs last  enabled at (1483): [<ffffffff8128f5d9>] console_unlock+0x929/0xb30 kernel/printk/printk.c:2552
> hardirqs last disabled at (1494): [<ffffffff83c43a7b>] sysvec_apic_timer_interrupt+0xb/0xa0 arch/x86/kernel/apic/apic.c:1095
> softirqs last  enabled at (1072): [<ffffffff83e00f92>] asm_call_irq_on_stack+0x12/0x20
> softirqs last disabled at (1067): [<ffffffff83e00f92>] asm_call_irq_on_stack+0x12/0x20
> 
> I have done a bisect and the commit causing this is: 0b2a990e5d2f ("io_uring: fix link timeout refs")
> 
> The git bisect log is:
> # bad: [71046eac2db9aeccf10763d034a1a123911c9a81] Linux 5.10.53
> # good: [2c85ebc57b3e1817b6ce1a6b703928e113a90442] Linux 5.10
> git bisect start 'v5.10.53' 'v5.10'
> # good: [d29c38dd926d5aba65d177c0b99381ea632ff0a0] staging: rtl8192e: Change state information from u16 to u8
> git bisect good d29c38dd926d5aba65d177c0b99381ea632ff0a0
> # good: [b67c3d74adc3f7f832f57c170234bbe1fc69c87c] Revert "net: fujitsu: fix a potential NULL pointer dereference"
> git bisect good b67c3d74adc3f7f832f57c170234bbe1fc69c87c
> # bad: [f1f30b3373df2e5ab96dd3781df5c02e5366f845] mmc: usdhi6rol0: fix error return code in usdhi6_probe()
> git bisect bad f1f30b3373df2e5ab96dd3781df5c02e5366f845
> # bad: [3d60457d74d9cc7b36f78f9cb74f29bc6182c1e8] cxgb4: fix endianness when flashing boot image
> git bisect bad 3d60457d74d9cc7b36f78f9cb74f29bc6182c1e8
> # bad: [3a6b69221f96f87c680bbc9fba01db3415b18f27] drm/amdgpu: make sure we unpin the UVD BO
> git bisect bad 3a6b69221f96f87c680bbc9fba01db3415b18f27
> # good: [65859eca4dff1af0db5e36d1cfbac15b834c6a65] Linux 5.10.42
> git bisect good 65859eca4dff1af0db5e36d1cfbac15b834c6a65
> # good: [a1bf16616d8351a2e79400d6d19608befb2ce1dd] ixgbe: add correct exception tracing for XDP
> git bisect good a1bf16616d8351a2e79400d6d19608befb2ce1dd
> # bad: [c5155c741a484e036e7997420559431a951f2106] wireguard: allowedips: allocate nodes in kmem_cache
> git bisect bad c5155c741a484e036e7997420559431a951f2106
> # good: [3c23e23c7ad9844a645f4e2bd8ec34a0a2ee5514] riscv: vdso: fix and clean-up Makefile
> git bisect good 3c23e23c7ad9844a645f4e2bd8ec34a0a2ee5514
> # bad: [74caf718cc7422a957aac381c73d798c0a999a65] Bluetooth: use correct lock to prevent UAF of hdev object
> git bisect bad 74caf718cc7422a957aac381c73d798c0a999a65
> # bad: [58f4d45d8d4d391f60b6f0db6308df1994a265b3] drm/amdgpu/vcn3: add cancel_delayed_work_sync before power gate
> git bisect bad 58f4d45d8d4d391f60b6f0db6308df1994a265b3
> # bad: [ec72cb50c1db39816eae7296686449bba8ca0b2e] io_uring: use better types for cflags
> git bisect bad ec72cb50c1db39816eae7296686449bba8ca0b2e
> # bad: [0b2a990e5d2f76d020cb840c456e6ec5f0c27530] io_uring: fix link timeout refs
> git bisect bad 0b2a990e5d2f76d020cb840c456e6ec5f0c27530
> # first bad commit: [0b2a990e5d2f76d020cb840c456e6ec5f0c27530] io_uring: fix link timeout refs
> 
> The mainline commit for the bad LTS commit is:
> a298232ee6b9 ("io_uring: fix link timeout refs") and I have tested the
> reproducer on mainline with 'a298232ee6b9' as HEAD and the issue is not
> reproduced. I think we are missing some change in v5.10.y kernel which
> was missed while the mainline fix was backported to LTS.
> 
> I can reproduce the crash using syzkaller and will be happy to test any
> patch for this.
> 
> 
> --
> Regards
> Sudip
> 

-- 
Pavel Begunkov
