Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652B44B483E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245490AbiBNJwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:52:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344132AbiBNJvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:51:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93D96581B;
        Mon, 14 Feb 2022 01:42:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38F21B80DC1;
        Mon, 14 Feb 2022 09:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB32C340E9;
        Mon, 14 Feb 2022 09:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831749;
        bh=j4NjT9wPBSn60O5aF8wnGLros10t+vYrPu6cKZCp8Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JiH93W5AhhIuowagpxJ4JhnC6qfYfpP7832Yzhuuu5Chmrtly16zzGigVuGzZ6MYU
         lphuGf6pzB1g+Qy4lMtab8qOF4rOn1mUc9Dmn4WJ0Job1KqippXxSqfuiKM1RvsgQ2
         76ZUvGNmWT56ZxNB/WmlnvXtELJFiK9y6JWqh2KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/116] ice: fix IPIP and SIT TSO offload
Date:   Mon, 14 Feb 2022 10:26:23 +0100
Message-Id: <20220214092501.668211968@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit 46b699c50c0304cdbd725d7740073a7f9d5edb10 ]

The driver was avoiding offload for IPIP (at least) frames due to
parsing the inner header offsets incorrectly when trying to check
lengths.

This length check works for VXLAN frames but fails on IPIP frames
because skb_transport_offset points to the inner header in IPIP
frames, which meant the subtraction of transport_header from
inner_network_header returns a negative value (-20).

With the code before this patch, everything continued to work, but GSO
was being used to segment, causing throughputs of 1.5Gb/s per thread.
After this patch, throughput is more like 10Gb/s per thread for IPIP
traffic.

Fixes: e94d44786693 ("ice: Implement filter sync, NDO operations and bump version")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 25 +++++++++++++------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index c0ee0541e53fc..847e1ef8e1064 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -507,6 +507,7 @@ struct ice_tx_ctx_desc {
 			(0x3FFFFULL << ICE_TXD_CTX_QW1_TSO_LEN_S)
 
 #define ICE_TXD_CTX_QW1_MSS_S	50
+#define ICE_TXD_CTX_MIN_MSS	64
 
 enum ice_tx_ctx_desc_cmd_bits {
 	ICE_TX_CTX_DESC_TSO		= 0x01,
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4c7d1720113a0..fb4656902634c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6787,6 +6787,7 @@ ice_features_check(struct sk_buff *skb,
 		   struct net_device __always_unused *netdev,
 		   netdev_features_t features)
 {
+	bool gso = skb_is_gso(skb);
 	size_t len;
 
 	/* No point in doing any of this if neither checksum nor GSO are
@@ -6799,24 +6800,32 @@ ice_features_check(struct sk_buff *skb,
 	/* We cannot support GSO if the MSS is going to be less than
 	 * 64 bytes. If it is then we need to drop support for GSO.
 	 */
-	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
+	if (gso && (skb_shinfo(skb)->gso_size < ICE_TXD_CTX_MIN_MSS))
 		features &= ~NETIF_F_GSO_MASK;
 
-	len = skb_network_header(skb) - skb->data;
+	len = skb_network_offset(skb);
 	if (len > ICE_TXD_MACLEN_MAX || len & 0x1)
 		goto out_rm_features;
 
-	len = skb_transport_header(skb) - skb_network_header(skb);
+	len = skb_network_header_len(skb);
 	if (len > ICE_TXD_IPLEN_MAX || len & 0x1)
 		goto out_rm_features;
 
 	if (skb->encapsulation) {
-		len = skb_inner_network_header(skb) - skb_transport_header(skb);
-		if (len > ICE_TXD_L4LEN_MAX || len & 0x1)
-			goto out_rm_features;
+		/* this must work for VXLAN frames AND IPIP/SIT frames, and in
+		 * the case of IPIP frames, the transport header pointer is
+		 * after the inner header! So check to make sure that this
+		 * is a GRE or UDP_TUNNEL frame before doing that math.
+		 */
+		if (gso && (skb_shinfo(skb)->gso_type &
+			    (SKB_GSO_GRE | SKB_GSO_UDP_TUNNEL))) {
+			len = skb_inner_network_header(skb) -
+			      skb_transport_header(skb);
+			if (len > ICE_TXD_L4LEN_MAX || len & 0x1)
+				goto out_rm_features;
+		}
 
-		len = skb_inner_transport_header(skb) -
-		      skb_inner_network_header(skb);
+		len = skb_inner_network_header_len(skb);
 		if (len > ICE_TXD_IPLEN_MAX || len & 0x1)
 			goto out_rm_features;
 	}
-- 
2.34.1



