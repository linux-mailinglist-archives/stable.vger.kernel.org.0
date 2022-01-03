Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429F6483206
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiACOXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiACOXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:23:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7BCC06139B;
        Mon,  3 Jan 2022 06:23:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C1AE1CE1106;
        Mon,  3 Jan 2022 14:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991BFC36AEB;
        Mon,  3 Jan 2022 14:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219800;
        bh=kQ4guDYlrQYbAjN/bYy1uZPTCskSgH/9rloGcEcedIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6VjexzSWgZXyG2gBsjJmRi918HxQghlLm6xdAnYTTx7lbfUgNcI57dnCW3DXBwrs
         V6nguVmh4vqt0cfHQIRxbTYjxXJghrjSa6KWG37j4Itj4ZFV7iCMKLNpZNZynXeyMV
         OWS+zOgzhUAZagi1m35010QAPYEtZb5/JsktxZsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com,
        Lee Jones <lee.jones@linaro.org>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 19/19] sctp: use call_rcu to free endpoint
Date:   Mon,  3 Jan 2022 15:21:36 +0100
Message-Id: <20220103142052.693212217@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.068378906@linuxfoundation.org>
References: <20220103142052.068378906@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 5ec7d18d1813a5bead0b495045606c93873aecbb upstream.

This patch is to delay the endpoint free by calling call_rcu() to fix
another use-after-free issue in sctp_sock_dump():

  BUG: KASAN: use-after-free in __lock_acquire+0x36d9/0x4c20
  Call Trace:
    __lock_acquire+0x36d9/0x4c20 kernel/locking/lockdep.c:3218
    lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
    __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
    _raw_spin_lock_bh+0x31/0x40 kernel/locking/spinlock.c:168
    spin_lock_bh include/linux/spinlock.h:334 [inline]
    __lock_sock+0x203/0x350 net/core/sock.c:2253
    lock_sock_nested+0xfe/0x120 net/core/sock.c:2774
    lock_sock include/net/sock.h:1492 [inline]
    sctp_sock_dump+0x122/0xb20 net/sctp/diag.c:324
    sctp_for_each_transport+0x2b5/0x370 net/sctp/socket.c:5091
    sctp_diag_dump+0x3ac/0x660 net/sctp/diag.c:527
    __inet_diag_dump+0xa8/0x140 net/ipv4/inet_diag.c:1049
    inet_diag_dump+0x9b/0x110 net/ipv4/inet_diag.c:1065
    netlink_dump+0x606/0x1080 net/netlink/af_netlink.c:2244
    __netlink_dump_start+0x59a/0x7c0 net/netlink/af_netlink.c:2352
    netlink_dump_start include/linux/netlink.h:216 [inline]
    inet_diag_handler_cmd+0x2ce/0x3f0 net/ipv4/inet_diag.c:1170
    __sock_diag_cmd net/core/sock_diag.c:232 [inline]
    sock_diag_rcv_msg+0x31d/0x410 net/core/sock_diag.c:263
    netlink_rcv_skb+0x172/0x440 net/netlink/af_netlink.c:2477
    sock_diag_rcv+0x2a/0x40 net/core/sock_diag.c:274

This issue occurs when asoc is peeled off and the old sk is freed after
getting it by asoc->base.sk and before calling lock_sock(sk).

To prevent the sk free, as a holder of the sk, ep should be alive when
calling lock_sock(). This patch uses call_rcu() and moves sock_put and
ep free into sctp_endpoint_destroy_rcu(), so that it's safe to try to
hold the ep under rcu_read_lock in sctp_transport_traverse_process().

If sctp_endpoint_hold() returns true, it means this ep is still alive
and we have held it and can continue to dump it; If it returns false,
it means this ep is dead and can be freed after rcu_read_unlock, and
we should skip it.

In sctp_sock_dump(), after locking the sk, if this ep is different from
tsp->asoc->ep, it means during this dumping, this asoc was peeled off
before calling lock_sock(), and the sk should be skipped; If this ep is
the same with tsp->asoc->ep, it means no peeloff happens on this asoc,
and due to lock_sock, no peeloff will happen either until release_sock.

Note that delaying endpoint free won't delay the port release, as the
port release happens in sctp_endpoint_destroy() before calling call_rcu().
Also, freeing endpoint by call_rcu() makes it safe to access the sk by
asoc->base.sk in sctp_assocs_seq_show() and sctp_rcv().

Thanks Jones to bring this issue up.

v1->v2:
  - improve the changelog.
  - add kfree(ep) into sctp_endpoint_destroy_rcu(), as Jakub noticed.

Reported-by: syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com
Reported-by: Lee Jones <lee.jones@linaro.org>
Fixes: d25adbeb0cdb ("sctp: fix an use-after-free issue in sctp_sock_dump")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sctp/sctp.h    |    6 +++---
 include/net/sctp/structs.h |    3 ++-
 net/sctp/endpointola.c     |   23 +++++++++++++++--------
 net/sctp/sctp_diag.c       |   12 ++++++------
 net/sctp/socket.c          |   23 +++++++++++++++--------
 5 files changed, 41 insertions(+), 26 deletions(-)

--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -118,6 +118,7 @@ extern struct percpu_counter sctp_socket
 int sctp_asconf_mgmt(struct sctp_sock *, struct sctp_sockaddr_entry *);
 struct sk_buff *sctp_skb_recv_datagram(struct sock *, int, int, int *);
 
+typedef int (*sctp_callback_t)(struct sctp_endpoint *, struct sctp_transport *, void *);
 int sctp_transport_walk_start(struct rhashtable_iter *iter);
 void sctp_transport_walk_stop(struct rhashtable_iter *iter);
 struct sctp_transport *sctp_transport_get_next(struct net *net,
@@ -128,9 +129,8 @@ int sctp_transport_lookup_process(int (*
 				  struct net *net,
 				  const union sctp_addr *laddr,
 				  const union sctp_addr *paddr, void *p);
-int sctp_for_each_transport(int (*cb)(struct sctp_transport *, void *),
-			    int (*cb_done)(struct sctp_transport *, void *),
-			    struct net *net, int *pos, void *p);
+int sctp_transport_traverse_process(sctp_callback_t cb, sctp_callback_t cb_done,
+				    struct net *net, int *pos, void *p);
 int sctp_for_each_endpoint(int (*cb)(struct sctp_endpoint *, void *), void *p);
 int sctp_get_sctp_info(struct sock *sk, struct sctp_association *asoc,
 		       struct sctp_info *info);
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1272,6 +1272,7 @@ struct sctp_endpoint {
 	      reconf_enable:1;
 
 	__u8  strreset_enable;
+	struct rcu_head rcu;
 };
 
 /* Recover the outter endpoint structure. */
@@ -1287,7 +1288,7 @@ static inline struct sctp_endpoint *sctp
 struct sctp_endpoint *sctp_endpoint_new(struct sock *, gfp_t);
 void sctp_endpoint_free(struct sctp_endpoint *);
 void sctp_endpoint_put(struct sctp_endpoint *);
-void sctp_endpoint_hold(struct sctp_endpoint *);
+int sctp_endpoint_hold(struct sctp_endpoint *ep);
 void sctp_endpoint_add_asoc(struct sctp_endpoint *, struct sctp_association *);
 struct sctp_association *sctp_endpoint_lookup_assoc(
 	const struct sctp_endpoint *ep,
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -242,6 +242,18 @@ void sctp_endpoint_free(struct sctp_endp
 }
 
 /* Final destructor for endpoint.  */
+static void sctp_endpoint_destroy_rcu(struct rcu_head *head)
+{
+	struct sctp_endpoint *ep = container_of(head, struct sctp_endpoint, rcu);
+	struct sock *sk = ep->base.sk;
+
+	sctp_sk(sk)->ep = NULL;
+	sock_put(sk);
+
+	kfree(ep);
+	SCTP_DBG_OBJCNT_DEC(ep);
+}
+
 static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
 {
 	struct sock *sk;
@@ -275,18 +287,13 @@ static void sctp_endpoint_destroy(struct
 	if (sctp_sk(sk)->bind_hash)
 		sctp_put_port(sk);
 
-	sctp_sk(sk)->ep = NULL;
-	/* Give up our hold on the sock */
-	sock_put(sk);
-
-	kfree(ep);
-	SCTP_DBG_OBJCNT_DEC(ep);
+	call_rcu(&ep->rcu, sctp_endpoint_destroy_rcu);
 }
 
 /* Hold a reference to an endpoint. */
-void sctp_endpoint_hold(struct sctp_endpoint *ep)
+int sctp_endpoint_hold(struct sctp_endpoint *ep)
 {
-	refcount_inc(&ep->base.refcnt);
+	return refcount_inc_not_zero(&ep->base.refcnt);
 }
 
 /* Release a reference to an endpoint and clean up if there are
--- a/net/sctp/sctp_diag.c
+++ b/net/sctp/sctp_diag.c
@@ -276,9 +276,8 @@ out:
 	return err;
 }
 
-static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
+static int sctp_sock_dump(struct sctp_endpoint *ep, struct sctp_transport *tsp, void *p)
 {
-	struct sctp_endpoint *ep = tsp->asoc->ep;
 	struct sctp_comm_param *commp = p;
 	struct sock *sk = ep->base.sk;
 	struct sk_buff *skb = commp->skb;
@@ -288,6 +287,8 @@ static int sctp_sock_dump(struct sctp_tr
 	int err = 0;
 
 	lock_sock(sk);
+	if (ep != tsp->asoc->ep)
+		goto release;
 	list_for_each_entry(assoc, &ep->asocs, asocs) {
 		if (cb->args[4] < cb->args[1])
 			goto next;
@@ -330,9 +331,8 @@ release:
 	return err;
 }
 
-static int sctp_sock_filter(struct sctp_transport *tsp, void *p)
+static int sctp_sock_filter(struct sctp_endpoint *ep, struct sctp_transport *tsp, void *p)
 {
-	struct sctp_endpoint *ep = tsp->asoc->ep;
 	struct sctp_comm_param *commp = p;
 	struct sock *sk = ep->base.sk;
 	const struct inet_diag_req_v2 *r = commp->r;
@@ -490,8 +490,8 @@ skip:
 	if (!(idiag_states & ~(TCPF_LISTEN | TCPF_CLOSE)))
 		goto done;
 
-	sctp_for_each_transport(sctp_sock_filter, sctp_sock_dump,
-				net, &pos, &commp);
+	sctp_transport_traverse_process(sctp_sock_filter, sctp_sock_dump,
+					net, &pos, &commp);
 	cb->args[2] = pos;
 
 done:
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4738,11 +4738,12 @@ int sctp_transport_lookup_process(int (*
 }
 EXPORT_SYMBOL_GPL(sctp_transport_lookup_process);
 
-int sctp_for_each_transport(int (*cb)(struct sctp_transport *, void *),
-			    int (*cb_done)(struct sctp_transport *, void *),
-			    struct net *net, int *pos, void *p) {
+int sctp_transport_traverse_process(sctp_callback_t cb, sctp_callback_t cb_done,
+				    struct net *net, int *pos, void *p)
+{
 	struct rhashtable_iter hti;
 	struct sctp_transport *tsp;
+	struct sctp_endpoint *ep;
 	int ret;
 
 again:
@@ -4752,26 +4753,32 @@ again:
 
 	tsp = sctp_transport_get_idx(net, &hti, *pos + 1);
 	for (; !IS_ERR_OR_NULL(tsp); tsp = sctp_transport_get_next(net, &hti)) {
-		ret = cb(tsp, p);
-		if (ret)
-			break;
+		ep = tsp->asoc->ep;
+		if (sctp_endpoint_hold(ep)) { /* asoc can be peeled off */
+			ret = cb(ep, tsp, p);
+			if (ret)
+				break;
+			sctp_endpoint_put(ep);
+		}
 		(*pos)++;
 		sctp_transport_put(tsp);
 	}
 	sctp_transport_walk_stop(&hti);
 
 	if (ret) {
-		if (cb_done && !cb_done(tsp, p)) {
+		if (cb_done && !cb_done(ep, tsp, p)) {
 			(*pos)++;
+			sctp_endpoint_put(ep);
 			sctp_transport_put(tsp);
 			goto again;
 		}
+		sctp_endpoint_put(ep);
 		sctp_transport_put(tsp);
 	}
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sctp_for_each_transport);
+EXPORT_SYMBOL_GPL(sctp_transport_traverse_process);
 
 /* 7.2.1 Association Status (SCTP_STATUS)
 


