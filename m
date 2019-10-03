Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71815CA936
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404091AbfJCQjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403971AbfJCQjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:39:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39C48215EA;
        Thu,  3 Oct 2019 16:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120742;
        bh=5q0PLQdi6AJ6C8Dj+RBxjxqThfLtkDeN6xsz6UwYsPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2xHVRxBQiHwg3ZGsPk+AMz64HVTWtViOiIi5SESBDN5ITlBqY7KxxHBfj4x31j0d
         XYIE27t33gfYmXzvPOLcWsqNXHYwcdvO0UuBCqU6bho4MkYev0qq48EcAhUx0byNcS
         RxXqOJ8yio4/QWsXQUvfMxDYcFx784Ry0R9Mmz+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Linkin <dmitrolin@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.3 021/344] net/mlx5e: Fix matching on tunnel addresses type
Date:   Thu,  3 Oct 2019 17:49:46 +0200
Message-Id: <20191003154542.166889134@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

[ Upstream commit fe1587a7de94912ed75ba5ddbfabf0741f9f8239 ]

In mlx5 parse_tunnel_attr() function dispatch on encap IP address type
is performed by directly checking flow_rule_match_key() on
FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS, and then on
FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS. However, since those are stored in
union, first check is always true if any type of encap address is set,
which leads to IPv6 tunnel encap address being parsed as IPv4 by mlx5.
Determine correct IP address type by checking control key first and if
it set, take address type from match.key->addr_type.

Fixes: d1bda7eecd88 ("net/mlx5e: Allow matching only enc_key_id/enc_dst_port for decapsulation action")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |   97 ++++++++++++++----------
 1 file changed, 57 insertions(+), 40 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1369,46 +1369,63 @@ static int parse_tunnel_attr(struct mlx5
 		return err;
 	}
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS)) {
-		struct flow_match_ipv4_addrs match;
-
-		flow_rule_match_enc_ipv4_addrs(rule, &match);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c,
-			 src_ipv4_src_ipv6.ipv4_layout.ipv4,
-			 ntohl(match.mask->src));
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v,
-			 src_ipv4_src_ipv6.ipv4_layout.ipv4,
-			 ntohl(match.key->src));
-
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c,
-			 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
-			 ntohl(match.mask->dst));
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v,
-			 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
-			 ntohl(match.key->dst));
-
-		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ethertype);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype, ETH_P_IP);
-	} else if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS)) {
-		struct flow_match_ipv6_addrs match;
-
-		flow_rule_match_enc_ipv6_addrs(rule, &match);
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
-				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
-		       &match.mask->src, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
-				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
-		       &match.key->src, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
-
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
-				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       &match.mask->dst, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
-				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       &match.key->dst, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
-
-		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ethertype);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype, ETH_P_IPV6);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
+		struct flow_match_control match;
+		u16 addr_type;
+
+		flow_rule_match_enc_control(rule, &match);
+		addr_type = match.key->addr_type;
+
+		/* For tunnel addr_type used same key id`s as for non-tunnel */
+		if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+			struct flow_match_ipv4_addrs match;
+
+			flow_rule_match_enc_ipv4_addrs(rule, &match);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
+				 src_ipv4_src_ipv6.ipv4_layout.ipv4,
+				 ntohl(match.mask->src));
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
+				 src_ipv4_src_ipv6.ipv4_layout.ipv4,
+				 ntohl(match.key->src));
+
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
+				 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
+				 ntohl(match.mask->dst));
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
+				 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
+				 ntohl(match.key->dst));
+
+			MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c,
+					 ethertype);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
+				 ETH_P_IP);
+		} else if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+			struct flow_match_ipv6_addrs match;
+
+			flow_rule_match_enc_ipv6_addrs(rule, &match);
+			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
+					    src_ipv4_src_ipv6.ipv6_layout.ipv6),
+			       &match.mask->src, MLX5_FLD_SZ_BYTES(ipv6_layout,
+								   ipv6));
+			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
+					    src_ipv4_src_ipv6.ipv6_layout.ipv6),
+			       &match.key->src, MLX5_FLD_SZ_BYTES(ipv6_layout,
+								  ipv6));
+
+			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
+					    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+			       &match.mask->dst, MLX5_FLD_SZ_BYTES(ipv6_layout,
+								   ipv6));
+			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
+					    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+			       &match.key->dst, MLX5_FLD_SZ_BYTES(ipv6_layout,
+								  ipv6));
+
+			MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c,
+					 ethertype);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
+				 ETH_P_IPV6);
+		}
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IP)) {


