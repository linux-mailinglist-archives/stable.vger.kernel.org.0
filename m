Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26371579D87
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242021AbiGSMwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241919AbiGSMu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:50:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8098AB86E;
        Tue, 19 Jul 2022 05:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03F7B6177D;
        Tue, 19 Jul 2022 12:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1573C341C6;
        Tue, 19 Jul 2022 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233211;
        bh=JHvkOaikfq7lVP2FgXzAZJuffmnjOBt/h6hBSSmaQ9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0wZdZ70LdKJ0eW2aKtBqfbHkmoGmoyYQh2Ic9gVvzGTbk9bMR/+GAPf5q3F2MQeZ
         lyb0NQ+hOxxvmd16slkbxj01tusbA7KAaAJSmUX0ju4eARvcPNKXqT/nW3Iz0pLwd0
         BZeYi8TFyjdcsTcj6svG9rIjatFGoUg+QGFwLN+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 045/231] net/mlx5e: CT: Use own workqueue instead of mlx5e priv
Date:   Tue, 19 Jul 2022 13:52:10 +0200
Message-Id: <20220719114718.092751571@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit 6c4e8fa03fde7e5b304594294e397a9ba92feaf6 ]

Allocate a ct priv workqueue instead of using mlx5e priv one
so flushing will only be of related CT entries.
Also move flushing of the workqueue before rhashtable destroy
otherwise entries won't be valid.

Fixes: b069e14fff46 ("net/mlx5e: CT: Fix queued up restore put() executing after relevant ft release")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 1ff7a07bcd06..fbcce63e5b80 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -66,6 +66,7 @@ struct mlx5_tc_ct_priv {
 	struct mlx5_ct_fs *fs;
 	struct mlx5_ct_fs_ops *fs_ops;
 	spinlock_t ht_lock; /* protects ft entries */
+	struct workqueue_struct *wq;
 };
 
 struct mlx5_ct_flow {
@@ -927,14 +928,11 @@ static void mlx5_tc_ct_entry_del_work(struct work_struct *work)
 static void
 __mlx5_tc_ct_entry_put(struct mlx5_ct_entry *entry)
 {
-	struct mlx5e_priv *priv;
-
 	if (!refcount_dec_and_test(&entry->refcnt))
 		return;
 
-	priv = netdev_priv(entry->ct_priv->netdev);
 	INIT_WORK(&entry->work, mlx5_tc_ct_entry_del_work);
-	queue_work(priv->wq, &entry->work);
+	queue_work(entry->ct_priv->wq, &entry->work);
 }
 
 static struct mlx5_ct_counter *
@@ -1744,19 +1742,16 @@ mlx5_tc_ct_flush_ft_entry(void *ptr, void *arg)
 static void
 mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
 {
-	struct mlx5e_priv *priv;
-
 	if (!refcount_dec_and_test(&ft->refcount))
 		return;
 
+	flush_workqueue(ct_priv->wq);
 	nf_flow_table_offload_del_cb(ft->nf_ft,
 				     mlx5_tc_ct_block_flow_offload, ft);
 	rhashtable_remove_fast(&ct_priv->zone_ht, &ft->node, zone_params);
 	rhashtable_free_and_destroy(&ft->ct_entries_ht,
 				    mlx5_tc_ct_flush_ft_entry,
 				    ct_priv);
-	priv = netdev_priv(ct_priv->netdev);
-	flush_workqueue(priv->wq);
 	mlx5_tc_ct_free_pre_ct_tables(ft);
 	mapping_remove(ct_priv->zone_mapping, ft->zone_restore_id);
 	kfree(ft);
@@ -2139,6 +2134,12 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 	if (rhashtable_init(&ct_priv->ct_tuples_nat_ht, &tuples_nat_ht_params))
 		goto err_ct_tuples_nat_ht;
 
+	ct_priv->wq = alloc_ordered_workqueue("mlx5e_ct_priv_wq", 0);
+	if (!ct_priv->wq) {
+		err = -ENOMEM;
+		goto err_wq;
+	}
+
 	err = mlx5_tc_ct_fs_init(ct_priv);
 	if (err)
 		goto err_init_fs;
@@ -2146,6 +2147,8 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 	return ct_priv;
 
 err_init_fs:
+	destroy_workqueue(ct_priv->wq);
+err_wq:
 	rhashtable_destroy(&ct_priv->ct_tuples_nat_ht);
 err_ct_tuples_nat_ht:
 	rhashtable_destroy(&ct_priv->ct_tuples_ht);
@@ -2175,6 +2178,7 @@ mlx5_tc_ct_clean(struct mlx5_tc_ct_priv *ct_priv)
 	if (!ct_priv)
 		return;
 
+	destroy_workqueue(ct_priv->wq);
 	chains = ct_priv->chains;
 
 	ct_priv->fs_ops->destroy(ct_priv->fs);
-- 
2.35.1



