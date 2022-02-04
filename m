Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190DD4A952C
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 09:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357029AbiBDIew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 03:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357027AbiBDIev (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 03:34:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6736CC061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 00:34:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CCA7B835FD
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 08:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691C3C004E1;
        Fri,  4 Feb 2022 08:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643963689;
        bh=L76JRpJkMVOrfjMUl1lqsL9d7IaLUAi/GXU1Jm7gbeM=;
        h=Subject:To:Cc:From:Date:From;
        b=J66PzyeiaJQjw3EU7ImT7F/F+uxKX7t1z188Gb1lQ15bfMjbIkHW9CEE1be3U3gcC
         YGV3S3CWccXo7Z7+wU8pwr2FloefcTJPvkr0sU0duDErSoWtFrrXH1jGdt9Id9ebpr
         RG6z+AnNAxe8Q20uo8g5MMPb/qDiGoEpvXj5jev4=
Subject: FAILED: patch "[PATCH] net/mlx5e: TC, Reject rules with drop and modify hdr action" failed to apply to 5.10-stable tree
To:     roid@nvidia.com, maord@nvidia.com, ozsh@nvidia.com,
        saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Feb 2022 09:34:35 +0100
Message-ID: <164396367515297@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a2446bc77a16cefd27de712d28af2396d6287593 Mon Sep 17 00:00:00 2001
From: Roi Dayan <roid@nvidia.com>
Date: Tue, 4 Jan 2022 10:38:02 +0200
Subject: [PATCH] net/mlx5e: TC, Reject rules with drop and modify hdr action

This kind of action is not supported by firmware and generates a
syndrome.

kernel: mlx5_core 0000:08:00.0: mlx5_cmd_check:777:(pid 102063): SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x8708c3)

Fixes: d7e75a325cb2 ("net/mlx5e: Add offloading of E-Switch TC pedit (header re-write) actions")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3d908a7e1406..671f76c350db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3191,6 +3191,12 @@ actions_match_supported(struct mlx5e_priv *priv,
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

