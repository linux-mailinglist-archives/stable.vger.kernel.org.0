Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4854AAF31
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 13:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbiBFMeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 07:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiBFMeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 07:34:11 -0500
X-Greylist: delayed 641 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 04:34:09 PST
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC621C043182
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 04:34:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19D1AB80E0A
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 12:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389D0C340E9;
        Sun,  6 Feb 2022 12:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644150846;
        bh=Y37c9ooMRdTikOmpkJXO2xZ6lPkpKaTJ05X9ucwNoko=;
        h=Subject:To:Cc:From:Date:From;
        b=JOoKSP5hDBbL4YYPuHqMlKjpSCi3uh/Q7ShUglFVxb/WLKUMI1KxE0tG6SwZ/JP5A
         qxuN8/VF6dEfRyRJqCxibA0C2TXxZQhRuJX7ZoPe2D98aUSCEfkTyDmReRZqsgYj11
         2ZuUCSAO+4GLRxPV0j/75Zk+M24RSaH4zoH00/VU=
Subject: FAILED: patch "[PATCH] RDMA/mlx4: Don't continue event handler after memory" failed to apply to 4.9-stable tree
To:     leon@kernel.org, haakon.bugge@oracle.com, jgg@nvidia.com,
        leonro@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 06 Feb 2022 13:34:04 +0100
Message-ID: <164415084481176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f3136c4ce7acf64bee43135971ca52a880572e32 Mon Sep 17 00:00:00 2001
From: Leon Romanovsky <leon@kernel.org>
Date: Mon, 31 Jan 2022 11:45:26 +0200
Subject: [PATCH] RDMA/mlx4: Don't continue event handler after memory
 allocation failure
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The failure to allocate memory during MLX4_DEV_EVENT_PORT_MGMT_CHANGE
event handler will cause skip the assignment logic, but
ib_dispatch_event() will be called anyway.

Fix it by calling to return instead of break after memory allocation
failure.

Fixes: 00f5ce99dc6e ("mlx4: Use port management change event instead of smp_snoop")
Link: https://lore.kernel.org/r/12a0e83f18cfad4b5f62654f141e240d04915e10.1643622264.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 1c3d97229988..93b1650eacfa 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -3237,7 +3237,7 @@ static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
 	case MLX4_DEV_EVENT_PORT_MGMT_CHANGE:
 		ew = kmalloc(sizeof *ew, GFP_ATOMIC);
 		if (!ew)
-			break;
+			return;
 
 		INIT_WORK(&ew->work, handle_port_mgmt_change_event);
 		memcpy(&ew->ib_eqe, eqe, sizeof *eqe);

