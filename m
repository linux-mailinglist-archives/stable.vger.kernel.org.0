Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB4B63915E
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbfFGPmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729577AbfFGPmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:42:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58F5321479;
        Fri,  7 Jun 2019 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922122;
        bh=INNwVElMXrU1EFqZcOcaC0iqeEpAiqts1z3iYUUbs+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeWZ/XJALopiWCh95a92TwNIyAmBdYKyf3t5M5uVS61x5D497TOgPL9I/7pwllvJ1
         5HDO8p2V7D+cZt6MKG0kOh/UL37PbQmE2t2cAYiib9f4BbecyemA0er5omWfZxk1l2
         sQizusqsmNUWtuI+z/uomTiCct0MAlM27WQ8L8K4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.14 09/69] net/mlx5: Allocate root ns memory using kzalloc to match kfree
Date:   Fri,  7 Jun 2019 17:38:50 +0200
Message-Id: <20190607153849.422451977@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 25fa506b70cadb580c1e9cbd836d6417276d4bcd ]

root ns is yet another fs core node which is freed using kfree() by
tree_put_node().
Rest of the other fs core objects are also allocated using kmalloc
variants.

However, root ns memory is allocated using kvzalloc().
Hence allocate root ns memory using kzalloc().

Fixes: 2530236303d9e ("net/mlx5_core: Flow steering tree initialization")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1960,7 +1960,7 @@ static struct mlx5_flow_root_namespace *
 	struct mlx5_flow_namespace *ns;
 
 	/* Create the root namespace */
-	root_ns = kvzalloc(sizeof(*root_ns), GFP_KERNEL);
+	root_ns = kzalloc(sizeof(*root_ns), GFP_KERNEL);
 	if (!root_ns)
 		return NULL;
 


