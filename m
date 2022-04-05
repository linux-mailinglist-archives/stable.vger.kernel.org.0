Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8321C4F2827
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbiDEIK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233344AbiDEIC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:02:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473EB580FB;
        Tue,  5 Apr 2022 01:00:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5FEF61668;
        Tue,  5 Apr 2022 08:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAC5C340EE;
        Tue,  5 Apr 2022 08:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145648;
        bh=598LsUvDO51y55921wS+9Yo1s9nm7pmwI2v420neoHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uo+XE9peIGbKw7ZRGgr+ixLapBez0DDFjgMyHxmXdZHk9cBC1t/GIE/rF2mSzZTzG
         hnoOYxXzXZjB4qj9WLIMHXO8m/ImLn0gD6+KMIFR8pLdEJTF9J8AnH8uwDH+C/aOqJ
         v1+BlJWFOAwMQOzJwibk0S5vKL+efiFyUqPBAlLo=
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
Subject: [PATCH 5.17 0480/1126] i40e: respect metadata on XSK Rx to skb
Date:   Tue,  5 Apr 2022 09:20:27 +0200
Message-Id: <20220405070421.716501077@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index a449c84fe357..67e9844e2076 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -241,19 +241,25 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
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
 		goto out;
 
-	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
-	if (metasize)
+	memcpy(__skb_put(skb, totalsize), xdp->data_meta,
+	       ALIGN(totalsize, sizeof(long)));
+
+	if (metasize) {
 		skb_metadata_set(skb, metasize);
+		__skb_pull(skb, metasize);
+	}
 
 out:
 	xsk_buff_free(xdp);
-- 
2.34.1



