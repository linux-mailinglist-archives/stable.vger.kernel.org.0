Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA146D4A91
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbjDCOs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbjDCOrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:47:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C28D2A593
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D3E4B81D5A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF1CC433EF;
        Mon,  3 Apr 2023 14:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533210;
        bh=8xbVRTF9ZztDD4+eufl19RlMg14b2/KeL98vGIONwmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VucZW4SbLbe42+W3AzelxN7eOjpZAzGOdU8Jh/hVMlHY06LrUVng5vDPp6Y1XMT5H
         kNP8xVzdj9S1qJh+BUgCYBPfzU4yKZb32iii4JGRvplp1qQG9gRhWiM18s6UuErba1
         RIdcE3mp4xae9CF1EqukFVNwaVwpOHcgGsclT3WQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com,
        Ivan Orlov <ivan.orlov0322@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 097/187] can: bcm: bcm_tx_setup(): fix KMSAN uninit-value in vfs_write
Date:   Mon,  3 Apr 2023 16:09:02 +0200
Message-Id: <20230403140419.168448584@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Orlov <ivan.orlov0322@gmail.com>

[ Upstream commit 2b4c99f7d9a57ecd644eda9b1fb0a1072414959f ]

Syzkaller reported the following issue:

=====================================================
BUG: KMSAN: uninit-value in aio_rw_done fs/aio.c:1520 [inline]
BUG: KMSAN: uninit-value in aio_write+0x899/0x950 fs/aio.c:1600
 aio_rw_done fs/aio.c:1520 [inline]
 aio_write+0x899/0x950 fs/aio.c:1600
 io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
 __do_sys_io_submit fs/aio.c:2078 [inline]
 __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
 __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:766 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 __kmem_cache_alloc_node+0x71f/0xce0 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc+0x11d/0x3b0 mm/slab_common.c:981
 kmalloc_array include/linux/slab.h:636 [inline]
 bcm_tx_setup+0x80e/0x29d0 net/can/bcm.c:930
 bcm_sendmsg+0x3a2/0xce0 net/can/bcm.c:1351
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 sock_write_iter+0x495/0x5e0 net/socket.c:1108
 call_write_iter include/linux/fs.h:2189 [inline]
 aio_write+0x63a/0x950 fs/aio.c:1600
 io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
 __do_sys_io_submit fs/aio.c:2078 [inline]
 __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
 __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

CPU: 1 PID: 5034 Comm: syz-executor350 Not tainted 6.2.0-rc6-syzkaller-80422-geda666ff2276 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
=====================================================

We can follow the call chain and find that 'bcm_tx_setup' function
calls 'memcpy_from_msg' to copy some content to the newly allocated
frame of 'op->frames'. After that the 'len' field of copied structure
being compared with some constant value (64 or 8). However, if
'memcpy_from_msg' returns an error, we will compare some uninitialized
memory. This triggers 'uninit-value' issue.

This patch will add 'memcpy_from_msg' possible errors processing to
avoid uninit-value issue.

Tested via syzkaller

Reported-by: syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=47f897f8ad958bbde5790ebf389b5e7e0a345089
Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Fixes: 6f3b911d5f29b ("can: bcm: add support for CAN FD frames")
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230314120445.12407-1-ivan.orlov0322@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/bcm.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 27706f6ace34a..a962ec2b8ba5b 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -941,6 +941,8 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 
 			cf = op->frames + op->cfsiz * i;
 			err = memcpy_from_msg((u8 *)cf, msg, op->cfsiz);
+			if (err < 0)
+				goto free_op;
 
 			if (op->flags & CAN_FD_FRAME) {
 				if (cf->len > 64)
@@ -950,12 +952,8 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 					err = -EINVAL;
 			}
 
-			if (err < 0) {
-				if (op->frames != &op->sframe)
-					kfree(op->frames);
-				kfree(op);
-				return err;
-			}
+			if (err < 0)
+				goto free_op;
 
 			if (msg_head->flags & TX_CP_CAN_ID) {
 				/* copy can_id into frame */
@@ -1026,6 +1024,12 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 		bcm_tx_start_timer(op);
 
 	return msg_head->nframes * op->cfsiz + MHSIZ;
+
+free_op:
+	if (op->frames != &op->sframe)
+		kfree(op->frames);
+	kfree(op);
+	return err;
 }
 
 /*
-- 
2.39.2



