Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39766272EBB
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbgIUQud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730018AbgIUQud (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:50:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B21CD2076E;
        Mon, 21 Sep 2020 16:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600707032;
        bh=dfQCpOrd7f0i5gazYBKV2RH2fdG4PvBzqR7yqVf3wJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Puq9P5TyMH6k8WPpKNoIcvsb1S9+sRzUi76ZZbpzg5ti3rzVsxQH8L342mjeeyQh6
         I5rzctuiDYwCJJ3BQ3MNXZMzHZGKc8gL12TMfxXFJLxmM5gOoPDqiHxOg4YrYN/hDR
         DTjcXJ1+KOoZFSpn1pmLkNjTO9LOrug5kArW0wlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Huang <ahuang12@lenovo.com>,
        Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
        kernel test robot <lkp@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.4 71/72] dm: Call proper helper to determine dax support
Date:   Mon, 21 Sep 2020 18:31:50 +0200
Message-Id: <20200921163125.239813828@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit e2ec5128254518cae320d5dc631b71b94160f663 upstream.

DM was calling generic_fsdax_supported() to determine whether a device
referenced in the DM table supports DAX. However this is a helper for "leaf" device drivers so that
they don't have to duplicate common generic checks. High level code
should call dax_supported() helper which that calls into appropriate
helper for the particular device. This problem manifested itself as
kernel messages:

dm-3: error: dax access failed (-95)

when lvm2-testsuite run in cases where a DM device was stacked on top of
another DM device.

Fixes: 7bf7eac8d648 ("dax: Arrange for dax_supported check to span multiple devices")
Cc: <stable@vger.kernel.org>
Tested-by: Adrian Huang <ahuang12@lenovo.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/160061715195.13131.5503173247632041975.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dax/super.c   |    4 ++++
 drivers/md/dm-table.c |   10 +++++++---
 include/linux/dax.h   |   22 ++++++++++++++++++++--
 3 files changed, 31 insertions(+), 5 deletions(-)

--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -318,11 +318,15 @@ EXPORT_SYMBOL_GPL(dax_direct_access);
 bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
 		int blocksize, sector_t start, sector_t len)
 {
+	if (!dax_dev)
+		return false;
+
 	if (!dax_alive(dax_dev))
 		return false;
 
 	return dax_dev->ops->dax_supported(dax_dev, bdev, blocksize, start, len);
 }
+EXPORT_SYMBOL_GPL(dax_supported);
 
 size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 		size_t bytes, struct iov_iter *i)
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -882,10 +882,14 @@ EXPORT_SYMBOL_GPL(dm_table_set_type);
 int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
 			sector_t start, sector_t len, void *data)
 {
-	int blocksize = *(int *) data;
+	int blocksize = *(int *) data, id;
+	bool rc;
 
-	return generic_fsdax_supported(dev->dax_dev, dev->bdev, blocksize,
-				       start, len);
+	id = dax_read_lock();
+	rc = dax_supported(dev->dax_dev, dev->bdev, blocksize, start, len);
+	dax_read_unlock(id);
+
+	return rc;
 }
 
 /* Check devices support synchronous DAX */
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -128,6 +128,8 @@ static inline bool generic_fsdax_support
 	return __generic_fsdax_supported(dax_dev, bdev, blocksize, start,
 			sectors);
 }
+bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
+		int blocksize, sector_t start, sector_t len);
 
 static inline struct dax_device *fs_dax_get_by_host(const char *host)
 {
@@ -165,6 +167,13 @@ static inline struct dax_device *fs_dax_
 	return NULL;
 }
 
+static inline bool dax_supported(struct dax_device *dax_dev,
+		struct block_device *bdev, int blocksize, sector_t start,
+		sector_t len)
+{
+	return false;
+}
+
 static inline void fs_put_dax(struct dax_device *dax_dev)
 {
 }
@@ -197,14 +206,23 @@ static inline void dax_unlock_page(struc
 }
 #endif
 
+#if IS_ENABLED(CONFIG_DAX)
 int dax_read_lock(void);
 void dax_read_unlock(int id);
+#else
+static inline int dax_read_lock(void)
+{
+	return 0;
+}
+
+static inline void dax_read_unlock(int id)
+{
+}
+#endif /* CONFIG_DAX */
 bool dax_alive(struct dax_device *dax_dev);
 void *dax_get_private(struct dax_device *dax_dev);
 long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 		void **kaddr, pfn_t *pfn);
-bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
-		int blocksize, sector_t start, sector_t len);
 size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 		size_t bytes, struct iov_iter *i);
 size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,


