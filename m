Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B31145C68C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354392AbhKXOKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350229AbhKXOGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:06:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEA826124D;
        Wed, 24 Nov 2021 13:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759551;
        bh=Cn51o0xM43b1LSRdF18gbXNQFu/Sw5KyLohjNLClZb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUkt2yUfVmEII98QoWwJXSdRtUI3pXnxIbnHMcwoQ/ET7HUXChXj2m6rfB3QwSGlX
         IXbSkrHDmQiscH2QeJCxGXL8dHcZgE2snZutJGkymhjsSATFXzPcfD85HGBoCokta9
         90v5f/BuysM2wPDGeJxqxGMQJdjR9OEJ1yI9Olm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Marco Elver <elver@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 278/279] net: add and use skb_unclone_keeptruesize() helper
Date:   Wed, 24 Nov 2021 12:59:25 +0100
Message-Id: <20211124115728.284884732@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit c4777efa751d293e369aec464ce6875e957be255 upstream.

While commit 097b9146c0e2 ("net: fix up truesize of cloned
skb in skb_prepare_for_shift()") fixed immediate issues found
when KFENCE was enabled/tested, there are still similar issues,
when tcp_trim_head() hits KFENCE while the master skb
is cloned.

This happens under heavy networking TX workloads,
when the TX completion might be delayed after incoming ACK.

This patch fixes the WARNING in sk_stream_kill_queues
when sk->sk_mem_queued/sk->sk_forward_alloc are not zero.

Fixes: d3fb45f370d9 ("mm, kfence: insert KFENCE hooks for SLAB")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Marco Elver <elver@google.com>
Link: https://lore.kernel.org/r/20211102004555.1359210-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |   16 ++++++++++++++++
 net/core/skbuff.c      |   14 +-------------
 net/ipv4/tcp_output.c  |    6 +++---
 3 files changed, 20 insertions(+), 16 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1671,6 +1671,22 @@ static inline int skb_unclone(struct sk_
 	return 0;
 }
 
+/* This variant of skb_unclone() makes sure skb->truesize is not changed */
+static inline int skb_unclone_keeptruesize(struct sk_buff *skb, gfp_t pri)
+{
+	might_sleep_if(gfpflags_allow_blocking(pri));
+
+	if (skb_cloned(skb)) {
+		unsigned int save = skb->truesize;
+		int res;
+
+		res = pskb_expand_head(skb, 0, 0, pri);
+		skb->truesize = save;
+		return res;
+	}
+	return 0;
+}
+
 /**
  *	skb_header_cloned - is the header a clone
  *	@skb: buffer to check
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3449,19 +3449,7 @@ EXPORT_SYMBOL(skb_split);
  */
 static int skb_prepare_for_shift(struct sk_buff *skb)
 {
-	int ret = 0;
-
-	if (skb_cloned(skb)) {
-		/* Save and restore truesize: pskb_expand_head() may reallocate
-		 * memory where ksize(kmalloc(S)) != ksize(kmalloc(S)), but we
-		 * cannot change truesize at this point.
-		 */
-		unsigned int save_truesize = skb->truesize;
-
-		ret = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
-		skb->truesize = save_truesize;
-	}
-	return ret;
+	return skb_unclone_keeptruesize(skb, GFP_ATOMIC);
 }
 
 /**
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1562,7 +1562,7 @@ int tcp_fragment(struct sock *sk, enum t
 		return -ENOMEM;
 	}
 
-	if (skb_unclone(skb, gfp))
+	if (skb_unclone_keeptruesize(skb, gfp))
 		return -ENOMEM;
 
 	/* Get a new skb... force flag on. */
@@ -1672,7 +1672,7 @@ int tcp_trim_head(struct sock *sk, struc
 {
 	u32 delta_truesize;
 
-	if (skb_unclone(skb, GFP_ATOMIC))
+	if (skb_unclone_keeptruesize(skb, GFP_ATOMIC))
 		return -ENOMEM;
 
 	delta_truesize = __pskb_trim_head(skb, len);
@@ -3184,7 +3184,7 @@ int __tcp_retransmit_skb(struct sock *sk
 				 cur_mss, GFP_ATOMIC))
 			return -ENOMEM; /* We'll try again later. */
 	} else {
-		if (skb_unclone(skb, GFP_ATOMIC))
+		if (skb_unclone_keeptruesize(skb, GFP_ATOMIC))
 			return -ENOMEM;
 
 		diff = tcp_skb_pcount(skb);


