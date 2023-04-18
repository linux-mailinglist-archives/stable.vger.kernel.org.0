Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212DB6E62BB
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbjDRMe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjDRMeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:34:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198A3B767
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:34:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0B7F6326C
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FC2C433EF;
        Tue, 18 Apr 2023 12:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821288;
        bh=EQ3gihb6Ff2FptoG0ltDjZrmF6w89IUzb4ypIn8FCTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wFMwIUjvX/p3Wqj8tx0EHEmnrLFu5KItRT2Umqzb3FkA0kGQYDtbf8tQh5nC6wljy
         5DdO2knfJ9K60/55EQfKprSt749wxz+MOP4jqghc0pBxO7Z5xx8iEidR4eEKUHwJjU
         kALLxyKU+I4WKGGpIpT+lG2ra2xJqGbxcf1oetfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maher Sanalla <msanalla@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/124] IB/mlx5: Add support for 400G_8X lane speed
Date:   Tue, 18 Apr 2023 14:21:29 +0200
Message-Id: <20230418120312.390105190@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 88c9483faf15ada14eca82714114656893063458 ]

Currently, when driver queries PTYS to report which link speed is being
used on its RoCE ports, it does not check the case of having 400Gbps
transmitted over 8 lanes. Thus it fails to report the said speed and
instead it defaults to report 10G over 4 lanes.

Add a check for the said speed when querying PTYS and report it back
correctly when needed.

Fixes: 08e8676f1607 ("IB/mlx5: Add support for 50Gbps per lane link modes")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/ec9040548d119d22557d6a4b4070d6f421701fd4.1678973994.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 638da09ff8380..5ef37902e96b5 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -437,6 +437,10 @@ static int translate_eth_ext_proto_oper(u32 eth_proto_oper, u16 *active_speed,
 		*active_width = IB_WIDTH_2X;
 		*active_speed = IB_SPEED_NDR;
 		break;
+	case MLX5E_PROT_MASK(MLX5E_400GAUI_8):
+		*active_width = IB_WIDTH_8X;
+		*active_speed = IB_SPEED_HDR;
+		break;
 	case MLX5E_PROT_MASK(MLX5E_400GAUI_4_400GBASE_CR4_KR4):
 		*active_width = IB_WIDTH_4X;
 		*active_speed = IB_SPEED_NDR;
-- 
2.39.2



