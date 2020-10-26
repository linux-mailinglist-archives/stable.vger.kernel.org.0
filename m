Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9110299B83
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 00:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409532AbgJZXvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:51:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409527AbgJZXvs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4953221F7;
        Mon, 26 Oct 2020 23:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756307;
        bh=dmsfJ8ipZvgGI28PnEwHEvnxNTV6rN2NO2SDCDLL+wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GWAIw3fWVniT4EjbRUn2CgWUoyyOmsQDUBmzY9ML1OJI4XIkYhG9Fz22iIi/AYiZt
         StCOodPyzq8x/Ya/nflfKCWnYDLc2EzPqDAYtobFS1YcNi/Kb8xvc5K18Bu4PlARnw
         xPZCfmBmBWT1Qpdt+sW/xdMDpV/ULqgqvaiQUCTk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 132/147] memory: emif: Remove bogus debugfs error handling
Date:   Mon, 26 Oct 2020 19:48:50 -0400
Message-Id: <20201026234905.1022767-132-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit fd22781648080cc400772b3c68aa6b059d2d5420 ]

Callers are generally not supposed to check the return values from
debugfs functions.  Debugfs functions never return NULL so this error
handling will never trigger.  (Historically debugfs functions used to
return a mix of NULL and error pointers but it was eventually deemed too
complicated for something which wasn't intended to be used in normal
situations).

Delete all the error handling.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Santosh Shilimkar <ssantosh@kernel.org>
Link: https://lore.kernel.org/r/20200826113759.GF393664@mwanda
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/emif.c | 33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index bb6a71d267988..5c4d8319c9cfb 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -163,35 +163,12 @@ static const struct file_operations emif_mr4_fops = {
 
 static int __init_or_module emif_debugfs_init(struct emif_data *emif)
 {
-	struct dentry	*dentry;
-	int		ret;
-
-	dentry = debugfs_create_dir(dev_name(emif->dev), NULL);
-	if (!dentry) {
-		ret = -ENOMEM;
-		goto err0;
-	}
-	emif->debugfs_root = dentry;
-
-	dentry = debugfs_create_file("regcache_dump", S_IRUGO,
-			emif->debugfs_root, emif, &emif_regdump_fops);
-	if (!dentry) {
-		ret = -ENOMEM;
-		goto err1;
-	}
-
-	dentry = debugfs_create_file("mr4", S_IRUGO,
-			emif->debugfs_root, emif, &emif_mr4_fops);
-	if (!dentry) {
-		ret = -ENOMEM;
-		goto err1;
-	}
-
+	emif->debugfs_root = debugfs_create_dir(dev_name(emif->dev), NULL);
+	debugfs_create_file("regcache_dump", S_IRUGO, emif->debugfs_root, emif,
+			    &emif_regdump_fops);
+	debugfs_create_file("mr4", S_IRUGO, emif->debugfs_root, emif,
+			    &emif_mr4_fops);
 	return 0;
-err1:
-	debugfs_remove_recursive(emif->debugfs_root);
-err0:
-	return ret;
 }
 
 static void __exit emif_debugfs_exit(struct emif_data *emif)
-- 
2.25.1

