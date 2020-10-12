Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D9228B80C
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731902AbgJLNtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731984AbgJLNs2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA19220678;
        Mon, 12 Oct 2020 13:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510507;
        bh=IROcsSuG5TsuWNjMrnvrxtHgBEicVFomcBBNZ4ij5hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4E1XoVFZaIyexX9O0FmO39Q/JAUNEJJr6AQ9deiKDGAjeb88V9eK/558dnqvA/+s
         KxqdrDVtUKQUZ0DRWsBqfoar864quwp9U9LrjKQ/mpHTcQeVXkkfUkfm2f9W5Sg2+C
         Q4bNY+fCPZTO3zxEL6o6WX6yLqmCIyeOPV1IEJ/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+0f84f6eed90503da72fc@syzkaller.appspotmail.com
Subject: [PATCH 5.8 122/124] net: qrtr: ns: Protect radix_tree_deref_slot() using rcu read locks
Date:   Mon, 12 Oct 2020 15:32:06 +0200
Message-Id: <20201012133152.760309569@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit a7809ff90ce6c48598d3c4ab54eb599bec1e9c42 upstream.

The rcu read locks are needed to avoid potential race condition while
dereferencing radix tree from multiple threads. The issue was identified
by syzbot. Below is the crash report:

=============================
WARNING: suspicious RCU usage
5.7.0-syzkaller #0 Not tainted
-----------------------------
include/linux/radix-tree.h:176 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
2 locks held by kworker/u4:1/21:
 #0: ffff88821b097938 ((wq_completion)qrtr_ns_handler){+.+.}-{0:0}, at: spin_unlock_irq include/linux/spinlock.h:403 [inline]
 #0: ffff88821b097938 ((wq_completion)qrtr_ns_handler){+.+.}-{0:0}, at: process_one_work+0x6df/0xfd0 kernel/workqueue.c:2241
 #1: ffffc90000dd7d80 ((work_completion)(&qrtr_ns.work)){+.+.}-{0:0}, at: process_one_work+0x71e/0xfd0 kernel/workqueue.c:2243

stack backtrace:
CPU: 0 PID: 21 Comm: kworker/u4:1 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: qrtr_ns_handler qrtr_ns_worker
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 radix_tree_deref_slot include/linux/radix-tree.h:176 [inline]
 ctrl_cmd_new_lookup net/qrtr/ns.c:558 [inline]
 qrtr_ns_worker+0x2aff/0x4500 net/qrtr/ns.c:674
 process_one_work+0x76e/0xfd0 kernel/workqueue.c:2268
 worker_thread+0xa7f/0x1450 kernel/workqueue.c:2414
 kthread+0x353/0x380 kernel/kthread.c:268

Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
Reported-and-tested-by: syzbot+0f84f6eed90503da72fc@syzkaller.appspotmail.com
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/qrtr/ns.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -193,12 +193,13 @@ static int announce_servers(struct socka
 	struct qrtr_server *srv;
 	struct qrtr_node *node;
 	void __rcu **slot;
-	int ret;
+	int ret = 0;
 
 	node = node_get(qrtr_ns.local_node);
 	if (!node)
 		return 0;
 
+	rcu_read_lock();
 	/* Announce the list of servers registered in this node */
 	radix_tree_for_each_slot(slot, &node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
@@ -206,11 +207,14 @@ static int announce_servers(struct socka
 		ret = service_announce_new(sq, srv);
 		if (ret < 0) {
 			pr_err("failed to announce new service\n");
-			return ret;
+			goto err_out;
 		}
 	}
 
-	return 0;
+err_out:
+	rcu_read_unlock();
+
+	return ret;
 }
 
 static struct qrtr_server *server_add(unsigned int service,
@@ -335,7 +339,7 @@ static int ctrl_cmd_bye(struct sockaddr_
 	struct qrtr_node *node;
 	void __rcu **slot;
 	struct kvec iv;
-	int ret;
+	int ret = 0;
 
 	iv.iov_base = &pkt;
 	iv.iov_len = sizeof(pkt);
@@ -344,11 +348,13 @@ static int ctrl_cmd_bye(struct sockaddr_
 	if (!node)
 		return 0;
 
+	rcu_read_lock();
 	/* Advertise removal of this client to all servers of remote node */
 	radix_tree_for_each_slot(slot, &node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
 		server_del(node, srv->port);
 	}
+	rcu_read_unlock();
 
 	/* Advertise the removal of this client to all local servers */
 	local_node = node_get(qrtr_ns.local_node);
@@ -359,6 +365,7 @@ static int ctrl_cmd_bye(struct sockaddr_
 	pkt.cmd = cpu_to_le32(QRTR_TYPE_BYE);
 	pkt.client.node = cpu_to_le32(from->sq_node);
 
+	rcu_read_lock();
 	radix_tree_for_each_slot(slot, &local_node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
 
@@ -372,11 +379,14 @@ static int ctrl_cmd_bye(struct sockaddr_
 		ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
 		if (ret < 0) {
 			pr_err("failed to send bye cmd\n");
-			return ret;
+			goto err_out;
 		}
 	}
 
-	return 0;
+err_out:
+	rcu_read_unlock();
+
+	return ret;
 }
 
 static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
@@ -394,7 +404,7 @@ static int ctrl_cmd_del_client(struct so
 	struct list_head *li;
 	void __rcu **slot;
 	struct kvec iv;
-	int ret;
+	int ret = 0;
 
 	iv.iov_base = &pkt;
 	iv.iov_len = sizeof(pkt);
@@ -434,6 +444,7 @@ static int ctrl_cmd_del_client(struct so
 	pkt.client.node = cpu_to_le32(node_id);
 	pkt.client.port = cpu_to_le32(port);
 
+	rcu_read_lock();
 	radix_tree_for_each_slot(slot, &local_node->servers, &iter, 0) {
 		srv = radix_tree_deref_slot(slot);
 
@@ -447,11 +458,14 @@ static int ctrl_cmd_del_client(struct so
 		ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
 		if (ret < 0) {
 			pr_err("failed to send del client cmd\n");
-			return ret;
+			goto err_out;
 		}
 	}
 
-	return 0;
+err_out:
+	rcu_read_unlock();
+
+	return ret;
 }
 
 static int ctrl_cmd_new_server(struct sockaddr_qrtr *from,
@@ -554,6 +568,7 @@ static int ctrl_cmd_new_lookup(struct so
 	filter.service = service;
 	filter.instance = instance;
 
+	rcu_read_lock();
 	radix_tree_for_each_slot(node_slot, &nodes, &node_iter, 0) {
 		node = radix_tree_deref_slot(node_slot);
 
@@ -568,6 +583,7 @@ static int ctrl_cmd_new_lookup(struct so
 			lookup_notify(from, srv, true);
 		}
 	}
+	rcu_read_unlock();
 
 	/* Empty notification, to indicate end of listing */
 	lookup_notify(from, NULL, true);


