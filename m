Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5054C76A7
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239766AbiB1SFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240603AbiB1SDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:03:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347A5DB2;
        Mon, 28 Feb 2022 09:47:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7336BB81187;
        Mon, 28 Feb 2022 17:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BDCC340E7;
        Mon, 28 Feb 2022 17:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070410;
        bh=zAcEzO9rWRlFOf8Z2O5jioA9Bj7raYxbPbKD+GiBMdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwsuNW25D1pngmoWL6rAib/Zaex8s15VW87b1mcwqlRcEy/UmBJinRJvDxwnZ/vjx
         WPHMDro5DkFAXGp0nij78A4q98rudUS2EU6YSpKBIkJ6U5hg/d//7fiycyKJCQ/rWX
         ZAmbun2pbXFpLdCY12Akj1n6wvmgU9CKM46s10Yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH 5.16 061/164] io_uring: add a schedule point in io_add_buffers()
Date:   Mon, 28 Feb 2022 18:23:43 +0100
Message-Id: <20220228172405.729864177@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit f240762f88b4b1b58561939ffd44837759756477 upstream.

Looping ~65535 times doing kmalloc() calls can trigger soft lockups,
especially with DEBUG features (like KASAN).

[  253.536212] watchdog: BUG: soft lockup - CPU#64 stuck for 26s! [b219417889:12575]
[  253.544433] Modules linked in: vfat fat i2c_mux_pca954x i2c_mux spidev cdc_acm xhci_pci xhci_hcd sha3_generic gq(O)
[  253.544451] CPU: 64 PID: 12575 Comm: b219417889 Tainted: G S         O      5.17.0-smp-DEV #801
[  253.544457] RIP: 0010:kernel_text_address (./include/asm-generic/sections.h:192 ./include/linux/kallsyms.h:29 kernel/extable.c:67 kernel/extable.c:98)
[  253.544464] Code: 0f 93 c0 48 c7 c1 e0 63 d7 a4 48 39 cb 0f 92 c1 20 c1 0f b6 c1 5b 5d c3 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 53 48 89 fb <48> c7 c0 00 00 80 a0 41 be 01 00 00 00 48 39 c7 72 0c 48 c7 c0 40
[  253.544468] RSP: 0018:ffff8882d8baf4c0 EFLAGS: 00000246
[  253.544471] RAX: 1ffff1105b175e00 RBX: ffffffffa13ef09a RCX: 00000000a13ef001
[  253.544474] RDX: ffffffffa13ef09a RSI: ffff8882d8baf558 RDI: ffffffffa13ef09a
[  253.544476] RBP: ffff8882d8baf4d8 R08: ffff8882d8baf5e0 R09: 0000000000000004
[  253.544479] R10: ffff8882d8baf5e8 R11: ffffffffa0d59a50 R12: ffff8882eab20380
[  253.544481] R13: ffffffffa0d59a50 R14: dffffc0000000000 R15: 1ffff1105b175eb0
[  253.544483] FS:  00000000016d3380(0000) GS:ffff88af48c00000(0000) knlGS:0000000000000000
[  253.544486] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  253.544488] CR2: 00000000004af0f0 CR3: 00000002eabfa004 CR4: 00000000003706e0
[  253.544491] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  253.544492] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  253.544494] Call Trace:
[  253.544496]  <TASK>
[  253.544498] ? io_queue_sqe (fs/io_uring.c:7143)
[  253.544505] __kernel_text_address (kernel/extable.c:78)
[  253.544508] unwind_get_return_address (arch/x86/kernel/unwind_frame.c:19)
[  253.544514] arch_stack_walk (arch/x86/kernel/stacktrace.c:27)
[  253.544517] ? io_queue_sqe (fs/io_uring.c:7143)
[  253.544521] stack_trace_save (kernel/stacktrace.c:123)
[  253.544527] ____kasan_kmalloc (mm/kasan/common.c:39 mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:515)
[  253.544531] ? ____kasan_kmalloc (mm/kasan/common.c:39 mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:515)
[  253.544533] ? __kasan_kmalloc (mm/kasan/common.c:524)
[  253.544535] ? kmem_cache_alloc_trace (./include/linux/kasan.h:270 mm/slab.c:3567)
[  253.544541] ? io_issue_sqe (fs/io_uring.c:4556 fs/io_uring.c:4589 fs/io_uring.c:6828)
[  253.544544] ? __io_queue_sqe (fs/io_uring.c:?)
[  253.544551] __kasan_kmalloc (mm/kasan/common.c:524)
[  253.544553] kmem_cache_alloc_trace (./include/linux/kasan.h:270 mm/slab.c:3567)
[  253.544556] ? io_issue_sqe (fs/io_uring.c:4556 fs/io_uring.c:4589 fs/io_uring.c:6828)
[  253.544560] io_issue_sqe (fs/io_uring.c:4556 fs/io_uring.c:4589 fs/io_uring.c:6828)
[  253.544564] ? __kasan_slab_alloc (mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:469)
[  253.544567] ? __kasan_slab_alloc (mm/kasan/common.c:39 mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:469)
[  253.544569] ? kmem_cache_alloc_bulk (mm/slab.h:732 mm/slab.c:3546)
[  253.544573] ? __io_alloc_req_refill (fs/io_uring.c:2078)
[  253.544578] ? io_submit_sqes (fs/io_uring.c:7441)
[  253.544581] ? __se_sys_io_uring_enter (fs/io_uring.c:10154 fs/io_uring.c:10096)
[  253.544584] ? __x64_sys_io_uring_enter (fs/io_uring.c:10096)
[  253.544587] ? do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
[  253.544590] ? entry_SYSCALL_64_after_hwframe (??:?)
[  253.544596] __io_queue_sqe (fs/io_uring.c:?)
[  253.544600] io_queue_sqe (fs/io_uring.c:7143)
[  253.544603] io_submit_sqe (fs/io_uring.c:?)
[  253.544608] io_submit_sqes (fs/io_uring.c:?)
[  253.544612] __se_sys_io_uring_enter (fs/io_uring.c:10154 fs/io_uring.c:10096)
[  253.544616] __x64_sys_io_uring_enter (fs/io_uring.c:10096)
[  253.544619] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
[  253.544623] entry_SYSCALL_64_after_hwframe (??:?)

Fixes: ddf0322db79c ("io_uring: add IORING_OP_PROVIDE_BUFFERS")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20220215041003.2394784-1-eric.dumazet@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4477,6 +4477,7 @@ static int io_add_buffers(struct io_prov
 		} else {
 			list_add_tail(&buf->list, &(*head)->list);
 		}
+		cond_resched();
 	}
 
 	return i ? i : -ENOMEM;


