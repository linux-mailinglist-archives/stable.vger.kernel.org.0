Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206344C490F
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241985AbiBYPdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242133AbiBYPdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:33:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB273181E73
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:33:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 898E0611CB
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93396C340F0;
        Fri, 25 Feb 2022 15:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645803191;
        bh=ccjAVDxFszFJHnE8uuTOKzu0ziGT9W5ekIdCzBkW9KY=;
        h=Subject:To:Cc:From:Date:From;
        b=QaNvrGJ1QTgLvYthsMPHwqw652/S/TSam447eJ5T6KcRBalEg/hMmmrYTqmKM8jKV
         2rGn/jfrA9W2J8Ijh1pSmdlFHv9YP/zIoeby/LH9cu4R+3/3KVVD+8x9BjoPiCejkS
         l0l+zKI3UVpj3RNBXyJqXsoD6RzJVhZdCMmV7WMY=
Subject: FAILED: patch "[PATCH] net/mlx5e: TC, Reject rules with forward and drop actions" failed to apply to 4.19-stable tree
To:     roid@nvidia.com, ozsh@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:32:55 +0100
Message-ID: <164580317513260@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3d65492a86d4e6675734646929759138a023d914 Mon Sep 17 00:00:00 2001
From: Roi Dayan <roid@nvidia.com>
Date: Mon, 17 Jan 2022 15:00:30 +0200
Subject: [PATCH] net/mlx5e: TC, Reject rules with forward and drop actions

Such rules are redundant but allowed and passed to the driver.
The driver does not support offloading such rules so return an error.

Fixes: 03a9d11e6eeb ("net/mlx5e: Add TC drop and mirred/redirect action parsing for SRIOV offloads")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 34700cf1285e..b27532a9301e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3204,6 +3204,12 @@ actions_match_supported(struct mlx5e_priv *priv,
 		return false;
 	}
 
+	if (!(~actions &
+	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
+		NL_SET_ERR_MSG_MOD(extack, "Rule cannot support forward+drop action");
+		return false;
+	}
+
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
 	    actions & MLX5_FLOW_CONTEXT_ACTION_DROP) {
 		NL_SET_ERR_MSG_MOD(extack, "Drop with modify header action is not supported");

