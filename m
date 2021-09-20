Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4563411093
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 09:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbhITH7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 03:59:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231350AbhITH7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 03:59:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 617F460FC1;
        Mon, 20 Sep 2021 07:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632124699;
        bh=YI50fz0l0Ra6OnXejsVP3PVE+TKE93FUVxpH+nGCjuA=;
        h=Subject:To:Cc:From:Date:From;
        b=OdFjXfJhgDU/GPvRM7cmegdx7IepOAoht671x4pevW56Tf2Y/4DZzjOWrDDLKXQKz
         FMc0/lAAQjDuKE3WrtRcrsBFDWoxlGa8WoypjHKi8yFC7eVKRzxOEnNYQkn3ISFqxy
         IC3DNy5UdbPsYi5/uBoAnXL3iG0ov1cjDuWlihdQ=
Subject: FAILED: patch "[PATCH] net/mlx5: FWTrace, cancel work on alloc pd error flow" failed to apply to 4.19-stable tree
To:     saeedm@nvidia.com, ayal@nvidia.com, pavel@denx.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Sep 2021 09:58:17 +0200
Message-ID: <1632124697101188@kroah.com>
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

From dfe6fd72b5f1878b16aa2c8603e031bbcd66b96d Mon Sep 17 00:00:00 2001
From: Saeed Mahameed <saeedm@nvidia.com>
Date: Wed, 18 Aug 2021 13:09:26 -0700
Subject: [PATCH] net/mlx5: FWTrace, cancel work on alloc pd error flow

Handle error flow on mlx5_core_alloc_pd() failure,
read_fw_strings_work must be canceled.

Fixes: c71ad41ccb0c ("net/mlx5: FW tracer, events handling")
Reported-by: Pavel Machek (CIP) <pavel@denx.de>
Suggested-by: Pavel Machek (CIP) <pavel@denx.de>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 3f8a98093f8c..f9cf9fb31547 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -1007,7 +1007,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 	err = mlx5_core_alloc_pd(dev, &tracer->buff.pdn);
 	if (err) {
 		mlx5_core_warn(dev, "FWTracer: Failed to allocate PD %d\n", err);
-		return err;
+		goto err_cancel_work;
 	}
 
 	err = mlx5_fw_tracer_create_mkey(tracer);
@@ -1031,6 +1031,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 	mlx5_core_destroy_mkey(dev, &tracer->buff.mkey);
 err_dealloc_pd:
 	mlx5_core_dealloc_pd(dev, tracer->buff.pdn);
+err_cancel_work:
 	cancel_work_sync(&tracer->read_fw_strings_work);
 	return err;
 }

