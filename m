Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7807A4C49E8
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 17:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242537AbiBYP7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242434AbiBYP7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:59:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3921DF856
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:59:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85946B83278
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E41C340F0;
        Fri, 25 Feb 2022 15:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645804757;
        bh=JGkVmkcT1WVerDI8zHppnAn9jcLpKAWSqI+yRcn5vbE=;
        h=Subject:To:Cc:From:Date:From;
        b=G4fY1W3biYXQvjaKB8Qh4tCFtOZXpBImjZUhQXPJDVO6ZBNJeDqNEUBLmR4P2RQSo
         vaHtIJd+zFqZmxyGVQpB/xmKL5GzzrpTTc0OTWBhIyG3ZG441VN8/ePPyZ9qFYAwOW
         njuBNbzfwKFTO9RMiIn7JHm2XYXZhVXnZXTNt9Do=
Subject: FAILED: patch "[PATCH] net/mlx5e: TC, Skip redundant ct clear actions" failed to apply to 5.16-stable tree
To:     roid@nvidia.com, lariel@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:59:06 +0100
Message-ID: <1645804746127153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fb7e76ea3f3b6238dda2f19a4212052d2caf00aa Mon Sep 17 00:00:00 2001
From: Roi Dayan <roid@nvidia.com>
Date: Thu, 3 Feb 2022 09:42:19 +0200
Subject: [PATCH] net/mlx5e: TC, Skip redundant ct clear actions

Offload of ct clear action is just resetting the reg_c register.
It's done by allocating modify hdr resources which is limited.
Doing it multiple times is redundant and wasting modify hdr resources
and if resources depleted the driver will fail offloading the rule.
Ignore redundant ct clear actions after the first one.

Fixes: 806401c20a0f ("net/mlx5e: CT, Fix multiple allocations and memleak of mod acts")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 26efa33de56f..10a40487d536 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -16,6 +16,7 @@ struct mlx5e_tc_act_parse_state {
 	unsigned int num_actions;
 	struct mlx5e_tc_flow *flow;
 	struct netlink_ext_ack *extack;
+	bool ct_clear;
 	bool encap;
 	bool decap;
 	bool mpls_push;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
index 06ec30cdb269..58cc33f1363d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -27,8 +27,13 @@ tc_act_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
 		struct mlx5e_priv *priv,
 		struct mlx5_flow_attr *attr)
 {
+	bool clear_action = act->ct.action & TCA_CT_ACT_CLEAR;
 	int err;
 
+	/* It's redundant to do ct clear more than once. */
+	if (clear_action && parse_state->ct_clear)
+		return 0;
+
 	err = mlx5_tc_ct_parse_action(parse_state->ct_priv, attr,
 				      &attr->parse_attr->mod_hdr_acts,
 				      act, parse_state->extack);
@@ -40,6 +45,8 @@ tc_act_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
 	if (mlx5e_is_eswitch_flow(parse_state->flow))
 		attr->esw_attr->split_count = attr->esw_attr->out_count;
 
+	parse_state->ct_clear = clear_action;
+
 	return 0;
 }
 

