Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5E08699F
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405064AbfHHTJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:09:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404649AbfHHTJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:09:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93FEB21743;
        Thu,  8 Aug 2019 19:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291352;
        bh=9AGNDiFGuoVv33UzIPs5eYd4Nji75eLh6NNA55ASf/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KubZJTLf4uUr1A44WXP8iX6Q2GIgAYaCHl4NdgyO6UEdN2wcsOCfF/0YRQNz+bBlf
         pXBMP6wycaDjdmNl33pvFo9JgFa3RIIUnuscXW2wS1Fk+t+8xoMc9zoOacHV50/GaP
         cn+t0O/SnRg0eUIf5mk1hlOpadrqFQ4HCV96yO6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 27/45] net: qualcomm: rmnet: Fix incorrect UL checksum offload logic
Date:   Thu,  8 Aug 2019 21:05:13 +0200
Message-Id: <20190808190455.254936047@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

[ Upstream commit a7cf3d24ee6081930feb4c830a7f6f16ebe31c49 ]

The udp_ip4_ind bit is set only for IPv4 UDP non-fragmented packets
so that the hardware can flip the checksum to 0xFFFF if the computed
checksum is 0 per RFC768.

However, this bit had to be set for IPv6 UDP non fragmented packets
as well per hardware requirements. Otherwise, IPv6 UDP packets
with computed checksum as 0 were transmitted by hardware and were
dropped in the network.

In addition to setting this bit for IPv6 UDP, the field is also
appropriately renamed to udp_ind as part of this change.

Fixes: 5eb5f8608ef1 ("net: qualcomm: rmnet: Add support for TX checksum offload")
Cc: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h      |    2 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c |   13 +++++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -59,7 +59,7 @@ struct rmnet_map_dl_csum_trailer {
 struct rmnet_map_ul_csum_header {
 	__be16 csum_start_offset;
 	u16 csum_insert_offset:14;
-	u16 udp_ip4_ind:1;
+	u16 udp_ind:1;
 	u16 csum_enabled:1;
 } __aligned(1);
 
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -215,9 +215,9 @@ rmnet_map_ipv4_ul_csum_header(void *iphd
 	ul_header->csum_insert_offset = skb->csum_offset;
 	ul_header->csum_enabled = 1;
 	if (ip4h->protocol == IPPROTO_UDP)
-		ul_header->udp_ip4_ind = 1;
+		ul_header->udp_ind = 1;
 	else
-		ul_header->udp_ip4_ind = 0;
+		ul_header->udp_ind = 0;
 
 	/* Changing remaining fields to network order */
 	hdr++;
@@ -248,6 +248,7 @@ rmnet_map_ipv6_ul_csum_header(void *ip6h
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
+	struct ipv6hdr *ip6h = (struct ipv6hdr *)ip6hdr;
 	__be16 *hdr = (__be16 *)ul_header, offset;
 
 	offset = htons((__force u16)(skb_transport_header(skb) -
@@ -255,7 +256,11 @@ rmnet_map_ipv6_ul_csum_header(void *ip6h
 	ul_header->csum_start_offset = offset;
 	ul_header->csum_insert_offset = skb->csum_offset;
 	ul_header->csum_enabled = 1;
-	ul_header->udp_ip4_ind = 0;
+
+	if (ip6h->nexthdr == IPPROTO_UDP)
+		ul_header->udp_ind = 1;
+	else
+		ul_header->udp_ind = 0;
 
 	/* Changing remaining fields to network order */
 	hdr++;
@@ -428,7 +433,7 @@ sw_csum:
 	ul_header->csum_start_offset = 0;
 	ul_header->csum_insert_offset = 0;
 	ul_header->csum_enabled = 0;
-	ul_header->udp_ip4_ind = 0;
+	ul_header->udp_ind = 0;
 
 	priv->stats.csum_sw++;
 }


