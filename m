Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0E31BCBD8
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 21:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgD1TAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 15:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729053AbgD1S1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:27:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41F61208E0;
        Tue, 28 Apr 2020 18:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098463;
        bh=/n+aw/AIgsVNLvpZZefwZf1O71uQadggFN+UnXZb02c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5H8yvU3XLN5ALVZpbV3oljUs43uqSnzTkOuZtlLDcaqFL+SYzlim2nbCCjPvapUg
         cT3D2Cqv/lcPNXJ71kfOyzPMk21qnqRdE2gCpGvybhTUvUpdHjwPZf90HobF3dZDPV
         brq/SSTr3DHXa/NkqqKUHFrstMU1l8Eoa8wlwW3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 051/167] mlxsw: Fix some IS_ERR() vs NULL bugs
Date:   Tue, 28 Apr 2020 20:23:47 +0200
Message-Id: <20200428182231.481512904@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c391eb8366ae052d571bb2841f1ccb4d39f3ceb8 ]

The mlxsw_sp_acl_rulei_create() function is supposed to return an error
pointer from mlxsw_afa_block_create().  The problem is that these
functions both return NULL instead of error pointers.  Half the callers
expect NULL and half expect error pointers so it could lead to a NULL
dereference on failure.

This patch changes both of them to return error pointers and changes all
the callers which checked for NULL to check for IS_ERR() instead.

Fixes: 4cda7d8d7098 ("mlxsw: core: Introduce flexible actions support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c |    4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c    |    4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c          |    2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c      |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -316,7 +316,7 @@ struct mlxsw_afa_block *mlxsw_afa_block_
 
 	block = kzalloc(sizeof(*block), GFP_KERNEL);
 	if (!block)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	INIT_LIST_HEAD(&block->resource_list);
 	block->afa = mlxsw_afa;
 
@@ -344,7 +344,7 @@ err_second_set_create:
 	mlxsw_afa_set_destroy(block->first_set);
 err_first_set_create:
 	kfree(block);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL(mlxsw_afa_block_create);
 
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c
@@ -88,8 +88,8 @@ static int mlxsw_sp2_acl_tcam_init(struc
 	 * to be written using PEFA register to all indexes for all regions.
 	 */
 	afa_block = mlxsw_afa_block_create(mlxsw_sp->afa);
-	if (!afa_block) {
-		err = -ENOMEM;
+	if (IS_ERR(afa_block)) {
+		err = PTR_ERR(afa_block);
 		goto err_afa_block;
 	}
 	err = mlxsw_afa_block_continue(afa_block);
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -444,7 +444,7 @@ mlxsw_sp_acl_rulei_create(struct mlxsw_s
 
 	rulei = kzalloc(sizeof(*rulei), GFP_KERNEL);
 	if (!rulei)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (afa_block) {
 		rulei->act_block = afa_block;
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c
@@ -199,8 +199,8 @@ mlxsw_sp_mr_tcam_afa_block_create(struct
 	int err;
 
 	afa_block = mlxsw_afa_block_create(mlxsw_sp->afa);
-	if (!afa_block)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(afa_block))
+		return afa_block;
 
 	err = mlxsw_afa_block_append_allocated_counter(afa_block,
 						       counter_index);


