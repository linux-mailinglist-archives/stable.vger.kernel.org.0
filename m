Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 007AE13341F
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgAGVYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:24:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728457AbgAGVAt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:00:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C9C4222D9;
        Tue,  7 Jan 2020 21:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430848;
        bh=Oq/IGIoS/9lpokSgXwduhp3ax8b9IJZeMgYsrpXfaKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZjuJH+u+0YfE8X4nU/WhWAYIF42U/LVWUwXuQiVSEQ/4lSHCfLgk/BxnybOsxyVR
         6ER8iEWcR34Cb1F4Rt+SMLtMhb1fJPtQkGiY7NlqO3Yi+pkr8Wv4WvtCZZD8Y75Rto
         7uKtz/UDQEcSmtw5m2WDIQ031z3Jzjk5rYVQka+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5320383e16029ba057ff@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 120/191] io_uring: use current task creds instead of allocating a new one
Date:   Tue,  7 Jan 2020 21:54:00 +0100
Message-Id: <20200107205339.401944946@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 0b8c0ec7eedcd8f9f1a1f238d87f9b512b09e71a upstream.

syzbot reports:

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9217 Comm: io_uring-sq Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
RIP: 0010:creds_are_invalid kernel/cred.c:792 [inline]
RIP: 0010:__validate_creds include/linux/cred.h:187 [inline]
RIP: 0010:override_creds+0x9f/0x170 kernel/cred.c:550
Code: ac 25 00 81 fb 64 65 73 43 0f 85 a3 37 00 00 e8 17 ab 25 00 49 8d 7c
24 10 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84
c0 74 08 3c 03 0f 8e 96 00 00 00 41 8b 5c 24 10 bf
RSP: 0018:ffff88809c45fda0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000043736564 RCX: ffffffff814f3318
RDX: 0000000000000002 RSI: ffffffff814f3329 RDI: 0000000000000010
RBP: ffff88809c45fdb8 R08: ffff8880a3aac240 R09: ffffed1014755849
R10: ffffed1014755848 R11: ffff8880a3aac247 R12: 0000000000000000
R13: ffff888098ab1600 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd51c40664 CR3: 0000000092641000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  io_sq_thread+0x1c7/0xa20 fs/io_uring.c:3274
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace f2e1a4307fbe2245 ]---
RIP: 0010:creds_are_invalid kernel/cred.c:792 [inline]
RIP: 0010:__validate_creds include/linux/cred.h:187 [inline]
RIP: 0010:override_creds+0x9f/0x170 kernel/cred.c:550
Code: ac 25 00 81 fb 64 65 73 43 0f 85 a3 37 00 00 e8 17 ab 25 00 49 8d 7c
24 10 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84
c0 74 08 3c 03 0f 8e 96 00 00 00 41 8b 5c 24 10 bf
RSP: 0018:ffff88809c45fda0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000043736564 RCX: ffffffff814f3318
RDX: 0000000000000002 RSI: ffffffff814f3329 RDI: 0000000000000010
RBP: ffff88809c45fdb8 R08: ffff8880a3aac240 R09: ffffed1014755849
R10: ffffed1014755848 R11: ffff8880a3aac247 R12: 0000000000000000
R13: ffff888098ab1600 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd51c40664 CR3: 0000000092641000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

which is caused by slab fault injection triggering a failure in
prepare_creds(). We don't actually need to create a copy of the creds
as we're not modifying it, we just need a reference on the current task
creds. This avoids the failure case as well, and propagates the const
throughout the stack.

Fixes: 181e448d8709 ("io_uring: async workers should inherit the user creds")
Reported-by: syzbot+5320383e16029ba057ff@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ only use the io_uring.c portion of the patch - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -239,7 +239,7 @@ struct io_ring_ctx {
 
 	struct user_struct	*user;
 
-	struct cred		*creds;
+	const struct cred	*creds;
 
 	struct completion	ctx_done;
 
@@ -3876,7 +3876,7 @@ static int io_uring_create(unsigned entr
 	ctx->account_mem = account_mem;
 	ctx->user = user;
 
-	ctx->creds = prepare_creds();
+	ctx->creds = get_current_cred();
 	if (!ctx->creds) {
 		ret = -ENOMEM;
 		goto err;


