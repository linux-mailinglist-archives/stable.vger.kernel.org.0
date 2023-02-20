Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B062F69CE7E
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbjBTN7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbjBTN7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E1293D7
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:59:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DBECB80D5A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE8EC433D2;
        Mon, 20 Feb 2023 13:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901517;
        bh=I5xRH2qrYlHm87/6xUB5Y8i+Y4zJ2WUuZn9ylKcm5VA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wdkYEXtajconnpP4DHhrVZa63/j1ZrpNYwY7v1t8Ze0g0ZJKr/JavGxL8kg5ZD4U+
         fVoF7k6NPLd2uT/Gi7rlETUN8gvmLni/m6uKkfMltFwV0NNCqLTf95FG5Eee1vVxs1
         gCVoWgWr/qrKsJqi+u7QNfyLY/tAstmlQIqjnzOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ronak Doshi <doshir@vmware.com>,
        Peng Li <lpeng@vmware.com>, Guolin Yang <gyang@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 048/118] vmxnet3: move rss code block under eop descriptor
Date:   Mon, 20 Feb 2023 14:36:04 +0100
Message-Id: <20230220133602.351145047@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronak Doshi <doshir@vmware.com>

commit ec76d0c2da5c6dfb6a33f1545cc15997013923da upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |   50 +++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1546,31 +1546,6 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx
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
 
@@ -1653,6 +1628,31 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx
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


