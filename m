Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C177F594ACC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355928AbiHPAGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351272AbiHPAAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358E515DFB6;
        Mon, 15 Aug 2022 13:21:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCE58B80EB1;
        Mon, 15 Aug 2022 20:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FFBC433C1;
        Mon, 15 Aug 2022 20:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594877;
        bh=w9DKv41Q3nZHDkkXaYYUdVGq5szEXNwsqk7DaJ1L83s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FEhfs3tdz6wdMh5x4qYYzG0U9zGpOr1jDbotdAhIw7rJfYPUbdOScGGP/Iws/+iVL
         dlUuzuyuMUsu6MZl70/eA+DFMj/rGdNaOnDc1C4zns4fItBkuz4k1uqCVXnO9t0Ig2
         v4c72GwKeYtfh8rJ6yTS+mINCBi6ekQscTzAx+k0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0554/1157] net/mlx5: DR, Fix SMFS steering info dump format
Date:   Mon, 15 Aug 2022 19:58:30 +0200
Message-Id: <20220815180501.790573837@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 62d2664351ef37da34f6f3a3fd8ab34257d6fe30 ]

Fix several issues in SMFS steering info dump:
 - Fix outdated macro value for matcher mask in the SMFS debug dump format.
   The existing value denotes the old format of the matcher mask, as it was
   used during the early stages of development, and it results in wrong
   parsing by the steering dump parser - wrong fields are shown in the
   parsed output.
 - Add the missing destination table to the dumped action.
   The missing dest table handle breaks the ability to associate between
   the "go to table" action and the actual table in the steering info.

Fixes: 9222f0b27da2 ("net/mlx5: DR, Add support for dumping steering info")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c   | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
index d5998ef59be4..7adcf0eec13b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
@@ -21,10 +21,11 @@ enum dr_dump_rec_type {
 	DR_DUMP_REC_TYPE_TABLE_TX = 3102,
 
 	DR_DUMP_REC_TYPE_MATCHER = 3200,
-	DR_DUMP_REC_TYPE_MATCHER_MASK = 3201,
+	DR_DUMP_REC_TYPE_MATCHER_MASK_DEPRECATED = 3201,
 	DR_DUMP_REC_TYPE_MATCHER_RX = 3202,
 	DR_DUMP_REC_TYPE_MATCHER_TX = 3203,
 	DR_DUMP_REC_TYPE_MATCHER_BUILDER = 3204,
+	DR_DUMP_REC_TYPE_MATCHER_MASK = 3205,
 
 	DR_DUMP_REC_TYPE_RULE = 3300,
 	DR_DUMP_REC_TYPE_RULE_RX_ENTRY_V0 = 3301,
@@ -114,13 +115,15 @@ dr_dump_rule_action_mem(struct seq_file *file, const u64 rule_id,
 		break;
 	case DR_ACTION_TYP_FT:
 		if (action->dest_tbl->is_fw_tbl)
-			seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
+			seq_printf(file, "%d,0x%llx,0x%llx,0x%x,0x%x\n",
 				   DR_DUMP_REC_TYPE_ACTION_FT, action_id,
-				   rule_id, action->dest_tbl->fw_tbl.id);
+				   rule_id, action->dest_tbl->fw_tbl.id,
+				   -1);
 		else
-			seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
+			seq_printf(file, "%d,0x%llx,0x%llx,0x%x,0x%llx\n",
 				   DR_DUMP_REC_TYPE_ACTION_FT, action_id,
-				   rule_id, action->dest_tbl->tbl->table_id);
+				   rule_id, action->dest_tbl->tbl->table_id,
+				   DR_DBG_PTR_TO_ID(action->dest_tbl->tbl));
 
 		break;
 	case DR_ACTION_TYP_CTR:
-- 
2.35.1



