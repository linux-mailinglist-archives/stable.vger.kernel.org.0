Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95EDC14B615
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgA1OCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:02:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727574AbgA1OCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:02:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2F67205F4;
        Tue, 28 Jan 2020 14:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220129;
        bh=p/bap1X9BjDkzOSSBgFAOM0RZH5PPJ0UwhkIpfbTts0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBNzfNBxpoTTDV+iiNcAsIUVsapnXaKuUBCv4hRA3dW4Wt+vYFlcGCDxetKvUtN5M
         zVvyKwzYOHVZq4IsDUttfsMUB+asDHP7BcrodCGT7a53CBSNv8NwtNtMvQAgFCZse3
         c3cDGf8+odhpQJl4NpWrgXHdbqkq8wBh+TMxM00k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 028/104] net/mlx5: DR, use non preemptible call to get the current cpu number
Date:   Tue, 28 Jan 2020 14:59:49 +0100
Message-Id: <20200128135821.161614290@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

commit c0702a4bd41829f05638ec2dab70f6bb8d8010ce upstream.

Use raw_smp_processor_id instead of smp_processor_id() otherwise we will
get the following trace in debug-kernel:
	BUG: using smp_processor_id() in preemptible [00000000] code: devlink
	caller is dr_create_cq.constprop.2+0x31d/0x970 [mlx5_core]
	Call Trace:
	dump_stack+0x9a/0xf0
	debug_smp_processor_id+0x1f3/0x200
	dr_create_cq.constprop.2+0x31d/0x970
	genl_family_rcv_msg+0x5fd/0x1170
	genl_rcv_msg+0xb8/0x160
	netlink_rcv_skb+0x11e/0x340

Fixes: 297cccebdc5a ("net/mlx5: DR, Expose an internal API to issue RDMA operations")
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2019 Mellanox Technologies. */
 
+#include <linux/smp.h>
 #include "dr_types.h"
 
 #define QUEUE_SIZE 128
@@ -729,7 +730,7 @@ static struct mlx5dr_cq *dr_create_cq(st
 	if (!in)
 		goto err_cqwq;
 
-	vector = smp_processor_id() % mlx5_comp_vectors_count(mdev);
+	vector = raw_smp_processor_id() % mlx5_comp_vectors_count(mdev);
 	err = mlx5_vector2eqn(mdev, vector, &eqn, &irqn);
 	if (err) {
 		kvfree(in);


