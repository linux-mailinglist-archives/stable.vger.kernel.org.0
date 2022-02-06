Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7984AAF34
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 13:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235749AbiBFMoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 07:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiBFMoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 07:44:04 -0500
X-Greylist: delayed 2060 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 04:44:03 PST
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E624C06173B
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 04:44:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B133C60EBC
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 12:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D610C340E9;
        Sun,  6 Feb 2022 12:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644151442;
        bh=P5BsJaF797d3PQXIFZs65WK0Vs9baO9lA8P2IQLdjFA=;
        h=Subject:To:Cc:From:Date:From;
        b=QkrXKtLDGKfjqWQ+Ugg1Qpr9pwfvXBhTAXSzmx7DaaUfSsriMCVulCYgR/WXLK6GV
         PhDaaNAXGaVYhKXFiBGa2YW1NNMtVOTXH/KKIeBjcR5FxXpeb+VBkImoYp4q22lEk6
         tNK3ZWsxVVoZBmy9QhgsCAWejrwlQ3u2uyB54pn0=
Subject: FAILED: patch "[PATCH] net/smc: Forward wakeup to smc socket waitqueue after" failed to apply to 5.4-stable tree
To:     guwen@linux.alibaba.com, davem@davemloft.net, kgraul@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 06 Feb 2022 13:43:51 +0100
Message-ID: <164415143110826@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 341adeec9adad0874f29a0a1af35638207352a39 Mon Sep 17 00:00:00 2001
From: Wen Gu <guwen@linux.alibaba.com>
Date: Wed, 26 Jan 2022 23:33:04 +0800
Subject: [PATCH] net/smc: Forward wakeup to smc socket waitqueue after
 fallback

When we replace TCP with SMC and a fallback occurs, there may be
some socket waitqueue entries remaining in smc socket->wq, such
as eppoll_entries inserted by userspace applications.

After the fallback, data flows over TCP/IP and only clcsocket->wq
will be woken up. Applications can't be notified by the entries
which were inserted in smc socket->wq before fallback. So we need
a mechanism to wake up smc socket->wq at the same time if some
entries remaining in it.

The current workaround is to transfer the entries from smc socket->wq
to clcsock->wq during the fallback. But this may cause a crash
like this:

 general protection fault, probably for non-canonical address 0xdead000000000100: 0000 [#1] PREEMPT SMP PTI
 CPU: 3 PID: 0 Comm: swapper/3 Kdump: loaded Tainted: G E     5.16.0+ #107
 RIP: 0010:__wake_up_common+0x65/0x170
 Call Trace:
  <IRQ>
  __wake_up_common_lock+0x7a/0xc0
  sock_def_readable+0x3c/0x70
  tcp_data_queue+0x4a7/0xc40
  tcp_rcv_established+0x32f/0x660
  ? sk_filter_trim_cap+0xcb/0x2e0
  tcp_v4_do_rcv+0x10b/0x260
  tcp_v4_rcv+0xd2a/0xde0
  ip_protocol_deliver_rcu+0x3b/0x1d0
  ip_local_deliver_finish+0x54/0x60
  ip_local_deliver+0x6a/0x110
  ? tcp_v4_early_demux+0xa2/0x140
  ? tcp_v4_early_demux+0x10d/0x140
  ip_sublist_rcv_finish+0x49/0x60
  ip_sublist_rcv+0x19d/0x230
  ip_list_rcv+0x13e/0x170
  __netif_receive_skb_list_core+0x1c2/0x240
  netif_receive_skb_list_internal+0x1e6/0x320
  napi_complete_done+0x11d/0x190
  mlx5e_napi_poll+0x163/0x6b0 [mlx5_core]
  __napi_poll+0x3c/0x1b0
  net_rx_action+0x27c/0x300
  __do_softirq+0x114/0x2d2
  irq_exit_rcu+0xb4/0xe0
  common_interrupt+0xba/0xe0
  </IRQ>
  <TASK>

The crash is caused by privately transferring waitqueue entries from
smc socket->wq to clcsock->wq. The owners of these entries, such as
epoll, have no idea that the entries have been transferred to a
different socket wait queue and still use original waitqueue spinlock
(smc socket->wq.wait.lock) to make the entries operation exclusive,
but it doesn't work. The operations to the entries, such as removing
from the waitqueue (now is clcsock->wq after fallback), may cause a
crash when clcsock waitqueue is being iterated over at the moment.

This patch tries to fix this by no longer transferring wait queue
entries privately, but introducing own implementations of clcsock's
callback functions in fallback situation. The callback functions will
forward the wakeup to smc socket->wq if clcsock->wq is actually woken
up and smc socket->wq has remaining entries.

Fixes: 2153bd1e3d3d ("net/smc: Transfer remaining wait queue entries during fallback")
Suggested-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index d5ea62b82bb8..8c89d0b0ca18 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -566,17 +566,115 @@ static void smc_stat_fallback(struct smc_sock *smc)
 	mutex_unlock(&net->smc.mutex_fback_rsn);
 }
 
+/* must be called under rcu read lock */
+static void smc_fback_wakeup_waitqueue(struct smc_sock *smc, void *key)
+{
+	struct socket_wq *wq;
+	__poll_t flags;
+
+	wq = rcu_dereference(smc->sk.sk_wq);
+	if (!skwq_has_sleeper(wq))
+		return;
+
+	/* wake up smc sk->sk_wq */
+	if (!key) {
+		/* sk_state_change */
+		wake_up_interruptible_all(&wq->wait);
+	} else {
+		flags = key_to_poll(key);
+		if (flags & (EPOLLIN | EPOLLOUT))
+			/* sk_data_ready or sk_write_space */
+			wake_up_interruptible_sync_poll(&wq->wait, flags);
+		else if (flags & EPOLLERR)
+			/* sk_error_report */
+			wake_up_interruptible_poll(&wq->wait, flags);
+	}
+}
+
+static int smc_fback_mark_woken(wait_queue_entry_t *wait,
+				unsigned int mode, int sync, void *key)
+{
+	struct smc_mark_woken *mark =
+		container_of(wait, struct smc_mark_woken, wait_entry);
+
+	mark->woken = true;
+	mark->key = key;
+	return 0;
+}
+
+static void smc_fback_forward_wakeup(struct smc_sock *smc, struct sock *clcsk,
+				     void (*clcsock_callback)(struct sock *sk))
+{
+	struct smc_mark_woken mark = { .woken = false };
+	struct socket_wq *wq;
+
+	init_waitqueue_func_entry(&mark.wait_entry,
+				  smc_fback_mark_woken);
+	rcu_read_lock();
+	wq = rcu_dereference(clcsk->sk_wq);
+	if (!wq)
+		goto out;
+	add_wait_queue(sk_sleep(clcsk), &mark.wait_entry);
+	clcsock_callback(clcsk);
+	remove_wait_queue(sk_sleep(clcsk), &mark.wait_entry);
+
+	if (mark.woken)
+		smc_fback_wakeup_waitqueue(smc, mark.key);
+out:
+	rcu_read_unlock();
+}
+
+static void smc_fback_state_change(struct sock *clcsk)
+{
+	struct smc_sock *smc =
+		smc_clcsock_user_data(clcsk);
+
+	if (!smc)
+		return;
+	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_state_change);
+}
+
+static void smc_fback_data_ready(struct sock *clcsk)
+{
+	struct smc_sock *smc =
+		smc_clcsock_user_data(clcsk);
+
+	if (!smc)
+		return;
+	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_data_ready);
+}
+
+static void smc_fback_write_space(struct sock *clcsk)
+{
+	struct smc_sock *smc =
+		smc_clcsock_user_data(clcsk);
+
+	if (!smc)
+		return;
+	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_write_space);
+}
+
+static void smc_fback_error_report(struct sock *clcsk)
+{
+	struct smc_sock *smc =
+		smc_clcsock_user_data(clcsk);
+
+	if (!smc)
+		return;
+	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_error_report);
+}
+
 static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 {
-	wait_queue_head_t *smc_wait = sk_sleep(&smc->sk);
-	wait_queue_head_t *clc_wait;
-	unsigned long flags;
+	struct sock *clcsk;
 
 	mutex_lock(&smc->clcsock_release_lock);
 	if (!smc->clcsock) {
 		mutex_unlock(&smc->clcsock_release_lock);
 		return -EBADF;
 	}
+	clcsk = smc->clcsock->sk;
+
 	smc->use_fallback = true;
 	smc->fallback_rsn = reason_code;
 	smc_stat_fallback(smc);
@@ -587,16 +685,22 @@ static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		smc->clcsock->wq.fasync_list =
 			smc->sk.sk_socket->wq.fasync_list;
 
-		/* There may be some entries remaining in
-		 * smc socket->wq, which should be removed
-		 * to clcsocket->wq during the fallback.
+		/* There might be some wait entries remaining
+		 * in smc sk->sk_wq and they should be woken up
+		 * as clcsock's wait queue is woken up.
 		 */
-		clc_wait = sk_sleep(smc->clcsock->sk);
-		spin_lock_irqsave(&smc_wait->lock, flags);
-		spin_lock_nested(&clc_wait->lock, SINGLE_DEPTH_NESTING);
-		list_splice_init(&smc_wait->head, &clc_wait->head);
-		spin_unlock(&clc_wait->lock);
-		spin_unlock_irqrestore(&smc_wait->lock, flags);
+		smc->clcsk_state_change = clcsk->sk_state_change;
+		smc->clcsk_data_ready = clcsk->sk_data_ready;
+		smc->clcsk_write_space = clcsk->sk_write_space;
+		smc->clcsk_error_report = clcsk->sk_error_report;
+
+		clcsk->sk_state_change = smc_fback_state_change;
+		clcsk->sk_data_ready = smc_fback_data_ready;
+		clcsk->sk_write_space = smc_fback_write_space;
+		clcsk->sk_error_report = smc_fback_error_report;
+
+		smc->clcsock->sk->sk_user_data =
+			(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
 	}
 	mutex_unlock(&smc->clcsock_release_lock);
 	return 0;
@@ -2115,10 +2219,9 @@ static void smc_tcp_listen_work(struct work_struct *work)
 
 static void smc_clcsock_data_ready(struct sock *listen_clcsock)
 {
-	struct smc_sock *lsmc;
+	struct smc_sock *lsmc =
+		smc_clcsock_user_data(listen_clcsock);
 
-	lsmc = (struct smc_sock *)
-	       ((uintptr_t)listen_clcsock->sk_user_data & ~SK_USER_DATA_NOCOPY);
 	if (!lsmc)
 		return;
 	lsmc->clcsk_data_ready(listen_clcsock);
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 3d0b8e300deb..37b2001a0255 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -139,6 +139,12 @@ enum smc_urg_state {
 	SMC_URG_READ	= 3,			/* data was already read */
 };
 
+struct smc_mark_woken {
+	bool woken;
+	void *key;
+	wait_queue_entry_t wait_entry;
+};
+
 struct smc_connection {
 	struct rb_node		alert_node;
 	struct smc_link_group	*lgr;		/* link group of connection */
@@ -228,8 +234,14 @@ struct smc_connection {
 struct smc_sock {				/* smc sock container */
 	struct sock		sk;
 	struct socket		*clcsock;	/* internal tcp socket */
+	void			(*clcsk_state_change)(struct sock *sk);
+						/* original stat_change fct. */
 	void			(*clcsk_data_ready)(struct sock *sk);
-						/* original data_ready fct. **/
+						/* original data_ready fct. */
+	void			(*clcsk_write_space)(struct sock *sk);
+						/* original write_space fct. */
+	void			(*clcsk_error_report)(struct sock *sk);
+						/* original error_report fct. */
 	struct smc_connection	conn;		/* smc connection */
 	struct smc_sock		*listen_smc;	/* listen parent */
 	struct work_struct	connect_work;	/* handle non-blocking connect*/
@@ -264,6 +276,12 @@ static inline struct smc_sock *smc_sk(const struct sock *sk)
 	return (struct smc_sock *)sk;
 }
 
+static inline struct smc_sock *smc_clcsock_user_data(struct sock *clcsk)
+{
+	return (struct smc_sock *)
+	       ((uintptr_t)clcsk->sk_user_data & ~SK_USER_DATA_NOCOPY);
+}
+
 extern struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
 extern struct workqueue_struct	*smc_close_wq;	/* wq for close work */
 

