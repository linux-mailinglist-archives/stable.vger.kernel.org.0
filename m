Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7100A566B90
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiGEMJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbiGEMGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:06:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DC010B8;
        Tue,  5 Jul 2022 05:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAB34B817CE;
        Tue,  5 Jul 2022 12:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372C7C341C7;
        Tue,  5 Jul 2022 12:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022745;
        bh=K52TrGq1aFPFEStWsMUZmS0HuOAk2NHW/vx/U7mCB8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geTnHcAIkPMt4hbv3O01x7IT9f6F1aoimBI9KSWmd9LqhI3O1uY1DeqPWFpTAQUVH
         FYURR9CZOTsJ1m32AoK1Fz51f4wAHgguyovF+2Kf7CBmFLsD3w/18sF2vxagAtQpJT
         xaB1UXf0ldeyjNKzeH22BvYqRa884ytgpVhbc03Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.4 53/58] xen/netfront: force data bouncing when backend is untrusted
Date:   Tue,  5 Jul 2022 13:58:29 +0200
Message-Id: <20220705115611.809633002@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Pau Monne <roger.pau@citrix.com>

commit 4491001c2e0fa69efbb748c96ec96b100a5cdb7e upstream.

Bounce all data on the skbs to be transmitted into zeroed pages if the
backend is untrusted. This avoids leaking data present in the pages
shared with the backend but not part of the skb fragments.  This
requires introducing a new helper in order to allocate skbs with a
size multiple of XEN_PAGE_SIZE so we don't leak contiguous data on the
granted pages.

Reporting whether the backend is to be trusted can be done using a
module parameter, or from the xenstore frontend path as set by the
toolstack when adding the device.

This is CVE-2022-33741, part of XSA-403.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |   50 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -63,6 +63,10 @@ module_param_named(max_queues, xennet_ma
 MODULE_PARM_DESC(max_queues,
 		 "Maximum number of queues per virtual interface");
 
+static bool __read_mostly xennet_trusted = true;
+module_param_named(trusted, xennet_trusted, bool, 0644);
+MODULE_PARM_DESC(trusted, "Is the backend trusted");
+
 #define XENNET_TIMEOUT  (5 * HZ)
 
 static const struct ethtool_ops xennet_ethtool_ops;
@@ -163,6 +167,9 @@ struct netfront_info {
 	/* Is device behaving sane? */
 	bool broken;
 
+	/* Should skbs be bounced into a zeroed buffer? */
+	bool bounce;
+
 	atomic_t rx_gso_checksum_fixup;
 };
 
@@ -590,6 +597,34 @@ static void xennet_mark_tx_pending(struc
 		queue->tx_link[i] = TX_PENDING;
 }
 
+struct sk_buff *bounce_skb(const struct sk_buff *skb)
+{
+	unsigned int headerlen = skb_headroom(skb);
+	/* Align size to allocate full pages and avoid contiguous data leaks */
+	unsigned int size = ALIGN(skb_end_offset(skb) + skb->data_len,
+				  XEN_PAGE_SIZE);
+	struct sk_buff *n = alloc_skb(size, GFP_ATOMIC | __GFP_ZERO);
+
+	if (!n)
+		return NULL;
+
+	if (!IS_ALIGNED((uintptr_t)n->head, XEN_PAGE_SIZE)) {
+		WARN_ONCE(1, "misaligned skb allocated\n");
+		kfree_skb(n);
+		return NULL;
+	}
+
+	/* Set the data pointer */
+	skb_reserve(n, headerlen);
+	/* Set the tail pointer and length */
+	skb_put(n, skb->len);
+
+	BUG_ON(skb_copy_bits(skb, -headerlen, n->head, headerlen + skb->len));
+
+	skb_copy_header(n, skb);
+	return n;
+}
+
 #define MAX_XEN_SKB_FRAGS (65536 / XEN_PAGE_SIZE + 1)
 
 static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -642,9 +677,13 @@ static netdev_tx_t xennet_start_xmit(str
 
 	/* The first req should be at least ETH_HLEN size or the packet will be
 	 * dropped by netback.
+	 *
+	 * If the backend is not trusted bounce all data to zeroed pages to
+	 * avoid exposing contiguous data on the granted page not belonging to
+	 * the skb.
 	 */
-	if (unlikely(PAGE_SIZE - offset < ETH_HLEN)) {
-		nskb = skb_copy(skb, GFP_ATOMIC);
+	if (np->bounce || unlikely(PAGE_SIZE - offset < ETH_HLEN)) {
+		nskb = bounce_skb(skb);
 		if (!nskb)
 			goto drop;
 		dev_consume_skb_any(skb);
@@ -1950,6 +1989,10 @@ static int talk_to_netback(struct xenbus
 
 	info->netdev->irq = 0;
 
+	/* Check if backend is trusted. */
+	info->bounce = !xennet_trusted ||
+		       !xenbus_read_unsigned(dev->nodename, "trusted", 1);
+
 	/* Check if backend supports multiple queues */
 	max_queues = xenbus_read_unsigned(info->xbdev->otherend,
 					  "multi-queue-max-queues", 1);
@@ -2103,6 +2146,9 @@ static int xennet_connect(struct net_dev
 	err = talk_to_netback(np->xbdev, np);
 	if (err)
 		return err;
+	if (np->bounce)
+		dev_info(&np->xbdev->dev,
+			 "bouncing transmitted data to zeroed pages\n");
 
 	/* talk_to_netback() sets the correct number of queues */
 	num_queues = dev->real_num_tx_queues;


