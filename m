Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1523AE816
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 13:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbhFUL1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 07:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhFUL1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 07:27:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C45CC061574
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 04:25:02 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lvI32-0007An-CL
        for stable@vger.kernel.org; Mon, 21 Jun 2021 13:25:00 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id DB1AD640515
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 11:24:55 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E916A64050D;
        Mon, 21 Jun 2021 11:24:54 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1059371f;
        Mon, 21 Jun 2021 11:24:54 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     linux-can@vger.kernel.org
Cc:     kernel@pengutronix.de,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-stable <stable@vger.kernel.org>,
        syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>,
        syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH] can: bcm/raw/isotp: use per module netdevice notifier
Date:   Mon, 21 Jun 2021 13:24:51 +0200
Message-Id: <20210621112451.2882032-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1624271916195215@kroah.com>
References: <1624271916195215@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit 8d0caedb759683041d9db82069937525999ada53 upstream

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
[mkl: ported to v4.19.195]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
Hello Greg,

this is a backport of

| 8d0caedb7596 can: bcm/raw/isotp: use per module netdevice notifier

to v4.19.195. Please apply.

regards,
Marc

 net/can/bcm.c | 59 +++++++++++++++++++++++++++++++++++++-----------
 net/can/raw.c | 62 +++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 94 insertions(+), 27 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 79bb8afa9c0c..48798fa28fa4 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -125,7 +125,7 @@ struct bcm_sock {
 	struct sock sk;
 	int bound;
 	int ifindex;
-	struct notifier_block notifier;
+	struct list_head notifier;
 	struct list_head rx_ops;
 	struct list_head tx_ops;
 	unsigned long dropped_usr_msgs;
@@ -133,6 +133,10 @@ struct bcm_sock {
 	char procname [32]; /* inode number in decimal with \0 */
 };
 
+static LIST_HEAD(bcm_notifier_list);
+static DEFINE_SPINLOCK(bcm_notifier_lock);
+static struct bcm_sock *bcm_busy_notifier;
+
 static inline struct bcm_sock *bcm_sk(const struct sock *sk)
 {
 	return (struct bcm_sock *)sk;
@@ -1429,20 +1433,15 @@ static int bcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
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
 
@@ -1477,7 +1476,28 @@ static int bcm_notifier(struct notifier_block *nb, unsigned long msg,
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
 
@@ -1497,9 +1517,9 @@ static int bcm_init(struct sock *sk)
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
@@ -1522,7 +1542,14 @@ static int bcm_release(struct socket *sock)
 
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
 
@@ -1737,6 +1764,10 @@ static struct pernet_operations canbcm_pernet_ops __read_mostly = {
 	.exit = canbcm_pernet_exit,
 };
 
+static struct notifier_block canbcm_notifier = {
+	.notifier_call = bcm_notifier
+};
+
 static int __init bcm_module_init(void)
 {
 	int err;
@@ -1750,12 +1781,14 @@ static int __init bcm_module_init(void)
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
 
diff --git a/net/can/raw.c b/net/can/raw.c
index 3aab7664933f..296a11a922e0 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -84,7 +84,7 @@ struct raw_sock {
 	struct sock sk;
 	int bound;
 	int ifindex;
-	struct notifier_block notifier;
+	struct list_head notifier;
 	int loopback;
 	int recv_own_msgs;
 	int fd_frames;
@@ -96,6 +96,10 @@ struct raw_sock {
 	struct uniqframe __percpu *uniq;
 };
 
+static LIST_HEAD(raw_notifier_list);
+static DEFINE_SPINLOCK(raw_notifier_lock);
+static struct raw_sock *raw_busy_notifier;
+
 /*
  * Return pointer to store the extra msg flags for raw_recvmsg().
  * We use the space of one unsigned int beyond the 'struct sockaddr_can'
@@ -266,21 +270,16 @@ static int raw_enable_allfilters(struct net *net, struct net_device *dev,
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
 
@@ -309,7 +308,28 @@ static int raw_notifier(struct notifier_block *nb,
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
 
@@ -338,9 +358,9 @@ static int raw_init(struct sock *sk)
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
@@ -355,7 +375,14 @@ static int raw_release(struct socket *sock)
 
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
 
@@ -870,6 +897,10 @@ static const struct can_proto raw_can_proto = {
 	.prot       = &raw_proto,
 };
 
+static struct notifier_block canraw_notifier = {
+	.notifier_call = raw_notifier
+};
+
 static __init int raw_module_init(void)
 {
 	int err;
@@ -879,6 +910,8 @@ static __init int raw_module_init(void)
 	err = can_proto_register(&raw_can_proto);
 	if (err < 0)
 		printk(KERN_ERR "can: registration of raw protocol failed\n");
+	else
+		register_netdevice_notifier(&canraw_notifier);
 
 	return err;
 }
@@ -886,6 +919,7 @@ static __init int raw_module_init(void)
 static __exit void raw_module_exit(void)
 {
 	can_proto_unregister(&raw_can_proto);
+	unregister_netdevice_notifier(&canraw_notifier);
 }
 
 module_init(raw_module_init);
-- 
2.30.2


