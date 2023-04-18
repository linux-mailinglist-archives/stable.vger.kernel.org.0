Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5F26E62BA
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbjDRMe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbjDRMes (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:34:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6682118F1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:34:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1167A6325E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20953C4339B;
        Tue, 18 Apr 2023 12:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821285;
        bh=DUQqNQJp71jz31Ay0zSawdv181CMoOcHC6gpX7cz7uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bxPxeEF+ilHlrZmMOxD9rFQI48+qeCOLM6nT7tiO6zP/DonBVjQPj+YyYE3+GI9j4
         XCPdHq1z69g8pXPsBCTlj+0CPW6ZyxAzO83Qia+pzzteeApz8txrCxPvmu81M2fq/u
         NbQ36HM7byrXYkXcMxCcPwqqc2itj6gdol0Je9ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Meir Lichtinger <meirl@mellanox.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/124] IB/mlx5: Add support for NDR link speed
Date:   Tue, 18 Apr 2023 14:21:28 +0200
Message-Id: <20230418120312.355222787@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meir Lichtinger <meirl@mellanox.com>

[ Upstream commit f946e45f59ef01ff54ffb3b1eba3a8e7915e7326 ]

The IBTA specification has new speed - NDR. That speed supports signaling
rate of 100Gb. mlx5 IB driver translates link modes reported by ConnectX
device to IB speed and width. Added translation of new 100Gb, 200Gb and
400Gb link modes to NDR IB type and width of x1, x2 or x4 respectively.

Link: https://lore.kernel.org/r/20201026133738.1340432-3-leon@kernel.org
Signed-off-by: Meir Lichtinger <meirl@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 88c9483faf15 ("IB/mlx5: Add support for 400G_8X lane speed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index eb69bec77e5d4..638da09ff8380 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -425,10 +425,22 @@ static int translate_eth_ext_proto_oper(u32 eth_proto_oper, u16 *active_speed,
 		*active_width = IB_WIDTH_2X;
 		*active_speed = IB_SPEED_HDR;
 		break;
+	case MLX5E_PROT_MASK(MLX5E_100GAUI_1_100GBASE_CR_KR):
+		*active_width = IB_WIDTH_1X;
+		*active_speed = IB_SPEED_NDR;
+		break;
 	case MLX5E_PROT_MASK(MLX5E_200GAUI_4_200GBASE_CR4_KR4):
 		*active_width = IB_WIDTH_4X;
 		*active_speed = IB_SPEED_HDR;
 		break;
+	case MLX5E_PROT_MASK(MLX5E_200GAUI_2_200GBASE_CR2_KR2):
+		*active_width = IB_WIDTH_2X;
+		*active_speed = IB_SPEED_NDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_400GAUI_4_400GBASE_CR4_KR4):
+		*active_width = IB_WIDTH_4X;
+		*active_speed = IB_SPEED_NDR;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.39.2



