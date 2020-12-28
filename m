Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E292E3D77
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440759AbgL1OPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:15:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440754AbgL1OPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0322E22AAA;
        Mon, 28 Dec 2020 14:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164910;
        bh=r1tlACLZjAyGOdjwoCkZPsPlsYbDLmUk9QEd2yrZF20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GH5OG37dYPEpUSp4BvwvoVmDdoCZlXtURjjwgYCA1Ne6kjj9pr49sRAeI2MC1+ns1
         QedFVlFxP/HXXfeBhRb0GRGy4ovcG7cqzzidKGGOSj0vxyLHQFq0bcafCz6/avOHM7
         Vw6fIGr2BxXiaqFWZxvG75VSduYmZRq3dskqKdt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Lutz Pogrell <lutz.pogrell@cloud.ionos.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 341/717] block/rnbd-clt: Dynamically alloc buffer for pathname & blk_symlink_name
Date:   Mon, 28 Dec 2020 13:45:39 +0100
Message-Id: <20201228125037.361525019@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>

[ Upstream commit 64e8a6ece1a5b1fa21316918053d068baeac84af ]

For every rnbd_clt_dev, we alloc the pathname and blk_symlink_name
statically to NAME_MAX which is 255 bytes. In most of the cases we only
need less than 10 bytes, so 500 bytes per block device are wasted.

This commit dynamically allocates memory buffer for pathname and
blk_symlink_name.

Signed-off-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Reviewed-by: Lutz Pogrell <lutz.pogrell@cloud.ionos.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-clt-sysfs.c | 12 ++++++++++--
 drivers/block/rnbd/rnbd-clt.c       | 14 +++++++++++---
 drivers/block/rnbd/rnbd-clt.h       |  4 ++--
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-clt-sysfs.c b/drivers/block/rnbd/rnbd-clt-sysfs.c
index 4f4474eecadb7..b53df40c9a97f 100644
--- a/drivers/block/rnbd/rnbd-clt-sysfs.c
+++ b/drivers/block/rnbd/rnbd-clt-sysfs.c
@@ -435,6 +435,7 @@ void rnbd_clt_remove_dev_symlink(struct rnbd_clt_dev *dev)
 	 */
 	if (strlen(dev->blk_symlink_name) && try_module_get(THIS_MODULE)) {
 		sysfs_remove_link(rnbd_devs_kobj, dev->blk_symlink_name);
+		kfree(dev->blk_symlink_name);
 		module_put(THIS_MODULE);
 	}
 }
@@ -487,10 +488,17 @@ static int rnbd_clt_get_path_name(struct rnbd_clt_dev *dev, char *buf,
 static int rnbd_clt_add_dev_symlink(struct rnbd_clt_dev *dev)
 {
 	struct kobject *gd_kobj = &disk_to_dev(dev->gd)->kobj;
-	int ret;
+	int ret, len;
+
+	len = strlen(dev->pathname) + strlen(dev->sess->sessname) + 2;
+	dev->blk_symlink_name = kzalloc(len, GFP_KERNEL);
+	if (!dev->blk_symlink_name) {
+		rnbd_clt_err(dev, "Failed to allocate memory for blk_symlink_name\n");
+		goto out_err;
+	}
 
 	ret = rnbd_clt_get_path_name(dev, dev->blk_symlink_name,
-				      sizeof(dev->blk_symlink_name));
+				      len);
 	if (ret) {
 		rnbd_clt_err(dev, "Failed to get /sys/block symlink path, err: %d\n",
 			      ret);
diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
index 8b2411ccbda97..f180ebf1e11c9 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -59,6 +59,7 @@ static void rnbd_clt_put_dev(struct rnbd_clt_dev *dev)
 	ida_simple_remove(&index_ida, dev->clt_device_id);
 	mutex_unlock(&ida_lock);
 	kfree(dev->hw_queues);
+	kfree(dev->pathname);
 	rnbd_clt_put_sess(dev->sess);
 	mutex_destroy(&dev->lock);
 	kfree(dev);
@@ -1381,10 +1382,17 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
 		       pathname, sess->sessname, ret);
 		goto out_queues;
 	}
+
+	dev->pathname = kzalloc(strlen(pathname) + 1, GFP_KERNEL);
+	if (!dev->pathname) {
+		ret = -ENOMEM;
+		goto out_queues;
+	}
+	strlcpy(dev->pathname, pathname, strlen(pathname) + 1);
+
 	dev->clt_device_id	= ret;
 	dev->sess		= sess;
 	dev->access_mode	= access_mode;
-	strlcpy(dev->pathname, pathname, sizeof(dev->pathname));
 	mutex_init(&dev->lock);
 	refcount_set(&dev->refcount, 1);
 	dev->dev_state = DEV_STATE_INIT;
@@ -1413,8 +1421,8 @@ static bool __exists_dev(const char *pathname)
 	list_for_each_entry(sess, &sess_list, list) {
 		mutex_lock(&sess->lock);
 		list_for_each_entry(dev, &sess->devs_list, list) {
-			if (!strncmp(dev->pathname, pathname,
-				     sizeof(dev->pathname))) {
+			if (strlen(dev->pathname) == strlen(pathname) &&
+			    !strcmp(dev->pathname, pathname)) {
 				found = true;
 				break;
 			}
diff --git a/drivers/block/rnbd/rnbd-clt.h b/drivers/block/rnbd/rnbd-clt.h
index ed33654aa4868..b193d59040503 100644
--- a/drivers/block/rnbd/rnbd-clt.h
+++ b/drivers/block/rnbd/rnbd-clt.h
@@ -108,7 +108,7 @@ struct rnbd_clt_dev {
 	u32			clt_device_id;
 	struct mutex		lock;
 	enum rnbd_clt_dev_state	dev_state;
-	char			pathname[NAME_MAX];
+	char			*pathname;
 	enum rnbd_access_mode	access_mode;
 	bool			read_only;
 	bool			rotational;
@@ -126,7 +126,7 @@ struct rnbd_clt_dev {
 	struct list_head        list;
 	struct gendisk		*gd;
 	struct kobject		kobj;
-	char			blk_symlink_name[NAME_MAX];
+	char			*blk_symlink_name;
 	refcount_t		refcount;
 	struct work_struct	unmap_on_rmmod_work;
 };
-- 
2.27.0



