Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B3330053D
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbhAVOXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:23:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728563AbhAVOWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:22:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66F5823B6C;
        Fri, 22 Jan 2021 14:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325005;
        bh=WEE2pYAzXqt5jonheFeplys8motuV2yMEuaOr1evwKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Fd8ezHhc1oPF3R+/bJyezkY4an+PpymRzKThkw6PaASeTqrQVF4EK1WKKiU1MnIN
         76JNYdvFs4cEGCyL9hqrV9P/fxd+fd3p2VOsZoBTrKj1TCJWX5SAI8fdYpNl2LdxFw
         b02608mhUWX85uw7hIX6MYK3PQDdYGBfg0mmvymU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 14/33] net: introduce skb_list_walk_safe for skb segment walking
Date:   Fri, 22 Jan 2021 15:12:30 +0100
Message-Id: <20210122135734.153685343@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
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
@@ -1480,6 +1480,11 @@ static inline void skb_mark_not_on_list(
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


