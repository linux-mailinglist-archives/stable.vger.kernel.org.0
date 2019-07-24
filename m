Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A86745B1
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391313AbfGYFpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391304AbfGYFpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:45:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02F5A22BEB;
        Thu, 25 Jul 2019 05:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033515;
        bh=TEcS6VEwrK6c/rRhgJG8532FMPLUvInMa8VorxuqWJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AoBiQ6vtsB877tgXck4QeOUE5YIrYKZ3s6uqY3lBtpmzywZQmEhcYuKUqnjBcFFUu
         PosaTDL/XHFaId1qAykseZ9tFLKR62Q8Z3vfTU4Yux4/zaa2AZ2Il1efQf9Zwjw2Tg
         Whpweesp5jSIOPq42DbDaD19om/oHnoXy3ivx3h8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danit Goldberg <danitg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.19 235/271] IB/mlx5: Report correctly tag matching rendezvous capability
Date:   Wed, 24 Jul 2019 21:21:44 +0200
Message-Id: <20190724191715.296943279@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Danit Goldberg <danitg@mellanox.com>

commit 89705e92700170888236555fe91b45e4c1bb0985 upstream.

Userspace expects the IB_TM_CAP_RC bit to indicate that the device
supports RC transport tag matching with rendezvous offload. However the
firmware splits this into two capabilities for eager and rendezvous tag
matching.

Only if the FW supports both modes should userspace be told the tag
matching capability is available.

Cc: <stable@vger.kernel.org> # 4.13
Fixes: eb761894351d ("IB/mlx5: Fill XRQ capabilities")
Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/main.c |    8 ++++++--
 include/rdma/ib_verbs.h           |    4 ++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -939,15 +939,19 @@ static int mlx5_ib_query_device(struct i
 	}
 
 	if (MLX5_CAP_GEN(mdev, tag_matching)) {
-		props->tm_caps.max_rndv_hdr_size = MLX5_TM_MAX_RNDV_MSG_SIZE;
 		props->tm_caps.max_num_tags =
 			(1 << MLX5_CAP_GEN(mdev, log_tag_matching_list_sz)) - 1;
-		props->tm_caps.flags = IB_TM_CAP_RC;
 		props->tm_caps.max_ops =
 			1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
 		props->tm_caps.max_sge = MLX5_TM_MAX_SGE;
 	}
 
+	if (MLX5_CAP_GEN(mdev, tag_matching) &&
+	    MLX5_CAP_GEN(mdev, rndv_offload_rc)) {
+		props->tm_caps.flags = IB_TM_CAP_RNDV_RC;
+		props->tm_caps.max_rndv_hdr_size = MLX5_TM_MAX_RNDV_MSG_SIZE;
+	}
+
 	if (MLX5_CAP_GEN(dev->mdev, cq_moderation)) {
 		props->cq_caps.max_cq_moderation_count =
 						MLX5_MAX_CQ_COUNT;
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -290,8 +290,8 @@ struct ib_rss_caps {
 };
 
 enum ib_tm_cap_flags {
-	/*  Support tag matching on RC transport */
-	IB_TM_CAP_RC		    = 1 << 0,
+	/*  Support tag matching with rendezvous offload for RC transport */
+	IB_TM_CAP_RNDV_RC = 1 << 0,
 };
 
 struct ib_tm_caps {


