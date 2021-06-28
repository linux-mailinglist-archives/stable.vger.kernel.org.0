Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635F03B6458
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbhF1PG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237245AbhF1PF2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:05:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 073B161D02;
        Mon, 28 Jun 2021 14:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891411;
        bh=rAoq1iRbC0Et7SLPGlLyOO4vQFhJGL/vKS5TRRuGO7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MeP39Bpxj60ERPu/yYtYCSDnWu4h4wWtz06hY4MN9UBx+T74TXyfrZXEledLSXxIA
         gEbuk/4rzYjNJifeP+1mu99mt0UnGP9lDqfYCOOLmdv1KMS8beX7o+pBEWxx8PoCdY
         Pb43906aLZif0D8uSH3PQN0n9zVtmcrCfev8QKbomisUVqAvV69BDMqEN1p8zUEOlz
         /gwh0z0sONAoqZ74/hCwC2xSQEw/ec0Aor98ELJTMhz/vxdHIaNMg9xcRNmHExvMox
         2G3uXsRlbhwOHY8372UKtdeoi6/7XgprJOLqXzI50ZiThJASbGKAelJLcpPqB6hC0O
         2evmfcNDOnr8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>,
        syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 38/57] can: bcm/raw/isotp: use per module netdevice notifier
Date:   Mon, 28 Jun 2021 10:42:37 -0400
Message-Id: <20210628144256.34524-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 net/can/bcm.c | 61 +++++++++++++++++++++++++++++++++++++++-----------
 net/can/raw.c | 62 +++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 96 insertions(+), 27 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index bd9e10db6cd7..c6fee58baac4 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -121,7 +121,7 @@ struct bcm_sock {
 	struct sock sk;
 	int bound;
 	int ifindex;
-	struct notifier_block notifier;
+	struct list_head notifier;
 	struct list_head rx_ops;
 	struct list_head tx_ops;
 	unsigned long dropped_usr_msgs;
@@ -129,6 +129,10 @@ struct bcm_sock {
 	char procname [32]; /* inode number in decimal with \0 */
 };
 
+static LIST_HEAD(bcm_notifier_list);
+static DEFINE_SPINLOCK(bcm_notifier_lock);
+static struct bcm_sock *bcm_busy_notifier;
+
 static inline struct bcm_sock *bcm_sk(const struct sock *sk)
 {
 	return (struct bcm_sock *)sk;
@@ -1388,20 +1392,15 @@ static int bcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
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
 
 	if (!net_eq(dev_net(dev), &init_net))
-		return NOTIFY_DONE;
-
-	if (dev->type != ARPHRD_CAN)
-		return NOTIFY_DONE;
+		return;
 
 	switch (msg) {
 
@@ -1436,7 +1435,28 @@ static int bcm_notifier(struct notifier_block *nb, unsigned long msg,
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
 
@@ -1456,9 +1476,9 @@ static int bcm_init(struct sock *sk)
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
@@ -1479,7 +1499,14 @@ static int bcm_release(struct socket *sock)
 
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
 
@@ -1665,6 +1692,10 @@ static const struct can_proto bcm_can_proto = {
 	.prot       = &bcm_proto,
 };
 
+static struct notifier_block canbcm_notifier = {
+	.notifier_call = bcm_notifier
+};
+
 static int __init bcm_module_init(void)
 {
 	int err;
@@ -1679,6 +1710,8 @@ static int __init bcm_module_init(void)
 
 	/* create /proc/net/can-bcm directory */
 	proc_dir = proc_mkdir("can-bcm", init_net.proc_net);
+	register_netdevice_notifier(&canbcm_notifier);
+
 	return 0;
 }
 
@@ -1688,6 +1721,8 @@ static void __exit bcm_module_exit(void)
 
 	if (proc_dir)
 		remove_proc_entry("can-bcm", init_net.proc_net);
+
+	unregister_netdevice_notifier(&canbcm_notifier);
 }
 
 module_init(bcm_module_init);
diff --git a/net/can/raw.c b/net/can/raw.c
index e9403a26a1d5..2e1d850a7f2a 100644
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
@@ -260,21 +264,16 @@ static int raw_enable_allfilters(struct net_device *dev, struct sock *sk)
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
 
 	if (!net_eq(dev_net(dev), &init_net))
-		return NOTIFY_DONE;
-
-	if (dev->type != ARPHRD_CAN)
-		return NOTIFY_DONE;
+		return;
 
 	if (ro->ifindex != dev->ifindex)
-		return NOTIFY_DONE;
+		return;
 
 	switch (msg) {
 
@@ -303,7 +302,28 @@ static int raw_notifier(struct notifier_block *nb,
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
 
@@ -332,9 +352,9 @@ static int raw_init(struct sock *sk)
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
@@ -349,7 +369,14 @@ static int raw_release(struct socket *sock)
 
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
 
@@ -857,6 +884,10 @@ static const struct can_proto raw_can_proto = {
 	.prot       = &raw_proto,
 };
 
+static struct notifier_block canraw_notifier = {
+	.notifier_call = raw_notifier
+};
+
 static __init int raw_module_init(void)
 {
 	int err;
@@ -866,6 +897,8 @@ static __init int raw_module_init(void)
 	err = can_proto_register(&raw_can_proto);
 	if (err < 0)
 		printk(KERN_ERR "can: registration of raw protocol failed\n");
+	else
+		register_netdevice_notifier(&canraw_notifier);
 
 	return err;
 }
@@ -873,6 +906,7 @@ static __init int raw_module_init(void)
 static __exit void raw_module_exit(void)
 {
 	can_proto_unregister(&raw_can_proto);
+	unregister_netdevice_notifier(&canraw_notifier);
 }
 
 module_init(raw_module_init);
-- 
2.30.2

