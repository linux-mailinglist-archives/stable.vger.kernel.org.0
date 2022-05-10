Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A65F52192E
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244266AbiEJNn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244810AbiEJNmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:42:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB4A81991;
        Tue, 10 May 2022 06:30:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3BB461763;
        Tue, 10 May 2022 13:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94B8C385C2;
        Tue, 10 May 2022 13:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189433;
        bh=bZpbnHDawu3VCWMLYiGy43zxTarsma7M7G7naDOwl/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHHDj38GX4WBsxMtFT119xfrPyB2F5UwLG5fd+k+R+x/ZTrUIWNz48NPb2c84GnQr
         3ONmIYq/UZzAWFbIJRVe73GG4jO8R/rTsARW7jsQdaJV6wfhQn4qkjq/+NF47Ik+D7
         KsECsk1SIoypHZbRR7hCODnxBEE0iZMXH9++m1rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 050/135] net/mlx5e: CT: Fix queued up restore put() executing after relevant ft release
Date:   Tue, 10 May 2022 15:07:12 +0200
Message-Id: <20220510130741.835869717@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
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
@@ -1699,6 +1699,8 @@ mlx5_tc_ct_flush_ft_entry(void *ptr, voi
 static void
 mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
 {
+	struct mlx5e_priv *priv;
+
 	if (!refcount_dec_and_test(&ft->refcount))
 		return;
 
@@ -1708,6 +1710,8 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_p
 	rhashtable_free_and_destroy(&ft->ct_entries_ht,
 				    mlx5_tc_ct_flush_ft_entry,
 				    ct_priv);
+	priv = netdev_priv(ct_priv->netdev);
+	flush_workqueue(priv->wq);
 	mlx5_tc_ct_free_pre_ct_tables(ft);
 	mapping_remove(ct_priv->zone_mapping, ft->zone_restore_id);
 	kfree(ft);


