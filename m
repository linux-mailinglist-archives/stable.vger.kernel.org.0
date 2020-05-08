Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DD91CAB13
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgEHMjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgEHMje (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4072E20731;
        Fri,  8 May 2020 12:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941573;
        bh=O9N3m2qQAeS4ZdZmamklYq3Otx1v5shcUcP/2kvOnMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZvWvdV3s1iyx1JuDNsM6AXpfyi+/3TLOnsw0kAw3ufmgf6sED81xmhQJF3MouOmf
         0WoHohSxwlC6kzPdOZrzryv4evDFisBACUG++smSXKsCqWxsL3LmjqQsmuox9+D+EF
         H3KYytwPa/6qn5NjP7hUm4PKqRYI/OlPX647zD8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Finlay <matt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 086/312] net/mlx5e: Copy all L2 headers into inline segment
Date:   Fri,  8 May 2020 14:31:17 +0200
Message-Id: <20200508123130.596236140@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Finlay <matt@mellanox.com>

commit e3a19b53cbb0e6738b7a547f262179065b72e3fa upstream.

ConnectX4-Lx uses an inline wqe mode that currently defaults to
requiring the entire L2 header be included in the wqe.
This patch fixes mlx5e_get_inline_hdr_size() to account for
all L2 headers (VLAN, QinQ, etc) using skb_network_offset(skb).

Fixes: e586b3b0baee ("net/mlx5: Ethernet Datapath files")
Signed-off-by: Matthew Finlay <matt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -124,7 +124,7 @@ static inline u16 mlx5e_get_inline_hdr_s
 	 * headers and occur before the data gather.
 	 * Therefore these headers must be copied into the WQE
 	 */
-#define MLX5E_MIN_INLINE ETH_HLEN
+#define MLX5E_MIN_INLINE (ETH_HLEN + VLAN_HLEN)
 
 	if (bf) {
 		u16 ihs = skb_headlen(skb);
@@ -136,7 +136,7 @@ static inline u16 mlx5e_get_inline_hdr_s
 			return skb_headlen(skb);
 	}
 
-	return MLX5E_MIN_INLINE;
+	return max(skb_network_offset(skb), MLX5E_MIN_INLINE);
 }
 
 static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)


