Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DB32788B0
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgIYMut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729107AbgIYMus (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50A682072E;
        Fri, 25 Sep 2020 12:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038247;
        bh=eO1AFOk0UMgBCNN0Cnq4DsxNzUIiz2Z5/KfS8R/unzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNnZgLaNOl5DqrmpqMzobSOlDuGb5dnqo1Psh4OwoWQwcso9JgMJ0URNY9uRlEKcP
         W/NqyXD6FAQjA44h8lX/+VkXBr+sxjJpjYYJVDQfDH0aa8742HuXCRgwf7fxj8jRSR
         fsRUYaxDKlLfvS7XAg1pspG6YDIrUDEH83qFbHtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.8 56/56] net/mlx5e: Fix endianness when calculating pedit mask first bit
Date:   Fri, 25 Sep 2020 14:48:46 +0200
Message-Id: <20200925124736.178223285@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 82198d8bcdeff01d19215d712aa55031e21bccbc ]

The field mask value is provided in network byte order and has to
be converted to host byte order before calculating pedit mask
first bit.

Fixes: 88f30bbcbaaa ("net/mlx5e: Bit sized fields rewrite support")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |   34 ++++++++++++++----------
 1 file changed, 21 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2731,6 +2731,22 @@ static struct mlx5_fields fields[] = {
 	OFFLOAD(UDP_DPORT, 16, U16_MAX, udp.dest,   0, udp_dport),
 };
 
+static unsigned long mask_to_le(unsigned long mask, int size)
+{
+	__be32 mask_be32;
+	__be16 mask_be16;
+
+	if (size == 32) {
+		mask_be32 = (__force __be32)(mask);
+		mask = (__force unsigned long)cpu_to_le32(be32_to_cpu(mask_be32));
+	} else if (size == 16) {
+		mask_be32 = (__force __be32)(mask);
+		mask_be16 = *(__be16 *)&mask_be32;
+		mask = (__force unsigned long)cpu_to_le16(be16_to_cpu(mask_be16));
+	}
+
+	return mask;
+}
 static int offload_pedit_fields(struct mlx5e_priv *priv,
 				int namespace,
 				struct pedit_headers_action *hdrs,
@@ -2744,9 +2760,7 @@ static int offload_pedit_fields(struct m
 	u32 *s_masks_p, *a_masks_p, s_mask, a_mask;
 	struct mlx5e_tc_mod_hdr_acts *mod_acts;
 	struct mlx5_fields *f;
-	unsigned long mask;
-	__be32 mask_be32;
-	__be16 mask_be16;
+	unsigned long mask, field_mask;
 	int err;
 	u8 cmd;
 
@@ -2812,14 +2826,7 @@ static int offload_pedit_fields(struct m
 		if (skip)
 			continue;
 
-		if (f->field_bsize == 32) {
-			mask_be32 = (__force __be32)(mask);
-			mask = (__force unsigned long)cpu_to_le32(be32_to_cpu(mask_be32));
-		} else if (f->field_bsize == 16) {
-			mask_be32 = (__force __be32)(mask);
-			mask_be16 = *(__be16 *)&mask_be32;
-			mask = (__force unsigned long)cpu_to_le16(be16_to_cpu(mask_be16));
-		}
+		mask = mask_to_le(mask, f->field_bsize);
 
 		first = find_first_bit(&mask, f->field_bsize);
 		next_z = find_next_zero_bit(&mask, f->field_bsize, first);
@@ -2850,9 +2857,10 @@ static int offload_pedit_fields(struct m
 		if (cmd == MLX5_ACTION_TYPE_SET) {
 			int start;
 
+			field_mask = mask_to_le(f->field_mask, f->field_bsize);
+
 			/* if field is bit sized it can start not from first bit */
-			start = find_first_bit((unsigned long *)&f->field_mask,
-					       f->field_bsize);
+			start = find_first_bit(&field_mask, f->field_bsize);
 
 			MLX5_SET(set_action_in, action, offset, first - start);
 			/* length is num of bits to be written, zero means length of 32 */


