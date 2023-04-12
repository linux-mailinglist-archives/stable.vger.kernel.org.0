Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EB76DEE17
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjDLIkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjDLIjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:39:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C6672B5
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:38:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B19B962FF5
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AD5C433D2;
        Wed, 12 Apr 2023 08:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288574;
        bh=1lfyEJY4IWyIg1OwJ35B0yccnwqQoU9c82tx3TNVGbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbqCpVmzAPUc6OQtX0V2WPpZ1Ug48nwLW0UsY5FyWW/t4AwUpDyvBxLkF3uNmatQp
         mSk1t8gRAB3wFyAmXQX/vXKhk/LkM4tBvgUUm7Mrmtb86RmT1eivlivfBfsbu5u/oq
         BlR1dJyhO5LUl0xu0mNpBVpjq41NKJEQIdMBiUOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+a7492efaa5d61b51db23@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 30/93] net: qrtr: Fix a refcount bug in qrtr_recvmsg()
Date:   Wed, 12 Apr 2023 10:33:31 +0200
Message-Id: <20230412082824.356485550@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 44d807320000db0d0013372ad39b53e12d52f758 ]

Syzbot reported a bug as following:

refcount_t: addition on 0; use-after-free.
...
RIP: 0010:refcount_warn_saturate+0x17c/0x1f0 lib/refcount.c:25
...
Call Trace:
 <TASK>
 __refcount_add include/linux/refcount.h:199 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 kref_get include/linux/kref.h:45 [inline]
 qrtr_node_acquire net/qrtr/af_qrtr.c:202 [inline]
 qrtr_node_lookup net/qrtr/af_qrtr.c:398 [inline]
 qrtr_send_resume_tx net/qrtr/af_qrtr.c:1003 [inline]
 qrtr_recvmsg+0x85f/0x990 net/qrtr/af_qrtr.c:1070
 sock_recvmsg_nosec net/socket.c:1017 [inline]
 sock_recvmsg+0xe2/0x160 net/socket.c:1038
 qrtr_ns_worker+0x170/0x1700 net/qrtr/ns.c:688
 process_one_work+0x991/0x15c0 kernel/workqueue.c:2390
 worker_thread+0x669/0x1090 kernel/workqueue.c:2537

It occurs in the concurrent scenario of qrtr_recvmsg() and
qrtr_endpoint_unregister() as following:

	cpu0					cpu1
qrtr_recvmsg				qrtr_endpoint_unregister
qrtr_send_resume_tx			qrtr_node_release
qrtr_node_lookup			mutex_lock(&qrtr_node_lock)
spin_lock_irqsave(&qrtr_nodes_lock, )	refcount_dec_and_test(&node->ref) [node->ref == 0]
radix_tree_lookup [node != NULL]	__qrtr_node_release
qrtr_node_acquire			spin_lock_irqsave(&qrtr_nodes_lock, )
kref_get(&node->ref) [WARNING]		...
					mutex_unlock(&qrtr_node_lock)

Use qrtr_node_lock to protect qrtr_node_lookup() implementation, this
is actually improving the protection of node reference.

Fixes: 0a7e0d0ef054 ("net: qrtr: Migrate node lookup tree to spinlock")
Reported-by: syzbot+a7492efaa5d61b51db23@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=a7492efaa5d61b51db23
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/af_qrtr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index ec23225297278..6e88ba812d2a2 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -393,10 +393,12 @@ static struct qrtr_node *qrtr_node_lookup(unsigned int nid)
 	struct qrtr_node *node;
 	unsigned long flags;
 
+	mutex_lock(&qrtr_node_lock);
 	spin_lock_irqsave(&qrtr_nodes_lock, flags);
 	node = radix_tree_lookup(&qrtr_nodes, nid);
 	node = qrtr_node_acquire(node);
 	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
+	mutex_unlock(&qrtr_node_lock);
 
 	return node;
 }
-- 
2.39.2



