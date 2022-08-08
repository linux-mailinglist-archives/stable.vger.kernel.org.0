Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE0658BF3D
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242037AbiHHBgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242209AbiHHBfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:35:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F68CE0B;
        Sun,  7 Aug 2022 18:33:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C34A60CF7;
        Mon,  8 Aug 2022 01:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A89C433D6;
        Mon,  8 Aug 2022 01:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922400;
        bh=698Flm7SpQJiRiiikVpbc456D/RJv3Ovb7vU4f/tM+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aAZbeVCJhIXHDEJAXrU1VxCJ66tx+j5967/bPwCfHiNslvqoliax8pihVDTYz9AMP
         Sh1EmMy+8pDa88kI04ftAV1aGur04/9PESDrbp1PjCuGbutfk8yfcv8O+LFx86gZSI
         rKd1AIR0VQOLZiKvUpXchmt9lMUwMpawGXoYXpN82z/CfRfNyEKH56HNgl3N8iSL21
         lqu6WjzMbqiZDqRIeuL3YJ73juWup2tmxSPtrJwjjLJ9wWBvY80wvD6WbhL4cB/5QZ
         jaGWUCyA8vNc4yHXxEC/hRjd09wsTyAviTiYWMfGrWYpDbjdlh+hvI/OdQEhijsWyA
         nJ7PspPJKW6tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, thierry.reding@gmail.com,
        jonathanh@nvidia.com, arnd@arndb.de, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 47/58] firmware: tegra: Fix error check return value of debugfs_create_file()
Date:   Sun,  7 Aug 2022 21:31:05 -0400
Message-Id: <20220808013118.313965-47-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit afcdb8e55c91c6ff0700ab272fd0f74e899ab884 ]

If an error occurs, debugfs_create_file() will return ERR_PTR(-ERROR),
so use IS_ERR() to check it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/tegra/bpmp-debugfs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/tegra/bpmp-debugfs.c b/drivers/firmware/tegra/bpmp-debugfs.c
index fd89899aeeed..0c440afd5224 100644
--- a/drivers/firmware/tegra/bpmp-debugfs.c
+++ b/drivers/firmware/tegra/bpmp-debugfs.c
@@ -474,7 +474,7 @@ static int bpmp_populate_debugfs_inband(struct tegra_bpmp *bpmp,
 			mode |= attrs & DEBUGFS_S_IWUSR ? 0200 : 0;
 			dentry = debugfs_create_file(name, mode, parent, bpmp,
 						     &bpmp_debug_fops);
-			if (!dentry) {
+			if (IS_ERR(dentry)) {
 				err = -ENOMEM;
 				goto out;
 			}
@@ -725,7 +725,7 @@ static int bpmp_populate_dir(struct tegra_bpmp *bpmp, struct seqbuf *seqbuf,
 
 		if (t & DEBUGFS_S_ISDIR) {
 			dentry = debugfs_create_dir(name, parent);
-			if (!dentry)
+			if (IS_ERR(dentry))
 				return -ENOMEM;
 			err = bpmp_populate_dir(bpmp, seqbuf, dentry, depth+1);
 			if (err < 0)
@@ -738,7 +738,7 @@ static int bpmp_populate_dir(struct tegra_bpmp *bpmp, struct seqbuf *seqbuf,
 			dentry = debugfs_create_file(name, mode,
 						     parent, bpmp,
 						     &debugfs_fops);
-			if (!dentry)
+			if (IS_ERR(dentry))
 				return -ENOMEM;
 		}
 	}
@@ -788,11 +788,11 @@ int tegra_bpmp_init_debugfs(struct tegra_bpmp *bpmp)
 		return 0;
 
 	root = debugfs_create_dir("bpmp", NULL);
-	if (!root)
+	if (IS_ERR(root))
 		return -ENOMEM;
 
 	bpmp->debugfs_mirror = debugfs_create_dir("debug", root);
-	if (!bpmp->debugfs_mirror) {
+	if (IS_ERR(bpmp->debugfs_mirror)) {
 		err = -ENOMEM;
 		goto out;
 	}
-- 
2.35.1

