Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9FE3D578E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 12:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhGZJtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 05:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbhGZJtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 05:49:12 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78AAC061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 03:29:40 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id r2so10490700wrl.1
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 03:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=ipqz+q+np2RB0qenQCkNNLi/CCiWIL+nWjHni1Oln3E=;
        b=Ozjhk92aOKn3cPh/SMGhURMKqlv1Qq+0Vt9dzUhaSdaA2qVgoRO8SEUpceSR5Gmnj6
         Nlk7AzVNJPSnDnjABGIkc9OjeBhS0Q3VaqooGgBdEBdsWK7KMqgMv8zFLlfFMxHVzj/Q
         lLQfMMv5Be0EnL4sixvq7Eb0KJ3xkwEIWrQoPGqNQdvb/ZqjJsEjZggdVqpK5u3WyKmi
         zYYVI4Rw7I4peoouU0qMa1I+fSCYf9n7Ovym5nvwwUmf38JWJ7D1enqCO6RD55m3D9me
         aOAgkZsNLtf64dz19HMvytDkY20xO+diO9CKA73uIq4f1ppKqsagBBL6jl41h/c34eZR
         tzlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ipqz+q+np2RB0qenQCkNNLi/CCiWIL+nWjHni1Oln3E=;
        b=GO9vK7c4canMMb7b9uuYetOLd8chazglpvakfO4ldTevsLAPsUxm0OhHpWG1OyA1aM
         moT+SirmqxRZ0Wq6vO9nzgQbZ/j9PDfQB3iIIrwXalFVeG0qsv5h/fExNj7ujI77zeHK
         kYxz521cnTbw65L1AXq1jMO73Tf94pGu0x2KyCNe9LsY5RZoEY96EFB3dPxCVIB3wJSO
         zz1NbR3oH0+SjVDb673vNjo+nZzNu5cGd3EsmV4LSIuRrWsy/dlPaqlIXlzHGO/IyWxl
         2TETVLd41ruzqVE3kPRjcFyFmLS03Dhvg1ZTIynKKCxY6fP4Lv3C4KNXEGAinP8zonV0
         lPzQ==
X-Gm-Message-State: AOAM532NA+eJsTCmhQ8l2ixF3OOdbMPzDxnHkN1wttZ7l/1WO+f+ivDp
        Y2Jr9+EJekb9Q1GutTBKGVg=
X-Google-Smtp-Source: ABdhPJyVHT84FA2/GAbA4z4RDfMkNm7B4uNr/qAqdJBEzD9jMKknvz4v0QH35s9rxiyQwxbXtqC6aw==
X-Received: by 2002:adf:f282:: with SMTP id k2mr5300909wro.183.1627295379398;
        Mon, 26 Jul 2021 03:29:39 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id q14sm6389164wrs.8.2021.07.26.03.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 03:29:39 -0700 (PDT)
Date:   Mon, 26 Jul 2021 11:29:37 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: use-after-free" with v5.10.y caused by backport of a298232ee6b9
 ("io_uring: fix link timeout refs")
Message-ID: <YP6OkehtVdkjKikL@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

We had been running syzkaller on v5.10.y and a "use after free" is being
reported for v5.10.43+ kernels.

The syzkaller report is at: https://elisa-builder-00.iol.unh.edu/syzkaller/file?name=crashes%2fb23bc4ad436bbe4afc620d9503730ddd78c382c0%2freport19

The trace is:

refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 8769 at lib/refcount.c:28 refcount_warn_saturate+0x103/0x1f0 lib/refcount.c:28
Modules linked in:
CPU: 1 PID: 8769 Comm: syz-executor.6 Not tainted 5.10.52 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
RIP: 0010:refcount_warn_saturate+0x103/0x1f0 lib/refcount.c:28
Code: 1d d2 63 54 03 31 ff 89 de e8 c9 22 51 ff 84 db 75 a3 e8 90 29 51 ff 48 c7 c7 20 38 3b 84 c6 05 b2 63 54 03 01 e8 cc 0c c9 01 <0f> 0b eb 87 e8 74 29 51 ff 0f b6 1d 9b 63 54 03 31 ff 89 de e8 94
RSP: 0018:ffff88804ec5f9f8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff81293053 RDI: ffffed1009d8bf31
RBP: ffff888048ceb41c R08: 0000000000000001 R09: ffff88806cf1ff9b
R10: 0000000000000000 R11: 0000000000000001 R12: ffff888048ceb41c
R13: 0000000000000000 R14: ffff888048ceb558 R15: ffff88800c857180
FS:  00007f0e798e9700(0000) GS:ffff88806cf00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000558bbbc7d898 CR3: 0000000048fb6000 CR4: 0000000000350ee0
Call Trace:
 __refcount_sub_and_test include/linux/refcount.h:283 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 io_put_req+0xc6/0x100 fs/io_uring.c:2220
 __io_queue_sqe+0x2b1/0xd00 fs/io_uring.c:6358
 io_queue_sqe+0x5bc/0x1020 fs/io_uring.c:6403
 io_queue_link_head fs/io_uring.c:6414 [inline]
 io_submit_sqe fs/io_uring.c:6455 [inline]
 io_submit_sqes+0x17b5/0x2310 fs/io_uring.c:6700
 __do_sys_io_uring_enter+0x1092/0x1910 fs/io_uring.c:9092
 do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x466609
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0e798e9188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 0000000000466609
RDX: 0000000000000000 RSI: 00000000000058ab RDI: 0000000000000004
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffdbe4f1c5f R14: 00007f0e798e9300 R15: 0000000000022000
irq event stamp: 1473
hardirqs last  enabled at (1483): [<ffffffff8128f5d9>] console_unlock+0x929/0xb30 kernel/printk/printk.c:2552
hardirqs last disabled at (1494): [<ffffffff83c43a7b>] sysvec_apic_timer_interrupt+0xb/0xa0 arch/x86/kernel/apic/apic.c:1095
softirqs last  enabled at (1072): [<ffffffff83e00f92>] asm_call_irq_on_stack+0x12/0x20
softirqs last disabled at (1067): [<ffffffff83e00f92>] asm_call_irq_on_stack+0x12/0x20

I have done a bisect and the commit causing this is: 0b2a990e5d2f ("io_uring: fix link timeout refs")

The git bisect log is:
# bad: [71046eac2db9aeccf10763d034a1a123911c9a81] Linux 5.10.53
# good: [2c85ebc57b3e1817b6ce1a6b703928e113a90442] Linux 5.10
git bisect start 'v5.10.53' 'v5.10'
# good: [d29c38dd926d5aba65d177c0b99381ea632ff0a0] staging: rtl8192e: Change state information from u16 to u8
git bisect good d29c38dd926d5aba65d177c0b99381ea632ff0a0
# good: [b67c3d74adc3f7f832f57c170234bbe1fc69c87c] Revert "net: fujitsu: fix a potential NULL pointer dereference"
git bisect good b67c3d74adc3f7f832f57c170234bbe1fc69c87c
# bad: [f1f30b3373df2e5ab96dd3781df5c02e5366f845] mmc: usdhi6rol0: fix error return code in usdhi6_probe()
git bisect bad f1f30b3373df2e5ab96dd3781df5c02e5366f845
# bad: [3d60457d74d9cc7b36f78f9cb74f29bc6182c1e8] cxgb4: fix endianness when flashing boot image
git bisect bad 3d60457d74d9cc7b36f78f9cb74f29bc6182c1e8
# bad: [3a6b69221f96f87c680bbc9fba01db3415b18f27] drm/amdgpu: make sure we unpin the UVD BO
git bisect bad 3a6b69221f96f87c680bbc9fba01db3415b18f27
# good: [65859eca4dff1af0db5e36d1cfbac15b834c6a65] Linux 5.10.42
git bisect good 65859eca4dff1af0db5e36d1cfbac15b834c6a65
# good: [a1bf16616d8351a2e79400d6d19608befb2ce1dd] ixgbe: add correct exception tracing for XDP
git bisect good a1bf16616d8351a2e79400d6d19608befb2ce1dd
# bad: [c5155c741a484e036e7997420559431a951f2106] wireguard: allowedips: allocate nodes in kmem_cache
git bisect bad c5155c741a484e036e7997420559431a951f2106
# good: [3c23e23c7ad9844a645f4e2bd8ec34a0a2ee5514] riscv: vdso: fix and clean-up Makefile
git bisect good 3c23e23c7ad9844a645f4e2bd8ec34a0a2ee5514
# bad: [74caf718cc7422a957aac381c73d798c0a999a65] Bluetooth: use correct lock to prevent UAF of hdev object
git bisect bad 74caf718cc7422a957aac381c73d798c0a999a65
# bad: [58f4d45d8d4d391f60b6f0db6308df1994a265b3] drm/amdgpu/vcn3: add cancel_delayed_work_sync before power gate
git bisect bad 58f4d45d8d4d391f60b6f0db6308df1994a265b3
# bad: [ec72cb50c1db39816eae7296686449bba8ca0b2e] io_uring: use better types for cflags
git bisect bad ec72cb50c1db39816eae7296686449bba8ca0b2e
# bad: [0b2a990e5d2f76d020cb840c456e6ec5f0c27530] io_uring: fix link timeout refs
git bisect bad 0b2a990e5d2f76d020cb840c456e6ec5f0c27530
# first bad commit: [0b2a990e5d2f76d020cb840c456e6ec5f0c27530] io_uring: fix link timeout refs

The mainline commit for the bad LTS commit is:
a298232ee6b9 ("io_uring: fix link timeout refs") and I have tested the
reproducer on mainline with 'a298232ee6b9' as HEAD and the issue is not
reproduced. I think we are missing some change in v5.10.y kernel which
was missed while the mainline fix was backported to LTS.

I can reproduce the crash using syzkaller and will be happy to test any
patch for this.


--
Regards
Sudip
