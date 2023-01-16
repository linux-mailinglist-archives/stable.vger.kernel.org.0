Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E070266C4FE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbjAPQAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbjAPQAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:00:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1815423C5C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0BFCB81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DDDC433EF;
        Mon, 16 Jan 2023 16:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884814;
        bh=t85UF9TupQ/VaXI7mH4PDfmG9rJfJWkOdJVHF8qO2T0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRVilRExUXNH/XaomvLRUskAZ+Mvo61w3n9Oz6KsL3OrWSKFX1ZbSL38VdWKG4OwA
         mkz9o933nx/R/O01peazN3DmqaJfMK8rEyYdDfEHr6BZ8xGBBNIAnhTlQm7baTiD+f
         V+mLgUbCGMlUYRyR9YWviNJeuUph0UKWLQyuIo6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ariel Levkovich <lariel@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/183] net/mlx5: check attr pointer validity before dereferencing it
Date:   Mon, 16 Jan 2023 16:51:13 +0100
Message-Id: <20230116154809.675932768@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

[ Upstream commit e0bf81bf0d3d4747c146e0bf44774d3d881d7137 ]

Fix attr pointer validity checks after it was already
dereferenced.

Fixes: cb0d54cbf948 ("net/mlx5e: Fix wrong source vport matching on tunnel rule")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 8c6c9bcb3dc3..b4e263e8cfb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -142,7 +142,7 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 		if (mlx5_esw_indir_table_decap_vport(attr))
 			vport = mlx5_esw_indir_table_decap_vport(attr);
 
-		if (attr && !attr->chain && esw_attr->int_port)
+		if (!attr->chain && esw_attr && esw_attr->int_port)
 			metadata =
 				mlx5e_tc_int_port_get_metadata_for_match(esw_attr->int_port);
 		else
-- 
2.35.1



