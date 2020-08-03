Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC9323A656
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgHCMrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728314AbgHCM0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:26:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4239B204EC;
        Mon,  3 Aug 2020 12:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457569;
        bh=1/r9Q8IfWowqNWxBcXwbOD8b3HJEuZTPsq0N564a95c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfxE/AEpfSe7XqWYEsCjHPTuuxVBSck3uqX9U8PZ6hJdzsaYjzKLH3j1VJgVSwg4V
         lohTiKdWkkZom2JayUrNlknstaWe6GGeAo8VJfR6V5Lx11NgblbmF0I9Qbwccm3SZS
         t3EQ6tkYvKY6lJbQdAviAriat6su3gQijlDq5dSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 115/120] drivers/net/wan: lapb: Corrected the usage of skb_cow
Date:   Mon,  3 Aug 2020 14:19:33 +0200
Message-Id: <20200803121908.501864761@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 8754e1379e7089516a449821f88e1fe1ebbae5e1 ]

This patch fixed 2 issues with the usage of skb_cow in LAPB drivers
"lapbether" and "hdlc_x25":

1) After skb_cow fails, kfree_skb should be called to drop a reference
to the skb. But in both drivers, kfree_skb is not called.

2) skb_cow should be called before skb_push so that is can ensure the
safety of skb_push. But in "lapbether", it is incorrectly called after
skb_push.

More details about these 2 issues:

1) The behavior of calling kfree_skb on failure is also the behavior of
netif_rx, which is called by this function with "return netif_rx(skb);".
So this function should follow this behavior, too.

2) In "lapbether", skb_cow is called after skb_push. This results in 2
logical issues:
   a) skb_push is not protected by skb_cow;
   b) An extra headroom of 1 byte is ensured after skb_push. This extra
      headroom has no use in this function. It also has no use in the
      upper-layer function that this function passes the skb to
      (x25_lapb_receive_frame in net/x25/x25_dev.c).
So logically skb_cow should instead be called before skb_push.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_x25.c  | 4 +++-
 drivers/net/wan/lapbether.c | 8 +++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index c84536b03aa84..f70336bb6f524 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -71,8 +71,10 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
 	unsigned char *ptr;
 
-	if (skb_cow(skb, 1))
+	if (skb_cow(skb, 1)) {
+		kfree_skb(skb);
 		return NET_RX_DROP;
+	}
 
 	skb_push(skb, 1);
 	skb_reset_network_header(skb);
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 284832314f310..b2868433718f6 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -128,10 +128,12 @@ static int lapbeth_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
 	unsigned char *ptr;
 
-	skb_push(skb, 1);
-
-	if (skb_cow(skb, 1))
+	if (skb_cow(skb, 1)) {
+		kfree_skb(skb);
 		return NET_RX_DROP;
+	}
+
+	skb_push(skb, 1);
 
 	ptr  = skb->data;
 	*ptr = X25_IFACE_DATA;
-- 
2.25.1



