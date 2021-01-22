Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8A9300C2C
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 20:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbhAVSlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:41:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:37758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbhAVOVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:21:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A683023A54;
        Fri, 22 Jan 2021 14:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324895;
        bh=cGQfnrgoeCJEnL0TN9QJGquA+MO91nPl+N9O1fCN5cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3QPDCL+zi7Fu5eACvNUnXPJqTdp3zCH6ClGDfHvvh53tKAKztk2D2S2SmdLKUs7X
         2thepnJW/X+BJgvKK1tA363ws7WMVJE5Ye6AeOwR4pwGszrN2UQXwLkonfoztsFNFN
         zg4OkVW32qyl5d6YUpFbWREVJd/wGgL23+hWSHfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 47/50] net: introduce skb_list_walk_safe for skb segment walking
Date:   Fri, 22 Jan 2021 15:12:28 +0100
Message-Id: <20210122135737.099337340@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit dcfea72e79b0aa7a057c8f6024169d86a1bbc84b upstream.

As part of the continual effort to remove direct usage of skb->next and
skb->prev, this patch adds a helper for iterating through the
singly-linked variant of skb lists, which are used for lists of GSO
packet. The name "skb_list_..." has been chosen to match the existing
function, "kfree_skb_list, which also operates on these singly-linked
lists, and the "..._walk_safe" part is the same idiom as elsewhere in
the kernel.

This patch removes the helper from wireguard and puts it into
linux/skbuff.h, while making it a bit more robust for general usage. In
particular, parenthesis are added around the macro argument usage, and it
now accounts for trying to iterate through an already-null skb pointer,
which will simply run the iteration zero times. This latter enhancement
means it can be used to replace both do { ... } while and while (...)
open-coded idioms.

This should take care of these three possible usages, which match all
current methods of iterations.

skb_list_walk_safe(segs, skb, next) { ... }
skb_list_walk_safe(skb, skb, next) { ... }
skb_list_walk_safe(segs, skb, segs) { ... }

Gcc appears to generate efficient code for each of these.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ Just the skbuff.h changes for backporting - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1340,6 +1340,11 @@ static inline void skb_mark_not_on_list(
 	skb->next = NULL;
 }
 
+/* Iterate through singly-linked GSO fragments of an skb. */
+#define skb_list_walk_safe(first, skb, next)                                   \
+	for ((skb) = (first), (next) = (skb) ? (skb)->next : NULL; (skb);      \
+	     (skb) = (next), (next) = (skb) ? (skb)->next : NULL)
+
 static inline void skb_list_del_init(struct sk_buff *skb)
 {
 	__list_del_entry(&skb->list);


