Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE9013347D
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgAGV0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:26:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:60286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727225AbgAGU7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:59:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A80E72087F;
        Tue,  7 Jan 2020 20:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430761;
        bh=mEpZI1AiW0OMmKj9mQE/MPrwrVxuZ+BRFKNfORLLlEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XfRjxp/zFiy+DSfIcKUtQ8Nt/tDDKm9uk5BYQk0Q1YooT0qj6MZUWzvLEiVj19p8D
         8xBvi4AW81FvTSfHlRp8BDCscdD7DJl2BQKfcVfzYps114yhZU3OQKhOZJyL1roGv+
         IFJArtdKrA1bYkGzEK0e+2sIyMl/D5cStIL+6BEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Raed Salem <raeds@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/191] IB/mlx5: Fix steering rule of drop and count
Date:   Tue,  7 Jan 2020 21:52:49 +0100
Message-Id: <20200107205335.619488990@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

[ Upstream commit ed9085fed9d95d5921582e3c8474f3736c5d2782 ]

There are two flow rule destinations: QP and packet. While users are
setting DROP packet rule, the QP should not be set as a destination.

Fixes: 3b3233fbf02e ("IB/mlx5: Add flow counters binding support")
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Link: https://lore.kernel.org/r/20191212091214.315005-4-leon@kernel.org
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 831539419c30..e1cfbedefcbc 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3548,10 +3548,6 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 	}
 
 	INIT_LIST_HEAD(&handler->list);
-	if (dst) {
-		memcpy(&dest_arr[0], dst, sizeof(*dst));
-		dest_num++;
-	}
 
 	for (spec_index = 0; spec_index < flow_attr->num_of_specs; spec_index++) {
 		err = parse_flow_attr(dev->mdev, spec,
@@ -3564,6 +3560,11 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 		ib_flow += ((union ib_flow_spec *)ib_flow)->size;
 	}
 
+	if (dst && !(flow_act.action & MLX5_FLOW_CONTEXT_ACTION_DROP)) {
+		memcpy(&dest_arr[0], dst, sizeof(*dst));
+		dest_num++;
+	}
+
 	if (!flow_is_multicast_only(flow_attr))
 		set_underlay_qp(dev, spec, underlay_qpn);
 
@@ -3604,10 +3605,8 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 	}
 
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_DROP) {
-		if (!(flow_act.action & MLX5_FLOW_CONTEXT_ACTION_COUNT)) {
+		if (!dest_num)
 			rule_dst = NULL;
-			dest_num = 0;
-		}
 	} else {
 		if (is_egress)
 			flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_ALLOW;
-- 
2.20.1



