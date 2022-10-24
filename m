Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3BD60B97E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbiJXUNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJXUNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:13:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313D0DFB7B;
        Mon, 24 Oct 2022 11:31:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CBDBDCE16F9;
        Mon, 24 Oct 2022 12:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAB2C433C1;
        Mon, 24 Oct 2022 12:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615963;
        bh=yxGkSTZYL1lOGJSNqH0ReJY84nBjcJY52M5+93fYZ7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqWbttfN1bXh+9Z9xAAWiDX7S5qwYTHqnLqx/J9JXOc8ql/sMh+3/YdkcRjc+Odp+
         o3EPgOOQSaLrS/RU30dp/d6ITa8OJc6uahcc9fMyh3HjhgjbtC70nlTTwr96B29bhs
         jmcx/0grmwJ56NHrTPNIfGuozKXPKUZsp3vLfTcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c80e9ef5d8bb45894db0@syzkaller.appspotmail.com,
        Gerd Hoffmann <kraxel@redhat.com>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 449/530] udmabuf: Set ubuf->sg = NULL if the creation of sg table fails
Date:   Mon, 24 Oct 2022 13:33:13 +0200
Message-Id: <20221024113105.368780901@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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

From: Vivek Kasireddy <vivek.kasireddy@intel.com>

[ Upstream commit d9c04a1b7a15b5e74b2977461d9511e497f05d8f ]

When userspace tries to map the dmabuf and if for some reason
(e.g. OOM) the creation of the sg table fails, ubuf->sg needs to be
set to NULL. Otherwise, when the userspace subsequently closes the
dmabuf fd, we'd try to erroneously free the invalid sg table from
release_udmabuf resulting in the following crash reported by syzbot:

general protection fault, probably for non-canonical address
0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 3609 Comm: syz-executor487 Not tainted
5.19.0-syzkaller-13930-g7ebfc85e2cd7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 07/22/2022
RIP: 0010:dma_unmap_sgtable include/linux/dma-mapping.h:378 [inline]
RIP: 0010:put_sg_table drivers/dma-buf/udmabuf.c:89 [inline]
RIP: 0010:release_udmabuf+0xcb/0x4f0 drivers/dma-buf/udmabuf.c:114
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 2b 04 00 00 48 8d 7d 0c 4c
8b 63 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14
02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 e2
RSP: 0018:ffffc900037efd30 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffffff8cb67800 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff84ad27e0 RDI: 0000000000000000
RBP: fffffffffffffff4 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 000000000008c07c R12: ffff88801fa05000
R13: ffff888073db07e8 R14: ffff888025c25440 R15: 0000000000000000
FS:  0000555555fc4300(0000) GS:ffff8880b9a00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc1c0ce06e4 CR3: 00000000715e6000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 dma_buf_release+0x157/0x2d0 drivers/dma-buf/dma-buf.c:78
 __dentry_kill+0x42b/0x640 fs/dcache.c:612
 dentry_kill fs/dcache.c:733 [inline]
 dput+0x806/0xdb0 fs/dcache.c:913
 __fput+0x39c/0x9d0 fs/file_table.c:333
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 ptrace_notify+0x114/0x140 kernel/signal.c:2353
 ptrace_report_syscall include/linux/ptrace.h:420 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:482 [inline]
 syscall_exit_work kernel/entry/common.c:249 [inline]
 syscall_exit_to_user_mode_prepare+0x129/0x280 kernel/entry/common.c:276
 __syscall_exit_to_user_mode_work kernel/entry/common.c:281 [inline]
 syscall_exit_to_user_mode+0x9/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fc1c0c35b6b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24
0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00
f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
RSP: 002b:00007ffd78a06090 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000007 RCX: 00007fc1c0c35b6b
RDX: 0000000020000280 RSI: 0000000040086200 RDI: 0000000000000006
RBP: 0000000000000007 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 000000000000000c
R13: 0000000000000003 R14: 00007fc1c0cfe4a0 R15: 00007ffd78a06140
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:dma_unmap_sgtable include/linux/dma-mapping.h:378 [inline]
RIP: 0010:put_sg_table drivers/dma-buf/udmabuf.c:89 [inline]
RIP: 0010:release_udmabuf+0xcb/0x4f0 drivers/dma-buf/udmabuf.c:114

Reported-by: syzbot+c80e9ef5d8bb45894db0@syzkaller.appspotmail.com
Cc: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220825063522.801264-1-vivek.kasireddy@intel.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/udmabuf.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 38e8767ec371..bf11d32205f3 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -124,17 +124,20 @@ static int begin_cpu_udmabuf(struct dma_buf *buf,
 {
 	struct udmabuf *ubuf = buf->priv;
 	struct device *dev = ubuf->device->this_device;
+	int ret = 0;
 
 	if (!ubuf->sg) {
 		ubuf->sg = get_sg_table(dev, buf, direction);
-		if (IS_ERR(ubuf->sg))
-			return PTR_ERR(ubuf->sg);
+		if (IS_ERR(ubuf->sg)) {
+			ret = PTR_ERR(ubuf->sg);
+			ubuf->sg = NULL;
+		}
 	} else {
 		dma_sync_sg_for_cpu(dev, ubuf->sg->sgl, ubuf->sg->nents,
 				    direction);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int end_cpu_udmabuf(struct dma_buf *buf,
-- 
2.35.1



