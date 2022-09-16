Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4685BAAA9
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiIPKZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiIPKXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:23:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03E1AE228;
        Fri, 16 Sep 2022 03:14:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56161629FE;
        Fri, 16 Sep 2022 10:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4993BC433D6;
        Fri, 16 Sep 2022 10:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323232;
        bh=PRBPCyadRuV9zkGr+EwMDIzNXZl0sf3bWmirgArukng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxzxAfFYDW9RK8b47wruntH4kqIbzFHx1JaLs0ijIfmH89HC9DVNGJYi8tr1jKRoL
         2LhrSvXfrYS+2YXGJMbt9WuGvHWVuA4QM4On8cSYq6yiMlaNZk2Ogp1Vx+9i+VpUVH
         Xl7hTcuyfHoQr+etuGiyMG2+rfy4f2+ReB9h2xIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 02/38] net/mlx5: Introduce ifc bits for using software vhca id
Date:   Fri, 16 Sep 2022 12:08:36 +0200
Message-Id: <20220916100448.537727730@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 0372c546eca575445331c0ad8902210b70be6d61 ]

Introduce ifc related stuff to enable using software vhca id
functionality.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 9ca05b0f27de ("RDMA/mlx5: Rely on RoCE fw cap instead of devlink when setting profile")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index fd7d083a34d33..6d57e5ec9718d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1804,7 +1804,14 @@ struct mlx5_ifc_cmd_hca_cap_2_bits {
 	u8	   max_reformat_remove_size[0x8];
 	u8	   max_reformat_remove_offset[0x8];
 
-	u8	   reserved_at_c0[0x740];
+	u8	   reserved_at_c0[0x160];
+
+	u8	   reserved_at_220[0x1];
+	u8	   sw_vhca_id_valid[0x1];
+	u8	   sw_vhca_id[0xe];
+	u8	   reserved_at_230[0x10];
+
+	u8	   reserved_at_240[0x5c0];
 };
 
 enum mlx5_ifc_flow_destination_type {
@@ -3715,6 +3722,11 @@ struct mlx5_ifc_rmpc_bits {
 	struct mlx5_ifc_wq_bits wq;
 };
 
+enum {
+	VHCA_ID_TYPE_HW = 0,
+	VHCA_ID_TYPE_SW = 1,
+};
+
 struct mlx5_ifc_nic_vport_context_bits {
 	u8         reserved_at_0[0x5];
 	u8         min_wqe_inline_mode[0x3];
@@ -3731,8 +3743,8 @@ struct mlx5_ifc_nic_vport_context_bits {
 	u8         event_on_mc_address_change[0x1];
 	u8         event_on_uc_address_change[0x1];
 
-	u8         reserved_at_40[0xc];
-
+	u8         vhca_id_type[0x1];
+	u8         reserved_at_41[0xb];
 	u8	   affiliation_criteria[0x4];
 	u8	   affiliated_vhca_id[0x10];
 
@@ -7189,7 +7201,12 @@ struct mlx5_ifc_init_hca_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x40];
+	u8         reserved_at_40[0x20];
+
+	u8         reserved_at_60[0x2];
+	u8         sw_vhca_id[0xe];
+	u8         reserved_at_70[0x10];
+
 	u8	   sw_owner_id[4][0x20];
 };
 
-- 
2.35.1



