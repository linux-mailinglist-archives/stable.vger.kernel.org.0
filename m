Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9D054909D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385567AbiFMOpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386145AbiFMOok (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:44:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9FBB57A8;
        Mon, 13 Jun 2022 04:51:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3160C61499;
        Mon, 13 Jun 2022 11:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E948C3411C;
        Mon, 13 Jun 2022 11:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121069;
        bh=fphWgj6blX7Mwg172MoSu8DWPSEvMv8Yw5V5OMgkO+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPOULlx0n/etT1ZSqA39eE/fu6sg3i3YLOs0/wyEkZe0kz07kUG0nNvmgltEtVCPm
         nXlgE9TBJqWuJaHycF0R/zEi60gJea/c3Edo0aWHQ+X+W61Mf7Iz0E3W+0aOXnyBkm
         Br8S1BMO3LFLudbLwbAN0dcjTSMzcdU1DamXhzp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 243/298] nbd: fix io hung while disconnecting device
Date:   Mon, 13 Jun 2022 12:12:17 +0200
Message-Id: <20220613094932.456773601@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 09dadb5985023e27d4740ebd17e6fea4640110e5 ]

In our tests, "qemu-nbd" triggers a io hung:

INFO: task qemu-nbd:11445 blocked for more than 368 seconds.
      Not tainted 5.18.0-rc3-next-20220422-00003-g2176915513ca #884
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:qemu-nbd        state:D stack:    0 pid:11445 ppid:     1 flags:0x00000000
Call Trace:
 <TASK>
 __schedule+0x480/0x1050
 ? _raw_spin_lock_irqsave+0x3e/0xb0
 schedule+0x9c/0x1b0
 blk_mq_freeze_queue_wait+0x9d/0xf0
 ? ipi_rseq+0x70/0x70
 blk_mq_freeze_queue+0x2b/0x40
 nbd_add_socket+0x6b/0x270 [nbd]
 nbd_ioctl+0x383/0x510 [nbd]
 blkdev_ioctl+0x18e/0x3e0
 __x64_sys_ioctl+0xac/0x120
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fd8ff706577
RSP: 002b:00007fd8fcdfebf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000040000000 RCX: 00007fd8ff706577
RDX: 000000000000000d RSI: 000000000000ab00 RDI: 000000000000000f
RBP: 000000000000000f R08: 000000000000fbe8 R09: 000055fe497c62b0
R10: 00000002aff20000 R11: 0000000000000246 R12: 000000000000006d
R13: 0000000000000000 R14: 00007ffe82dc5e70 R15: 00007fd8fcdff9c0

"qemu-ndb -d" will call ioctl 'NBD_DISCONNECT' first, however, following
message was found:

block nbd0: Send disconnect failed -32

Which indicate that something is wrong with the server. Then,
"qemu-nbd -d" will call ioctl 'NBD_CLEAR_SOCK', however ioctl can't clear
requests after commit 2516ab1543fd("nbd: only clear the queue on device
teardown"). And in the meantime, request can't complete through timeout
because nbd_xmit_timeout() will always return 'BLK_EH_RESET_TIMER', which
means such request will never be completed in this situation.

Now that the flag 'NBD_CMD_INFLIGHT' can make sure requests won't
complete multiple times, switch back to call nbd_clear_sock() in
nbd_clear_sock_ioctl(), so that inflight requests can be cleared.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20220521073749.3146892-5-yukuai3@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 7af1c9dbe9f5..151264a4be36 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1434,7 +1434,7 @@ static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *b
 static void nbd_clear_sock_ioctl(struct nbd_device *nbd,
 				 struct block_device *bdev)
 {
-	sock_shutdown(nbd);
+	nbd_clear_sock(nbd);
 	__invalidate_device(bdev, true);
 	nbd_bdev_reset(bdev);
 	if (test_and_clear_bit(NBD_RT_HAS_CONFIG_REF,
-- 
2.35.1



