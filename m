Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1316737C637
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbhELPtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234063AbhELPnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:43:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11411613DA;
        Wed, 12 May 2021 15:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832937;
        bh=QTTUFpROkm8dS7T8quIL5mVZnCVjcNUhbHG058qivy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ULZ/BFyOC4sSQIbs77GLQcADouln7UN6JfsANUtkeE+BYzVmyT/kprzamTBiizTEe
         px7fZovelx9x8dnoB1qkAk/4ZtnkA0eDOIkx67IHeTq4VUEPU+CjB/iW4+MYZ4udOz
         unuPtFm1IznQ3Nhyz/dhbi89DXsV/Em9d3hCmorU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 448/530] net/packet: make packet_fanout.arr size configurable up to 64K
Date:   Wed, 12 May 2021 16:49:18 +0200
Message-Id: <20210512144834.492970328@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

[ Upstream commit 9c661b0b85444e426d3f23250305eeb16f6ffe88 ]

One use case of PACKET_FANOUT is lockless reception with one socket
per CPU. 256 is a practical limit on increasingly many machines.

Increase PACKET_FANOUT_MAX to 64K. Expand setsockopt PACKET_FANOUT to
take an extra argument max_num_members. Also explicitly define a
fanout_args struct, instead of implicitly casting to an integer. This
documents the API and simplifies the control flow.

If max_num_members is not specified or is set to 0, then 256 is used,
same as before.

Signed-off-by: Tanner Love <tannerlove@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/if_packet.h | 12 +++++++++++
 net/packet/af_packet.c         | 37 +++++++++++++++++++++++-----------
 net/packet/internal.h          |  5 +++--
 3 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_packet.h
index 3d884d68eb30..c07caf7b40db 100644
--- a/include/uapi/linux/if_packet.h
+++ b/include/uapi/linux/if_packet.h
@@ -2,6 +2,7 @@
 #ifndef __LINUX_IF_PACKET_H
 #define __LINUX_IF_PACKET_H
 
+#include <asm/byteorder.h>
 #include <linux/types.h>
 
 struct sockaddr_pkt {
@@ -296,6 +297,17 @@ struct packet_mreq {
 	unsigned char	mr_address[8];
 };
 
+struct fanout_args {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u16		id;
+	__u16		type_flags;
+#else
+	__u16		type_flags;
+	__u16		id;
+#endif
+	__u32		max_num_members;
+};
+
 #define PACKET_MR_MULTICAST	0
 #define PACKET_MR_PROMISC	1
 #define PACKET_MR_ALLMULTI	2
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index a0121e7c98b1..92501e5f9d49 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1636,13 +1636,15 @@ static bool fanout_find_new_id(struct sock *sk, u16 *new_id)
 	return false;
 }
 
-static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
+static int fanout_add(struct sock *sk, struct fanout_args *args)
 {
 	struct packet_rollover *rollover = NULL;
 	struct packet_sock *po = pkt_sk(sk);
+	u16 type_flags = args->type_flags;
 	struct packet_fanout *f, *match;
 	u8 type = type_flags & 0xff;
 	u8 flags = type_flags >> 8;
+	u16 id = args->id;
 	int err;
 
 	switch (type) {
@@ -1700,11 +1702,21 @@ static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
 		}
 	}
 	err = -EINVAL;
-	if (match && match->flags != flags)
-		goto out;
-	if (!match) {
+	if (match) {
+		if (match->flags != flags)
+			goto out;
+		if (args->max_num_members &&
+		    args->max_num_members != match->max_num_members)
+			goto out;
+	} else {
+		if (args->max_num_members > PACKET_FANOUT_MAX)
+			goto out;
+		if (!args->max_num_members)
+			/* legacy PACKET_FANOUT_MAX */
+			args->max_num_members = 256;
 		err = -ENOMEM;
-		match = kzalloc(sizeof(*match), GFP_KERNEL);
+		match = kvzalloc(struct_size(match, arr, args->max_num_members),
+				 GFP_KERNEL);
 		if (!match)
 			goto out;
 		write_pnet(&match->net, sock_net(sk));
@@ -1720,6 +1732,7 @@ static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
 		match->prot_hook.func = packet_rcv_fanout;
 		match->prot_hook.af_packet_priv = match;
 		match->prot_hook.id_match = match_fanout_group;
+		match->max_num_members = args->max_num_members;
 		list_add(&match->list, &fanout_list);
 	}
 	err = -EINVAL;
@@ -1730,7 +1743,7 @@ static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
 	    match->prot_hook.type == po->prot_hook.type &&
 	    match->prot_hook.dev == po->prot_hook.dev) {
 		err = -ENOSPC;
-		if (refcount_read(&match->sk_ref) < PACKET_FANOUT_MAX) {
+		if (refcount_read(&match->sk_ref) < match->max_num_members) {
 			__dev_remove_pack(&po->prot_hook);
 			po->fanout = match;
 			po->rollover = rollover;
@@ -1744,7 +1757,7 @@ static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
 
 	if (err && !refcount_read(&match->sk_ref)) {
 		list_del(&match->list);
-		kfree(match);
+		kvfree(match);
 	}
 
 out:
@@ -3075,7 +3088,7 @@ static int packet_release(struct socket *sock)
 	kfree(po->rollover);
 	if (f) {
 		fanout_release_data(f);
-		kfree(f);
+		kvfree(f);
 	}
 	/*
 	 *	Now the socket is dead. No more input will appear.
@@ -3866,14 +3879,14 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 	}
 	case PACKET_FANOUT:
 	{
-		int val;
+		struct fanout_args args = { 0 };
 
-		if (optlen != sizeof(val))
+		if (optlen != sizeof(int) && optlen != sizeof(args))
 			return -EINVAL;
-		if (copy_from_sockptr(&val, optval, sizeof(val)))
+		if (copy_from_sockptr(&args, optval, optlen))
 			return -EFAULT;
 
-		return fanout_add(sk, val & 0xffff, val >> 16);
+		return fanout_add(sk, &args);
 	}
 	case PACKET_FANOUT_DATA:
 	{
diff --git a/net/packet/internal.h b/net/packet/internal.h
index fd41ecb7f605..baafc3f3fa25 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -77,11 +77,12 @@ struct packet_ring_buffer {
 };
 
 extern struct mutex fanout_mutex;
-#define PACKET_FANOUT_MAX	256
+#define PACKET_FANOUT_MAX	(1 << 16)
 
 struct packet_fanout {
 	possible_net_t		net;
 	unsigned int		num_members;
+	u32			max_num_members;
 	u16			id;
 	u8			type;
 	u8			flags;
@@ -90,10 +91,10 @@ struct packet_fanout {
 		struct bpf_prog __rcu	*bpf_prog;
 	};
 	struct list_head	list;
-	struct sock		*arr[PACKET_FANOUT_MAX];
 	spinlock_t		lock;
 	refcount_t		sk_ref;
 	struct packet_type	prot_hook ____cacheline_aligned_in_smp;
+	struct sock		*arr[];
 };
 
 struct packet_rollover {
-- 
2.30.2



