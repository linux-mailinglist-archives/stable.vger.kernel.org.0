Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35D19F840
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbfD3Lk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728600AbfD3Lky (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:40:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 247EF21734;
        Tue, 30 Apr 2019 11:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624452;
        bh=ajN8JtMnQlPa1YlO/4u54AdoCGo5ukZNwYAQwujZ7f0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g3t6qEOJQGIF+xzuR5RiiZMBFQ4FjbqL9gKSoP7xXyx9kl/1Fhtuyretdu67Irp2D
         MxDOGOpdifXGXfMXtScvOep6IjrZyxWz6HnNLKQKib7wtVYeST2lp73BMopS+1APCp
         7z2Wsy1IXjMEP0lt/BDwVGasnJ5QzkFpLcVSkITM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Oskolkov <posk@google.com>,
        Tom Herbert <tom@herbertland.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 41/41] net: IP6 defrag: use rbtrees in nf_conntrack_reasm.c
Date:   Tue, 30 Apr 2019 13:38:52 +0200
Message-Id: <20190430113535.261302059@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
References: <20190430113524.451237916@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Oskolkov <posk@google.com>

[ Upstream commit 997dd96471641e147cb2c33ad54284000d0f5e35 ]

Currently, IPv6 defragmentation code drops non-last fragments that
are smaller than 1280 bytes: see
commit 0ed4229b08c1 ("ipv6: defrag: drop non-last frags smaller than min mtu")

This behavior is not specified in IPv6 RFCs and appears to break
compatibility with some IPv6 implemenations, as reported here:
https://www.spinics.net/lists/netdev/msg543846.html

This patch re-uses common IP defragmentation queueing and reassembly
code in IP6 defragmentation in nf_conntrack, removing the 1280 byte
restriction.

Signed-off-by: Peter Oskolkov <posk@google.com>
Reported-by: Tom Herbert <tom@herbertland.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c |  260 +++++++++-----------------------
 1 file changed, 74 insertions(+), 186 deletions(-)

--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -51,14 +51,6 @@
 
 static const char nf_frags_cache_name[] = "nf-frags";
 
-struct nf_ct_frag6_skb_cb
-{
-	struct inet6_skb_parm	h;
-	int			offset;
-};
-
-#define NFCT_FRAG6_CB(skb)	((struct nf_ct_frag6_skb_cb *)((skb)->cb))
-
 static struct inet_frags nf_frags;
 
 #ifdef CONFIG_SYSCTL
@@ -144,6 +136,9 @@ static void __net_exit nf_ct_frags6_sysc
 }
 #endif
 
+static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
+			     struct sk_buff *prev_tail, struct net_device *dev);
+
 static inline u8 ip6_frag_ecn(const struct ipv6hdr *ipv6h)
 {
 	return 1 << (ipv6_get_dsfield(ipv6h) & INET_ECN_MASK);
@@ -184,9 +179,10 @@ static struct frag_queue *fq_find(struct
 static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 			     const struct frag_hdr *fhdr, int nhoff)
 {
-	struct sk_buff *prev, *next;
 	unsigned int payload_len;
-	int offset, end;
+	struct net_device *dev;
+	struct sk_buff *prev;
+	int offset, end, err;
 	u8 ecn;
 
 	if (fq->q.flags & INET_FRAG_COMPLETE) {
@@ -261,55 +257,19 @@ static int nf_ct_frag6_queue(struct frag
 		goto err;
 	}
 
-	/* Find out which fragments are in front and at the back of us
-	 * in the chain of fragments so far.  We must know where to put
-	 * this fragment, right?
-	 */
+	/* Note : skb->rbnode and skb->dev share the same location. */
+	dev = skb->dev;
+	/* Makes sure compiler wont do silly aliasing games */
+	barrier();
+
 	prev = fq->q.fragments_tail;
-	if (!prev || NFCT_FRAG6_CB(prev)->offset < offset) {
-		next = NULL;
-		goto found;
-	}
-	prev = NULL;
-	for (next = fq->q.fragments; next != NULL; next = next->next) {
-		if (NFCT_FRAG6_CB(next)->offset >= offset)
-			break;	/* bingo! */
-		prev = next;
-	}
-
-found:
-	/* RFC5722, Section 4:
-	 *                                  When reassembling an IPv6 datagram, if
-	 *   one or more its constituent fragments is determined to be an
-	 *   overlapping fragment, the entire datagram (and any constituent
-	 *   fragments, including those not yet received) MUST be silently
-	 *   discarded.
-	 */
+	err = inet_frag_queue_insert(&fq->q, skb, offset, end);
+	if (err)
+		goto insert_error;
+
+	if (dev)
+		fq->iif = dev->ifindex;
 
-	/* Check for overlap with preceding fragment. */
-	if (prev &&
-	    (NFCT_FRAG6_CB(prev)->offset + prev->len) > offset)
-		goto discard_fq;
-
-	/* Look for overlap with succeeding segment. */
-	if (next && NFCT_FRAG6_CB(next)->offset < end)
-		goto discard_fq;
-
-	NFCT_FRAG6_CB(skb)->offset = offset;
-
-	/* Insert this fragment in the chain of fragments. */
-	skb->next = next;
-	if (!next)
-		fq->q.fragments_tail = skb;
-	if (prev)
-		prev->next = skb;
-	else
-		fq->q.fragments = skb;
-
-	if (skb->dev) {
-		fq->iif = skb->dev->ifindex;
-		skb->dev = NULL;
-	}
 	fq->q.stamp = skb->tstamp;
 	fq->q.meat += skb->len;
 	fq->ecn |= ecn;
@@ -325,11 +285,25 @@ found:
 		fq->q.flags |= INET_FRAG_FIRST_IN;
 	}
 
-	return 0;
+	if (fq->q.flags == (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &&
+	    fq->q.meat == fq->q.len) {
+		unsigned long orefdst = skb->_skb_refdst;
+
+		skb->_skb_refdst = 0UL;
+		err = nf_ct_frag6_reasm(fq, skb, prev, dev);
+		skb->_skb_refdst = orefdst;
+		return err;
+	}
+
+	skb_dst_drop(skb);
+	return -EINPROGRESS;
 
-discard_fq:
+insert_error:
+	if (err == IPFRAG_DUP)
+		goto err;
 	inet_frag_kill(&fq->q);
 err:
+	skb_dst_drop(skb);
 	return -EINVAL;
 }
 
@@ -339,141 +313,67 @@ err:
  *	It is called with locked fq, and caller must check that
  *	queue is eligible for reassembly i.e. it is not COMPLETE,
  *	the last and the first frames arrived and all the bits are here.
- *
- *	returns true if *prev skb has been transformed into the reassembled
- *	skb, false otherwise.
  */
-static bool
-nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *prev,  struct net_device *dev)
+static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
+			     struct sk_buff *prev_tail, struct net_device *dev)
 {
-	struct sk_buff *fp, *head = fq->q.fragments;
-	int    payload_len;
+	void *reasm_data;
+	int payload_len;
 	u8 ecn;
 
 	inet_frag_kill(&fq->q);
 
-	WARN_ON(head == NULL);
-	WARN_ON(NFCT_FRAG6_CB(head)->offset != 0);
-
 	ecn = ip_frag_ecn_table[fq->ecn];
 	if (unlikely(ecn == 0xff))
-		return false;
+		goto err;
+
+	reasm_data = inet_frag_reasm_prepare(&fq->q, skb, prev_tail);
+	if (!reasm_data)
+		goto err;
 
-	/* Unfragmented part is taken from the first segment. */
-	payload_len = ((head->data - skb_network_header(head)) -
+	payload_len = ((skb->data - skb_network_header(skb)) -
 		       sizeof(struct ipv6hdr) + fq->q.len -
 		       sizeof(struct frag_hdr));
 	if (payload_len > IPV6_MAXPLEN) {
 		net_dbg_ratelimited("nf_ct_frag6_reasm: payload len = %d\n",
 				    payload_len);
-		return false;
-	}
-
-	/* Head of list must not be cloned. */
-	if (skb_unclone(head, GFP_ATOMIC))
-		return false;
-
-	/* If the first fragment is fragmented itself, we split
-	 * it to two chunks: the first with data and paged part
-	 * and the second, holding only fragments. */
-	if (skb_has_frag_list(head)) {
-		struct sk_buff *clone;
-		int i, plen = 0;
-
-		clone = alloc_skb(0, GFP_ATOMIC);
-		if (clone == NULL)
-			return false;
-
-		clone->next = head->next;
-		head->next = clone;
-		skb_shinfo(clone)->frag_list = skb_shinfo(head)->frag_list;
-		skb_frag_list_init(head);
-		for (i = 0; i < skb_shinfo(head)->nr_frags; i++)
-			plen += skb_frag_size(&skb_shinfo(head)->frags[i]);
-		clone->len = clone->data_len = head->data_len - plen;
-		head->data_len -= clone->len;
-		head->len -= clone->len;
-		clone->csum = 0;
-		clone->ip_summed = head->ip_summed;
-
-		add_frag_mem_limit(fq->q.net, clone->truesize);
-	}
-
-	/* morph head into last received skb: prev.
-	 *
-	 * This allows callers of ipv6 conntrack defrag to continue
-	 * to use the last skb(frag) passed into the reasm engine.
-	 * The last skb frag 'silently' turns into the full reassembled skb.
-	 *
-	 * Since prev is also part of q->fragments we have to clone it first.
-	 */
-	if (head != prev) {
-		struct sk_buff *iter;
-
-		fp = skb_clone(prev, GFP_ATOMIC);
-		if (!fp)
-			return false;
-
-		fp->next = prev->next;
-
-		iter = head;
-		while (iter) {
-			if (iter->next == prev) {
-				iter->next = fp;
-				break;
-			}
-			iter = iter->next;
-		}
-
-		skb_morph(prev, head);
-		prev->next = head->next;
-		consume_skb(head);
-		head = prev;
+		goto err;
 	}
 
 	/* We have to remove fragment header from datagram and to relocate
 	 * header in order to calculate ICV correctly. */
-	skb_network_header(head)[fq->nhoffset] = skb_transport_header(head)[0];
-	memmove(head->head + sizeof(struct frag_hdr), head->head,
-		(head->data - head->head) - sizeof(struct frag_hdr));
-	head->mac_header += sizeof(struct frag_hdr);
-	head->network_header += sizeof(struct frag_hdr);
-
-	skb_shinfo(head)->frag_list = head->next;
-	skb_reset_transport_header(head);
-	skb_push(head, head->data - skb_network_header(head));
-
-	for (fp = head->next; fp; fp = fp->next) {
-		head->data_len += fp->len;
-		head->len += fp->len;
-		if (head->ip_summed != fp->ip_summed)
-			head->ip_summed = CHECKSUM_NONE;
-		else if (head->ip_summed == CHECKSUM_COMPLETE)
-			head->csum = csum_add(head->csum, fp->csum);
-		head->truesize += fp->truesize;
-		fp->sk = NULL;
-	}
-	sub_frag_mem_limit(fq->q.net, head->truesize);
-
-	head->ignore_df = 1;
-	head->next = NULL;
-	head->dev = dev;
-	head->tstamp = fq->q.stamp;
-	ipv6_hdr(head)->payload_len = htons(payload_len);
-	ipv6_change_dsfield(ipv6_hdr(head), 0xff, ecn);
-	IP6CB(head)->frag_max_size = sizeof(struct ipv6hdr) + fq->q.max_size;
+	skb_network_header(skb)[fq->nhoffset] = skb_transport_header(skb)[0];
+	memmove(skb->head + sizeof(struct frag_hdr), skb->head,
+		(skb->data - skb->head) - sizeof(struct frag_hdr));
+	skb->mac_header += sizeof(struct frag_hdr);
+	skb->network_header += sizeof(struct frag_hdr);
+
+	skb_reset_transport_header(skb);
+
+	inet_frag_reasm_finish(&fq->q, skb, reasm_data);
+
+	skb->ignore_df = 1;
+	skb->dev = dev;
+	ipv6_hdr(skb)->payload_len = htons(payload_len);
+	ipv6_change_dsfield(ipv6_hdr(skb), 0xff, ecn);
+	IP6CB(skb)->frag_max_size = sizeof(struct ipv6hdr) + fq->q.max_size;
 
 	/* Yes, and fold redundant checksum back. 8) */
-	if (head->ip_summed == CHECKSUM_COMPLETE)
-		head->csum = csum_partial(skb_network_header(head),
-					  skb_network_header_len(head),
-					  head->csum);
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		skb->csum = csum_partial(skb_network_header(skb),
+					 skb_network_header_len(skb),
+					 skb->csum);
 
 	fq->q.fragments = NULL;
 	fq->q.rb_fragments = RB_ROOT;
 	fq->q.fragments_tail = NULL;
+	fq->q.last_run_head = NULL;
+
+	return 0;
 
-	return true;
+err:
+	inet_frag_kill(&fq->q);
+	return -EINVAL;
 }
 
 /*
@@ -542,7 +442,6 @@ find_prev_fhdr(struct sk_buff *skb, u8 *
 int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 {
 	u16 savethdr = skb->transport_header;
-	struct net_device *dev = skb->dev;
 	int fhoff, nhoff, ret;
 	struct frag_hdr *fhdr;
 	struct frag_queue *fq;
@@ -565,10 +464,6 @@ int nf_ct_frag6_gather(struct net *net,
 	hdr = ipv6_hdr(skb);
 	fhdr = (struct frag_hdr *)skb_transport_header(skb);
 
-	if (skb->len - skb_network_offset(skb) < IPV6_MIN_MTU &&
-	    fhdr->frag_off & htons(IP6_MF))
-		return -EINVAL;
-
 	skb_orphan(skb);
 	fq = fq_find(net, fhdr->identification, user, hdr,
 		     skb->dev ? skb->dev->ifindex : 0);
@@ -580,24 +475,17 @@ int nf_ct_frag6_gather(struct net *net,
 	spin_lock_bh(&fq->q.lock);
 
 	ret = nf_ct_frag6_queue(fq, skb, fhdr, nhoff);
-	if (ret < 0) {
-		if (ret == -EPROTO) {
-			skb->transport_header = savethdr;
-			ret = 0;
-		}
-		goto out_unlock;
+	if (ret == -EPROTO) {
+		skb->transport_header = savethdr;
+		ret = 0;
 	}
 
 	/* after queue has assumed skb ownership, only 0 or -EINPROGRESS
 	 * must be returned.
 	 */
-	ret = -EINPROGRESS;
-	if (fq->q.flags == (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &&
-	    fq->q.meat == fq->q.len &&
-	    nf_ct_frag6_reasm(fq, skb, dev))
-		ret = 0;
+	if (ret)
+		ret = -EINPROGRESS;
 
-out_unlock:
 	spin_unlock_bh(&fq->q.lock);
 	inet_frag_put(&fq->q);
 	return ret;


