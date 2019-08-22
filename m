Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEBAF99A1B
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389029AbfHVRKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390771AbfHVRJ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:26 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BD3A23404;
        Thu, 22 Aug 2019 17:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493765;
        bh=OISerNNq/KSKZ9zgFyCo2BfYz3vhlAIwrCf0lE8plNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xL1cZVhsCaoxock0zJCpgJENHNMd5xtN1rgKz17CyySqO1tAAaGhYWAIveB0Xn+QW
         pcQcOoVxxW8jNNET/7H1s5lhRbZPAf/mmSCNFsTOg+H/TW9fm2Tfoze1DZ++ka41tu
         Mq3CkiahfvWC4GbthQNcabCvi1XJvjydmEkVwjpM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Willem de Bruijn <willemb@google.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 132/135] net/tls: prevent skb_orphan() from leaking TLS plain text with offload
Date:   Thu, 22 Aug 2019 13:08:08 -0400
Message-Id: <20190822170811.13303-133-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 414776621d1006e57e80e6db7fdc3837897aaa64 ]

sk_validate_xmit_skb() and drivers depend on the sk member of
struct sk_buff to identify segments requiring encryption.
Any operation which removes or does not preserve the original TLS
socket such as skb_orphan() or skb_clone() will cause clear text
leaks.

Make the TCP socket underlying an offloaded TLS connection
mark all skbs as decrypted, if TLS TX is in offload mode.
Then in sk_validate_xmit_skb() catch skbs which have no socket
(or a socket with no validation) and decrypted flag set.

Note that CONFIG_SOCK_VALIDATE_XMIT, CONFIG_TLS_DEVICE and
sk->sk_validate_xmit_skb are slightly interchangeable right now,
they all imply TLS offload. The new checks are guarded by
CONFIG_TLS_DEVICE because that's the option guarding the
sk_buff->decrypted member.

Second, smaller issue with orphaning is that it breaks
the guarantee that packets will be delivered to device
queues in-order. All TLS offload drivers depend on that
scheduling property. This means skb_orphan_partial()'s
trick of preserving partial socket references will cause
issues in the drivers. We need a full orphan, and as a
result netem delay/throttling will cause all TLS offload
skbs to be dropped.

Reusing the sk_buff->decrypted flag also protects from
leaking clear text when incoming, decrypted skb is redirected
(e.g. by TC).

See commit 0608c69c9a80 ("bpf: sk_msg, sock{map|hash} redirect
through ULP") for justification why the internal flag is safe.
The only location which could leak the flag in is tcp_bpf_sendmsg(),
which is taken care of by clearing the previously unused bit.

v2:
 - remove superfluous decrypted mark copy (Willem);
 - remove the stale doc entry (Boris);
 - rely entirely on EOR marking to prevent coalescing (Boris);
 - use an internal sendpages flag instead of marking the socket
   (Boris).
v3 (Willem):
 - reorganize the can_skb_orphan_partial() condition;
 - fix the flag leak-in through tcp_bpf_sendmsg.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/tls-offload.rst | 18 ------------------
 include/linux/skbuff.h                   |  8 ++++++++
 include/linux/socket.h                   |  3 +++
 include/net/sock.h                       | 10 +++++++++-
 net/core/sock.c                          | 19 ++++++++++++++-----
 net/ipv4/tcp.c                           |  3 +++
 net/ipv4/tcp_bpf.c                       |  6 +++++-
 net/ipv4/tcp_output.c                    |  3 +++
 net/tls/tls_device.c                     |  9 +++++++--
 9 files changed, 52 insertions(+), 27 deletions(-)

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index cb85af559dff1..178f4104f5cf2 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -445,24 +445,6 @@ These flags will be acted upon accordingly by the core ``ktls`` code.
 TLS device feature flags only control adding of new TLS connection
 offloads, old connections will remain active after flags are cleared.
 
-Known bugs
-==========
-
-skb_orphan() leaks clear text
------------------------------
-
-Currently drivers depend on the :c:member:`sk` member of
-:c:type:`struct sk_buff <sk_buff>` to identify segments requiring
-encryption. Any operation which removes or does not preserve the socket
-association such as :c:func:`skb_orphan` or :c:func:`skb_clone`
-will cause the driver to miss the packets and lead to clear text leaks.
-
-Redirects leak clear text
--------------------------
-
-In the RX direction, if segment has already been decrypted by the device
-and it gets redirected or mirrored - clear text will be transmitted out.
-
 .. _pre_tls_data:
 
 Transmission of pre-TLS data
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 056f557d5194e..64fa59b2c8d5a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1358,6 +1358,14 @@ static inline void skb_copy_hash(struct sk_buff *to, const struct sk_buff *from)
 	to->l4_hash = from->l4_hash;
 };
 
+static inline void skb_copy_decrypted(struct sk_buff *to,
+				      const struct sk_buff *from)
+{
+#ifdef CONFIG_TLS_DEVICE
+	to->decrypted = from->decrypted;
+#endif
+}
+
 #ifdef NET_SKBUFF_DATA_USES_OFFSET
 static inline unsigned char *skb_end_pointer(const struct sk_buff *skb)
 {
diff --git a/include/linux/socket.h b/include/linux/socket.h
index b57cd8bf96e2b..810d5ec0ada32 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -291,6 +291,9 @@ struct ucred {
 #define MSG_BATCH	0x40000 /* sendmmsg(): more messages coming */
 #define MSG_EOF         MSG_FIN
 #define MSG_NO_SHARED_FRAGS 0x80000 /* sendpage() internal : page frags are not shared */
+#define MSG_SENDPAGE_DECRYPTED	0x100000 /* sendpage() internal : page may carry
+					  * plain text and require encryption
+					  */
 
 #define MSG_ZEROCOPY	0x4000000	/* Use user data in kernel path */
 #define MSG_FASTOPEN	0x20000000	/* Send data in TCP SYN */
diff --git a/include/net/sock.h b/include/net/sock.h
index 6cbc16136357d..526de911cd91d 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2482,6 +2482,7 @@ static inline bool sk_fullsock(const struct sock *sk)
 
 /* Checks if this SKB belongs to an HW offloaded socket
  * and whether any SW fallbacks are required based on dev.
+ * Check decrypted mark in case skb_orphan() cleared socket.
  */
 static inline struct sk_buff *sk_validate_xmit_skb(struct sk_buff *skb,
 						   struct net_device *dev)
@@ -2489,8 +2490,15 @@ static inline struct sk_buff *sk_validate_xmit_skb(struct sk_buff *skb,
 #ifdef CONFIG_SOCK_VALIDATE_XMIT
 	struct sock *sk = skb->sk;
 
-	if (sk && sk_fullsock(sk) && sk->sk_validate_xmit_skb)
+	if (sk && sk_fullsock(sk) && sk->sk_validate_xmit_skb) {
 		skb = sk->sk_validate_xmit_skb(sk, dev, skb);
+#ifdef CONFIG_TLS_DEVICE
+	} else if (unlikely(skb->decrypted)) {
+		pr_warn_ratelimited("unencrypted skb with no associated socket - dropping\n");
+		kfree_skb(skb);
+		skb = NULL;
+#endif
+	}
 #endif
 
 	return skb;
diff --git a/net/core/sock.c b/net/core/sock.c
index aa4a00d381e38..df7b38b60164f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1988,6 +1988,19 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
 }
 EXPORT_SYMBOL(skb_set_owner_w);
 
+static bool can_skb_orphan_partial(const struct sk_buff *skb)
+{
+#ifdef CONFIG_TLS_DEVICE
+	/* Drivers depend on in-order delivery for crypto offload,
+	 * partial orphan breaks out-of-order-OK logic.
+	 */
+	if (skb->decrypted)
+		return false;
+#endif
+	return (skb->destructor == sock_wfree ||
+		(IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree));
+}
+
 /* This helper is used by netem, as it can hold packets in its
  * delay queue. We want to allow the owner socket to send more
  * packets, as if they were already TX completed by a typical driver.
@@ -1999,11 +2012,7 @@ void skb_orphan_partial(struct sk_buff *skb)
 	if (skb_is_tcp_pure_ack(skb))
 		return;
 
-	if (skb->destructor == sock_wfree
-#ifdef CONFIG_INET
-	    || skb->destructor == tcp_wfree
-#endif
-		) {
+	if (can_skb_orphan_partial(skb)) {
 		struct sock *sk = skb->sk;
 
 		if (refcount_inc_not_zero(&sk->sk_refcnt)) {
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5264f064a87e3..b30f7f8771817 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -984,6 +984,9 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 			if (!skb)
 				goto wait_for_memory;
 
+#ifdef CONFIG_TLS_DEVICE
+			skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
+#endif
 			skb_entail(sk, skb);
 			copy = size_goal;
 		}
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 3d1e154013844..8a56e09cfb0ed 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -398,10 +398,14 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 {
 	struct sk_msg tmp, *msg_tx = NULL;
-	int flags = msg->msg_flags | MSG_NO_SHARED_FRAGS;
 	int copied = 0, err = 0;
 	struct sk_psock *psock;
 	long timeo;
+	int flags;
+
+	/* Don't let internal do_tcp_sendpages() flags through */
+	flags = (msg->msg_flags & ~MSG_SENDPAGE_DECRYPTED);
+	flags |= MSG_NO_SHARED_FRAGS;
 
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 7d0be046cbc13..359d298348c72 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1318,6 +1318,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	buff = sk_stream_alloc_skb(sk, nsize, gfp, true);
 	if (!buff)
 		return -ENOMEM; /* We'll just try again later. */
+	skb_copy_decrypted(buff, skb);
 
 	sk->sk_wmem_queued += buff->truesize;
 	sk_mem_charge(sk, buff->truesize);
@@ -1872,6 +1873,7 @@ static int tso_fragment(struct sock *sk, struct sk_buff *skb, unsigned int len,
 	buff = sk_stream_alloc_skb(sk, 0, gfp, true);
 	if (unlikely(!buff))
 		return -ENOMEM;
+	skb_copy_decrypted(buff, skb);
 
 	sk->sk_wmem_queued += buff->truesize;
 	sk_mem_charge(sk, buff->truesize);
@@ -2141,6 +2143,7 @@ static int tcp_mtu_probe(struct sock *sk)
 	sk_mem_charge(sk, nskb->truesize);
 
 	skb = tcp_send_head(sk);
+	skb_copy_decrypted(nskb, skb);
 
 	TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(skb)->seq;
 	TCP_SKB_CB(nskb)->end_seq = TCP_SKB_CB(skb)->seq + probe_size;
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index eb8f24f420f0f..4cfcce211c2f1 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -342,9 +342,9 @@ static int tls_push_data(struct sock *sk,
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct tls_offload_context_tx *ctx = tls_offload_ctx_tx(tls_ctx);
-	int tls_push_record_flags = flags | MSG_SENDPAGE_NOTLAST;
 	int more = flags & (MSG_SENDPAGE_NOTLAST | MSG_MORE);
 	struct tls_record_info *record = ctx->open_record;
+	int tls_push_record_flags;
 	struct page_frag *pfrag;
 	size_t orig_size = size;
 	u32 max_open_record_len;
@@ -359,6 +359,9 @@ static int tls_push_data(struct sock *sk,
 	if (sk->sk_err)
 		return -sk->sk_err;
 
+	flags |= MSG_SENDPAGE_DECRYPTED;
+	tls_push_record_flags = flags | MSG_SENDPAGE_NOTLAST;
+
 	timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
 	if (tls_is_partially_sent_record(tls_ctx)) {
 		rc = tls_push_partial_record(sk, tls_ctx, flags);
@@ -545,7 +548,9 @@ void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
 		gfp_t sk_allocation = sk->sk_allocation;
 
 		sk->sk_allocation = GFP_ATOMIC;
-		tls_push_partial_record(sk, ctx, MSG_DONTWAIT | MSG_NOSIGNAL);
+		tls_push_partial_record(sk, ctx,
+					MSG_DONTWAIT | MSG_NOSIGNAL |
+					MSG_SENDPAGE_DECRYPTED);
 		sk->sk_allocation = sk_allocation;
 	}
 }
-- 
2.20.1

