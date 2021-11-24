Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B8545C32C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347072AbhKXNgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:36:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352077AbhKXNeA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:34:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD43F61371;
        Wed, 24 Nov 2021 12:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758440;
        bh=qr2gE5jVB5SSEieWnUhuBnmWnM1Uki2RcON51jBA5WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iE1+d3TPoZulXNzFfJ98dvQ6sCpl3qzPlk1+qG0JucZ48DAV13JVIu8AN1vQCQPZh
         96nA4CAaFK+M7ENzCHuYYsYVGS5SwniY7o7qshiu97G1VV1mEH2JoFCZiFQ9BoMK8O
         GiFD+dzGcNy6fX3lemhbUNJp1bToNnk0XNfvEz/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arjun Roy <arjunroy@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/154] net-zerocopy: Copy straggler unaligned data for TCP Rx. zerocopy.
Date:   Wed, 24 Nov 2021 12:57:45 +0100
Message-Id: <20211124115704.545871330@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

[ Upstream commit 18fb76ed53865c1b5d5f0157b1b825704590beb5 ]

When TCP receive zerocopy does not successfully map the entire
requested space, it outputs a 'hint' that the caller should recvmsg().

Augment zerocopy to accept a user buffer that it tries to copy this
hint into - if it is possible to copy the entire hint, it will do so.
This elides a recvmsg() call for received traffic that isn't exactly
page-aligned in size.

This was tested with RPC-style traffic of arbitrary sizes. Normally,
each received message required at least one getsockopt() call, and one
recvmsg() call for the remaining unaligned data.

With this change, almost all of the recvmsg() calls are eliminated,
leading to a savings of about 25%-50% in number of system calls
for RPC-style workloads.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/tcp.h |  2 +
 net/ipv4/tcp.c           | 84 ++++++++++++++++++++++++++++++++--------
 2 files changed, 70 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index cfcb10b754838..62db78b9c1a0a 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -349,5 +349,7 @@ struct tcp_zerocopy_receive {
 	__u32 recv_skip_hint;	/* out: amount of bytes to skip */
 	__u32 inq; /* out: amount of bytes in read queue */
 	__s32 err; /* out: socket error */
+	__u64 copybuf_address;	/* in: copybuf address (small reads) */
+	__s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
 };
 #endif /* _UAPI_LINUX_TCP_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e8aca226c4ae3..ba6e4c6db3b0a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1746,6 +1746,52 @@ int tcp_mmap(struct file *file, struct socket *sock,
 }
 EXPORT_SYMBOL(tcp_mmap);
 
+static int tcp_copy_straggler_data(struct tcp_zerocopy_receive *zc,
+				   struct sk_buff *skb, u32 copylen,
+				   u32 *offset, u32 *seq)
+{
+	unsigned long copy_address = (unsigned long)zc->copybuf_address;
+	struct msghdr msg = {};
+	struct iovec iov;
+	int err;
+
+	if (copy_address != zc->copybuf_address)
+		return -EINVAL;
+
+	err = import_single_range(READ, (void __user *)copy_address,
+				  copylen, &iov, &msg.msg_iter);
+	if (err)
+		return err;
+	err = skb_copy_datagram_msg(skb, *offset, &msg, copylen);
+	if (err)
+		return err;
+	zc->recv_skip_hint -= copylen;
+	*offset += copylen;
+	*seq += copylen;
+	return (__s32)copylen;
+}
+
+static int tcp_zerocopy_handle_leftover_data(struct tcp_zerocopy_receive *zc,
+					     struct sock *sk,
+					     struct sk_buff *skb,
+					     u32 *seq,
+					     s32 copybuf_len)
+{
+	u32 offset, copylen = min_t(u32, copybuf_len, zc->recv_skip_hint);
+
+	if (!copylen)
+		return 0;
+	/* skb is null if inq < PAGE_SIZE. */
+	if (skb)
+		offset = *seq - TCP_SKB_CB(skb)->seq;
+	else
+		skb = tcp_recv_skb(sk, *seq, &offset);
+
+	zc->copybuf_len = tcp_copy_straggler_data(zc, skb, copylen, &offset,
+						  seq);
+	return zc->copybuf_len < 0 ? 0 : copylen;
+}
+
 static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
 					struct page **pages,
 					unsigned long pages_to_map,
@@ -1779,8 +1825,10 @@ static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
 static int tcp_zerocopy_receive(struct sock *sk,
 				struct tcp_zerocopy_receive *zc)
 {
+	u32 length = 0, offset, vma_len, avail_len, aligned_len, copylen = 0;
 	unsigned long address = (unsigned long)zc->address;
-	u32 length = 0, seq, offset, zap_len;
+	s32 copybuf_len = zc->copybuf_len;
+	struct tcp_sock *tp = tcp_sk(sk);
 	#define PAGE_BATCH_SIZE 8
 	struct page *pages[PAGE_BATCH_SIZE];
 	const skb_frag_t *frags = NULL;
@@ -1788,10 +1836,12 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	struct sk_buff *skb = NULL;
 	unsigned long pg_idx = 0;
 	unsigned long curr_addr;
-	struct tcp_sock *tp;
-	int inq;
+	u32 seq = tp->copied_seq;
+	int inq = tcp_inq(sk);
 	int ret;
 
+	zc->copybuf_len = 0;
+
 	if (address & (PAGE_SIZE - 1) || address != zc->address)
 		return -EINVAL;
 
@@ -1800,8 +1850,6 @@ static int tcp_zerocopy_receive(struct sock *sk,
 
 	sock_rps_record_flow(sk);
 
-	tp = tcp_sk(sk);
-
 	mmap_read_lock(current->mm);
 
 	vma = find_vma(current->mm, address);
@@ -1809,17 +1857,16 @@ static int tcp_zerocopy_receive(struct sock *sk,
 		mmap_read_unlock(current->mm);
 		return -EINVAL;
 	}
-	zc->length = min_t(unsigned long, zc->length, vma->vm_end - address);
-
-	seq = tp->copied_seq;
-	inq = tcp_inq(sk);
-	zc->length = min_t(u32, zc->length, inq);
-	zap_len = zc->length & ~(PAGE_SIZE - 1);
-	if (zap_len) {
-		zap_page_range(vma, address, zap_len);
+	vma_len = min_t(unsigned long, zc->length, vma->vm_end - address);
+	avail_len = min_t(u32, vma_len, inq);
+	aligned_len = avail_len & ~(PAGE_SIZE - 1);
+	if (aligned_len) {
+		zap_page_range(vma, address, aligned_len);
+		zc->length = aligned_len;
 		zc->recv_skip_hint = 0;
 	} else {
-		zc->recv_skip_hint = zc->length;
+		zc->length = avail_len;
+		zc->recv_skip_hint = avail_len;
 	}
 	ret = 0;
 	curr_addr = address;
@@ -1888,13 +1935,18 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	}
 out:
 	mmap_read_unlock(current->mm);
-	if (length) {
+	/* Try to copy straggler data. */
+	if (!ret)
+		copylen = tcp_zerocopy_handle_leftover_data(zc, sk, skb, &seq,
+							    copybuf_len);
+
+	if (length + copylen) {
 		WRITE_ONCE(tp->copied_seq, seq);
 		tcp_rcv_space_adjust(sk);
 
 		/* Clean up data we have read: This will do ACK frames. */
 		tcp_recv_skb(sk, seq, &offset);
-		tcp_cleanup_rbuf(sk, length);
+		tcp_cleanup_rbuf(sk, length + copylen);
 		ret = 0;
 		if (length == zc->length)
 			zc->recv_skip_hint = 0;
-- 
2.33.0



