Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0AD490CE8
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241407AbiAQQ77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 11:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241421AbiAQQ7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 11:59:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C24AC061762;
        Mon, 17 Jan 2022 08:59:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BA45611DA;
        Mon, 17 Jan 2022 16:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F59C36AE7;
        Mon, 17 Jan 2022 16:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438777;
        bh=wpeCaTchYmxiHGGB/zd+aYB5oc+l/iumejBoL0k8dtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vOhDwI+F2C8+Njl60v59+DK7IdjzTTXzYvkAwsnuS6b2qz+cFelGMPH5PvJAF2taT
         X4dp1hHGWwKptbWU3TItIC94+u1JcYbty3Pvkqacn/4zf7Q35ZkPhpZjjTXLgc5j7m
         bcX1R+gcwfDU+V6WKW0OBkEIi5srb7Hv26FagSPFxjdsvt2oOfBW5bxb9twyFBePXr
         uPJR76dQH1HvaRyQpZxElcOAa+aXLx667ElvgYCnlk2l1tl3MNIuD1lvNMDFA0axce
         lr99NiP1J8QVhTARCUw0q3tsfjI5/ykTR1wUy7IBj6bg5OY8fruRHn0KAMuoLafdv1
         pZLFARRBefa0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, vishal.l.verma@intel.com,
        dave.jiang@intel.com, agk@redhat.com, dm-devel@redhat.com,
        nvdimm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.16 19/52] dm: make the DAX support depend on CONFIG_FS_DAX
Date:   Mon, 17 Jan 2022 11:58:20 -0500
Message-Id: <20220117165853.1470420-19-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 5d2a228b9e1319ff188f9ea89006fbe575561921 ]

The device mapper DAX support is all hanging off a block device and thus
can't be used with device dax.  Make it depend on CONFIG_FS_DAX instead
of CONFIG_DAX_DRIVER.  This also means that bdev_dax_pgoff only needs to
be built under CONFIG_FS_DAX now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Link: https://lore.kernel.org/r/20211129102203.2243509-3-hch@lst.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/super.c        | 6 ++----
 drivers/md/dm-linear.c     | 2 +-
 drivers/md/dm-log-writes.c | 2 +-
 drivers/md/dm-stripe.c     | 2 +-
 drivers/md/dm-writecache.c | 2 +-
 drivers/md/dm.c            | 2 +-
 6 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index b882cf8106ea3..e20d0cef10a18 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -63,7 +63,7 @@ static int dax_host_hash(const char *host)
 	return hashlen_hash(hashlen_string("DAX", host)) % DAX_HASH_SIZE;
 }
 
-#ifdef CONFIG_BLOCK
+#if defined(CONFIG_BLOCK) && defined(CONFIG_FS_DAX)
 #include <linux/blkdev.h>
 
 int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
@@ -80,7 +80,6 @@ int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
 }
 EXPORT_SYMBOL(bdev_dax_pgoff);
 
-#if IS_ENABLED(CONFIG_FS_DAX)
 /**
  * dax_get_by_host() - temporary lookup mechanism for filesystem-dax
  * @host: alternate name for the device registered by a dax driver
@@ -219,8 +218,7 @@ bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dax_supported);
-#endif /* CONFIG_FS_DAX */
-#endif /* CONFIG_BLOCK */
+#endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
 
 enum dax_device_flags {
 	/* !alive + rcu grace period == no new operations / mappings */
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 66ba16713f696..0a260c35aeeed 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -162,7 +162,7 @@ static int linear_iterate_devices(struct dm_target *ti,
 	return fn(ti, lc->dev, lc->start, ti->len, data);
 }
 
-#if IS_ENABLED(CONFIG_DAX_DRIVER)
+#if IS_ENABLED(CONFIG_FS_DAX)
 static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
 {
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 0b3ef977ceeba..3155875d4e5b0 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -901,7 +901,7 @@ static void log_writes_io_hints(struct dm_target *ti, struct queue_limits *limit
 	limits->io_min = limits->physical_block_size;
 }
 
-#if IS_ENABLED(CONFIG_DAX_DRIVER)
+#if IS_ENABLED(CONFIG_FS_DAX)
 static int log_dax(struct log_writes_c *lc, sector_t sector, size_t bytes,
 		   struct iov_iter *i)
 {
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 6660b6b53d5bf..f084607220293 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -300,7 +300,7 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
-#if IS_ENABLED(CONFIG_DAX_DRIVER)
+#if IS_ENABLED(CONFIG_FS_DAX)
 static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
 {
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 4b8991cde223d..4f31591d2d25e 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -38,7 +38,7 @@
 #define BITMAP_GRANULARITY	PAGE_SIZE
 #endif
 
-#if IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API) && IS_ENABLED(CONFIG_DAX_DRIVER)
+#if IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API) && IS_ENABLED(CONFIG_FS_DAX)
 #define DM_WRITECACHE_HAS_PMEM
 #endif
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index acc84dc1bded5..b93fcc91176e5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1783,7 +1783,7 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
-	if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
+	if (IS_ENABLED(CONFIG_FS_DAX)) {
 		md->dax_dev = alloc_dax(md, md->disk->disk_name,
 					&dm_dax_ops, 0);
 		if (IS_ERR(md->dax_dev)) {
-- 
2.34.1

