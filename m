Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC6213F780
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732697AbgAPTMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:12:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387630AbgAPQ77 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:59:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B78C20730;
        Thu, 16 Jan 2020 16:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193998;
        bh=KjvFMa7OZIvtEkWLUk4GLsSCtEY8T/9x0pX/63vGGII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTSgCJDxyAJkHSrbnPoFVUs4Hh2nEXLW7tEOnVvbMPlLbRaxys7utsfM0s/Stph49
         rt9Z9rJYghonltAZPek053MN8Xb6m9ZHBK53RZkuaBAD0j5NKtgCpgWKmBcfjJinWH
         jurEeSYnQkLXJjcgU8mlhUgHO5qxt3XDQYgJKMfY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 126/671] IB/mlx5: Don't override existing ip_protocol
Date:   Thu, 16 Jan 2020 11:50:35 -0500
Message-Id: <20200116165940.10720-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

[ Upstream commit 6113cc44015b41ca51c0a76fed82522b68108dac ]

Two flow specifications can set the ip protocol field in
the flow table entry:

1) IB_FLOW_SPEC_TCP/UDP/GRE - set the ip protocol accordingly.
2) IB_FLOW_SPEC_IPV4/6 - has ip_protocol field for users
who want to receive specific L4 packets.

We need to avoid overriding of the ip_protocol with zeros,
in case that the user first put the L4 specification and
only then the L3.

Fixes: ca0d47538528b ('IB/mlx5: Add support in TOS and protocol to flow steering')
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 53 +++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index df5be462dd28..2db34f7b5ced 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2390,10 +2390,29 @@ static u8 get_match_criteria_enable(u32 *match_criteria)
 	return match_criteria_enable;
 }
 
-static void set_proto(void *outer_c, void *outer_v, u8 mask, u8 val)
+static int set_proto(void *outer_c, void *outer_v, u8 mask, u8 val)
 {
-	MLX5_SET(fte_match_set_lyr_2_4, outer_c, ip_protocol, mask);
-	MLX5_SET(fte_match_set_lyr_2_4, outer_v, ip_protocol, val);
+	u8 entry_mask;
+	u8 entry_val;
+	int err = 0;
+
+	if (!mask)
+		goto out;
+
+	entry_mask = MLX5_GET(fte_match_set_lyr_2_4, outer_c,
+			      ip_protocol);
+	entry_val = MLX5_GET(fte_match_set_lyr_2_4, outer_v,
+			     ip_protocol);
+	if (!entry_mask) {
+		MLX5_SET(fte_match_set_lyr_2_4, outer_c, ip_protocol, mask);
+		MLX5_SET(fte_match_set_lyr_2_4, outer_v, ip_protocol, val);
+		goto out;
+	}
+	/* Don't override existing ip protocol */
+	if (mask != entry_mask || val != entry_val)
+		err = -EINVAL;
+out:
+	return err;
 }
 
 static void set_flow_label(void *misc_c, void *misc_v, u32 mask, u32 val,
@@ -2597,8 +2616,10 @@ static int parse_flow_attr(struct mlx5_core_dev *mdev, u32 *match_c,
 		set_tos(headers_c, headers_v,
 			ib_spec->ipv4.mask.tos, ib_spec->ipv4.val.tos);
 
-		set_proto(headers_c, headers_v,
-			  ib_spec->ipv4.mask.proto, ib_spec->ipv4.val.proto);
+		if (set_proto(headers_c, headers_v,
+			      ib_spec->ipv4.mask.proto,
+			      ib_spec->ipv4.val.proto))
+			return -EINVAL;
 		break;
 	case IB_FLOW_SPEC_IPV6:
 		if (FIELDS_NOT_SUPPORTED(ib_spec->ipv6.mask, LAST_IPV6_FIELD))
@@ -2637,9 +2658,10 @@ static int parse_flow_attr(struct mlx5_core_dev *mdev, u32 *match_c,
 			ib_spec->ipv6.mask.traffic_class,
 			ib_spec->ipv6.val.traffic_class);
 
-		set_proto(headers_c, headers_v,
-			  ib_spec->ipv6.mask.next_hdr,
-			  ib_spec->ipv6.val.next_hdr);
+		if (set_proto(headers_c, headers_v,
+			      ib_spec->ipv6.mask.next_hdr,
+			      ib_spec->ipv6.val.next_hdr))
+			return -EINVAL;
 
 		set_flow_label(misc_params_c, misc_params_v,
 			       ntohl(ib_spec->ipv6.mask.flow_label),
@@ -2660,10 +2682,8 @@ static int parse_flow_attr(struct mlx5_core_dev *mdev, u32 *match_c,
 					 LAST_TCP_UDP_FIELD))
 			return -EOPNOTSUPP;
 
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_protocol,
-			 0xff);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_protocol,
-			 IPPROTO_TCP);
+		if (set_proto(headers_c, headers_v, 0xff, IPPROTO_TCP))
+			return -EINVAL;
 
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c, tcp_sport,
 			 ntohs(ib_spec->tcp_udp.mask.src_port));
@@ -2680,10 +2700,8 @@ static int parse_flow_attr(struct mlx5_core_dev *mdev, u32 *match_c,
 					 LAST_TCP_UDP_FIELD))
 			return -EOPNOTSUPP;
 
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_protocol,
-			 0xff);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_protocol,
-			 IPPROTO_UDP);
+		if (set_proto(headers_c, headers_v, 0xff, IPPROTO_UDP))
+			return -EINVAL;
 
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c, udp_sport,
 			 ntohs(ib_spec->tcp_udp.mask.src_port));
@@ -2699,6 +2717,9 @@ static int parse_flow_attr(struct mlx5_core_dev *mdev, u32 *match_c,
 		if (ib_spec->gre.mask.c_ks_res0_ver)
 			return -EOPNOTSUPP;
 
+		if (set_proto(headers_c, headers_v, 0xff, IPPROTO_GRE))
+			return -EINVAL;
+
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_protocol,
 			 0xff);
 		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_protocol,
-- 
2.20.1

