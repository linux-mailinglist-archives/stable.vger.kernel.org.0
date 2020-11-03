Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DC42A574D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731147AbgKCU4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732115AbgKCU4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:56:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5EBE223BF;
        Tue,  3 Nov 2020 20:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436963;
        bh=/5LWgQ/WVYbMHfGvzmqDtdA71HwyE7u5qWhtd/GkzsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSCsFxEJHZN4jRi2e2DopgN6aLP+jKHgWs8KVaDNWqJzkfd5Db5rm9zdny1K/JVHQ
         SJFAQKxIgQPX8xQhmsLvbjfkItEX5pEjaKXsQqCX0pjNR3SZVvbwW7Q0Aj18xaYDjX
         ONx0TRe4MZZgjGSg5dZ+8T32GNK/4yihwkm+JWEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/214] memory: emif: Remove bogus debugfs error handling
Date:   Tue,  3 Nov 2020 21:35:36 +0100
Message-Id: <20201103203258.637208207@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 402c6bc8e621d..af296b6fcbbdc 100644
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
2.27.0



