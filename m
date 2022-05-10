Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7B9521AA5
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244741AbiEJODB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244536AbiEJNyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:54:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C495D2A18A8;
        Tue, 10 May 2022 06:38:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2DD2B81D7A;
        Tue, 10 May 2022 13:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3767DC385C2;
        Tue, 10 May 2022 13:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189908;
        bh=qFOSbVuRiYCNwN3z56nH5mm7KYKcnGciMCHG35PpTx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MjAcwiSAoA5ws8HIm4zcv49yh9B4kwNA+tQJN7zQlP71SIb7mdIEl0/oZXm3a4X82
         MFcAGnlFNmRmULw27gOetnTsmiEAP2o4MCC0crR8SOzUK/+0piyf97yAtmUpbGRnx0
         oIjvVZQ2J+csBh6/9ftgugMim5N5yWZvywNg+Qy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.17 067/140] net/mlx5e: CT: Fix queued up restore put() executing after relevant ft release
Date:   Tue, 10 May 2022 15:07:37 +0200
Message-Id: <20220510130743.535016608@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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
@@ -1739,6 +1739,8 @@ mlx5_tc_ct_flush_ft_entry(void *ptr, voi
 static void
 mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
 {
+	struct mlx5e_priv *priv;
+
 	if (!refcount_dec_and_test(&ft->refcount))
 		return;
 
@@ -1748,6 +1750,8 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_p
 	rhashtable_free_and_destroy(&ft->ct_entries_ht,
 				    mlx5_tc_ct_flush_ft_entry,
 				    ct_priv);
+	priv = netdev_priv(ct_priv->netdev);
+	flush_workqueue(priv->wq);
 	mlx5_tc_ct_free_pre_ct_tables(ft);
 	mapping_remove(ct_priv->zone_mapping, ft->zone_restore_id);
 	kfree(ft);


