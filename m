Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A1B2D042B
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgLFLnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:43:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgLFLni (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:43:38 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 33/39] net/mlx5: DR, Proper handling of unsupported Connect-X6DX SW steering
Date:   Sun,  6 Dec 2020 12:17:37 +0100
Message-Id: <20201206111556.265344487@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
References: <20201206111554.677764505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit d421e466c2373095f165ddd25cbabd6c5b077928 ]

STEs format for Connect-X5 and Connect-X6DX different. Currently, on
Connext-X6DX the SW steering would break at some point when building STEs
w/o giving a proper error message. Fix this by checking the STE format of
the current device when initializing domain: add mlx5_ifc definitions for
Connect-X6DX SW steering, read FW capability to get the current format
version, and check this version when domain is being created.

Fixes: 26d688e33f88 ("net/mlx5: DR, Add Steering entry (STE) utilities")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c    |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c |    5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h  |    1 +
 include/linux/mlx5/mlx5_ifc.h                                |    9 ++++++++-
 4 files changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -92,6 +92,7 @@ int mlx5dr_cmd_query_device(struct mlx5_
 	caps->eswitch_manager	= MLX5_CAP_GEN(mdev, eswitch_manager);
 	caps->gvmi		= MLX5_CAP_GEN(mdev, vhca_id);
 	caps->flex_protocols	= MLX5_CAP_GEN(mdev, flex_parser_protocols);
+	caps->sw_format_ver	= MLX5_CAP_GEN(mdev, steering_format_version);
 
 	if (mlx5dr_matcher_supp_flex_parser_icmp_v4(caps)) {
 		caps->flex_parser_id_icmp_dw0 = MLX5_CAP_GEN(mdev, flex_parser_id_icmp_dw0);
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -223,6 +223,11 @@ static int dr_domain_caps_init(struct ml
 	if (ret)
 		return ret;
 
+	if (dmn->info.caps.sw_format_ver != MLX5_STEERING_FORMAT_CONNECTX_5) {
+		mlx5dr_err(dmn, "SW steering is not supported on this device\n");
+		return -EOPNOTSUPP;
+	}
+
 	ret = dr_domain_query_fdb_caps(mdev, dmn);
 	if (ret)
 		return ret;
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -613,6 +613,7 @@ struct mlx5dr_cmd_caps {
 	u8 max_ft_level;
 	u16 roce_min_src_udp;
 	u8 num_esw_ports;
+	u8 sw_format_ver;
 	bool eswitch_manager;
 	bool rx_sw_owner;
 	bool tx_sw_owner;
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1139,6 +1139,11 @@ enum mlx5_fc_bulk_alloc_bitmask {
 
 #define MLX5_FC_BULK_NUM_FCS(fc_enum) (MLX5_FC_BULK_SIZE_FACTOR * (fc_enum))
 
+enum {
+	MLX5_STEERING_FORMAT_CONNECTX_5   = 0,
+	MLX5_STEERING_FORMAT_CONNECTX_6DX = 1,
+};
+
 struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_0[0x30];
 	u8         vhca_id[0x10];
@@ -1419,7 +1424,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         general_obj_types[0x40];
 
-	u8         reserved_at_440[0x20];
+	u8         reserved_at_440[0x4];
+	u8         steering_format_version[0x4];
+	u8         create_qp_start_hint[0x18];
 
 	u8         reserved_at_460[0x3];
 	u8         log_max_uctx[0x5];


