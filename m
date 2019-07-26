Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4608A76DAA
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389372AbfGZPcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:32:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389370AbfGZPcC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:32:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 766AE205F4;
        Fri, 26 Jul 2019 15:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155121;
        bh=zRkOIPNoyE8ivzzuFEeKn7cn1eMbQrjTjT9edSUPa4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0TNo1FLvOZbpYo3JDZIf3D9aufs5uVIu8d98jJWkgv899OmiOfi285orqZItJAjx
         GLShbBgvwQLJyazrxse8Zmy1/N/ZcslBhzngMwT8jPbu/LS+dqQuxvjP+IJNu0Wn4l
         VCQ1E47HtCj4m0uOeVutM48Yp45Y2ybeVmQdKAvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 10/50] net: make skb_dst_force return true when dst is refcounted
Date:   Fri, 26 Jul 2019 17:24:45 +0200
Message-Id: <20190726152301.681782579@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
References: <20190726152300.760439618@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b60a77386b1d4868f72f6353d35dabe5fbe981f2 ]

netfilter did not expect that skb_dst_force() can cause skb to lose its
dst entry.

I got a bug report with a skb->dst NULL dereference in netfilter
output path.  The backtrace contains nf_reinject(), so the dst might have
been cleared when skb got queued to userspace.

Other users were fixed via
if (skb_dst(skb)) {
	skb_dst_force(skb);
	if (!skb_dst(skb))
		goto handle_err;
}

But I think its preferable to make the 'dst might be cleared' part
of the function explicit.

In netfilter case, skb with a null dst is expected when queueing in
prerouting hook, so drop skb for the other hooks.

v2:
 v1 of this patch returned true in case skb had no dst entry.
 Eric said:
   Say if we have two skb_dst_force() calls for some reason
   on the same skb, only the first one will return false.

 This now returns false even when skb had no dst, as per Erics
 suggestion, so callers might need to check skb_dst() first before
 skb_dst_force().

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst.h        |    5 ++++-
 net/netfilter/nf_queue.c |    6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -313,8 +313,9 @@ static inline bool dst_hold_safe(struct
  * @skb: buffer
  *
  * If dst is not yet refcounted and not destroyed, grab a ref on it.
+ * Returns true if dst is refcounted.
  */
-static inline void skb_dst_force(struct sk_buff *skb)
+static inline bool skb_dst_force(struct sk_buff *skb)
 {
 	if (skb_dst_is_noref(skb)) {
 		struct dst_entry *dst = skb_dst(skb);
@@ -325,6 +326,8 @@ static inline void skb_dst_force(struct
 
 		skb->_skb_refdst = (unsigned long)dst;
 	}
+
+	return skb->_skb_refdst != 0UL;
 }
 
 
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -174,6 +174,11 @@ static int __nf_queue(struct sk_buff *sk
 		goto err;
 	}
 
+	if (!skb_dst_force(skb) && state->hook != NF_INET_PRE_ROUTING) {
+		status = -ENETDOWN;
+		goto err;
+	}
+
 	*entry = (struct nf_queue_entry) {
 		.skb	= skb,
 		.state	= *state,
@@ -182,7 +187,6 @@ static int __nf_queue(struct sk_buff *sk
 	};
 
 	nf_queue_entry_get_refs(entry);
-	skb_dst_force(skb);
 
 	switch (entry->state.pf) {
 	case AF_INET:


