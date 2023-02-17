Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E6569AD44
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 14:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjBQN7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 08:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjBQN7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 08:59:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF2C64B01
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 05:59:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9735661B9A
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 13:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7E8C433EF;
        Fri, 17 Feb 2023 13:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676642370;
        bh=G3cy65F70YCMKVGl+XCBA9wogj4ZoUKWvWsBYVGEg/E=;
        h=Subject:To:Cc:From:Date:From;
        b=1cvTONNzWxvWX706/hK4Mk0PTZ8u9pqY2J7NlzGVLUwgW4Jjnm0AzEUHC3zZ4UJ1g
         l+HzelE0zh5RQpWs5Ca9TtBR6VrLresJ43U987ze9yc2fe8/4tKAxh+r+KNW+Rq0x6
         0DRTqJ8FmdfVvOE/8mrvzdibu3IIl8/ylRcqhcGM=
Subject: FAILED: patch "[PATCH] vmxnet3: move rss code block under eop descriptor" failed to apply to 5.15-stable tree
To:     doshir@vmware.com, gyang@vmware.com, kuba@kernel.org,
        lpeng@vmware.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Feb 2023 14:59:27 +0100
Message-ID: <1676642367153153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ec76d0c2da5c ("vmxnet3: move rss code block under eop descriptor")
bdeed8b0958c ("vmxnet3: Record queue number to incoming packets")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ec76d0c2da5c6dfb6a33f1545cc15997013923da Mon Sep 17 00:00:00 2001
From: Ronak Doshi <doshir@vmware.com>
Date: Wed, 8 Feb 2023 14:38:59 -0800
Subject: [PATCH] vmxnet3: move rss code block under eop descriptor

Commit b3973bb40041 ("vmxnet3: set correct hash type based on
rss information") added hashType information into skb. However,
rssType field is populated for eop descriptor. This can lead
to incorrectly reporting of hashType for packets which use
multiple rx descriptors. Multiple rx descriptors are used
for Jumbo frame or LRO packets, which can hit this issue.

This patch moves the RSS codeblock under eop descritor.

Cc: stable@vger.kernel.org
Fixes: b3973bb40041 ("vmxnet3: set correct hash type based on rss information")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Peng Li <lpeng@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
Link: https://lore.kernel.org/r/20230208223900.5794-1-doshir@vmware.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 56267c327f0b..682987040ea8 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1546,31 +1546,6 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 				rxd->len = rbi->len;
 			}
 
-#ifdef VMXNET3_RSS
-			if (rcd->rssType != VMXNET3_RCD_RSS_TYPE_NONE &&
-			    (adapter->netdev->features & NETIF_F_RXHASH)) {
-				enum pkt_hash_types hash_type;
-
-				switch (rcd->rssType) {
-				case VMXNET3_RCD_RSS_TYPE_IPV4:
-				case VMXNET3_RCD_RSS_TYPE_IPV6:
-					hash_type = PKT_HASH_TYPE_L3;
-					break;
-				case VMXNET3_RCD_RSS_TYPE_TCPIPV4:
-				case VMXNET3_RCD_RSS_TYPE_TCPIPV6:
-				case VMXNET3_RCD_RSS_TYPE_UDPIPV4:
-				case VMXNET3_RCD_RSS_TYPE_UDPIPV6:
-					hash_type = PKT_HASH_TYPE_L4;
-					break;
-				default:
-					hash_type = PKT_HASH_TYPE_L3;
-					break;
-				}
-				skb_set_hash(ctx->skb,
-					     le32_to_cpu(rcd->rssHash),
-					     hash_type);
-			}
-#endif
 			skb_record_rx_queue(ctx->skb, rq->qid);
 			skb_put(ctx->skb, rcd->len);
 
@@ -1653,6 +1628,31 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			u32 mtu = adapter->netdev->mtu;
 			skb->len += skb->data_len;
 
+#ifdef VMXNET3_RSS
+			if (rcd->rssType != VMXNET3_RCD_RSS_TYPE_NONE &&
+			    (adapter->netdev->features & NETIF_F_RXHASH)) {
+				enum pkt_hash_types hash_type;
+
+				switch (rcd->rssType) {
+				case VMXNET3_RCD_RSS_TYPE_IPV4:
+				case VMXNET3_RCD_RSS_TYPE_IPV6:
+					hash_type = PKT_HASH_TYPE_L3;
+					break;
+				case VMXNET3_RCD_RSS_TYPE_TCPIPV4:
+				case VMXNET3_RCD_RSS_TYPE_TCPIPV6:
+				case VMXNET3_RCD_RSS_TYPE_UDPIPV4:
+				case VMXNET3_RCD_RSS_TYPE_UDPIPV6:
+					hash_type = PKT_HASH_TYPE_L4;
+					break;
+				default:
+					hash_type = PKT_HASH_TYPE_L3;
+					break;
+				}
+				skb_set_hash(skb,
+					     le32_to_cpu(rcd->rssHash),
+					     hash_type);
+			}
+#endif
 			vmxnet3_rx_csum(adapter, skb,
 					(union Vmxnet3_GenericDesc *)rcd);
 			skb->protocol = eth_type_trans(skb, adapter->netdev);

