Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D0732BB8
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfFCJLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727317AbfFCJLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:11:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7805527E44;
        Mon,  3 Jun 2019 09:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553064;
        bh=pzvuY0MLooD1BHTw3uxhWYwmhUamRWf5Y/TkApoxcns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvrA51Zkkv/xmlzPIZkWZkDpNsF4WHvLEjri9iHStxD/BT7W16BXnCJ3JjsfQZl8Y
         Gs9qs2DH28ASglE13hlAqtqoypaEzVPGulHAEgp8HLR2HjcPNgVPNEkbLz6+WqItfg
         bKgjzl0dcjJVtXb9jxuh75QEbXsp6/rvWwR483mQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 18/32] net/mlx5: Avoid double free in fs init error unwinding path
Date:   Mon,  3 Jun 2019 11:08:12 +0200
Message-Id: <20190603090313.666082384@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090308.472021390@linuxfoundation.org>
References: <20190603090308.472021390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 9414277a5df3669c67e818708c0f881597e0118e ]

In below code flow, for ingress acl table root ns memory leads
to double free.

mlx5_init_fs
  init_ingress_acls_root_ns()
    init_ingress_acl_root_ns
       kfree(steering->esw_ingress_root_ns);
       /* steering->esw_ingress_root_ns is not marked NULL */
  mlx5_cleanup_fs
    cleanup_ingress_acls_root_ns
       steering->esw_ingress_root_ns non NULL check passes.
       kfree(steering->esw_ingress_root_ns);
       /* double free */

Similar issue exist for other tables.

Hence zero out the pointers to not process the table again.

Fixes: 9b93ab981e3bf ("net/mlx5: Separate ingress/egress namespaces for each vport")
Fixes: 40c3eebb49e51 ("net/mlx5: Add support in RDMA RX steering")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2363,6 +2363,7 @@ static void cleanup_egress_acls_root_ns(
 		cleanup_root_ns(steering->esw_egress_root_ns[i]);
 
 	kfree(steering->esw_egress_root_ns);
+	steering->esw_egress_root_ns = NULL;
 }
 
 static void cleanup_ingress_acls_root_ns(struct mlx5_core_dev *dev)
@@ -2377,6 +2378,7 @@ static void cleanup_ingress_acls_root_ns
 		cleanup_root_ns(steering->esw_ingress_root_ns[i]);
 
 	kfree(steering->esw_ingress_root_ns);
+	steering->esw_ingress_root_ns = NULL;
 }
 
 void mlx5_cleanup_fs(struct mlx5_core_dev *dev)
@@ -2505,6 +2507,7 @@ cleanup_root_ns:
 	for (i--; i >= 0; i--)
 		cleanup_root_ns(steering->esw_egress_root_ns[i]);
 	kfree(steering->esw_egress_root_ns);
+	steering->esw_egress_root_ns = NULL;
 	return err;
 }
 
@@ -2532,6 +2535,7 @@ cleanup_root_ns:
 	for (i--; i >= 0; i--)
 		cleanup_root_ns(steering->esw_ingress_root_ns[i]);
 	kfree(steering->esw_ingress_root_ns);
+	steering->esw_ingress_root_ns = NULL;
 	return err;
 }
 


