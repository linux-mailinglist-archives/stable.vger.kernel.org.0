Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC76A4F4246
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349232AbiDEMHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358041AbiDEK15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310D818B04;
        Tue,  5 Apr 2022 03:13:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6B01B81C88;
        Tue,  5 Apr 2022 10:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2D9C385A0;
        Tue,  5 Apr 2022 10:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153609;
        bh=WyeADXdrlcdcxuQs7Rbvfpn+khMbsrZAVeSDN+p9oSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Znc3WUF3UbjAk7DTFvRM1IwjadMuH9P2ps5B/B+08AVwPxg08LC74xTdYk/LiZY/o
         bO60xhqZM2zdC8PHqndI5Ul7ocjQRPiGp85iuyK98esc0okoYBrl/P6lF5WW/hw8fU
         pHa/3xOvCL3lWPdGIoeRfN2tGlm94ITo+EkALWLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/599] i40e: respect metadata on XSK Rx to skb
Date:   Tue,  5 Apr 2022 09:29:35 +0200
Message-Id: <20220405070307.197428318@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

[ Upstream commit 6dba29537c0f639b482bd8f8bbd50ab4ae74b48d ]

For now, if the XDP prog returns XDP_PASS on XSK, the metadata will
be lost as it doesn't get copied to the skb.

Copy it along with the frame headers. Account its size on skb
allocation, and when copying just treat it as a part of the frame
and do a pull after to "move" it to the "reserved" zone.

net_prefetch() xdp->data_meta and align the copy size to speed-up
memcpy() a little and better match i40e_construct_skb().

Fixes: 0a714186d3c0 ("i40e: add AF_XDP zero-copy Rx support")
Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index d444e38360c1..75e4a698c3db 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -247,19 +247,25 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 static struct sk_buff *i40e_construct_skb_zc(struct i40e_ring *rx_ring,
 					     struct xdp_buff *xdp)
 {
+	unsigned int totalsize = xdp->data_end - xdp->data_meta;
 	unsigned int metasize = xdp->data - xdp->data_meta;
-	unsigned int datasize = xdp->data_end - xdp->data;
 	struct sk_buff *skb;
 
+	net_prefetch(xdp->data_meta);
+
 	/* allocate a skb to store the frags */
-	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, datasize,
+	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, totalsize,
 			       GFP_ATOMIC | __GFP_NOWARN);
 	if (unlikely(!skb))
 		return NULL;
 
-	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
-	if (metasize)
+	memcpy(__skb_put(skb, totalsize), xdp->data_meta,
+	       ALIGN(totalsize, sizeof(long)));
+
+	if (metasize) {
 		skb_metadata_set(skb, metasize);
+		__skb_pull(skb, metasize);
+	}
 
 	xsk_buff_free(xdp);
 	return skb;
-- 
2.34.1



