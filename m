Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC40D3AEDAE
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhFUQWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231514AbhFUQVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:21:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F43E61261;
        Mon, 21 Jun 2021 16:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292329;
        bh=T1A1LUVGoErIToXyaU2g1B1N1LGR7np53AISHhiAQmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSz4xsWd4EyexgqBVutmDVx4ob497BGMq+QkPD+WWuXN8hFt4nocjcx7WdqcQ4oEz
         6KdmWxBboLa6KxU0ivu18wFWVmaiJNaYsd2iwNzG5ZsMY5tbtLOj2oEKZN2Xr3ftNW
         j0cssDETIcALMiV5A3ayfvfwSN1+PDPfkEiVDeQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>,
        syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 51/90] can: bcm/raw/isotp: use per module netdevice notifier
Date:   Mon, 21 Jun 2021 18:15:26 +0200
Message-Id: <20210621154905.870204703@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit 8d0caedb759683041d9db82069937525999ada53 upstream.

syzbot is reporting hung task at register_netdevice_notifier() [1] and
unregister_netdevice_notifier() [2], for cleanup_net() might perform
time consuming operations while CAN driver's raw/bcm/isotp modules are
calling {register,unregister}_netdevice_notifier() on each socket.

Change raw/bcm/isotp modules to call register_netdevice_notifier() from
module's __init function and call unregister_netdevice_notifier() from
module's __exit function, as with gw/j1939 modules are doing.

Link: https://syzkaller.appspot.com/bug?id=391b9498827788b3cc6830226d4ff5be87107c30 [1]
Link: https://syzkaller.appspot.com/bug?id=1724d278c83ca6e6df100a2e320c10d991cf2bce [2]
Link: https://lore.kernel.org/r/54a5f451-05ed-f977-8534-79e7aa2bcc8f@i-love.sakura.ne.jp
Cc: linux-stable <stable@vger.kernel.org>
Reported-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Tested-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/bcm.c |   59 +++++++++++++++++++++++++++++++++++++++++++------------
 net/can/raw.c |   62 ++++++++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 94 insertions(+), 27 deletions(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -127,7 +127,7 @@ struct bcm_sock {
 	struct sock sk;
 	int bound;
 	int ifindex;
-	struct notifier_block notifier;
+	struct list_head notifier;
 	struct list_head rx_ops;
 	struct list_head tx_ops;
 	unsigned long dropped_usr_msgs;
@@ -135,6 +135,10 @@ struct bcm_sock {
 	char procname [32]; /* inode number in decimal with \0 */
 };
 
+static LIST_HEAD(bcm_notifier_list);
+static DEFINE_SPINLOCK(bcm_notifier_lock);
+static struct bcm_sock *bcm_busy_notifier;
+
 static inline struct bcm_sock *bcm_sk(const struct sock *sk)
 {
 	return (struct bcm_sock *)sk;
@@ -1383,20 +1387,15 @@ static int bcm_sendmsg(struct socket *so
 /*
  * notification handler for netdevice status changes
  */
-static int bcm_notifier(struct notifier_block *nb, unsigned long msg,
-			void *ptr)
+static void bcm_notify(struct bcm_sock *bo, unsigned long msg,
+		       struct net_device *dev)
 {
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct bcm_sock *bo = container_of(nb, struct bcm_sock, notifier);
 	struct sock *sk = &bo->sk;
 	struct bcm_op *op;
 	int notify_enodev = 0;
 
 	if (!net_eq(dev_net(dev), sock_net(sk)))
-		return NOTIFY_DONE;
-
-	if (dev->type != ARPHRD_CAN)
-		return NOTIFY_DONE;
+		return;
 
 	switch (msg) {
 
@@ -1431,7 +1430,28 @@ static int bcm_notifier(struct notifier_
 				sk->sk_error_report(sk);
 		}
 	}
+}
 
+static int bcm_notifier(struct notifier_block *nb, unsigned long msg,
+			void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	if (dev->type != ARPHRD_CAN)
+		return NOTIFY_DONE;
+	if (msg != NETDEV_UNREGISTER && msg != NETDEV_DOWN)
+		return NOTIFY_DONE;
+	if (unlikely(bcm_busy_notifier)) /* Check for reentrant bug. */
+		return NOTIFY_DONE;
+
+	spin_lock(&bcm_notifier_lock);
+	list_for_each_entry(bcm_busy_notifier, &bcm_notifier_list, notifier) {
+		spin_unlock(&bcm_notifier_lock);
+		bcm_notify(bcm_busy_notifier, msg, dev);
+		spin_lock(&bcm_notifier_lock);
+	}
+	bcm_busy_notifier = NULL;
+	spin_unlock(&bcm_notifier_lock);
 	return NOTIFY_DONE;
 }
 
@@ -1451,9 +1471,9 @@ static int bcm_init(struct sock *sk)
 	INIT_LIST_HEAD(&bo->rx_ops);
 
 	/* set notifier */
-	bo->notifier.notifier_call = bcm_notifier;
-
-	register_netdevice_notifier(&bo->notifier);
+	spin_lock(&bcm_notifier_lock);
+	list_add_tail(&bo->notifier, &bcm_notifier_list);
+	spin_unlock(&bcm_notifier_lock);
 
 	return 0;
 }
@@ -1476,7 +1496,14 @@ static int bcm_release(struct socket *so
 
 	/* remove bcm_ops, timer, rx_unregister(), etc. */
 
-	unregister_netdevice_notifier(&bo->notifier);
+	spin_lock(&bcm_notifier_lock);
+	while (bcm_busy_notifier == bo) {
+		spin_unlock(&bcm_notifier_lock);
+		schedule_timeout_uninterruptible(1);
+		spin_lock(&bcm_notifier_lock);
+	}
+	list_del(&bo->notifier);
+	spin_unlock(&bcm_notifier_lock);
 
 	lock_sock(sk);
 
@@ -1699,6 +1726,10 @@ static struct pernet_operations canbcm_p
 	.exit = canbcm_pernet_exit,
 };
 
+static struct notifier_block canbcm_notifier = {
+	.notifier_call = bcm_notifier
+};
+
 static int __init bcm_module_init(void)
 {
 	int err;
@@ -1712,12 +1743,14 @@ static int __init bcm_module_init(void)
 	}
 
 	register_pernet_subsys(&canbcm_pernet_ops);
+	register_netdevice_notifier(&canbcm_notifier);
 	return 0;
 }
 
 static void __exit bcm_module_exit(void)
 {
 	can_proto_unregister(&bcm_can_proto);
+	unregister_netdevice_notifier(&canbcm_notifier);
 	unregister_pernet_subsys(&canbcm_pernet_ops);
 }
 
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -85,7 +85,7 @@ struct raw_sock {
 	struct sock sk;
 	int bound;
 	int ifindex;
-	struct notifier_block notifier;
+	struct list_head notifier;
 	int loopback;
 	int recv_own_msgs;
 	int fd_frames;
@@ -97,6 +97,10 @@ struct raw_sock {
 	struct uniqframe __percpu *uniq;
 };
 
+static LIST_HEAD(raw_notifier_list);
+static DEFINE_SPINLOCK(raw_notifier_lock);
+static struct raw_sock *raw_busy_notifier;
+
 /* Return pointer to store the extra msg flags for raw_recvmsg().
  * We use the space of one unsigned int beyond the 'struct sockaddr_can'
  * in skb->cb.
@@ -265,21 +269,16 @@ static int raw_enable_allfilters(struct
 	return err;
 }
 
-static int raw_notifier(struct notifier_block *nb,
-			unsigned long msg, void *ptr)
+static void raw_notify(struct raw_sock *ro, unsigned long msg,
+		       struct net_device *dev)
 {
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct raw_sock *ro = container_of(nb, struct raw_sock, notifier);
 	struct sock *sk = &ro->sk;
 
 	if (!net_eq(dev_net(dev), sock_net(sk)))
-		return NOTIFY_DONE;
-
-	if (dev->type != ARPHRD_CAN)
-		return NOTIFY_DONE;
+		return;
 
 	if (ro->ifindex != dev->ifindex)
-		return NOTIFY_DONE;
+		return;
 
 	switch (msg) {
 	case NETDEV_UNREGISTER:
@@ -307,7 +306,28 @@ static int raw_notifier(struct notifier_
 			sk->sk_error_report(sk);
 		break;
 	}
+}
+
+static int raw_notifier(struct notifier_block *nb, unsigned long msg,
+			void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	if (dev->type != ARPHRD_CAN)
+		return NOTIFY_DONE;
+	if (msg != NETDEV_UNREGISTER && msg != NETDEV_DOWN)
+		return NOTIFY_DONE;
+	if (unlikely(raw_busy_notifier)) /* Check for reentrant bug. */
+		return NOTIFY_DONE;
 
+	spin_lock(&raw_notifier_lock);
+	list_for_each_entry(raw_busy_notifier, &raw_notifier_list, notifier) {
+		spin_unlock(&raw_notifier_lock);
+		raw_notify(raw_busy_notifier, msg, dev);
+		spin_lock(&raw_notifier_lock);
+	}
+	raw_busy_notifier = NULL;
+	spin_unlock(&raw_notifier_lock);
 	return NOTIFY_DONE;
 }
 
@@ -336,9 +356,9 @@ static int raw_init(struct sock *sk)
 		return -ENOMEM;
 
 	/* set notifier */
-	ro->notifier.notifier_call = raw_notifier;
-
-	register_netdevice_notifier(&ro->notifier);
+	spin_lock(&raw_notifier_lock);
+	list_add_tail(&ro->notifier, &raw_notifier_list);
+	spin_unlock(&raw_notifier_lock);
 
 	return 0;
 }
@@ -353,7 +373,14 @@ static int raw_release(struct socket *so
 
 	ro = raw_sk(sk);
 
-	unregister_netdevice_notifier(&ro->notifier);
+	spin_lock(&raw_notifier_lock);
+	while (raw_busy_notifier == ro) {
+		spin_unlock(&raw_notifier_lock);
+		schedule_timeout_uninterruptible(1);
+		spin_lock(&raw_notifier_lock);
+	}
+	list_del(&ro->notifier);
+	spin_unlock(&raw_notifier_lock);
 
 	lock_sock(sk);
 
@@ -879,6 +906,10 @@ static const struct can_proto raw_can_pr
 	.prot       = &raw_proto,
 };
 
+static struct notifier_block canraw_notifier = {
+	.notifier_call = raw_notifier
+};
+
 static __init int raw_module_init(void)
 {
 	int err;
@@ -888,6 +919,8 @@ static __init int raw_module_init(void)
 	err = can_proto_register(&raw_can_proto);
 	if (err < 0)
 		pr_err("can: registration of raw protocol failed\n");
+	else
+		register_netdevice_notifier(&canraw_notifier);
 
 	return err;
 }
@@ -895,6 +928,7 @@ static __init int raw_module_init(void)
 static __exit void raw_module_exit(void)
 {
 	can_proto_unregister(&raw_can_proto);
+	unregister_netdevice_notifier(&canraw_notifier);
 }
 
 module_init(raw_module_init);


