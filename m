Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABBD649FE6
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbiLLNQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiLLNQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:16:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFD913D06
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:16:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F277FB80B9B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46196C433D2;
        Mon, 12 Dec 2022 13:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850964;
        bh=JQ6E/WOZtWHfagFtlqUP/YHyZ1GTvOs7pB4p7Qkumvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtDG+E6OIYPaxsUGJDVVMjdyue2EQe0MfM0NRhDu67+YqwjcY3mTeU7P79vCE2VHi
         4lN6HztqgHl8fKSCDB8XLf33nvwnVd6q9gm66WupRn9d2OTbYkVUqY6btZgOY2tw6W
         b6RUe/1396xGuOR0FdvxCQ3T2xo4fQ1FHX+lOi6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ronak Doshi <doshir@vmware.com>,
        Guolin Yang <gyang@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/106] vmxnet3: correctly report encapsulated LRO packet
Date:   Mon, 12 Dec 2022 14:10:18 +0100
Message-Id: <20221212130928.151274914@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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

[ Upstream commit 40b8c2a1af03ba3e8da55a4490d646bfa845e71a ]

Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
support") added support for encapsulation offload. However, the
pathc did not report correctly the encapsulated packet which is
LRO'ed by the hypervisor.

This patch fixes this issue by using correct callback for the LRO'ed
encapsulated packet.

Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 6678a734cc4d..43a4bcdd92c1 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1356,6 +1356,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 	};
 	u32 num_pkts = 0;
 	bool skip_page_frags = false;
+	bool encap_lro = false;
 	struct Vmxnet3_RxCompDesc *rcd;
 	struct vmxnet3_rx_ctx *ctx = &rq->rx_ctx;
 	u16 segCnt = 0, mss = 0;
@@ -1496,13 +1497,18 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			if (VMXNET3_VERSION_GE_2(adapter) &&
 			    rcd->type == VMXNET3_CDTYPE_RXCOMP_LRO) {
 				struct Vmxnet3_RxCompDescExt *rcdlro;
+				union Vmxnet3_GenericDesc *gdesc;
+
 				rcdlro = (struct Vmxnet3_RxCompDescExt *)rcd;
+				gdesc = (union Vmxnet3_GenericDesc *)rcd;
 
 				segCnt = rcdlro->segCnt;
 				WARN_ON_ONCE(segCnt == 0);
 				mss = rcdlro->mss;
 				if (unlikely(segCnt <= 1))
 					segCnt = 0;
+				encap_lro = (le32_to_cpu(gdesc->dword[0]) &
+					(1UL << VMXNET3_RCD_HDR_INNER_SHIFT));
 			} else {
 				segCnt = 0;
 			}
@@ -1570,7 +1576,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			vmxnet3_rx_csum(adapter, skb,
 					(union Vmxnet3_GenericDesc *)rcd);
 			skb->protocol = eth_type_trans(skb, adapter->netdev);
-			if (!rcd->tcp ||
+			if ((!rcd->tcp && !encap_lro) ||
 			    !(adapter->netdev->features & NETIF_F_LRO))
 				goto not_lro;
 
@@ -1579,7 +1585,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 					SKB_GSO_TCPV4 : SKB_GSO_TCPV6;
 				skb_shinfo(skb)->gso_size = mss;
 				skb_shinfo(skb)->gso_segs = segCnt;
-			} else if (segCnt != 0 || skb->len > mtu) {
+			} else if ((segCnt != 0 || skb->len > mtu) && !encap_lro) {
 				u32 hlen;
 
 				hlen = vmxnet3_get_hdr_len(adapter, skb,
@@ -1608,6 +1614,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 				napi_gro_receive(&rq->napi, skb);
 
 			ctx->skb = NULL;
+			encap_lro = false;
 			num_pkts++;
 		}
 
-- 
2.35.1



