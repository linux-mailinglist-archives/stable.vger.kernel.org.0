Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0F41D0E4B
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387927AbgEMJxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:53:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387915AbgEMJxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:53:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A524A20753;
        Wed, 13 May 2020 09:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363592;
        bh=1CMv9hFWmICCdrJOEUu6oBzHCYSfNEa4RMkguyk+ykY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XG0i1lWepxFRtP+8PBshFHjxlnpma01X23IudOpxaOZmLpSf/wkItECag9qUu05U+
         yYwgNCyn6EsxBXu4dVRMYqqyxCxJ38MDCWzk897mmUH+jm57fwFBAWHXnz27LntePV
         639Wiky6XjsI0jK6w+AlrIENnrKUIPUezh5JO9NI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erez Shitrit <erezsh@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.6 046/118] net/mlx5: DR, On creation set CQs arm_db member to right value
Date:   Wed, 13 May 2020 11:44:25 +0200
Message-Id: <20200513094421.280886211@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

[ Upstream commit 8075411d93b6efe143d9f606f6531077795b7fbf ]

In polling mode, set arm_db member to a value that will avoid CQ
event recovery by the HW.
Otherwise we might get event without completion function.
In addition,empty completion function to was added to protect from
unexpected events.

Fixes: 297cccebdc5a ("net/mlx5: DR, Expose an internal API to issue RDMA operations")
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c |   14 ++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -689,6 +689,12 @@ static void dr_cq_event(struct mlx5_core
 	pr_info("CQ event %u on CQ #%u\n", event, mcq->cqn);
 }
 
+static void dr_cq_complete(struct mlx5_core_cq *mcq,
+			   struct mlx5_eqe *eqe)
+{
+	pr_err("CQ completion CQ: #%u\n", mcq->cqn);
+}
+
 static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 				      struct mlx5_uars_page *uar,
 				      size_t ncqe)
@@ -750,6 +756,7 @@ static struct mlx5dr_cq *dr_create_cq(st
 	mlx5_fill_page_frag_array(&cq->wq_ctrl.buf, pas);
 
 	cq->mcq.event = dr_cq_event;
+	cq->mcq.comp  = dr_cq_complete;
 
 	err = mlx5_core_create_cq(mdev, &cq->mcq, in, inlen, out, sizeof(out));
 	kvfree(in);
@@ -761,7 +768,12 @@ static struct mlx5dr_cq *dr_create_cq(st
 	cq->mcq.set_ci_db = cq->wq_ctrl.db.db;
 	cq->mcq.arm_db = cq->wq_ctrl.db.db + 1;
 	*cq->mcq.set_ci_db = 0;
-	*cq->mcq.arm_db = 0;
+
+	/* set no-zero value, in order to avoid the HW to run db-recovery on
+	 * CQ that used in polling mode.
+	 */
+	*cq->mcq.arm_db = cpu_to_be32(2 << 28);
+
 	cq->mcq.vector = 0;
 	cq->mcq.irqn = irqn;
 	cq->mcq.uar = uar;


