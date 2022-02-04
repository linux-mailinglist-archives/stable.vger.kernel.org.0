Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9CB4A952B
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 09:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357024AbiBDIes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 03:34:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60452 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiBDIer (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 03:34:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBAE2B83551
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 08:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2EBC004E1;
        Fri,  4 Feb 2022 08:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643963685;
        bh=qIFowo4K7B+bDIoMWW4d+55LjIcC7qN4ETGeNdxhmmQ=;
        h=Subject:To:Cc:From:Date:From;
        b=rkn1NGAIyN4EGG6i3fVZRWpXy8lAZyaw6gdWSlYNcEbsYxqfp5ZwXNjoXgzKnibml
         DgYL3ZLRHgHypG/pXL+pDOfTn/N6vJgdAEFL4mnWpvVRt00zCvm7nYqKQyk5Kyu98s
         8VnR+XlOVDkzSJ1PpuYql36hoPC1Rr5C903hzL5g=
Subject: FAILED: patch "[PATCH] net/mlx5e: TC, Reject rules with drop and modify hdr action" failed to apply to 4.19-stable tree
To:     roid@nvidia.com, maord@nvidia.com, ozsh@nvidia.com,
        saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Feb 2022 09:34:34 +0100
Message-ID: <164396367495182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

