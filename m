Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5F94C4914
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242156AbiBYPeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242155AbiBYPeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:34:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31DCC24B7
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:33:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3343B611CB
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB82C340E7;
        Fri, 25 Feb 2022 15:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645803209;
        bh=6Jj4AQo1Teyi+SFoD2yY65q9acjaY2/if1+wf4Y8b1w=;
        h=Subject:To:Cc:From:Date:From;
        b=jU+jyu0JmGCE0y0rs8O0gbtYpwfmHoUWNDt6iF8C1DHr/71nQRre2pkb7IIOG7n8s
         xt+KGzDyhsMewn6kI0CWNeN7eCRTXy1KfsrbtRbMV+JpVmsBWH5z8LjVXakxufCHSj
         QwTErEBagPzVF+dNZEvgTOO16lbQpSAl+1ZiY8P0=
Subject: FAILED: patch "[PATCH] net/mlx5e: TC, Reject rules with drop and modify hdr action" failed to apply to 4.14-stable tree
To:     roid@nvidia.com, maord@nvidia.com, ozsh@nvidia.com,
        saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:33:12 +0100
Message-ID: <164580319220918@kroah.com>
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


The patch below does not apply to the 4.14-stable tree.
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

