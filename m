Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D39113411
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbfLDSVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:21:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730505AbfLDSGK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:06:10 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4174E2081B;
        Wed,  4 Dec 2019 18:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482769;
        bh=TYfsVzZ4zwiOufA5oBSyagynvgD3Ixw6QqNPhHSGTfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9dHoBw9U334Sf0Qt+HKZneKKFQbTST5sD6CfKztyuBSLPfC5+lYo7zu4cquX8gnc
         N21s86nEUFqSoQK20ug8Y5IVasf3yLEDMduNpEsLpaqkvgenYrdsqD9wWoxp4roKSq
         IaaylsUD/D+SRvzGNnmg4N80aNar/wuYTmYyl5Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris Brezillon <bbrezillon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 126/209] mtd: Check add_mtd_device() ret code
Date:   Wed,  4 Dec 2019 18:55:38 +0100
Message-Id: <20191204175331.760818602@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



