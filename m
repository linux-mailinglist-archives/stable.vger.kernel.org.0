Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204995218B3
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243646AbiEJNjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244785AbiEJNiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20B15BD09;
        Tue, 10 May 2022 06:26:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6CFA615C8;
        Tue, 10 May 2022 13:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89D4C385A6;
        Tue, 10 May 2022 13:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189181;
        bh=abmYuJArJqRPZKjjiUnONxxuXLGmX/tmZAbp6sJlbwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNJVO6bc8pyCy5lfiWIZ/HFhEg945nsOH012FTd0va2z9rbrqUVCj36IvDNEri7cU
         0BJpnuunxgvOhR4BXQALtXTaPMFFK7O1s30qzZ+fDC1SWVPjmjwR63bXk8JQZP/KIl
         CnUCr7PYWytcb7/FbaHgTUD4zbeoTG3wExGjPdhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 39/70] net/mlx5e: CT: Fix queued up restore put() executing after relevant ft release
Date:   Tue, 10 May 2022 15:07:58 +0200
Message-Id: <20220510130734.007929518@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

commit b069e14fff46c8da9fcc79957f8acaa3e2dfdb6b upstream.

__mlx5_tc_ct_entry_put() queues release of tuple related to some ct FT,
if that is the last reference to that tuple, the actual deletion of
the tuple can happen after the FT is already destroyed and freed.

Flush the used workqueue before destroying the ct FT.

Fixes: a2173131526d ("net/mlx5e: CT: manage the lifetime of the ct entry object")
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1629,6 +1629,8 @@ mlx5_tc_ct_flush_ft_entry(void *ptr, voi
 static void
 mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
 {
+	struct mlx5e_priv *priv;
+
 	if (!refcount_dec_and_test(&ft->refcount))
 		return;
 
@@ -1638,6 +1640,8 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_p
 	rhashtable_free_and_destroy(&ft->ct_entries_ht,
 				    mlx5_tc_ct_flush_ft_entry,
 				    ct_priv);
+	priv = netdev_priv(ct_priv->netdev);
+	flush_workqueue(priv->wq);
 	mlx5_tc_ct_free_pre_ct_tables(ft);
 	mapping_remove(ct_priv->zone_mapping, ft->zone_restore_id);
 	kfree(ft);


