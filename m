Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356A63AEFE4
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbhFUQnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:43:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232742AbhFUQlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:41:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61F1B6143E;
        Mon, 21 Jun 2021 16:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293041;
        bh=U8FhRV64sQHh89inaaY/ZmSBPQgQzN4HGX3LNpqAlPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKrZDwxeaDVBRAKrMGVhfzuXZMGdkSZ6o+5t29rQo5vnYNXVuZsJzzSCplgq76m1a
         COKdXaZxGKzcJE5YOo6eeXKqfGUwTPe3wUFX/Y2VZ+ofyNYnASTW7Xk6n2EAkjgoSA
         WOgYJwMsz6WcC+Jumn4CuXlvKSrhQ13ew7PlPMLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erez Shitrit <erezsh@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 076/178] net/mlx5: DR, Fix STEv1 incorrect L3 decapsulation padding
Date:   Mon, 21 Jun 2021 18:14:50 +0200
Message-Id: <20210621154925.168999845@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Vesker <valex@nvidia.com>

[ Upstream commit 65fb7d109abe3a1a9f1c2d3ba7e1249bc978d5f0 ]

Decapsulation L3 on small inner packets which are less than
64 Bytes was done incorrectly. In small packets there is an
extra padding added in L2 which should not be included in L3
length. The issue was that after decapL3 the extra L2 padding
caused an update on the L3 length.

To avoid this issue the new header is pushed to the beginning
of the packet (offset 0) which should not cause a HW reparse
and update the L3 length.

Fixes: c349b4137cfd ("net/mlx5: DR, Add STEv1 modify header logic")
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 26 ++++++++++++-------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index f146c618a78e..46ef45fa9167 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -712,7 +712,11 @@ static int dr_ste_v1_set_action_decap_l3_list(void *data,
 	if (hw_action_sz / DR_STE_ACTION_DOUBLE_SZ < DR_STE_DECAP_L3_ACTION_NUM)
 		return -EINVAL;
 
-	memcpy(padded_data, data, data_sz);
+	inline_data_sz =
+		MLX5_FLD_SZ_BYTES(ste_double_action_insert_with_inline_v1, inline_data);
+
+	/* Add an alignment padding  */
+	memcpy(padded_data + data_sz % inline_data_sz, data, data_sz);
 
 	/* Remove L2L3 outer headers */
 	MLX5_SET(ste_single_action_remove_header_v1, hw_action, action_id,
@@ -724,32 +728,34 @@ static int dr_ste_v1_set_action_decap_l3_list(void *data,
 	hw_action += DR_STE_ACTION_DOUBLE_SZ;
 	used_actions++; /* Remove and NOP are a single double action */
 
-	inline_data_sz =
-		MLX5_FLD_SZ_BYTES(ste_double_action_insert_with_inline_v1, inline_data);
+	/* Point to the last dword of the header */
+	data_ptr += (data_sz / inline_data_sz) * inline_data_sz;
 
-	/* Add the new header inline + 2 extra bytes */
+	/* Add the new header using inline action 4Byte at a time, the header
+	 * is added in reversed order to the beginning of the packet to avoid
+	 * incorrect parsing by the HW. Since header is 14B or 18B an extra
+	 * two bytes are padded and later removed.
+	 */
 	for (i = 0; i < data_sz / inline_data_sz + 1; i++) {
 		void *addr_inline;
 
 		MLX5_SET(ste_double_action_insert_with_inline_v1, hw_action, action_id,
 			 DR_STE_V1_ACTION_ID_INSERT_INLINE);
 		/* The hardware expects here offset to words (2 bytes) */
-		MLX5_SET(ste_double_action_insert_with_inline_v1, hw_action, start_offset,
-			 i * 2);
+		MLX5_SET(ste_double_action_insert_with_inline_v1, hw_action, start_offset, 0);
 
 		/* Copy bytes one by one to avoid endianness problem */
 		addr_inline = MLX5_ADDR_OF(ste_double_action_insert_with_inline_v1,
 					   hw_action, inline_data);
-		memcpy(addr_inline, data_ptr, inline_data_sz);
+		memcpy(addr_inline, data_ptr - i * inline_data_sz, inline_data_sz);
 		hw_action += DR_STE_ACTION_DOUBLE_SZ;
-		data_ptr += inline_data_sz;
 		used_actions++;
 	}
 
-	/* Remove 2 extra bytes */
+	/* Remove first 2 extra bytes */
 	MLX5_SET(ste_single_action_remove_header_size_v1, hw_action, action_id,
 		 DR_STE_V1_ACTION_ID_REMOVE_BY_SIZE);
-	MLX5_SET(ste_single_action_remove_header_size_v1, hw_action, start_offset, data_sz / 2);
+	MLX5_SET(ste_single_action_remove_header_size_v1, hw_action, start_offset, 0);
 	/* The hardware expects here size in words (2 bytes) */
 	MLX5_SET(ste_single_action_remove_header_size_v1, hw_action, remove_size, 1);
 	used_actions++;
-- 
2.30.2



