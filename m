Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390A61061E5
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbfKVF5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:57:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729476AbfKVF5i (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:57:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C5B92072E;
        Fri, 22 Nov 2019 05:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402256;
        bh=TYfsVzZ4zwiOufA5oBSyagynvgD3Ixw6QqNPhHSGTfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ybgw8ZIqgQAdBE74FgRRy4uZZY20iRAJfXTgkSxAaIk2LxyoHCwHZCuU2Nwhw5qti
         Hd0kOBQTvR7nBBxTRa3Dmtlg5h+aVVyiMkAr8LjSgZgfGkZdxSzKF2dYPPkc+/VLPd
         6X4BhngDbrPJsH5FZO8xsTMBKHb0LnJ7VmIN/Ht4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 098/127] mtd: Check add_mtd_device() ret code
Date:   Fri, 22 Nov 2019 00:55:16 -0500
Message-Id: <20191122055544.3299-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <bbrezillon@kernel.org>

[ Upstream commit 2b6f0090a3335b7bdd03ca520c35591159463041 ]

add_mtd_device() can fail. We should always check its return value
and gracefully handle the failure case. Fix the call sites where this
not done (in mtdpart.c) and add a __must_check attribute to the
prototype to avoid this kind of mistakes.

Signed-off-by: Boris Brezillon <bbrezillon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.h |  2 +-
 drivers/mtd/mtdpart.c | 36 +++++++++++++++++++++++++++++++-----
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/mtdcore.h b/drivers/mtd/mtdcore.h
index 37accfd0400e5..24480b75a88dd 100644
--- a/drivers/mtd/mtdcore.h
+++ b/drivers/mtd/mtdcore.h
@@ -7,7 +7,7 @@
 extern struct mutex mtd_table_mutex;
 
 struct mtd_info *__mtd_next_device(int i);
-int add_mtd_device(struct mtd_info *mtd);
+int __must_check add_mtd_device(struct mtd_info *mtd);
 int del_mtd_device(struct mtd_info *mtd);
 int add_mtd_partitions(struct mtd_info *, const struct mtd_partition *, int);
 int del_mtd_partitions(struct mtd_info *);
diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index a308e707392d5..27d9785487d69 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -684,10 +684,22 @@ int mtd_add_partition(struct mtd_info *parent, const char *name,
 	list_add(&new->list, &mtd_partitions);
 	mutex_unlock(&mtd_partitions_mutex);
 
-	add_mtd_device(&new->mtd);
+	ret = add_mtd_device(&new->mtd);
+	if (ret)
+		goto err_remove_part;
 
 	mtd_add_partition_attrs(new);
 
+	return 0;
+
+err_remove_part:
+	mutex_lock(&mtd_partitions_mutex);
+	list_del(&new->list);
+	mutex_unlock(&mtd_partitions_mutex);
+
+	free_partition(new);
+	pr_info("%s:%i\n", __func__, __LINE__);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mtd_add_partition);
@@ -778,22 +790,31 @@ int add_mtd_partitions(struct mtd_info *master,
 {
 	struct mtd_part *slave;
 	uint64_t cur_offset = 0;
-	int i;
+	int i, ret;
 
 	printk(KERN_NOTICE "Creating %d MTD partitions on \"%s\":\n", nbparts, master->name);
 
 	for (i = 0; i < nbparts; i++) {
 		slave = allocate_partition(master, parts + i, i, cur_offset);
 		if (IS_ERR(slave)) {
-			del_mtd_partitions(master);
-			return PTR_ERR(slave);
+			ret = PTR_ERR(slave);
+			goto err_del_partitions;
 		}
 
 		mutex_lock(&mtd_partitions_mutex);
 		list_add(&slave->list, &mtd_partitions);
 		mutex_unlock(&mtd_partitions_mutex);
 
-		add_mtd_device(&slave->mtd);
+		ret = add_mtd_device(&slave->mtd);
+		if (ret) {
+			mutex_lock(&mtd_partitions_mutex);
+			list_del(&slave->list);
+			mutex_unlock(&mtd_partitions_mutex);
+
+			free_partition(slave);
+			goto err_del_partitions;
+		}
+
 		mtd_add_partition_attrs(slave);
 		if (parts[i].types)
 			mtd_parse_part(slave, parts[i].types);
@@ -802,6 +823,11 @@ int add_mtd_partitions(struct mtd_info *master,
 	}
 
 	return 0;
+
+err_del_partitions:
+	del_mtd_partitions(master);
+
+	return ret;
 }
 
 static DEFINE_SPINLOCK(part_parser_lock);
-- 
2.20.1

