Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB81412C915
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387745AbfL2R7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387498AbfL2R6U (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D43921744;
        Sun, 29 Dec 2019 17:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642299;
        bh=elpoaO+NxbhLt81HUttiqnFbU9c992t55J6bTfkFNYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fq16h8rCp1kydnS6eo6XsqWLocI7EwfsLR5l3DfyS149mnOMsHSBnfL0WbOseEtsB
         nL8mZsEMzzjE9/Qew+mwX3e5l+z0FszbCzK0SJcoBCyPgKqA/EG9KKkW5Zhb4elVjU
         /+P+nDVsBPq+skvj4DTJXMYH5syAFYeTkDPGq3QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frederic Barrat <fbarrat@linux.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 426/434] ocxl: Fix concurrent AFU open and device removal
Date:   Sun, 29 Dec 2019 18:27:59 +0100
Message-Id: <20191229172731.523660871@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Barrat <fbarrat@linux.ibm.com>

commit a58d37bce0d21cf7fbd589384c619e465ef2f927 upstream.

If an ocxl device is unbound through sysfs at the same time its AFU is
being opened by a user process, the open code may dereference freed
stuctures, which can lead to kernel oops messages. You'd have to hit a
tiny time window, but it's possible. It's fairly easy to test by
making the time window bigger artificially.

Fix it with a combination of 2 changes:
  - when an AFU device is found in the IDR by looking for the device
    minor number, we should hold a reference on the device until after
    the context is allocated. A reference on the AFU structure is kept
    when the context is allocated, so we can release the reference on
    the device after the context allocation.
  - with the fix above, there's still another even tinier window,
    between the time the AFU device is found in the IDR and the
    reference on the device is taken. We can fix this one by removing
    the IDR entry earlier, when the device setup is removed, instead
    of waiting for the 'release' device callback. With proper locking
    around the IDR.

Fixes: 75ca758adbaf ("ocxl: Create a clear delineation between ocxl backend & frontend")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
Reviewed-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190624144148.32022-1-fbarrat@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/ocxl/file.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/drivers/misc/ocxl/file.c
+++ b/drivers/misc/ocxl/file.c
@@ -18,18 +18,15 @@ static struct class *ocxl_class;
 static struct mutex minors_idr_lock;
 static struct idr minors_idr;
 
-static struct ocxl_file_info *find_file_info(dev_t devno)
+static struct ocxl_file_info *find_and_get_file_info(dev_t devno)
 {
 	struct ocxl_file_info *info;
 
-	/*
-	 * We don't declare an RCU critical section here, as our AFU
-	 * is protected by a reference counter on the device. By the time the
-	 * info reference is removed from the idr, the ref count of
-	 * the device is already at 0, so no user API will access that AFU and
-	 * this function can't return it.
-	 */
+	mutex_lock(&minors_idr_lock);
 	info = idr_find(&minors_idr, MINOR(devno));
+	if (info)
+		get_device(&info->dev);
+	mutex_unlock(&minors_idr_lock);
 	return info;
 }
 
@@ -58,14 +55,16 @@ static int afu_open(struct inode *inode,
 
 	pr_debug("%s for device %x\n", __func__, inode->i_rdev);
 
-	info = find_file_info(inode->i_rdev);
+	info = find_and_get_file_info(inode->i_rdev);
 	if (!info)
 		return -ENODEV;
 
 	rc = ocxl_context_alloc(&ctx, info->afu, inode->i_mapping);
-	if (rc)
+	if (rc) {
+		put_device(&info->dev);
 		return rc;
-
+	}
+	put_device(&info->dev);
 	file->private_data = ctx;
 	return 0;
 }
@@ -487,7 +486,6 @@ static void info_release(struct device *
 {
 	struct ocxl_file_info *info = container_of(dev, struct ocxl_file_info, dev);
 
-	free_minor(info);
 	ocxl_afu_put(info->afu);
 	kfree(info);
 }
@@ -577,6 +575,7 @@ void ocxl_file_unregister_afu(struct ocx
 
 	ocxl_file_make_invisible(info);
 	ocxl_sysfs_unregister_afu(info);
+	free_minor(info);
 	device_unregister(&info->dev);
 }
 


