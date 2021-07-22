Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C7A3D2A0F
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbhGVQIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235146AbhGVQHD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:07:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C72D6144E;
        Thu, 22 Jul 2021 16:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972456;
        bh=EFpnzNAE5hTcVD4qxLv0F2FRU29IaMMi9CYUaIANngw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlPgBQxYCGQdOjqVNRP42nZnUmotlbZvBi9iRoO8CBAhVppQzw/30eDw/+9dn8GMs
         sbE8MiCYzdUr+/u0rCi4wnHZ4PQ2qIgM8D4/dMYeo4Ewhr/Dp0uI15hjzYgx+uBDg5
         vLFWydC0ifZD8vDs9yH5kgFslqlirAr1c6C7Swaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 122/156] net: marvell: always set skb_shared_info in mvneta_swbm_add_rx_fragment
Date:   Thu, 22 Jul 2021 18:31:37 +0200
Message-Id: <20210722155632.309998555@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 6ff63a150b5556012589ae59efac1b5eeb7d32c3 upstream.

Always set skb_shared_info data structure in mvneta_swbm_add_rx_fragment
routine even if the fragment contains only the ethernet FCS.

Fixes: 039fbc47f9f1 ("net: mvneta: alloc skb_shared_info on the mvneta_rx_swbm stack")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvneta.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2303,19 +2303,19 @@ mvneta_swbm_add_rx_fragment(struct mvnet
 		skb_frag_off_set(frag, pp->rx_offset_correction);
 		skb_frag_size_set(frag, data_len);
 		__skb_frag_set_page(frag, page);
-
-		/* last fragment */
-		if (len == *size) {
-			struct skb_shared_info *sinfo;
-
-			sinfo = xdp_get_shared_info_from_buff(xdp);
-			sinfo->nr_frags = xdp_sinfo->nr_frags;
-			memcpy(sinfo->frags, xdp_sinfo->frags,
-			       sinfo->nr_frags * sizeof(skb_frag_t));
-		}
 	} else {
 		page_pool_put_full_page(rxq->page_pool, page, true);
 	}
+
+	/* last fragment */
+	if (len == *size) {
+		struct skb_shared_info *sinfo;
+
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		sinfo->nr_frags = xdp_sinfo->nr_frags;
+		memcpy(sinfo->frags, xdp_sinfo->frags,
+		       sinfo->nr_frags * sizeof(skb_frag_t));
+	}
 	*size -= len;
 }
 


