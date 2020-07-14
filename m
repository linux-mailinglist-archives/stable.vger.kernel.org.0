Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763AB21FB77
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbgGNS7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730811AbgGNS7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:59:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BC4522B2E;
        Tue, 14 Jul 2020 18:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753157;
        bh=a3lhJcck2t54slKGIQF8BvItKrqHUOSZaSHzOR0235o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qphcuQgNCl+kauqhpKHF1X84Ox0OLwsYTCn7DH8jwmryMWbSp7IgKeL+tg42pqKhW
         x55VMmsdjAwLtnxy8ZQuKUYNPyGu3CzPwr3te3iRRrYDCn1PbZ5ChaUEwiA9NWEpou
         rBpi0m9WMp5gu96k53PiRpllWfYy8zXwI9RpDBcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 124/166] io_uring: fix memleak in __io_sqe_files_update()
Date:   Tue, 14 Jul 2020 20:44:49 +0200
Message-Id: <20200714184121.770661187@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit f3bd9dae3708a0ff6b067e766073ffeb853301f9 upstream.

I got a memleak report when doing some fuzz test:

BUG: memory leak
unreferenced object 0xffff888113e02300 (size 488):
comm "syz-executor401", pid 356, jiffies 4294809529 (age 11.954s)
hex dump (first 32 bytes):
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
a0 a4 ce 19 81 88 ff ff 60 ce 09 0d 81 88 ff ff ........`.......
backtrace:
[<00000000129a84ec>] kmem_cache_zalloc include/linux/slab.h:659 [inline]
[<00000000129a84ec>] __alloc_file+0x25/0x310 fs/file_table.c:101
[<000000003050ad84>] alloc_empty_file+0x4f/0x120 fs/file_table.c:151
[<000000004d0a41a3>] alloc_file+0x5e/0x550 fs/file_table.c:193
[<000000002cb242f0>] alloc_file_pseudo+0x16a/0x240 fs/file_table.c:233
[<00000000046a4baa>] anon_inode_getfile fs/anon_inodes.c:91 [inline]
[<00000000046a4baa>] anon_inode_getfile+0xac/0x1c0 fs/anon_inodes.c:74
[<0000000035beb745>] __do_sys_perf_event_open+0xd4a/0x2680 kernel/events/core.c:11720
[<0000000049009dc7>] do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
[<00000000353731ca>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881152dd5e0 (size 16):
comm "syz-executor401", pid 356, jiffies 4294809529 (age 11.954s)
hex dump (first 16 bytes):
01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 ................
backtrace:
[<0000000074caa794>] kmem_cache_zalloc include/linux/slab.h:659 [inline]
[<0000000074caa794>] lsm_file_alloc security/security.c:567 [inline]
[<0000000074caa794>] security_file_alloc+0x32/0x160 security/security.c:1440
[<00000000c6745ea3>] __alloc_file+0xba/0x310 fs/file_table.c:106
[<000000003050ad84>] alloc_empty_file+0x4f/0x120 fs/file_table.c:151
[<000000004d0a41a3>] alloc_file+0x5e/0x550 fs/file_table.c:193
[<000000002cb242f0>] alloc_file_pseudo+0x16a/0x240 fs/file_table.c:233
[<00000000046a4baa>] anon_inode_getfile fs/anon_inodes.c:91 [inline]
[<00000000046a4baa>] anon_inode_getfile+0xac/0x1c0 fs/anon_inodes.c:74
[<0000000035beb745>] __do_sys_perf_event_open+0xd4a/0x2680 kernel/events/core.c:11720
[<0000000049009dc7>] do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
[<00000000353731ca>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

If io_sqe_file_register() failed, we need put the file that get by fget()
to avoid the memleak.

Fixes: c3a31e605620 ("io_uring: add support for IORING_REGISTER_FILES_UPDATE")
Cc: stable@vger.kernel.org
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6904,8 +6904,10 @@ static int __io_sqe_files_update(struct
 			}
 			table->files[index] = file;
 			err = io_sqe_file_register(ctx, file, i);
-			if (err)
+			if (err) {
+				fput(file);
 				break;
+			}
 		}
 		nr_args--;
 		done++;


