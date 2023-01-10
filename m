Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51B366486D
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238941AbjAJSLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239066AbjAJSKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:10:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7637E2DC3
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:09:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FFE0B818E0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9A6C433EF;
        Tue, 10 Jan 2023 18:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374138;
        bh=wT79O2IlfnsJYtG+7jIgx1drQPzfSonDpZSZ/05KOYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fngICZgyfKWHiaMDNWHV01ji4RfeOaeih5LpLlIUJ9T8eRdNXVf5uJYS/ZctMq6K4
         4+szV7HhYLPeBK0wxA5uKSQbuCLC6WuwmxRBYr4Ic37W81xrXst1SXVrBNmkse97zL
         1QbQoFFQIcq8fKidVVzdwqa3OtBehYny3Owc812w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 059/148] net/mlx5e: Set geneve_tlv_option_0_exist when matching on geneve option
Date:   Tue, 10 Jan 2023 19:02:43 +0100
Message-Id: <20230110180019.096206261@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit e54638a8380bd9c146a883035fffd0a821813682 ]

The cited patch added support of matching on geneve option by setting
geneve_tlv_option_0_data mask and key but didn't set geneve_tlv_option_0_exist
bit which is required on some HWs when matching geneve_tlv_option_0_data parameter,
this may cause in some cases for packets to wrongly match on rules with different
geneve option.

Example of such case is packet with geneve_tlv_object class=789 and data=456
will wrongly match on rule with match geneve_tlv_object class=123 and data=456.

Fix it by setting geneve_tlv_option_0_exist bit when supported by the HW when matching
on geneve_tlv_option_0_data parameter.

Fixes: 9272e3df3023 ("net/mlx5e: Geneve, Add support for encap/decap flows offload")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
index f5b26f5a7de4..054d80c4e65c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
@@ -273,6 +273,11 @@ static int mlx5e_tc_tun_parse_geneve_options(struct mlx5e_priv *priv,
 		 geneve_tlv_option_0_data, be32_to_cpu(opt_data_key));
 	MLX5_SET(fte_match_set_misc3, misc_3_c,
 		 geneve_tlv_option_0_data, be32_to_cpu(opt_data_mask));
+	if (MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev,
+				       ft_field_support.geneve_tlv_option_0_exist)) {
+		MLX5_SET_TO_ONES(fte_match_set_misc, misc_c, geneve_tlv_option_0_exist);
+		MLX5_SET_TO_ONES(fte_match_set_misc, misc_v, geneve_tlv_option_0_exist);
+	}
 
 	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_3;
 
-- 
2.35.1



