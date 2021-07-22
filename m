Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD563D26E9
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 17:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhGVPAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:00:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231925AbhGVPAu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9988661003;
        Thu, 22 Jul 2021 15:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626968484;
        bh=PdD1pDOt790RF0O2hTFEKpSgh6/i5twVKh2ZRm36mYk=;
        h=Subject:To:Cc:From:Date:From;
        b=wFW1y/nMWJNfWUvHYhvRKZ14RUby4VBKd9S0C0QGkwbNCHIXHvBmaZ81tdpN/XkDf
         7Tsv5xO84wOlYZYtFo849KvRZ4lIg+pNd6jUWVYsImMJZQokk9BjM0sATQ8ePIVOcL
         5Dbcfsim+AK+w2P6XBst8DHXacgKwNXW0KNWs8TQ=
Subject: FAILED: patch "[PATCH] tcp: call sk_wmem_schedule before sk_mem_charge in zerocopy" failed to apply to 4.19-stable tree
To:     talalahmad@google.com, davem@davemloft.net, edumazet@google.com,
        soheil@google.com, weiwan@google.com, willemb@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 22 Jul 2021 17:41:13 +0200
Message-ID: <1626968473173251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 358ed624207012f03318235017ac6fb41f8af592 Mon Sep 17 00:00:00 2001
From: Talal Ahmad <talalahmad@google.com>
Date: Fri, 9 Jul 2021 11:43:06 -0400
Subject: [PATCH] tcp: call sk_wmem_schedule before sk_mem_charge in zerocopy
 path

sk_wmem_schedule makes sure that sk_forward_alloc has enough
bytes for charging that is going to be done by sk_mem_charge.

In the transmit zerocopy path, there is sk_mem_charge but there was
no call to sk_wmem_schedule. This change adds that call.

Without this call to sk_wmem_schedule, sk_forward_alloc can go
negetive which is a bug because sk_forward_alloc is a per-socket
space that has been forward charged so this can't be negative.

Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
Signed-off-by: Talal Ahmad <talalahmad@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d5ab5f243640..8cb44040ec68 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1375,6 +1375,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			}
 			pfrag->offset += copy;
 		} else {
+			if (!sk_wmem_schedule(sk, copy))
+				goto wait_for_space;
+
 			err = skb_zerocopy_iter_stream(sk, skb, msg, copy, uarg);
 			if (err == -EMSGSIZE || err == -EEXIST) {
 				tcp_mark_push(tp, skb);

