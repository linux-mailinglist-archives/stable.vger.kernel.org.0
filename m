Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEEEECD510
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbfJFRcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729074AbfJFRcD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:32:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E9962080F;
        Sun,  6 Oct 2019 17:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383121;
        bh=W5ko8dKoTxp+EK2S8StLCSW/oIzptL3OD+fCC+I4QfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6NE+ElydK+bv0l3ajf9Gzms46dVLr0m5V/BH5e8hA/wS17CwBP2+5QoMMjo6Kknc
         2+KUhUBeKZweFW1LjrI0DsufEhsVoYk2DVDc4PXCnjaBCdOIIW5z6S7i+a7Xu+e58N
         i6fK7UPY3n7tBWufJgF4Im3sOR7H02kX5znJIptI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Hunt <johunt@akamai.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 095/106] udp: only do GSO if # of segs > 1
Date:   Sun,  6 Oct 2019 19:21:41 +0200
Message-Id: <20191006171201.386527724@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Hunt <johunt@akamai.com>

[ Upstream commit 4094871db1d65810acab3d57f6089aa39ef7f648 ]

Prior to this change an application sending <= 1MSS worth of data and
enabling UDP GSO would fail if the system had SW GSO enabled, but the
same send would succeed if HW GSO offload is enabled. In addition to this
inconsistency the error in the SW GSO case does not get back to the
application if sending out of a real device so the user is unaware of this
failure.

With this change we only perform GSO if the # of segments is > 1 even
if the application has enabled segmentation. I've also updated the
relevant udpgso selftests.

Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
Signed-off-by: Josh Hunt <johunt@akamai.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c                       |   11 +++++++----
 net/ipv6/udp.c                       |   11 +++++++----
 tools/testing/selftests/net/udpgso.c |   16 ++++------------
 3 files changed, 18 insertions(+), 20 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -775,6 +775,7 @@ static int udp_send_skb(struct sk_buff *
 	int is_udplite = IS_UDPLITE(sk);
 	int offset = skb_transport_offset(skb);
 	int len = skb->len - offset;
+	int datalen = len - sizeof(*uh);
 	__wsum csum = 0;
 
 	/*
@@ -808,10 +809,12 @@ static int udp_send_skb(struct sk_buff *
 			return -EIO;
 		}
 
-		skb_shinfo(skb)->gso_size = cork->gso_size;
-		skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
-		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
-							 cork->gso_size);
+		if (datalen > cork->gso_size) {
+			skb_shinfo(skb)->gso_size = cork->gso_size;
+			skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
+			skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(datalen,
+								 cork->gso_size);
+		}
 		goto csum_partial;
 	}
 
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1047,6 +1047,7 @@ static int udp_v6_send_skb(struct sk_buf
 	__wsum csum = 0;
 	int offset = skb_transport_offset(skb);
 	int len = skb->len - offset;
+	int datalen = len - sizeof(*uh);
 
 	/*
 	 * Create a UDP header
@@ -1079,10 +1080,12 @@ static int udp_v6_send_skb(struct sk_buf
 			return -EIO;
 		}
 
-		skb_shinfo(skb)->gso_size = cork->gso_size;
-		skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
-		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
-							 cork->gso_size);
+		if (datalen > cork->gso_size) {
+			skb_shinfo(skb)->gso_size = cork->gso_size;
+			skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
+			skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(datalen,
+								 cork->gso_size);
+		}
 		goto csum_partial;
 	}
 
--- a/tools/testing/selftests/net/udpgso.c
+++ b/tools/testing/selftests/net/udpgso.c
@@ -90,12 +90,9 @@ struct testcase testcases_v4[] = {
 		.tfail = true,
 	},
 	{
-		/* send a single MSS: will fail with GSO, because the segment
-		 * logic in udp4_ufo_fragment demands a gso skb to be > MTU
-		 */
+		/* send a single MSS: will fall back to no GSO */
 		.tlen = CONST_MSS_V4,
 		.gso_len = CONST_MSS_V4,
-		.tfail = true,
 		.r_num_mss = 1,
 	},
 	{
@@ -140,10 +137,9 @@ struct testcase testcases_v4[] = {
 		.tfail = true,
 	},
 	{
-		/* send a single 1B MSS: will fail, see single MSS above */
+		/* send a single 1B MSS: will fall back to no GSO */
 		.tlen = 1,
 		.gso_len = 1,
-		.tfail = true,
 		.r_num_mss = 1,
 	},
 	{
@@ -197,12 +193,9 @@ struct testcase testcases_v6[] = {
 		.tfail = true,
 	},
 	{
-		/* send a single MSS: will fail with GSO, because the segment
-		 * logic in udp4_ufo_fragment demands a gso skb to be > MTU
-		 */
+		/* send a single MSS: will fall back to no GSO */
 		.tlen = CONST_MSS_V6,
 		.gso_len = CONST_MSS_V6,
-		.tfail = true,
 		.r_num_mss = 1,
 	},
 	{
@@ -247,10 +240,9 @@ struct testcase testcases_v6[] = {
 		.tfail = true,
 	},
 	{
-		/* send a single 1B MSS: will fail, see single MSS above */
+		/* send a single 1B MSS: will fall back to no GSO */
 		.tlen = 1,
 		.gso_len = 1,
-		.tfail = true,
 		.r_num_mss = 1,
 	},
 	{


