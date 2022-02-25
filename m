Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0BA4C4916
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240536AbiBYPeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238931AbiBYPeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:34:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0403B289AF
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:33:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A861CB830B8
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED57AC340E7;
        Fri, 25 Feb 2022 15:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645803215;
        bh=LiCrPxOQ+2bpGpn3guB8JQHSXbTea5sq6LwBuEcPk7A=;
        h=Subject:To:Cc:From:Date:From;
        b=yOgjcYqOv+Em5bcER2AhXX64pHnM5NeqIavSONa+/8YZZGdSUUpMBxAo0AxRRVYB4
         WpSKlE9oNDZnBTgN0qjHwQtYyADQeqRvVRylLAokm2gyVmJXWX5s9Bjg6Od8YjHAkE
         0CIz1trkp190VwCDp1E7q/gURWF//rkJOXxrUzX8=
Subject: FAILED: patch "[PATCH] net/mlx5e: TC, Reject rules with drop and modify hdr action" failed to apply to 5.4-stable tree
To:     roid@nvidia.com, maord@nvidia.com, ozsh@nvidia.com,
        saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:33:13 +0100
Message-ID: <16458031932372@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 23216d387c40b090b221ad457c95912fb47eb11e Mon Sep 17 00:00:00 2001
From: Roi Dayan <roid@nvidia.com>
Date: Tue, 4 Jan 2022 10:38:02 +0200
Subject: [PATCH] net/mlx5e: TC, Reject rules with drop and modify hdr action

This kind of action is not supported by firmware and generates a
syndrome.

kernel: mlx5_core 0000:08:00.0: mlx5_cmd_check:777:(pid 102063): SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x8708c3)

Fixes: d7e75a325cb2 ("net/mlx5e: Add offloading of E-Switch TC pedit (header re-write) actions")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2022fa4a9598..34700cf1285e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3204,6 +3204,12 @@ actions_match_supported(struct mlx5e_priv *priv,
 		return false;
 	}
 
+	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
+	    actions & MLX5_FLOW_CONTEXT_ACTION_DROP) {
+		NL_SET_ERR_MSG_MOD(extack, "Drop with modify header action is not supported");
+		return false;
+	}
+
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
 	    !modify_header_match_supported(priv, &parse_attr->spec, flow_action,
 					   actions, ct_flow, ct_clear, extack))

