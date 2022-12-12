Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEB664A1EC
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbiLLNrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbiLLNqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:46:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243CE1408D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:46:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAF5AB80D50
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32693C433F1;
        Mon, 12 Dec 2022 13:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852805;
        bh=WJ70mKsLdwdd6oDIyDcfzVIDU5kM3mgo00ZO//oQQrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7LVpiMtJeIH9Foxyq2D9fn5U8/q7+ZcvrWXyPtdLsRgskIrMAIBLl531aEeIH9nA
         Oaw1Uw9K2kehwDxaKb9kLQyUnArgXP7x5ZBXX7Aan8w/TCLEvUu+X3+1k4RFBxK/XZ
         dJ12Qt/1kWe3SQmhilEnrQY45fdzto5MuGJdCoxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thorsten Winkler <twinkler@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 156/157] s390/qeth: fix use-after-free in hsci
Date:   Mon, 12 Dec 2022 14:18:24 +0100
Message-Id: <20221212130941.564333198@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit ebaaadc332cd21e9df4dcf9ce12552d9354bbbe4 ]

KASAN found that addr was dereferenced after br2dev_event_work was freed.

==================================================================
BUG: KASAN: use-after-free in qeth_l2_br2dev_worker+0x5ba/0x6b0
Read of size 1 at addr 00000000fdcea440 by task kworker/u760:4/540
CPU: 17 PID: 540 Comm: kworker/u760:4 Tainted: G            E      6.1.0-20221128.rc7.git1.5aa3bed4ce83.300.fc36.s390x+kasan #1
Hardware name: IBM 8561 T01 703 (LPAR)
Workqueue: 0.0.8000_event qeth_l2_br2dev_worker
Call Trace:
 [<000000016944d4ce>] dump_stack_lvl+0xc6/0xf8
 [<000000016942cd9c>] print_address_description.constprop.0+0x34/0x2a0
 [<000000016942d118>] print_report+0x110/0x1f8
 [<0000000167a7bd04>] kasan_report+0xfc/0x128
 [<000000016938d79a>] qeth_l2_br2dev_worker+0x5ba/0x6b0
 [<00000001673edd1e>] process_one_work+0x76e/0x1128
 [<00000001673ee85c>] worker_thread+0x184/0x1098
 [<000000016740718a>] kthread+0x26a/0x310
 [<00000001672c606a>] __ret_from_fork+0x8a/0xe8
 [<00000001694711da>] ret_from_fork+0xa/0x40
Allocated by task 108338:
 kasan_save_stack+0x40/0x68
 kasan_set_track+0x36/0x48
 __kasan_kmalloc+0xa0/0xc0
 qeth_l2_switchdev_event+0x25a/0x738
 atomic_notifier_call_chain+0x9c/0xf8
 br_switchdev_fdb_notify+0xf4/0x110
 fdb_notify+0x122/0x180
 fdb_add_entry.constprop.0.isra.0+0x312/0x558
 br_fdb_add+0x59e/0x858
 rtnl_fdb_add+0x58a/0x928
 rtnetlink_rcv_msg+0x5f8/0x8d8
 netlink_rcv_skb+0x1f2/0x408
 netlink_unicast+0x570/0x790
 netlink_sendmsg+0x752/0xbe0
 sock_sendmsg+0xca/0x110
 ____sys_sendmsg+0x510/0x6a8
 ___sys_sendmsg+0x12a/0x180
 __sys_sendmsg+0xe6/0x168
 __do_sys_socketcall+0x3c8/0x468
 do_syscall+0x22c/0x328
 __do_syscall+0x94/0xf0
 system_call+0x82/0xb0
Freed by task 540:
 kasan_save_stack+0x40/0x68
 kasan_set_track+0x36/0x48
 kasan_save_free_info+0x4c/0x68
 ____kasan_slab_free+0x14e/0x1a8
 __kasan_slab_free+0x24/0x30
 __kmem_cache_free+0x168/0x338
 qeth_l2_br2dev_worker+0x154/0x6b0
 process_one_work+0x76e/0x1128
 worker_thread+0x184/0x1098
 kthread+0x26a/0x310
 __ret_from_fork+0x8a/0xe8
 ret_from_fork+0xa/0x40
Last potentially related work creation:
 kasan_save_stack+0x40/0x68
 __kasan_record_aux_stack+0xbe/0xd0
 insert_work+0x56/0x2e8
 __queue_work+0x4ce/0xd10
 queue_work_on+0xf4/0x100
 qeth_l2_switchdev_event+0x520/0x738
 atomic_notifier_call_chain+0x9c/0xf8
 br_switchdev_fdb_notify+0xf4/0x110
 fdb_notify+0x122/0x180
 fdb_add_entry.constprop.0.isra.0+0x312/0x558
 br_fdb_add+0x59e/0x858
 rtnl_fdb_add+0x58a/0x928
 rtnetlink_rcv_msg+0x5f8/0x8d8
 netlink_rcv_skb+0x1f2/0x408
 netlink_unicast+0x570/0x790
 netlink_sendmsg+0x752/0xbe0
 sock_sendmsg+0xca/0x110
 ____sys_sendmsg+0x510/0x6a8
 ___sys_sendmsg+0x12a/0x180
 __sys_sendmsg+0xe6/0x168
 __do_sys_socketcall+0x3c8/0x468
 do_syscall+0x22c/0x328
 __do_syscall+0x94/0xf0
 system_call+0x82/0xb0
Second to last potentially related work creation:
 kasan_save_stack+0x40/0x68
 __kasan_record_aux_stack+0xbe/0xd0
 kvfree_call_rcu+0xb2/0x760
 kernfs_unlink_open_file+0x348/0x430
 kernfs_fop_release+0xc2/0x320
 __fput+0x1ae/0x768
 task_work_run+0x1bc/0x298
 exit_to_user_mode_prepare+0x1a0/0x1a8
 __do_syscall+0x94/0xf0
 system_call+0x82/0xb0
The buggy address belongs to the object at 00000000fdcea400
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 64 bytes inside of
 96-byte region [00000000fdcea400, 00000000fdcea460)
The buggy address belongs to the physical page:
page:000000005a9c26e8 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xfdcea
flags: 0x3ffff00000000200(slab|node=0|zone=1|lastcpupid=0x1ffff)
raw: 3ffff00000000200 0000000000000000 0000000100000122 000000008008cc00
raw: 0000000000000000 0020004100000000 ffffffff00000001 0000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 00000000fdcea300: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 00000000fdcea380: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>00000000fdcea400: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                           ^
 00000000fdcea480: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 00000000fdcea500: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================

Fixes: f7936b7b2663 ("s390/qeth: Update MACs of LEARNING_SYNC device")
Reported-by: Thorsten Winkler <twinkler@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Reviewed-by: Thorsten Winkler <twinkler@linux.ibm.com>
Link: https://lore.kernel.org/r/20221207105304.20494-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_l2_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 2d4436cbcb47..b38024a79376 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -758,7 +758,6 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 	struct list_head *iter;
 	int err = 0;
 
-	kfree(br2dev_event_work);
 	QETH_CARD_TEXT_(card, 4, "b2dw%04lx", event);
 	QETH_CARD_TEXT_(card, 4, "ma%012llx", ether_addr_to_u64(addr));
 
@@ -815,6 +814,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 	dev_put(brdev);
 	dev_put(lsyncdev);
 	dev_put(dstdev);
+	kfree(br2dev_event_work);
 }
 
 static int qeth_l2_br2dev_queue_work(struct net_device *brdev,
-- 
2.35.1



