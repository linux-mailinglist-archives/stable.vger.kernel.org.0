Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D724304AF7
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbhAZExU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:53:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbhAYSre (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:47:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59188224B8;
        Mon, 25 Jan 2021 18:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600427;
        bh=uHNVg1ZOxn4o7RXr91kFpduyISj09pE+619/H56nvKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wl7VWbDuZOYWr27qHn5OsZMEn01URlSF3ktUa6R0Z9g/WPgrJ9FJZgCeMH2ClcASL
         tpQfWkCZOv5OM+jwsLXoABOLR5XPxo3RSLkspf0oDBnbrpzqAqneL2LumzOhMSlvVd
         Ucwrs0bBP5yyIUz4C8AMmdpooBShq8vufUjxVO7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 011/199] crypto: xor - Fix divide error in do_xor_speed()
Date:   Mon, 25 Jan 2021 19:37:13 +0100
Message-Id: <20210125183216.734988547@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill Tkhai <ktkhai@virtuozzo.com>

commit 3c02e04fd4f57130e4fa75fab6f528f7a52db9b5 upstream.

crypto: Fix divide error in do_xor_speed()

From: Kirill Tkhai <ktkhai@virtuozzo.com>

Latest (but not only latest) linux-next panics with divide
error on my QEMU setup.

The patch at the bottom of this message fixes the problem.

xor: measuring software checksum speed
divide error: 0000 [#1] PREEMPT SMP KASAN
PREEMPT SMP KASAN
CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.10.0-next-20201223+ #2177
RIP: 0010:do_xor_speed+0xbb/0xf3
Code: 41 ff cc 75 b5 bf 01 00 00 00 e8 3d 23 8b fe 65 8b 05 f6 49 83 7d 85 c0 75 05 e8
 84 70 81 fe b8 00 00 50 c3 31 d2 48 8d 7b 10 <f7> f5 41 89 c4 e8 58 07 a2 fe 44 89 63 10 48 8d 7b 08
 e8 cb 07 a2
RSP: 0000:ffff888100137dc8 EFLAGS: 00010246
RAX: 00000000c3500000 RBX: ffffffff823f0160 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000808 RDI: ffffffff823f0170
RBP: 0000000000000000 R08: ffffffff8109c50f R09: ffffffff824bb6f7
R10: fffffbfff04976de R11: 0000000000000001 R12: 0000000000000000
R13: ffff888101997000 R14: ffff888101994000 R15: ffffffff823f0178
FS:  0000000000000000(0000) GS:ffff8881f7780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000220e000 CR4: 00000000000006a0
Call Trace:
 calibrate_xor_blocks+0x13c/0x1c4
 ? do_xor_speed+0xf3/0xf3
 do_one_initcall+0xc1/0x1b7
 ? start_kernel+0x373/0x373
 ? unpoison_range+0x3a/0x60
 kernel_init_freeable+0x1dd/0x238
 ? rest_init+0xc6/0xc6
 kernel_init+0x8/0x10a
 ret_from_fork+0x1f/0x30
---[ end trace 5bd3c1d0b77772da ]---

Fixes: c055e3eae0f1 ("crypto: xor - use ktime for template benchmarking")
Cc: <stable@vger.kernel.org>
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/xor.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -107,6 +107,8 @@ do_xor_speed(struct xor_block_template *
 	preempt_enable();
 
 	// bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s]
+	if (!min)
+		min = 1;
 	speed = (1000 * REPS * BENCH_SIZE) / (unsigned int)ktime_to_ns(min);
 	tmpl->speed = speed;
 


