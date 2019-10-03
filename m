Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E551CA74A
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406184AbfJCQwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406203AbfJCQwd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:52:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 774C520862;
        Thu,  3 Oct 2019 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121553;
        bh=Ty6OmMJeSi36HxlUFpwL5QrdExxs1uOXz5p0/lr+0ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MCXs22U+12p+M6ovxOOZwzdXmtbWuFQM7+YAQVj3Vu0xw52Oed0CDR/g3Q4qpwm+z
         jC+gjpZqmzDZshaLmD+rAAM6pLhOGzy9tDLhoyLL3l7WpB+HUyH3x5H4M0r18bAEQn
         KAwpWbDulL8q24c5mnTykT6YiahGxs/FGZiJ+xDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.3 321/344] md: dont report active array_state until after revalidate_disk() completes.
Date:   Thu,  3 Oct 2019 17:54:46 +0200
Message-Id: <20191003154610.681610226@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.com>

commit 9d4b45d6af442237560d0bb5502a012baa5234b7 upstream.

Until revalidate_disk() has completed, the size of a new md array will
appear to be zero.
So we shouldn't report, through array_state, that the array is active
until that time.
udev rules check array_state to see if the array is ready.  As soon as
it appear to be zero, fsck can be run.  If it find the size to be
zero, it will fail.

So add a new flag to provide an interlock between do_md_run() and
array_state_show().  This flag is set while do_md_run() is active and
it prevents array_state_show() from reporting that the array is
active.

Before do_md_run() is called, ->pers will be NULL so array is
definitely not active.
After do_md_run() is called, revalidate_disk() will have run and the
array will be completely ready.

We also move various sysfs_notify*() calls out of md_run() into
do_md_run() after MD_NOT_READY is cleared.  This ensure the
information is ready before the notification is sent.

Prior to v4.12, array_state_show() was called with the
mddev->reconfig_mutex held, which provided exclusion with do_md_run().

Note that MD_NOT_READY cleared twice.  This is deliberate to cover
both success and error paths with minimal noise.

Fixes: b7b17c9b67e5 ("md: remove mddev_lock() from md_attr_show()")
Cc: stable@vger.kernel.org (v4.12++)
Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |   11 +++++++----
 drivers/md/md.h |    3 +++
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4183,7 +4183,7 @@ array_state_show(struct mddev *mddev, ch
 {
 	enum array_state st = inactive;
 
-	if (mddev->pers)
+	if (mddev->pers && !test_bit(MD_NOT_READY, &mddev->flags))
 		switch(mddev->ro) {
 		case 1:
 			st = readonly;
@@ -5751,9 +5751,6 @@ int md_run(struct mddev *mddev)
 		md_update_sb(mddev, 0);
 
 	md_new_event(mddev);
-	sysfs_notify_dirent_safe(mddev->sysfs_state);
-	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	sysfs_notify(&mddev->kobj, NULL, "degraded");
 	return 0;
 
 bitmap_abort:
@@ -5774,6 +5771,7 @@ static int do_md_run(struct mddev *mddev
 {
 	int err;
 
+	set_bit(MD_NOT_READY, &mddev->flags);
 	err = md_run(mddev);
 	if (err)
 		goto out;
@@ -5794,9 +5792,14 @@ static int do_md_run(struct mddev *mddev
 
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	revalidate_disk(mddev->gendisk);
+	clear_bit(MD_NOT_READY, &mddev->flags);
 	mddev->changed = 1;
 	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
+	sysfs_notify_dirent_safe(mddev->sysfs_state);
+	sysfs_notify_dirent_safe(mddev->sysfs_action);
+	sysfs_notify(&mddev->kobj, NULL, "degraded");
 out:
+	clear_bit(MD_NOT_READY, &mddev->flags);
 	return err;
 }
 
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -248,6 +248,9 @@ enum mddev_flags {
 	MD_UPDATING_SB,		/* md_check_recovery is updating the metadata
 				 * without explicitly holding reconfig_mutex.
 				 */
+	MD_NOT_READY,		/* do_md_run() is active, so 'array_state'
+				 * must not report that array is ready yet
+				 */
 };
 
 enum mddev_sb_flags {


