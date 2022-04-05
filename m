Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9584F4F2564
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiDEHth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbiDEHpp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:45:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7850798583;
        Tue,  5 Apr 2022 00:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27038B81B14;
        Tue,  5 Apr 2022 07:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AD7C340EE;
        Tue,  5 Apr 2022 07:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144487;
        bh=meluS99HA5DD5fXgZELnG9CkrcTjeQOpPRk3nRfkcqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AP5aflc+T/4VmfDlMMHZFnJS2czIbAO/2LAkZw3hivjMKFtlCx92VpGZ72D9KmJZ/
         c+73T73lllSgeYKViPCfX6gaxBSg3sJ6lg11+Xky9oWZn6N1jB9jAhCLULkPHWCA3h
         xoe6/Czuns8joBPOSbJzwRMCpvNQOUdoAlF8b5wM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.17 0055/1126] SUNRPC: Do not dereference non-socket transports in sysfs
Date:   Tue,  5 Apr 2022 09:13:22 +0200
Message-Id: <20220405070409.182334839@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 421ab1be43bd015ffe744f4ea25df4f19d1ce6fe upstream.

Do not cast the struct xprt to a sock_xprt unless we know it is a UDP or
TCP transport. Otherwise the call to lock the mutex will scribble over
whatever structure is actually there. This has been seen to cause hard
system lockups when the underlying transport was RDMA.

Fixes: b49ea673e119 ("SUNRPC: lock against ->sock changing during sysfs read")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/xprt.h     |    3 ++
 include/linux/sunrpc/xprtsock.h |    1 
 net/sunrpc/sysfs.c              |   55 +++++++++++++++++++---------------------
 net/sunrpc/xprtsock.c           |   26 +++++++++++++++++-
 4 files changed, 54 insertions(+), 31 deletions(-)

--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -139,6 +139,9 @@ struct rpc_xprt_ops {
 	void		(*rpcbind)(struct rpc_task *task);
 	void		(*set_port)(struct rpc_xprt *xprt, unsigned short port);
 	void		(*connect)(struct rpc_xprt *xprt, struct rpc_task *task);
+	int		(*get_srcaddr)(struct rpc_xprt *xprt, char *buf,
+				       size_t buflen);
+	unsigned short	(*get_srcport)(struct rpc_xprt *xprt);
 	int		(*buf_alloc)(struct rpc_task *task);
 	void		(*buf_free)(struct rpc_task *task);
 	void		(*prepare_request)(struct rpc_rqst *req);
--- a/include/linux/sunrpc/xprtsock.h
+++ b/include/linux/sunrpc/xprtsock.h
@@ -10,7 +10,6 @@
 
 int		init_socket_xprt(void);
 void		cleanup_socket_xprt(void);
-unsigned short	get_srcport(struct rpc_xprt *);
 
 #define RPC_MIN_RESVPORT	(1U)
 #define RPC_MAX_RESVPORT	(65535U)
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -97,7 +97,7 @@ static ssize_t rpc_sysfs_xprt_dstaddr_sh
 		return 0;
 	ret = sprintf(buf, "%s\n", xprt->address_strings[RPC_DISPLAY_ADDR]);
 	xprt_put(xprt);
-	return ret + 1;
+	return ret;
 }
 
 static ssize_t rpc_sysfs_xprt_srcaddr_show(struct kobject *kobj,
@@ -105,33 +105,31 @@ static ssize_t rpc_sysfs_xprt_srcaddr_sh
 					   char *buf)
 {
 	struct rpc_xprt *xprt = rpc_sysfs_xprt_kobj_get_xprt(kobj);
-	struct sockaddr_storage saddr;
-	struct sock_xprt *sock;
-	ssize_t ret = -1;
+	size_t buflen = PAGE_SIZE;
+	ssize_t ret = -ENOTSOCK;
 
 	if (!xprt || !xprt_connected(xprt)) {
-		xprt_put(xprt);
-		return -ENOTCONN;
+		ret = -ENOTCONN;
+	} else if (xprt->ops->get_srcaddr) {
+		ret = xprt->ops->get_srcaddr(xprt, buf, buflen);
+		if (ret > 0) {
+			if (ret < buflen - 1) {
+				buf[ret] = '\n';
+				ret++;
+				buf[ret] = '\0';
+			}
+		}
 	}
-
-	sock = container_of(xprt, struct sock_xprt, xprt);
-	mutex_lock(&sock->recv_mutex);
-	if (sock->sock == NULL ||
-	    kernel_getsockname(sock->sock, (struct sockaddr *)&saddr) < 0)
-		goto out;
-
-	ret = sprintf(buf, "%pISc\n", &saddr);
-out:
-	mutex_unlock(&sock->recv_mutex);
 	xprt_put(xprt);
-	return ret + 1;
+	return ret;
 }
 
 static ssize_t rpc_sysfs_xprt_info_show(struct kobject *kobj,
-					struct kobj_attribute *attr,
-					char *buf)
+					struct kobj_attribute *attr, char *buf)
 {
 	struct rpc_xprt *xprt = rpc_sysfs_xprt_kobj_get_xprt(kobj);
+	unsigned short srcport = 0;
+	size_t buflen = PAGE_SIZE;
 	ssize_t ret;
 
 	if (!xprt || !xprt_connected(xprt)) {
@@ -139,7 +137,11 @@ static ssize_t rpc_sysfs_xprt_info_show(
 		return -ENOTCONN;
 	}
 
-	ret = sprintf(buf, "last_used=%lu\ncur_cong=%lu\ncong_win=%lu\n"
+	if (xprt->ops->get_srcport)
+		srcport = xprt->ops->get_srcport(xprt);
+
+	ret = snprintf(buf, buflen,
+		       "last_used=%lu\ncur_cong=%lu\ncong_win=%lu\n"
 		       "max_num_slots=%u\nmin_num_slots=%u\nnum_reqs=%u\n"
 		       "binding_q_len=%u\nsending_q_len=%u\npending_q_len=%u\n"
 		       "backlog_q_len=%u\nmain_xprt=%d\nsrc_port=%u\n"
@@ -147,14 +149,11 @@ static ssize_t rpc_sysfs_xprt_info_show(
 		       xprt->last_used, xprt->cong, xprt->cwnd, xprt->max_reqs,
 		       xprt->min_reqs, xprt->num_reqs, xprt->binding.qlen,
 		       xprt->sending.qlen, xprt->pending.qlen,
-		       xprt->backlog.qlen, xprt->main,
-		       (xprt->xprt_class->ident == XPRT_TRANSPORT_TCP) ?
-		       get_srcport(xprt) : 0,
+		       xprt->backlog.qlen, xprt->main, srcport,
 		       atomic_long_read(&xprt->queuelen),
-		       (xprt->xprt_class->ident == XPRT_TRANSPORT_TCP) ?
-				xprt->address_strings[RPC_DISPLAY_PORT] : "0");
+		       xprt->address_strings[RPC_DISPLAY_PORT]);
 	xprt_put(xprt);
-	return ret + 1;
+	return ret;
 }
 
 static ssize_t rpc_sysfs_xprt_state_show(struct kobject *kobj,
@@ -201,7 +200,7 @@ static ssize_t rpc_sysfs_xprt_state_show
 	}
 
 	xprt_put(xprt);
-	return ret + 1;
+	return ret;
 }
 
 static ssize_t rpc_sysfs_xprt_switch_info_show(struct kobject *kobj,
@@ -220,7 +219,7 @@ static ssize_t rpc_sysfs_xprt_switch_inf
 		      xprt_switch->xps_nunique_destaddr_xprts,
 		      atomic_long_read(&xprt_switch->xps_queuelen));
 	xprt_switch_put(xprt_switch);
-	return ret + 1;
+	return ret;
 }
 
 static ssize_t rpc_sysfs_xprt_dstaddr_store(struct kobject *kobj,
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1638,7 +1638,7 @@ static int xs_get_srcport(struct sock_xp
 	return port;
 }
 
-unsigned short get_srcport(struct rpc_xprt *xprt)
+static unsigned short xs_sock_srcport(struct rpc_xprt *xprt)
 {
 	struct sock_xprt *sock = container_of(xprt, struct sock_xprt, xprt);
 	unsigned short ret = 0;
@@ -1648,7 +1648,25 @@ unsigned short get_srcport(struct rpc_xp
 	mutex_unlock(&sock->recv_mutex);
 	return ret;
 }
-EXPORT_SYMBOL(get_srcport);
+
+static int xs_sock_srcaddr(struct rpc_xprt *xprt, char *buf, size_t buflen)
+{
+	struct sock_xprt *sock = container_of(xprt, struct sock_xprt, xprt);
+	union {
+		struct sockaddr sa;
+		struct sockaddr_storage st;
+	} saddr;
+	int ret = -ENOTCONN;
+
+	mutex_lock(&sock->recv_mutex);
+	if (sock->sock) {
+		ret = kernel_getsockname(sock->sock, &saddr.sa);
+		if (ret >= 0)
+			ret = snprintf(buf, buflen, "%pISc", &saddr.sa);
+	}
+	mutex_unlock(&sock->recv_mutex);
+	return ret;
+}
 
 static unsigned short xs_next_srcport(struct sock_xprt *transport, unsigned short port)
 {
@@ -2621,6 +2639,8 @@ static const struct rpc_xprt_ops xs_udp_
 	.rpcbind		= rpcb_getport_async,
 	.set_port		= xs_set_port,
 	.connect		= xs_connect,
+	.get_srcaddr		= xs_sock_srcaddr,
+	.get_srcport		= xs_sock_srcport,
 	.buf_alloc		= rpc_malloc,
 	.buf_free		= rpc_free,
 	.send_request		= xs_udp_send_request,
@@ -2643,6 +2663,8 @@ static const struct rpc_xprt_ops xs_tcp_
 	.rpcbind		= rpcb_getport_async,
 	.set_port		= xs_set_port,
 	.connect		= xs_connect,
+	.get_srcaddr		= xs_sock_srcaddr,
+	.get_srcport		= xs_sock_srcport,
 	.buf_alloc		= rpc_malloc,
 	.buf_free		= rpc_free,
 	.prepare_request	= xs_stream_prepare_request,


