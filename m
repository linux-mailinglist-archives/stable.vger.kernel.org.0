Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7054F313B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347467AbiDEJ0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245094AbiDEIxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:53:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1A7EA;
        Tue,  5 Apr 2022 01:51:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF63D61504;
        Tue,  5 Apr 2022 08:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7A6C385A1;
        Tue,  5 Apr 2022 08:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148676;
        bh=opiEEy8Zkh9teV55fjvoiiH/gqsoGMYbbK0t9H7hr2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nGQL6fMC5CDD+WrSqraUK+qcoxj01E5NrV2QaRSiSXWyoxlj21b7e+BPHYaS8JJj1
         cuTAb9zpgqfpWRohw0zixbM6P4RRK+wB0TGQRkdcTCY6F3UvffvgnSpWSaHwWS+K6t
         HVjh+8o0oTJwWwJFPnaJYsYmFd+hbgcrrA0SXgME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0442/1017] igc: dont reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
Date:   Tue,  5 Apr 2022 09:22:35 +0200
Message-Id: <20220405070407.415901628@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

[ Upstream commit f9e61d365bafdee40fe2586fc6be490c3e824dad ]

{__,}napi_alloc_skb() allocates and reserves additional NET_SKB_PAD
+ NET_IP_ALIGN for any skb.
OTOH, igc_construct_skb_zc() currently allocates and reserves
additional `xdp->data_meta - xdp->data_hard_start`, which is about
XDP_PACKET_HEADROOM for XSK frames.
There's no need for that at all as the frame is post-XDP and will
go only to the networking stack core.
Pass the size of the actual data only (+ meta) to
__napi_alloc_skb() and don't reserve anything. This will give
enough headroom for stack processing.
Also, net_prefetch() xdp->data_meta and align the copy size to
speed-up memcpy() a little and better match igc_construct_skb().

Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index d83e665b3a4f..a156738dc9b6 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2435,19 +2435,20 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 static struct sk_buff *igc_construct_skb_zc(struct igc_ring *ring,
 					    struct xdp_buff *xdp)
 {
+	unsigned int totalsize = xdp->data_end - xdp->data_meta;
 	unsigned int metasize = xdp->data - xdp->data_meta;
-	unsigned int datasize = xdp->data_end - xdp->data;
-	unsigned int totalsize = metasize + datasize;
 	struct sk_buff *skb;
 
-	skb = __napi_alloc_skb(&ring->q_vector->napi,
-			       xdp->data_end - xdp->data_hard_start,
+	net_prefetch(xdp->data_meta);
+
+	skb = __napi_alloc_skb(&ring->q_vector->napi, totalsize,
 			       GFP_ATOMIC | __GFP_NOWARN);
 	if (unlikely(!skb))
 		return NULL;
 
-	skb_reserve(skb, xdp->data_meta - xdp->data_hard_start);
-	memcpy(__skb_put(skb, totalsize), xdp->data_meta, totalsize);
+	memcpy(__skb_put(skb, totalsize), xdp->data_meta,
+	       ALIGN(totalsize, sizeof(long)));
+
 	if (metasize) {
 		skb_metadata_set(skb, metasize);
 		__skb_pull(skb, metasize);
-- 
2.34.1



