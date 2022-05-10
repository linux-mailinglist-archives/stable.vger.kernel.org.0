Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1BD95218B6
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243651AbiEJNjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244767AbiEJNiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00DE5838D;
        Tue, 10 May 2022 06:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 730C2B81DA8;
        Tue, 10 May 2022 13:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91E5C385C6;
        Tue, 10 May 2022 13:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189178;
        bh=Q7tCidXFNBg5wGReamRFoXUum6q7cRGXz98pfpLdfkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8kgaD5BUlRTrd82qnwJjidqNEbSCCgYKnRhrE8Nw6EDQveFECfsd0YPSFsYMQjJF
         sQhuSBF8otPg5VpKeznAeF+ReVekZ2FZIx9chiRn6Rr26SJDlw/sXs3eHCKvCG/utF
         Sqa+OhA0O9G3qbxI/50Mj/KN4m69TOufgHQtcm30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 38/70] net/mlx5e: Dont match double-vlan packets if cvlan is not set
Date:   Tue, 10 May 2022 15:07:57 +0200
Message-Id: <20220510130733.979174634@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
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
@@ -2396,6 +2396,17 @@ static int __parse_cls_flower(struct mlx
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


