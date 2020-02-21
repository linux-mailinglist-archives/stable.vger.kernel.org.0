Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F891671DD
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbgBUH6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:58:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730551AbgBUH6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:58:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30B9620578;
        Fri, 21 Feb 2020 07:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271880;
        bh=sjVY1Z5Q4dyM/6xX10VTEQpm72RuUKhACVpanJEy6kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7USGFYHk26hXVv1yHNvIjQHGvDhkvHJ1RRPESmEbeSFpDLGuYBhjvWO1zlJwoXuA
         uC4xifnrpVGGpZB6uAxyAAEw/FhGnGejTquaQia1Wu4qM3uVzrdq3bDXg1ZZEUfg72
         +wN0JLPSqOwF/ag1jONSz461qdGKMDLB8sNgzSkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 333/399] bcache: rework error unwinding in register_bcache
Date:   Fri, 21 Feb 2020 08:40:58 +0100
Message-Id: <20200221072433.446073031@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 50246693f81fe887f4db78bf7089051d7f1894cc ]

Split the successful and error return path, and use one goto label for each
resource to unwind.  This also fixes some small errors like leaking the
module reference count in the reboot case (which seems entirely harmless)
or printing the wrong warning messages for early failures.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 75 +++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 30 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a573ce1d85aae..bd2ae1d78fe15 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2375,29 +2375,33 @@ static bool bch_is_open(struct block_device *bdev)
 static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			       const char *buffer, size_t size)
 {
-	ssize_t ret = -EINVAL;
-	const char *err = "cannot allocate memory";
-	char *path = NULL;
-	struct cache_sb *sb = NULL;
+	const char *err;
+	char *path;
+	struct cache_sb *sb;
 	struct block_device *bdev = NULL;
-	struct page *sb_page = NULL;
+	struct page *sb_page;
+	ssize_t ret;
 
+	ret = -EBUSY;
 	if (!try_module_get(THIS_MODULE))
-		return -EBUSY;
+		goto out;
 
 	/* For latest state of bcache_is_reboot */
 	smp_mb();
 	if (bcache_is_reboot)
-		return -EBUSY;
+		goto out_module_put;
 
+	ret = -ENOMEM;
+	err = "cannot allocate memory";
 	path = kstrndup(buffer, size, GFP_KERNEL);
 	if (!path)
-		goto err;
+		goto out_module_put;
 
 	sb = kmalloc(sizeof(struct cache_sb), GFP_KERNEL);
 	if (!sb)
-		goto err;
+		goto out_free_path;
 
+	ret = -EINVAL;
 	err = "failed to open device";
 	bdev = blkdev_get_by_path(strim(path),
 				  FMODE_READ|FMODE_WRITE|FMODE_EXCL,
@@ -2414,57 +2418,68 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			if (!IS_ERR(bdev))
 				bdput(bdev);
 			if (attr == &ksysfs_register_quiet)
-				goto quiet_out;
+				goto done;
 		}
-		goto err;
+		goto out_free_sb;
 	}
 
 	err = "failed to set blocksize";
 	if (set_blocksize(bdev, 4096))
-		goto err_close;
+		goto out_blkdev_put;
 
 	err = read_super(sb, bdev, &sb_page);
 	if (err)
-		goto err_close;
+		goto out_blkdev_put;
 
 	err = "failed to register device";
 	if (SB_IS_BDEV(sb)) {
 		struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
 
 		if (!dc)
-			goto err_close;
+			goto out_put_sb_page;
 
 		mutex_lock(&bch_register_lock);
 		ret = register_bdev(sb, sb_page, bdev, dc);
 		mutex_unlock(&bch_register_lock);
 		/* blkdev_put() will be called in cached_dev_free() */
-		if (ret < 0)
-			goto err;
+		if (ret < 0) {
+			bdev = NULL;
+			goto out_put_sb_page;
+		}
 	} else {
 		struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
 
 		if (!ca)
-			goto err_close;
+			goto out_put_sb_page;
 
 		/* blkdev_put() will be called in bch_cache_release() */
-		if (register_cache(sb, sb_page, bdev, ca) != 0)
-			goto err;
+		if (register_cache(sb, sb_page, bdev, ca) != 0) {
+			bdev = NULL;
+			goto out_put_sb_page;
+		}
 	}
-quiet_out:
-	ret = size;
-out:
-	if (sb_page)
-		put_page(sb_page);
+
+	put_page(sb_page);
+done:
 	kfree(sb);
 	kfree(path);
 	module_put(THIS_MODULE);
-	return ret;
-
-err_close:
-	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
-err:
+	return size;
+
+out_put_sb_page:
+	put_page(sb_page);
+out_blkdev_put:
+	if (bdev)
+		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
+out_free_sb:
+	kfree(sb);
+out_free_path:
+	kfree(path);
+out_module_put:
+	module_put(THIS_MODULE);
+out:
 	pr_info("error %s: %s", path, err);
-	goto out;
+	return ret;
 }
 
 
-- 
2.20.1



