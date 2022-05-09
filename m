Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65F751FA27
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiEIKqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiEIKqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:46:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DAB26BCBB
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:41:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B1FA60FD7
        for <stable@vger.kernel.org>; Mon,  9 May 2022 10:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4672FC385AF;
        Mon,  9 May 2022 10:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652092867;
        bh=N28QuKaxMSkJ37vbqXk+tCb4eDHQGrZP6267p3LO80A=;
        h=Subject:To:Cc:From:Date:From;
        b=tQDtwNHsdqyFa/TKOaD0mhnJbbWzc05njlqgIuSFIPx7RhbY6IyVWhFhEFf4aQoJ6
         3fr/n3dco/2kucfM9oVb7pY35gD3o90NLeF0MbHloTTchkPVNu1gjsK9JCY2kHAL7k
         YdsP0FhD73zvzoKlkXe1dGogXRHw1rPx5CN7wBR0=
Subject: FAILED: patch "[PATCH] net/mlx5e: Don't match double-vlan packets if cvlan is not" failed to apply to 4.19-stable tree
To:     vladbu@nvidia.com, maord@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 12:38:39 +0200
Message-ID: <1652092719172220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ada09af92e621ab500dd80a16d1d0299a18a1180 Mon Sep 17 00:00:00 2001
From: Vlad Buslov <vladbu@nvidia.com>
Date: Mon, 28 Mar 2022 15:54:52 +0300
Subject: [PATCH] net/mlx5e: Don't match double-vlan packets if cvlan is not
 set

Currently, match VLAN rule also matches packets that have multiple VLAN
headers. This behavior is similar to buggy flower classifier behavior that
has recently been fixed. Fix the issue by matching on
outer_second_cvlan_tag with value 0 which will cause the HW to verify the
packet doesn't contain second vlan header.

Fixes: 699e96ddf47f ("net/mlx5e: Support offloading tc double vlan headers match")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e3fc15ae7bb1..ac0f73074f7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2459,6 +2459,17 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
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

