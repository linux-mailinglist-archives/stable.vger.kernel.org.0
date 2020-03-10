Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAC8E17F89B
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgCJMt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:49:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727865AbgCJMt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:49:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D40A92467D;
        Tue, 10 Mar 2020 12:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844568;
        bh=UrxAyspyyacTQv+bvn17scVrUXsw8Wvec21zX9DJ9Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ro6bJQxRLdcD1PL85AxlMg/SeJgFWT7U3c3l7M4apFhPjDm+DVjmYv95q3GoosyTh
         5uBpg8E1zApAYgDbBfSeeLF3reWXZW7c2KvEsvwKTBVb+ahfMwplKLWFzLRE8FKjL8
         WjyeeHU89Deo5UcUk+qk2IvmX+tqqQChmCQP1/bI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hamdan Igbaria <hamdani@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/168] net/mlx5: DR, Fix matching on vport gvmi
Date:   Tue, 10 Mar 2020 13:38:06 +0100
Message-Id: <20200310123639.475255717@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamdan Igbaria <hamdani@mellanox.com>

[ Upstream commit 52d214976d4f64504c1bbb52d47b46a5a3d5ee42 ]

Set vport gvmi in the tag, only when source gvmi is set in the bit mask.

Fixes: 26d688e3 ("net/mlx5: DR, Add Steering entry (STE) utilities")
Signed-off-by: Hamdan Igbaria <hamdani@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 2739ed2a29111..841abe75652c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -2257,7 +2257,9 @@ static int dr_ste_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 	struct mlx5dr_cmd_vport_cap *vport_cap;
 	struct mlx5dr_domain *dmn = sb->dmn;
 	struct mlx5dr_cmd_caps *caps;
+	u8 *bit_mask = sb->bit_mask;
 	u8 *tag = hw_ste->tag;
+	bool source_gvmi_set;
 
 	DR_STE_SET_TAG(src_gvmi_qp, tag, source_qp, misc, source_sqn);
 
@@ -2278,7 +2280,8 @@ static int dr_ste_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 	if (!vport_cap)
 		return -EINVAL;
 
-	if (vport_cap->vport_gvmi)
+	source_gvmi_set = MLX5_GET(ste_src_gvmi_qp, bit_mask, source_gvmi);
+	if (vport_cap->vport_gvmi && source_gvmi_set)
 		MLX5_SET(ste_src_gvmi_qp, tag, source_gvmi, vport_cap->vport_gvmi);
 
 	misc->source_eswitch_owner_vhca_id = 0;
-- 
2.20.1



