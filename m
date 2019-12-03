Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA97E111F31
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfLCWpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:45:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbfLCWpX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:45:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C50D2084B;
        Tue,  3 Dec 2019 22:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413122;
        bh=MGYoHpV0jT+UdRvrMW9NDOkuD2G+bXEnLaPX4xyofrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujHv0gddK2DdpGTuP1eVJzstAxPc1JAFlvCC1qgYSnonl4nPObZfBlbGUaKeHZHhC
         N4nHZcjerRSl1xEqATDWn/s4U1Z1tGu8N3tmLl4/WgHc8cCobzazbutkcNxtFQktDZ
         lSbr4KdWTPPe5Tn8E0NOR7u20EefjdL+FQoPVp30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 124/135] net: skmsg: fix TLS 1.3 crash with full sk_msg
Date:   Tue,  3 Dec 2019 23:36:04 +0100
Message-Id: <20191203213044.786543398@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 031097d9e079e40dce401031d1012e83d80eaf01 ]

TLS 1.3 started using the entry at the end of the SG array
for chaining-in the single byte content type entry. This mostly
works:

[ E E E E E E . . ]
  ^           ^
   start       end

                 E < content type
               /
[ E E E E E E C . ]
  ^           ^
   start       end

(Where E denotes a populated SG entry; C denotes a chaining entry.)

If the array is full, however, the end will point to the start:

[ E E E E E E E E ]
  ^
   start
   end

And we end up overwriting the start:

    E < content type
   /
[ C E E E E E E E ]
  ^
   start
   end

The sg array is supposed to be a circular buffer with start and
end markers pointing anywhere. In case where start > end
(i.e. the circular buffer has "wrapped") there is an extra entry
reserved at the end to chain the two halves together.

[ E E E E E E . . l ]

(Where l is the reserved entry for "looping" back to front.

As suggested by John, let's reserve another entry for chaining
SG entries after the main circular buffer. Note that this entry
has to be pointed to by the end entry so its position is not fixed.

Examples of full messages:

[ E E E E E E E E . l ]
  ^               ^
   start           end

   <---------------.
[ E E . E E E E E E l ]
      ^ ^
   end   start

Now the end will always point to an unused entry, so TLS 1.3
can always use it.

Fixes: 130b392c6cd6 ("net: tls: Add tls 1.3 support")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skmsg.h |   26 +++++++++++++-------------
 net/core/filter.c     |    8 ++++----
 net/core/skmsg.c      |    2 +-
 net/ipv4/tcp_bpf.c    |    2 +-
 4 files changed, 19 insertions(+), 19 deletions(-)

--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -14,6 +14,7 @@
 #include <net/strparser.h>
 
 #define MAX_MSG_FRAGS			MAX_SKB_FRAGS
+#define NR_MSG_FRAG_IDS			(MAX_MSG_FRAGS + 1)
 
 enum __sk_action {
 	__SK_DROP = 0,
@@ -29,11 +30,13 @@ struct sk_msg_sg {
 	u32				size;
 	u32				copybreak;
 	bool				copy[MAX_MSG_FRAGS];
-	/* The extra element is used for chaining the front and sections when
-	 * the list becomes partitioned (e.g. end < start). The crypto APIs
-	 * require the chaining.
+	/* The extra two elements:
+	 * 1) used for chaining the front and sections when the list becomes
+	 *    partitioned (e.g. end < start). The crypto APIs require the
+	 *    chaining;
+	 * 2) to chain tailer SG entries after the message.
 	 */
-	struct scatterlist		data[MAX_MSG_FRAGS + 1];
+	struct scatterlist		data[MAX_MSG_FRAGS + 2];
 };
 
 /* UAPI in filter.c depends on struct sk_msg_sg being first element. */
@@ -141,13 +144,13 @@ static inline void sk_msg_apply_bytes(st
 
 static inline u32 sk_msg_iter_dist(u32 start, u32 end)
 {
-	return end >= start ? end - start : end + (MAX_MSG_FRAGS - start);
+	return end >= start ? end - start : end + (NR_MSG_FRAG_IDS - start);
 }
 
 #define sk_msg_iter_var_prev(var)			\
 	do {						\
 		if (var == 0)				\
-			var = MAX_MSG_FRAGS - 1;	\
+			var = NR_MSG_FRAG_IDS - 1;	\
 		else					\
 			var--;				\
 	} while (0)
@@ -155,7 +158,7 @@ static inline u32 sk_msg_iter_dist(u32 s
 #define sk_msg_iter_var_next(var)			\
 	do {						\
 		var++;					\
-		if (var == MAX_MSG_FRAGS)		\
+		if (var == NR_MSG_FRAG_IDS)		\
 			var = 0;			\
 	} while (0)
 
@@ -172,9 +175,9 @@ static inline void sk_msg_clear_meta(str
 
 static inline void sk_msg_init(struct sk_msg *msg)
 {
-	BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != MAX_MSG_FRAGS);
+	BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != NR_MSG_FRAG_IDS);
 	memset(msg, 0, sizeof(*msg));
-	sg_init_marker(msg->sg.data, MAX_MSG_FRAGS);
+	sg_init_marker(msg->sg.data, NR_MSG_FRAG_IDS);
 }
 
 static inline void sk_msg_xfer(struct sk_msg *dst, struct sk_msg *src,
@@ -195,14 +198,11 @@ static inline void sk_msg_xfer_full(stru
 
 static inline bool sk_msg_full(const struct sk_msg *msg)
 {
-	return (msg->sg.end == msg->sg.start) && msg->sg.size;
+	return sk_msg_iter_dist(msg->sg.start, msg->sg.end) == MAX_MSG_FRAGS;
 }
 
 static inline u32 sk_msg_elem_used(const struct sk_msg *msg)
 {
-	if (sk_msg_full(msg))
-		return MAX_MSG_FRAGS;
-
 	return sk_msg_iter_dist(msg->sg.start, msg->sg.end);
 }
 
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2299,7 +2299,7 @@ BPF_CALL_4(bpf_msg_pull_data, struct sk_
 	WARN_ON_ONCE(last_sge == first_sge);
 	shift = last_sge > first_sge ?
 		last_sge - first_sge - 1 :
-		MAX_SKB_FRAGS - first_sge + last_sge - 1;
+		NR_MSG_FRAG_IDS - first_sge + last_sge - 1;
 	if (!shift)
 		goto out;
 
@@ -2308,8 +2308,8 @@ BPF_CALL_4(bpf_msg_pull_data, struct sk_
 	do {
 		u32 move_from;
 
-		if (i + shift >= MAX_MSG_FRAGS)
-			move_from = i + shift - MAX_MSG_FRAGS;
+		if (i + shift >= NR_MSG_FRAG_IDS)
+			move_from = i + shift - NR_MSG_FRAG_IDS;
 		else
 			move_from = i + shift;
 		if (move_from == msg->sg.end)
@@ -2323,7 +2323,7 @@ BPF_CALL_4(bpf_msg_pull_data, struct sk_
 	} while (1);
 
 	msg->sg.end = msg->sg.end - shift > msg->sg.end ?
-		      msg->sg.end - shift + MAX_MSG_FRAGS :
+		      msg->sg.end - shift + NR_MSG_FRAG_IDS :
 		      msg->sg.end - shift;
 out:
 	msg->data = sg_virt(&msg->sg.data[first_sge]) + start - offset;
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -422,7 +422,7 @@ static int sk_psock_skb_ingress(struct s
 	copied = skb->len;
 	msg->sg.start = 0;
 	msg->sg.size = copied;
-	msg->sg.end = num_sge == MAX_MSG_FRAGS ? 0 : num_sge;
+	msg->sg.end = num_sge;
 	msg->skb = skb;
 
 	sk_psock_queue_msg(psock, msg);
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -301,7 +301,7 @@ EXPORT_SYMBOL_GPL(tcp_bpf_sendmsg_redir)
 static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 				struct sk_msg *msg, int *copied, int flags)
 {
-	bool cork = false, enospc = msg->sg.start == msg->sg.end;
+	bool cork = false, enospc = sk_msg_full(msg);
 	struct sock *sk_redir;
 	u32 tosend, delta = 0;
 	int ret;


