Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B0D52190B
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243921AbiEJNmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244773AbiEJNmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:42:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301AE6C0F6;
        Tue, 10 May 2022 06:30:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59E406181B;
        Tue, 10 May 2022 13:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6436CC385A6;
        Tue, 10 May 2022 13:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189429;
        bh=g61op7ZwhDPVP/2KksLP31NrhdNotYN2BThA5StsoMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xx74pf/g8WlazmaPNJIKWHGatsAOoqs89VyCIwHYMbaBv+eYLDgLNJxCzUXKqTbCI
         E3W6o263vw6+kVoJIJEzmTxeqbM+jYqokr6zqmgoZaCaOfkGsD4+I4xDLdQ8c+nA1t
         EdFfdCZEyKVHs+HH7b5M/r+MDk/qtcBN97JKYW2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 049/135] net/mlx5e: Dont match double-vlan packets if cvlan is not set
Date:   Tue, 10 May 2022 15:07:11 +0200
Message-Id: <20220510130741.805647965@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

commit ada09af92e621ab500dd80a16d1d0299a18a1180 upstream.

Currently, match VLAN rule also matches packets that have multiple VLAN
headers. This behavior is similar to buggy flower classifier behavior that
has recently been fixed. Fix the issue by matching on
outer_second_cvlan_tag with value 0 which will cause the HW to verify the
packet doesn't contain second vlan header.

Fixes: 699e96ddf47f ("net/mlx5e: Support offloading tc double vlan headers match")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2291,6 +2291,17 @@ static int __parse_cls_flower(struct mlx
 				 match.key->vlan_priority);
 
 			*match_level = MLX5_MATCH_L2;
+
+			if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CVLAN) &&
+			    match.mask->vlan_eth_type &&
+			    MLX5_CAP_FLOWTABLE_TYPE(priv->mdev,
+						    ft_field_support.outer_second_vid,
+						    fs_type)) {
+				MLX5_SET(fte_match_set_misc, misc_c,
+					 outer_second_cvlan_tag, 1);
+				spec->match_criteria_enable |=
+					MLX5_MATCH_MISC_PARAMETERS;
+			}
 		}
 	} else if (*match_level != MLX5_MATCH_NONE) {
 		/* cvlan_tag enabled in match criteria and


