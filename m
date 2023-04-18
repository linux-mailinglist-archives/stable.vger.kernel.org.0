Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6206E6287
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjDRMd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbjDRMdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:33:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783289EF8
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:33:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5983A6318A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680A3C433D2;
        Tue, 18 Apr 2023 12:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821182;
        bh=4RqeshYpMJdjCa4M9mwS8ZHGPMItg+lYT48K503qAho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phDrN/A5rs51tB6elYFveWAjTuVry+wPKjBd1GOmkx4hK45rgYGG+6CnJH2+NLjql
         g+zg2GFXGCNhLnqa3SPCng5t2rt8tJWJi3Fx6SDggkGgPKpt7H3OJ7eei6BNuzCGwq
         BcxEgZZmq/lcBs2EPU0vLNNpETGZRr25udV7iBko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+a7492efaa5d61b51db23@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/124] net: qrtr: Fix a refcount bug in qrtr_recvmsg()
Date:   Tue, 18 Apr 2023 14:20:27 +0200
Message-Id: <20230418120309.906414839@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index 13448ca5aeff2..d0f0b2b8dce2f 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -388,10 +388,12 @@ static struct qrtr_node *qrtr_node_lookup(unsigned int nid)
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



