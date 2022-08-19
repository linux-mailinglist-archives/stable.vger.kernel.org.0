Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E10F59A021
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350676AbiHSP4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350926AbiHSP4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:56:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D5E10521D;
        Fri, 19 Aug 2022 08:50:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3B0A616F9;
        Fri, 19 Aug 2022 15:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31DFC433D6;
        Fri, 19 Aug 2022 15:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924237;
        bh=gVNJEFm1Q3F65zmNeU+fdgNngxG14eW9scGa3m0pN5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TArbcc9Hp94AC+5hfd3hCTkB3wr9VZZCeQkbCmR3EmQBy7qnwqfmBj4RgDguwAPe
         0Xuc5/QKJWmBLL78ogWoiAkp7dYvpYFt6QDvp0Sr2vGjPlGwp4brj2ZD7XCpfnxx/n
         Whfv8YJqYjwx5i4iBeF2O3oXnBRyqkvXXaUpYPiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Lv Ruyi <lv.ruyi@zte.com.cn>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/545] firmware: tegra: Fix error check return value of debugfs_create_file()
Date:   Fri, 19 Aug 2022 17:37:52 +0200
Message-Id: <20220819153833.841992911@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 440d99c63638..fad97ec8e81f 100644
--- a/drivers/firmware/tegra/bpmp-debugfs.c
+++ b/drivers/firmware/tegra/bpmp-debugfs.c
@@ -429,7 +429,7 @@ static int bpmp_populate_debugfs_inband(struct tegra_bpmp *bpmp,
 			mode |= attrs & DEBUGFS_S_IWUSR ? 0200 : 0;
 			dentry = debugfs_create_file(name, mode, parent, bpmp,
 						     &bpmp_debug_fops);
-			if (!dentry) {
+			if (IS_ERR(dentry)) {
 				err = -ENOMEM;
 				goto out;
 			}
@@ -680,7 +680,7 @@ static int bpmp_populate_dir(struct tegra_bpmp *bpmp, struct seqbuf *seqbuf,
 
 		if (t & DEBUGFS_S_ISDIR) {
 			dentry = debugfs_create_dir(name, parent);
-			if (!dentry)
+			if (IS_ERR(dentry))
 				return -ENOMEM;
 			err = bpmp_populate_dir(bpmp, seqbuf, dentry, depth+1);
 			if (err < 0)
@@ -693,7 +693,7 @@ static int bpmp_populate_dir(struct tegra_bpmp *bpmp, struct seqbuf *seqbuf,
 			dentry = debugfs_create_file(name, mode,
 						     parent, bpmp,
 						     &debugfs_fops);
-			if (!dentry)
+			if (IS_ERR(dentry))
 				return -ENOMEM;
 		}
 	}
@@ -743,11 +743,11 @@ int tegra_bpmp_init_debugfs(struct tegra_bpmp *bpmp)
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



