Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C524F2828
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbiDEIK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiDEID3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:03:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2535D664;
        Tue,  5 Apr 2022 01:00:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 577C7B81B18;
        Tue,  5 Apr 2022 08:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52D0C340EE;
        Tue,  5 Apr 2022 08:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145651;
        bh=7PzITTwsWG9q7fzViUInKvz5DqJLem2r3IZSSbeLHZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pp4754Nw3dCQgjQ3NAZmr0nWr7GW5IO8Wxx1Hqbhj78bWqWZQoyjo7KsEkPgsB9A/
         rp9FyjSl5cY+6AYWCsz2PvWDGTPF0aLlSuG354AZYBT34yllamanDBN6Gwuvlp+1w0
         4uktVRMNrpCiHrluSUZH8Tzp1TbBoeCE1PXJUjmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0481/1126] ice: dont reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
Date:   Tue,  5 Apr 2022 09:20:28 +0200
Message-Id: <20220405070421.746127895@linuxfoundation.org>
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

[ Upstream commit dc44572d195e10ec41a03e09b3b5addab4af5cea ]

{__,}napi_alloc_skb() allocates and reserves additional NET_SKB_PAD
+ NET_IP_ALIGN for any skb.
OTOH, ice_construct_skb_zc() currently allocates and reserves
additional `xdp->data - xdp->data_hard_start`, which is
XDP_PACKET_HEADROOM for XSK frames.
There's no need for that at all as the frame is post-XDP and will
go only to the networking stack core.
Pass the size of the actual data only to __napi_alloc_skb() and
don't reserve anything. This will give enough headroom for stack
processing.

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 2388837d6d6c..8fd8052edf09 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -428,17 +428,15 @@ static void ice_bump_ntc(struct ice_rx_ring *rx_ring)
 static struct sk_buff *
 ice_construct_skb_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp)
 {
-	unsigned int datasize_hard = xdp->data_end - xdp->data_hard_start;
 	unsigned int metasize = xdp->data - xdp->data_meta;
 	unsigned int datasize = xdp->data_end - xdp->data;
 	struct sk_buff *skb;
 
-	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, datasize_hard,
+	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, datasize,
 			       GFP_ATOMIC | __GFP_NOWARN);
 	if (unlikely(!skb))
 		return NULL;
 
-	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
 	if (metasize)
 		skb_metadata_set(skb, metasize);
-- 
2.34.1



