Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B06548A1A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357094AbiFMM6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349811AbiFMMzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:55:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A37E0D2;
        Mon, 13 Jun 2022 04:16:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA754B80D31;
        Mon, 13 Jun 2022 11:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A97C3411E;
        Mon, 13 Jun 2022 11:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118967;
        bh=jqlb9j3DcrFhiYXFuaDgQsMjUk2qrafWbbb6XbIC7vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCoD4I6LtmpaJDVbz+aNVsz0zdE+j30vLMbWza3Y+8fI1JbrwA1kHgUbWZJUByFlA
         ZWrbmV8dBWQ9S2av2qnB8Cdu61pi4E+NSunOk+HBbwtH86nysSa6PLJjagYsNNtFaS
         vFOtCDyvd6B0QEOudcwsYspHyvN7/d8AoJnA57TM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/247] net/mlx5: Dont use already freed action pointer
Date:   Mon, 13 Jun 2022 12:09:55 +0200
Message-Id: <20220613094925.778304735@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 80b2bd737d0e833e6a2b77e482e5a714a79c86a4 ]

The call to mlx5dr_action_destroy() releases "action" memory. That
pointer is set to miss_action later and generates the following smatch
error:

 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c:53 set_miss_action()
 warn: 'action' was already freed.

Make sure that the pointer is always valid by setting NULL after destroy.

Fixes: 6a48faeeca10 ("net/mlx5: Add direct rule fs_cmd implementation")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index ae4597118f8b..0553ee1fe80a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -43,11 +43,10 @@ static int set_miss_action(struct mlx5_flow_root_namespace *ns,
 	err = mlx5dr_table_set_miss_action(ft->fs_dr_table.dr_table, action);
 	if (err && action) {
 		err = mlx5dr_action_destroy(action);
-		if (err) {
-			action = NULL;
-			mlx5_core_err(ns->dev, "Failed to destroy action (%d)\n",
-				      err);
-		}
+		if (err)
+			mlx5_core_err(ns->dev,
+				      "Failed to destroy action (%d)\n", err);
+		action = NULL;
 	}
 	ft->fs_dr_table.miss_action = action;
 	if (old_miss_action) {
-- 
2.35.1



