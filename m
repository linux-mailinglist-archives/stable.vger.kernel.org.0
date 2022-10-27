Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D8A60FDE2
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236749AbiJ0RAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236795AbiJ0RAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:00:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD83838687
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:59:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67AAF610AB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794BAC433C1;
        Thu, 27 Oct 2022 16:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889998;
        bh=+cmGYKfYeoyPLJ/e02gHno3gBar5JmmYqFsDNco7OZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ny1QilxpC++S9Ee/SsbL40pNMS7JAGaYj4o8vjf8/oKdy2AJDIgb+8ab8AlbJDbC7
         ez6NjgQVNJ3ix8k3PTjeMW/mB99qrXc1TQb7WPP5WW4RDK5W3qsOfz1fgUme9/5tb5
         PhnSmKNaGDj5U4lMGzymvMbtXSw0VbO2m+7VommQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzkaller <syzkaller@googlegroups.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 78/94] io_uring/msg_ring: Fix NULL pointer dereference in io_msg_send_fd()
Date:   Thu, 27 Oct 2022 18:55:20 +0200
Message-Id: <20221027165100.347542864@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 16bbdfe5fb0e78e0acb13e45fc127e9a296913f2 ]

Syzkaller produced the below call trace:

 BUG: KASAN: null-ptr-deref in io_msg_ring+0x3cb/0x9f0
 Write of size 8 at addr 0000000000000070 by task repro/16399

 CPU: 0 PID: 16399 Comm: repro Not tainted 6.1.0-rc1 #28
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7
 Call Trace:
  <TASK>
  dump_stack_lvl+0xcd/0x134
  ? io_msg_ring+0x3cb/0x9f0
  kasan_report+0xbc/0xf0
  ? io_msg_ring+0x3cb/0x9f0
  kasan_check_range+0x140/0x190
  io_msg_ring+0x3cb/0x9f0
  ? io_msg_ring_prep+0x300/0x300
  io_issue_sqe+0x698/0xca0
  io_submit_sqes+0x92f/0x1c30
  __do_sys_io_uring_enter+0xae4/0x24b0
....
 RIP: 0033:0x7f2eaf8f8289
 RSP: 002b:00007fff40939718 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
 RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2eaf8f8289
 RDX: 0000000000000000 RSI: 0000000000006f71 RDI: 0000000000000004
 RBP: 00007fff409397a0 R08: 0000000000000000 R09: 0000000000000039
 R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004006d0
 R13: 00007fff40939880 R14: 0000000000000000 R15: 0000000000000000
  </TASK>
 Kernel panic - not syncing: panic_on_warn set ...

We don't have a NULL check on file_ptr in io_msg_send_fd() function,
so when file_ptr is NUL src_file is also NULL and get_file()
dereferences a NULL pointer and leads to above crash.

Add a NULL check to fix this issue.

Fixes: e6130eba8a84 ("io_uring: add support for passing fixed file descriptors")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20221019171218.1337614-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/msg_ring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 4a7e5d030c78..90d2fc6fd80e 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -95,6 +95,9 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 
 	msg->src_fd = array_index_nospec(msg->src_fd, ctx->nr_user_files);
 	file_ptr = io_fixed_file_slot(&ctx->file_table, msg->src_fd)->file_ptr;
+	if (!file_ptr)
+		goto out_unlock;
+
 	src_file = (struct file *) (file_ptr & FFS_MASK);
 	get_file(src_file);
 
-- 
2.35.1



