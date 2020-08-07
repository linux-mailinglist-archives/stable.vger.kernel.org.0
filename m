Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6761323EE32
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 15:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgHGN2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 09:28:53 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:38679 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726191AbgHGN2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 09:28:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 4A237AE8;
        Fri,  7 Aug 2020 09:28:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 07 Aug 2020 09:28:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/maHp1
        che3McVnacv51i4Hx8hvhMwIdRHjrKdc/uFo0=; b=JhaV1h8XbHKEttmQJH8d4M
        nvN103+5tnlLCcAWkcLl5Izng/rtlZ4se7Ocq6DDDsPOp8suBSAEM3Auk+b3sDwA
        RnNam0WPd0S1CgXdHwUFyf4yO9pKx+zSLUMSQUf/wm9Ik/14w8Rq/lMYfqzVom1F
        iPyPVo1KAiTm/an94agZTrKcn/204wjFs4fGLpnrPgdzvoY+Ricra3dUfBxzAQwf
        W27Skku7K30qK32PAmV7JLZoYxU1aw93YkmecpxOtJbx67wSswmtbp4rvOyPNot4
        mrNU9IBENEwaFtzsFPlNFsGODaaonK7rFzEpjKiWxBx594LyIu4cZXVGNFqKsDUA
        ==
X-ME-Sender: <xms:DFctX12omqpDMlQOgv5-6oLoAOKXAysaw021bMlSspDpu0RaxtC9BA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkedvgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:DFctX8FZz7pC_4bmHMw025CO8BDNkCucYgA8sek-atJrqV_JmOua8Q>
    <xmx:DFctX171OOhg88Hc6nGE9ii5VmcDGPfe4qJRrMk6ctch7HHq3PUeaw>
    <xmx:DFctXy1ZPgjECX6J6dftTOXwSkgVU4g8sf2T1YPsV66QzM1l63iE2Q>
    <xmx:DFctX7yjIiWVeMDz1v1aFfA9hZFK8wLvShTHN70cpKjko3okMrGPv5QR1Zs>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2A90C3280059;
        Fri,  7 Aug 2020 09:28:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: don't touch 'ctx' after installing file descriptor" failed to apply to 5.8-stable tree
To:     axboe@kernel.dk, sgarzare@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Aug 2020 15:28:58 +0200
Message-ID: <1596806938115186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d1719f70d0a5b83b12786a7dbc5b9fe396469016 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 30 Jul 2020 13:43:53 -0600
Subject: [PATCH] io_uring: don't touch 'ctx' after installing file descriptor

As soon as we install the file descriptor, we have to assume that it
can get arbitrarily closed. We currently account memory (and note that
we did) after installing the ring fd, which means that it could be a
potential use-after-free condition if the fd is closed right after
being installed, but before we fiddle with the ctx.

In fact, syzbot reported this exact scenario:

BUG: KASAN: use-after-free in io_account_mem fs/io_uring.c:7397 [inline]
BUG: KASAN: use-after-free in io_uring_create fs/io_uring.c:8369 [inline]
BUG: KASAN: use-after-free in io_uring_setup+0x2797/0x2910 fs/io_uring.c:8400
Read of size 1 at addr ffff888087a41044 by task syz-executor.5/18145

CPU: 0 PID: 18145 Comm: syz-executor.5 Not tainted 5.8.0-rc7-next-20200729-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 io_account_mem fs/io_uring.c:7397 [inline]
 io_uring_create fs/io_uring.c:8369 [inline]
 io_uring_setup+0x2797/0x2910 fs/io_uring.c:8400
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c429
Code: 8d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8f121d0c78 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000008540 RCX: 000000000045c429
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000196
RBP: 000000000078bf38 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 00007fff86698cff R14: 00007f8f121d19c0 R15: 000000000078bf0c

Move the accounting of the ring used locked memory before we get and
install the ring file descriptor.

Cc: stable@vger.kernel.org
Reported-by: syzbot+9d46305e76057f30c74e@syzkaller.appspotmail.com
Fixes: 309758254ea6 ("io_uring: report pinned memory usage")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fabf0b692384..33702f3b5af8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8329,6 +8329,15 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		ret = -EFAULT;
 		goto err;
 	}
+
+	/*
+	 * Account memory _before_ installing the file descriptor. Once
+	 * the descriptor is installed, it can get closed at any time.
+	 */
+	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries),
+		       ACCT_LOCKED);
+	ctx->limit_mem = limit_mem;
+
 	/*
 	 * Install ring fd as the very last thing, so we don't risk someone
 	 * having closed it before we finish setup
@@ -8338,9 +8347,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
-	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries),
-		       ACCT_LOCKED);
-	ctx->limit_mem = limit_mem;
 	return ret;
 err:
 	io_ring_ctx_wait_and_kill(ctx);

