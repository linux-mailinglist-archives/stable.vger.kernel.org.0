Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD6A3A64B6
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbhFNL2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:28:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235270AbhFNL0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:26:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C553461493;
        Mon, 14 Jun 2021 10:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623668083;
        bh=p/2xUfkabaxu60hQ7+xHBapQ3RlU25jwlHZ6KhYDtjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPGrY77KnyjCc6U4Gmeqs1iGt2deU3zn3x5fOaxMq1Kgd+IgI18JqM/OeIyUCM89a
         j3vkjgmts9w2Ax/rZIsLOYGR6HmQS2jC5NqHk0EvUXK8+4ibYOm7bK2HY6XTxKz/tG
         YXcs9QTC8JGOBviax/1uXgNLUhm7/bXrBODLXXtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.12 140/173] RDMA/mlx5: Block FDB rules when not in switchdev mode
Date:   Mon, 14 Jun 2021 12:27:52 +0200
Message-Id: <20210614102702.823072152@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

commit edc0b0bccc9c80d9a44d3002dcca94984b25e7cf upstream.

Allow creating FDB steering rules only when in switchdev mode.

The only software model where a userspace application can manipulate
FDB entries is when it manages the eswitch. This is only possible in
switchdev mode where we expose a single RDMA device with representors
for all the vports that are connected to the eswitch.

Fixes: 52438be44112 ("RDMA/mlx5: Allow inserting a steering rule to the FDB")
Link: https://lore.kernel.org/r/e928ae7c58d07f104716a2a8d730963d1bd01204.1623052923.git.leonro@nvidia.com
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/fs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2134,6 +2134,12 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD
 	if (err)
 		goto end;
 
+	if (obj->ns_type == MLX5_FLOW_NAMESPACE_FDB &&
+	    mlx5_eswitch_mode(dev->mdev) != MLX5_ESWITCH_OFFLOADS) {
+		err = -EINVAL;
+		goto end;
+	}
+
 	uobj->object = obj;
 	obj->mdev = dev->mdev;
 	atomic_set(&obj->usecnt, 0);


