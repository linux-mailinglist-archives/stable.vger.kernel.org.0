Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A221B1BDD9
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 21:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfEMTZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 15:25:57 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46866 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbfEMTZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 15:25:57 -0400
Received: from localhost.localdomain (unknown [IPv6:2804:431:9719:d573:a076:d1fd:3417:b195])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: koike)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id C545F281DC5;
        Mon, 13 May 2019 20:25:52 +0100 (BST)
From:   Helen Koike <helen.koike@collabora.com>
To:     dm-devel@redhat.com
Cc:     kernel@collabora.com, Helen Koike <helen.koike@collabora.com>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Subject: [PATCH] dm ioctl: fix hang in early create error condition
Date:   Mon, 13 May 2019 16:25:30 -0300
Message-Id: <20190513192530.1167-1-helen.koike@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The dm_early_create() function (which deals with "dm-mod.create=" kernel
command line option) calls dm_hash_insert() who gets an extra reference
to the md object.

In case of failure, this reference wasn't being released, causing
dm_destroy() to hang, thus hanging the whole boot process.

Fix this by calling __hash_remove() in the error path.

Fixes: 6bbc923dfcf57d ("dm: add support to directly boot to a mapped device")
Cc: stable@vger.kernel.org
Signed-off-by: Helen Koike <helen.koike@collabora.com>

---
Hi,

I tested this patch by adding a new test case in the following test
script:

https://gitlab.collabora.com/koike/dm-cmdline-test/commit/d2d7a0ee4a49931cdb59f08a837b516c2d5d743d

This test was failing, but with this patch it works correctly.

Thanks
Helen

 drivers/md/dm-ioctl.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index c740153b4e52..31da18611a21 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -205,7 +205,8 @@ static void free_cell(struct hash_cell *hc)
  * The kdev_t and uuid of a device can never change once it is
  * initially inserted.
  */
-static int dm_hash_insert(const char *name, const char *uuid, struct mapped_device *md)
+static struct hash_cell *dm_hash_insert(const char *name, const char *uuid,
+					struct mapped_device *md)
 {
 	struct hash_cell *cell, *hc;
 
@@ -214,7 +215,7 @@ static int dm_hash_insert(const char *name, const char *uuid, struct mapped_devi
 	 */
 	cell = alloc_cell(name, uuid, md);
 	if (!cell)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	/*
 	 * Insert the cell into both hash tables.
@@ -243,12 +244,12 @@ static int dm_hash_insert(const char *name, const char *uuid, struct mapped_devi
 	mutex_unlock(&dm_hash_cells_mutex);
 	up_write(&_hash_lock);
 
-	return 0;
+	return cell;
 
  bad:
 	up_write(&_hash_lock);
 	free_cell(cell);
-	return -EBUSY;
+	return ERR_PTR(-EBUSY);
 }
 
 static struct dm_table *__hash_remove(struct hash_cell *hc)
@@ -747,6 +748,7 @@ static int dev_create(struct file *filp, struct dm_ioctl *param, size_t param_si
 {
 	int r, m = DM_ANY_MINOR;
 	struct mapped_device *md;
+	struct hash_cell *hc;
 
 	r = check_name(param->name);
 	if (r)
@@ -759,11 +761,11 @@ static int dev_create(struct file *filp, struct dm_ioctl *param, size_t param_si
 	if (r)
 		return r;
 
-	r = dm_hash_insert(param->name, *param->uuid ? param->uuid : NULL, md);
-	if (r) {
+	hc = dm_hash_insert(param->name, *param->uuid ? param->uuid : NULL, md);
+	if (IS_ERR(hc)) {
 		dm_put(md);
 		dm_destroy(md);
-		return r;
+		return PTR_ERR(hc);
 	}
 
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
@@ -2044,6 +2046,7 @@ int __init dm_early_create(struct dm_ioctl *dmi,
 	int r, m = DM_ANY_MINOR;
 	struct dm_table *t, *old_map;
 	struct mapped_device *md;
+	struct hash_cell *hc;
 	unsigned int i;
 
 	if (!dmi->target_count)
@@ -2062,14 +2065,14 @@ int __init dm_early_create(struct dm_ioctl *dmi,
 		return r;
 
 	/* hash insert */
-	r = dm_hash_insert(dmi->name, *dmi->uuid ? dmi->uuid : NULL, md);
-	if (r)
+	hc = dm_hash_insert(dmi->name, *dmi->uuid ? dmi->uuid : NULL, md);
+	if (IS_ERR(hc))
 		goto err_destroy_dm;
 
 	/* alloc table */
 	r = dm_table_create(&t, get_mode(dmi), dmi->target_count, md);
 	if (r)
-		goto err_destroy_dm;
+		goto err_hash_remove;
 
 	/* add targets */
 	for (i = 0; i < dmi->target_count; i++) {
@@ -2116,6 +2119,8 @@ int __init dm_early_create(struct dm_ioctl *dmi,
 
 err_destroy_table:
 	dm_table_destroy(t);
+err_hash_remove:
+	__hash_remove(hc);
 err_destroy_dm:
 	dm_put(md);
 	dm_destroy(md);
-- 
2.20.1

