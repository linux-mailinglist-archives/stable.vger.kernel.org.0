Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016924A953C
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 09:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345295AbiBDIgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 03:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357139AbiBDIgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 03:36:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8AEC061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 00:36:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EF9060EF9
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 08:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF2BC340F2;
        Fri,  4 Feb 2022 08:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643963769;
        bh=92vZB5pxxEIwaBBKzDqTDOmxroV5WQurH4z/9BocF28=;
        h=Subject:To:Cc:From:Date:From;
        b=hV+mQpIFXOFIdSfMGJGomN5vYoRdPZuGt9RXIvUelqH8q5+oRCrghv3BzHRIHRf/f
         IeSBv7J75Y6dJHeV9m5yKUWo3SwQflW5jlY1J8ZigZrI8FYCg6XM0EI/arC7gdY/JM
         BrvilBFXA+QSJ76uuaMr3gkQa+CTciqfycT4znz4=
Subject: FAILED: patch "[PATCH] net/mlx5e: TC, Reject rules with forward and drop actions" failed to apply to 5.4-stable tree
To:     roid@nvidia.com, ozsh@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Feb 2022 09:35:49 +0100
Message-ID: <16439637499195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 5623ef8a118838aae65363750dfafcba734dc8cb Mon Sep 17 00:00:00 2001
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
index 671f76c350db..4c6e3c26c1ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3191,6 +3191,12 @@ actions_match_supported(struct mlx5e_priv *priv,
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

