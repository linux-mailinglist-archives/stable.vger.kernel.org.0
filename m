Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4A1627EED
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbiKNMx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237467AbiKNMxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:53:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA26425C67
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:53:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E0B6B80EAF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F041C433D6;
        Mon, 14 Nov 2022 12:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430400;
        bh=zo7cvXcdRTKH39Gs25RA0xplRxxLqljzSWS2LiKnLaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7UTU1M3IT0TbjV2YGh53IIZkiC33qQJRvUvAvFA8rG4nd8zjEZfvdSmxsq5fLHO8
         Ghn5cG83+3IKom8cP2JgNvM3mGV09ZnvINfryveSAeUHkn3SzXCDEkUWq7hDD8xQaf
         7MWEOM/mMdSXqzme9qTcx24wzvgEpq1lbDDuCQ5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/131] bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues
Date:   Mon, 14 Nov 2022 13:44:47 +0100
Message-Id: <20221114124449.496241810@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit d8616ee2affcff37c5d315310da557a694a3303d ]

During TCP sockmap redirect pressure test, the following warning is triggered:

WARNING: CPU: 3 PID: 2145 at net/core/stream.c:205 sk_stream_kill_queues+0xbc/0xd0
CPU: 3 PID: 2145 Comm: iperf Kdump: loaded Tainted: G        W         5.10.0+ #9
Call Trace:
 inet_csk_destroy_sock+0x55/0x110
 inet_csk_listen_stop+0xbb/0x380
 tcp_close+0x41b/0x480
 inet_release+0x42/0x80
 __sock_release+0x3d/0xa0
 sock_close+0x11/0x20
 __fput+0x9d/0x240
 task_work_run+0x62/0x90
 exit_to_user_mode_prepare+0x110/0x120
 syscall_exit_to_user_mode+0x27/0x190
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The reason we observed is that:

When the listener is closing, a connection may have completed the three-way
handshake but not accepted, and the client has sent some packets. The child
sks in accept queue release by inet_child_forget()->inet_csk_destroy_sock(),
but psocks of child sks have not released.

To fix, add sock_map_destroy to release psocks.

Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20220524075311.649153-1-wangyufen@huawei.com
Stable-dep-of: 8bbabb3fddcd ("bpf, sock_map: Move cancel_work_sync() out of sock lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h   |  1 +
 include/linux/skmsg.h |  1 +
 net/core/skmsg.c      |  1 +
 net/core/sock_map.c   | 23 +++++++++++++++++++++++
 net/ipv4/tcp_bpf.c    |  1 +
 5 files changed, 27 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 818cd594e922..84efd8dd139d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2022,6 +2022,7 @@ int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog);
 int sock_map_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype);
 int sock_map_update_elem_sys(struct bpf_map *map, void *key, void *value, u64 flags);
 void sock_map_unhash(struct sock *sk);
+void sock_map_destroy(struct sock *sk);
 void sock_map_close(struct sock *sk, long timeout);
 #else
 static inline int bpf_prog_offload_init(struct bpf_prog *prog,
diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 0c742cdf413c..ee7c67d8442d 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -96,6 +96,7 @@ struct sk_psock {
 	spinlock_t			link_lock;
 	refcount_t			refcnt;
 	void (*saved_unhash)(struct sock *sk);
+	void (*saved_destroy)(struct sock *sk);
 	void (*saved_close)(struct sock *sk, long timeout);
 	void (*saved_write_space)(struct sock *sk);
 	void (*saved_data_ready)(struct sock *sk);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 736d8b035a67..680f51f8974a 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -720,6 +720,7 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 	psock->eval = __SK_NONE;
 	psock->sk_proto = prot;
 	psock->saved_unhash = prot->unhash;
+	psock->saved_destroy = prot->destroy;
 	psock->saved_close = prot->close;
 	psock->saved_write_space = sk->sk_write_space;
 
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 795b3acfb9fd..43563d651ed0 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1524,6 +1524,29 @@ void sock_map_unhash(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(sock_map_unhash);
 
+void sock_map_destroy(struct sock *sk)
+{
+	void (*saved_destroy)(struct sock *sk);
+	struct sk_psock *psock;
+
+	rcu_read_lock();
+	psock = sk_psock_get(sk);
+	if (unlikely(!psock)) {
+		rcu_read_unlock();
+		if (sk->sk_prot->destroy)
+			sk->sk_prot->destroy(sk);
+		return;
+	}
+
+	saved_destroy = psock->saved_destroy;
+	sock_map_remove_links(sk, psock);
+	rcu_read_unlock();
+	sk_psock_stop(psock, true);
+	sk_psock_put(sk, psock);
+	saved_destroy(sk);
+}
+EXPORT_SYMBOL_GPL(sock_map_destroy);
+
 void sock_map_close(struct sock *sk, long timeout)
 {
 	void (*saved_close)(struct sock *sk, long timeout);
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 72892ebe9607..5194c6870273 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -543,6 +543,7 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 				   struct proto *base)
 {
 	prot[TCP_BPF_BASE]			= *base;
+	prot[TCP_BPF_BASE].destroy		= sock_map_destroy;
 	prot[TCP_BPF_BASE].close		= sock_map_close;
 	prot[TCP_BPF_BASE].recvmsg		= tcp_bpf_recvmsg;
 	prot[TCP_BPF_BASE].sock_is_readable	= sk_msg_is_readable;
-- 
2.35.1



