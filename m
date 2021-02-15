Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC9C31BD35
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhBOPm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:42:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230393AbhBOPiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36AF064EF4;
        Mon, 15 Feb 2021 15:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403257;
        bh=jA9B+9aaDDzuWSHQfxxvrM1xDfzuEAc2TwfPu1sS1/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSJ68E3GJfiygSIyHyKKRdpT2MF0olRwV3zbiur+B3f185kaFB6guE3gtNAzn6LmS
         Q8kKUaZ3Hl20cKr8uI1YYNISAQAXOehI8H0XK+GwV8AV4Ry78PygLaQBWHjQXHvs/H
         XfGCnQ6ioIGnRjW5Vd6998zPqtc0rM/nK2m0jXbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Graute <oliver.graute@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 088/104] udp: fix skb_copy_and_csum_datagram with odd segment sizes
Date:   Mon, 15 Feb 2021 16:27:41 +0100
Message-Id: <20210215152722.302772119@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

commit 52cbd23a119c6ebf40a527e53f3402d2ea38eccb upstream.

When iteratively computing a checksum with csum_block_add, track the
offset "pos" to correctly rotate in csum_block_add when offset is odd.

The open coded implementation of skb_copy_and_csum_datagram did this.
With the switch to __skb_datagram_iter calling csum_and_copy_to_iter,
pos was reinitialized to 0 on each call.

Bring back the pos by passing it along with the csum to the callback.

Changes v1->v2
  - pass csum value, instead of csump pointer (Alexander Duyck)

Link: https://lore.kernel.org/netdev/20210128152353.GB27281@optiplex/
Fixes: 950fcaecd5cc ("datagram: consolidate datagram copy to iter helpers")
Reported-by: Oliver Graute <oliver.graute@gmail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20210203192952.1849843-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/uio.h |    8 +++++++-
 lib/iov_iter.c      |   24 ++++++++++++++----------
 net/core/datagram.c |   12 ++++++++++--
 3 files changed, 31 insertions(+), 13 deletions(-)

--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -260,7 +260,13 @@ static inline void iov_iter_reexpand(str
 {
 	i->count = count;
 }
-size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csump, struct iov_iter *i);
+
+struct csum_state {
+	__wsum csum;
+	size_t off;
+};
+
+size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csstate, struct iov_iter *i);
 size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
 bool csum_and_copy_from_iter_full(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
 size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -592,14 +592,15 @@ static __wsum csum_and_memcpy(void *to,
 }
 
 static size_t csum_and_copy_to_pipe_iter(const void *addr, size_t bytes,
-				__wsum *csum, struct iov_iter *i)
+					 struct csum_state *csstate,
+					 struct iov_iter *i)
 {
 	struct pipe_inode_info *pipe = i->pipe;
 	unsigned int p_mask = pipe->ring_size - 1;
+	__wsum sum = csstate->csum;
+	size_t off = csstate->off;
 	unsigned int i_head;
 	size_t n, r;
-	size_t off = 0;
-	__wsum sum = *csum;
 
 	if (!sanity(i))
 		return 0;
@@ -621,7 +622,8 @@ static size_t csum_and_copy_to_pipe_iter
 		i_head++;
 	} while (n);
 	i->count -= bytes;
-	*csum = sum;
+	csstate->csum = sum;
+	csstate->off = off;
 	return bytes;
 }
 
@@ -1522,18 +1524,19 @@ bool csum_and_copy_from_iter_full(void *
 }
 EXPORT_SYMBOL(csum_and_copy_from_iter_full);
 
-size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csump,
+size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *_csstate,
 			     struct iov_iter *i)
 {
+	struct csum_state *csstate = _csstate;
 	const char *from = addr;
-	__wsum *csum = csump;
 	__wsum sum, next;
-	size_t off = 0;
+	size_t off;
 
 	if (unlikely(iov_iter_is_pipe(i)))
-		return csum_and_copy_to_pipe_iter(addr, bytes, csum, i);
+		return csum_and_copy_to_pipe_iter(addr, bytes, _csstate, i);
 
-	sum = *csum;
+	sum = csstate->csum;
+	off = csstate->off;
 	if (unlikely(iov_iter_is_discard(i))) {
 		WARN_ON(1);	/* for now */
 		return 0;
@@ -1561,7 +1564,8 @@ size_t csum_and_copy_to_iter(const void
 		off += v.iov_len;
 	})
 	)
-	*csum = sum;
+	csstate->csum = sum;
+	csstate->off = off;
 	return bytes;
 }
 EXPORT_SYMBOL(csum_and_copy_to_iter);
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -721,8 +721,16 @@ static int skb_copy_and_csum_datagram(co
 				      struct iov_iter *to, int len,
 				      __wsum *csump)
 {
-	return __skb_datagram_iter(skb, offset, to, len, true,
-			csum_and_copy_to_iter, csump);
+	struct csum_state csdata = { .csum = *csump };
+	int ret;
+
+	ret = __skb_datagram_iter(skb, offset, to, len, true,
+				  csum_and_copy_to_iter, &csdata);
+	if (ret)
+		return ret;
+
+	*csump = csdata.csum;
+	return 0;
 }
 
 /**


