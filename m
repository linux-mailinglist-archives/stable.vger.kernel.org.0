Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29521AC48C
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392792AbgDPOBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392766AbgDPOBV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:01:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21B0820732;
        Thu, 16 Apr 2020 14:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045679;
        bh=k7+F2+dZbLUXEVNzfB8DK7Rq3o1/WbEpoaovpbzJBtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3rhtds5ytU7kYPdovv0uMlDZRtVMRI4oZJCqtJGJurnUKDf8apPWWALBs7OYkq1L
         c2OK472cQfgKnkF6Nc3CwPGAu9kVQvJ8FK9EybjsikXLYNvbJ+0r0aXPOwsMOUavlZ
         oWZm3wnaBkAXKa/LYVQUo/ew9k6QaFqHG8wT7Wsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Merlijn Wajer <merlijn@archive.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.6 234/254] scsi: sr: get rid of sr global mutex
Date:   Thu, 16 Apr 2020 15:25:23 +0200
Message-Id: <20200416131354.857149679@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Merlijn Wajer <merlijn@archive.org>

commit 51a858817dcdbbdee22cb54b0b2b26eb145ca5b6 upstream.

When replacing the Big Kernel Lock in commit 2a48fc0ab242 ("block:
autoconvert trivial BKL users to private mutex"), the lock was replaced
with a sr-wide lock.

This causes very poor performance when using multiple sr devices, as the sr
driver was not able to execute more than one command to one drive at any
given time, even when there were many CD drives available.

Replace the global mutex with per-sr-device mutex.

Someone tried this patch at the time, but it never made it upstream, due to
possible concerns with race conditions, but it's not clear the patch
actually caused those:

https://www.spinics.net/lists/linux-scsi/msg63706.html
https://www.spinics.net/lists/linux-scsi/msg63750.html

Also see

http://lists.xiph.org/pipermail/paranoia/2019-December/001647.html

Link: https://lore.kernel.org/r/20200218143918.30267-1-merlijn@archive.org
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Merlijn Wajer <merlijn@archive.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sr.c |   20 +++++++++++---------
 drivers/scsi/sr.h |    2 ++
 2 files changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -79,7 +79,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
 	 CDC_MRW|CDC_MRW_W|CDC_RAM)
 
-static DEFINE_MUTEX(sr_mutex);
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt);
@@ -536,9 +535,9 @@ static int sr_block_open(struct block_de
 	scsi_autopm_get_device(sdev);
 	check_disk_change(bdev);
 
-	mutex_lock(&sr_mutex);
+	mutex_lock(&cd->lock);
 	ret = cdrom_open(&cd->cdi, bdev, mode);
-	mutex_unlock(&sr_mutex);
+	mutex_unlock(&cd->lock);
 
 	scsi_autopm_put_device(sdev);
 	if (ret)
@@ -551,10 +550,10 @@ out:
 static void sr_block_release(struct gendisk *disk, fmode_t mode)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
-	mutex_lock(&sr_mutex);
+	mutex_lock(&cd->lock);
 	cdrom_release(&cd->cdi, mode);
 	scsi_cd_put(cd);
-	mutex_unlock(&sr_mutex);
+	mutex_unlock(&cd->lock);
 }
 
 static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
@@ -565,7 +564,7 @@ static int sr_block_ioctl(struct block_d
 	void __user *argp = (void __user *)arg;
 	int ret;
 
-	mutex_lock(&sr_mutex);
+	mutex_lock(&cd->lock);
 
 	ret = scsi_ioctl_block_when_processing_errors(sdev, cmd,
 			(mode & FMODE_NDELAY) != 0);
@@ -595,7 +594,7 @@ put:
 	scsi_autopm_put_device(sdev);
 
 out:
-	mutex_unlock(&sr_mutex);
+	mutex_unlock(&cd->lock);
 	return ret;
 }
 
@@ -608,7 +607,7 @@ static int sr_block_compat_ioctl(struct
 	void __user *argp = compat_ptr(arg);
 	int ret;
 
-	mutex_lock(&sr_mutex);
+	mutex_lock(&cd->lock);
 
 	ret = scsi_ioctl_block_when_processing_errors(sdev, cmd,
 			(mode & FMODE_NDELAY) != 0);
@@ -638,7 +637,7 @@ put:
 	scsi_autopm_put_device(sdev);
 
 out:
-	mutex_unlock(&sr_mutex);
+	mutex_unlock(&cd->lock);
 	return ret;
 
 }
@@ -745,6 +744,7 @@ static int sr_probe(struct device *dev)
 	disk = alloc_disk(1);
 	if (!disk)
 		goto fail_free;
+	mutex_init(&cd->lock);
 
 	spin_lock(&sr_index_lock);
 	minor = find_first_zero_bit(sr_index_bits, SR_DISKS);
@@ -1055,6 +1055,8 @@ static void sr_kref_release(struct kref
 
 	put_disk(disk);
 
+	mutex_destroy(&cd->lock);
+
 	kfree(cd);
 }
 
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -20,6 +20,7 @@
 
 #include <linux/genhd.h>
 #include <linux/kref.h>
+#include <linux/mutex.h>
 
 #define MAX_RETRIES	3
 #define SR_TIMEOUT	(30 * HZ)
@@ -51,6 +52,7 @@ typedef struct scsi_cd {
 	bool ignore_get_event:1;	/* GET_EVENT is unreliable, use TUR */
 
 	struct cdrom_device_info cdi;
+	struct mutex lock;
 	/* We hold gendisk and scsi_device references on probe and use
 	 * the refs on this kref to decide when to release them */
 	struct kref kref;


