Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE56F303311
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbhAZEp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:45:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728366AbhAYSnU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC18720E65;
        Mon, 25 Jan 2021 18:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600145;
        bh=aATgpH4pTBbdwN1BD+DtBolaDHcikp3eRTHUSVHKz/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTu+5H71GmeAbYFEhAYUYSVKgOY36DNRfWGezkm4l0MHZisA7wez8PM5+p+or3I7I
         GICFUAxmbvdYjcVY1wphkhVRAMGZN8QMtZw6HXQy6P/brRbgyT4X1ONTBrVWw6j7x+
         lH7aiN3wX39Kt3fFBpj1b64T1LItdYjO4zx0a5pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 48/58] skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too
Date:   Mon, 25 Jan 2021 19:39:49 +0100
Message-Id: <20210125183158.777581501@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

commit 66c556025d687dbdd0f748c5e1df89c977b6c02a upstream.

Commit 3226b158e67c ("net: avoid 32 x truesize under-estimation for
tiny skbs") ensured that skbs with data size lower than 1025 bytes
will be kmalloc'ed to avoid excessive page cache fragmentation and
memory consumption.
However, the fix adressed only __napi_alloc_skb() (primarily for
virtio_net and napi_get_frags()), but the issue can still be achieved
through __netdev_alloc_skb(), which is still used by several drivers.
Drivers often allocate a tiny skb for headers and place the rest of
the frame to frags (so-called copybreak).
Mirror the condition to __netdev_alloc_skb() to handle this case too.

Since v1 [0]:
 - fix "Fixes:" tag;
 - refine commit message (mention copybreak usecase).

[0] https://lore.kernel.org/netdev/20210114235423.232737-1-alobakin@pm.me

Fixes: a1c7fff7e18f ("net: netdev_alloc_skb() use build_skb()")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Link: https://lore.kernel.org/r/20210115150354.85967-1-alobakin@pm.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/skbuff.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -398,7 +398,11 @@ struct sk_buff *__netdev_alloc_skb(struc
 
 	len += NET_SKB_PAD;
 
-	if ((len > SKB_WITH_OVERHEAD(PAGE_SIZE)) ||
+	/* If requested length is either too small or too big,
+	 * we use kmalloc() for skb->head allocation.
+	 */
+	if (len <= SKB_WITH_OVERHEAD(1024) ||
+	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
 	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
 		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
 		if (!skb)


