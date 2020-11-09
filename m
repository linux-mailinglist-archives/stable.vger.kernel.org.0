Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D3C2ABCEF
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbgKINlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730147AbgKINBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:01:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA05F206C0;
        Mon,  9 Nov 2020 13:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926897;
        bh=ZVere6ll14sNmvx4SfE3bvqZth8xPm0Z1tgh+hKBV20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSQZ31JAEf5NGpcj5KwXvt3gel1K7QipVj6rrUwV5hzvJf/YJ4JvDYPvxlFJ7EE6V
         x1REQgWGz4hnenNOKY2Q7/Xcr5VP6JwZuu2Ybcsa6grRhPumTGUu3I+PuzZRob35C0
         9o94Ib2vQslfoOsYFuTAJ8SAZ46baXGm9VcdlMn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 041/117] memory: emif: Remove bogus debugfs error handling
Date:   Mon,  9 Nov 2020 13:54:27 +0100
Message-Id: <20201109125027.606526959@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
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
index 04644e7b42b12..88c32b8dc88a1 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -165,35 +165,12 @@ static const struct file_operations emif_mr4_fops = {
 
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



