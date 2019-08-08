Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E92086A51
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404477AbfHHTIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404896AbfHHTIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F3EF2184E;
        Thu,  8 Aug 2019 19:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291302;
        bh=+hWlT7uUS4AlLaEPkmLlas7EoQBPeqvXeM/SV4hytTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XM4nHnl1CaA0R2oJL202jAD9g/La0VdP1xmawsrud0E23IA892eCpC+urvl1Q5soi
         4F7U31tp/tWKHCcmifY6BjV2XSul8HqL1lSSxtPhiR1lC6LovCFSc5GtKxenm66J8T
         Wc08KtgVKXmZg0E0WRLAbbMWcjEMcr5q9diWJWkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexis Bauvin <abauvin@scaleway.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 38/56] tun: mark small packets as owned by the tap sock
Date:   Thu,  8 Aug 2019 21:05:04 +0200
Message-Id: <20190808190454.585476147@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexis Bauvin <abauvin@scaleway.com>

[ Upstream commit 4b663366246be1d1d4b1b8b01245b2e88ad9e706 ]

- v1 -> v2: Move skb_set_owner_w to __tun_build_skb to reduce patch size

Small packets going out of a tap device go through an optimized code
path that uses build_skb() rather than sock_alloc_send_pskb(). The
latter calls skb_set_owner_w(), but the small packet code path does not.

The net effect is that small packets are not owned by the userland
application's socket (e.g. QEMU), while large packets are.
This can be seen with a TCP session, where packets are not owned when
the window size is small enough (around PAGE_SIZE), while they are once
the window grows (note that this requires the host to support virtio
tso for the guest to offload segmentation).
All this leads to inconsistent behaviour in the kernel, especially on
netfilter modules that uses sk->socket (e.g. xt_owner).

Fixes: 66ccbc9c87c2 ("tap: use build_skb() for small packet")
Signed-off-by: Alexis Bauvin <abauvin@scaleway.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1600,7 +1600,8 @@ static bool tun_can_build_skb(struct tun
 	return true;
 }
 
-static struct sk_buff *__tun_build_skb(struct page_frag *alloc_frag, char *buf,
+static struct sk_buff *__tun_build_skb(struct tun_file *tfile,
+				       struct page_frag *alloc_frag, char *buf,
 				       int buflen, int len, int pad)
 {
 	struct sk_buff *skb = build_skb(buf, buflen);
@@ -1610,6 +1611,7 @@ static struct sk_buff *__tun_build_skb(s
 
 	skb_reserve(skb, pad);
 	skb_put(skb, len);
+	skb_set_owner_w(skb, tfile->socket.sk);
 
 	get_page(alloc_frag->page);
 	alloc_frag->offset += buflen;
@@ -1687,7 +1689,8 @@ static struct sk_buff *tun_build_skb(str
 	 */
 	if (hdr->gso_type || !xdp_prog) {
 		*skb_xdp = 1;
-		return __tun_build_skb(alloc_frag, buf, buflen, len, pad);
+		return __tun_build_skb(tfile, alloc_frag, buf, buflen, len,
+				       pad);
 	}
 
 	*skb_xdp = 0;
@@ -1724,7 +1727,7 @@ static struct sk_buff *tun_build_skb(str
 	rcu_read_unlock();
 	local_bh_enable();
 
-	return __tun_build_skb(alloc_frag, buf, buflen, len, pad);
+	return __tun_build_skb(tfile, alloc_frag, buf, buflen, len, pad);
 
 err_xdp:
 	put_page(alloc_frag->page);


