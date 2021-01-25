Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A75304A80
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731108AbhAZFFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731338AbhAYSyZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:54:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AF8920719;
        Mon, 25 Jan 2021 18:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600825;
        bh=YaoFlUXHhcaBDbyC+y3UWkB3R7NV44U7PV0JzBxp0U0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/rgiZU3KtMJsaadcu3blCmvN1iDjeN2fDBtWUU8XOUGb/8yJhq7mSoTXyhIzd8g1
         11yds1MDw61XXp/oFRLy8bKneLoYW8Tbqqr3D49ASBhuEu99UJX4DBQm2p10ATQTq0
         OiRQIJSp87X3k801Q4gZoBiH5it2Vj+GZ6ObpjnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 166/199] skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too
Date:   Mon, 25 Jan 2021 19:39:48 +0100
Message-Id: <20210125183223.200711279@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
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
@@ -432,7 +432,11 @@ struct sk_buff *__netdev_alloc_skb(struc
 
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


