Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928BECA841
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389876AbfJCQYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:24:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390676AbfJCQYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:24:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D95A32054F;
        Thu,  3 Oct 2019 16:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119842;
        bh=lELE6Vaxr+TvQ92RUsLjVgiZt9kg/dHVU7y/pulWhUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lb5OeEVGA3UN9lJ8pnf25MLp/mfb1guqjfnTS7kjrmq6Ud7IiEwhVkgXS5PR1TK9h
         J1sjtWQht69jbxyyqlAfNWKjnCahGvIhgafImc/V2WUKTxv0x4S9eSQSoh3bCc5Fu8
         FhbmF2np4yRGcpcrHSyWmesJqhxxSFK2ny91PqnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 4.19 197/211] md: dont report active array_state until after revalidate_disk() completes.
Date:   Thu,  3 Oct 2019 17:54:23 +0200
Message-Id: <20191003154529.329375988@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
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
@@ -4123,7 +4123,7 @@ array_state_show(struct mddev *mddev, ch
 {
 	enum array_state st = inactive;
 
-	if (mddev->pers)
+	if (mddev->pers && !test_bit(MD_NOT_READY, &mddev->flags))
 		switch(mddev->ro) {
 		case 1:
 			st = readonly;
@@ -5678,9 +5678,6 @@ int md_run(struct mddev *mddev)
 		md_update_sb(mddev, 0);
 
 	md_new_event(mddev);
-	sysfs_notify_dirent_safe(mddev->sysfs_state);
-	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	sysfs_notify(&mddev->kobj, NULL, "degraded");
 	return 0;
 
 abort:
@@ -5694,6 +5691,7 @@ static int do_md_run(struct mddev *mddev
 {
 	int err;
 
+	set_bit(MD_NOT_READY, &mddev->flags);
 	err = md_run(mddev);
 	if (err)
 		goto out;
@@ -5714,9 +5712,14 @@ static int do_md_run(struct mddev *mddev
 
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
@@ -243,6 +243,9 @@ enum mddev_flags {
 	MD_UPDATING_SB,		/* md_check_recovery is updating the metadata
 				 * without explicitly holding reconfig_mutex.
 				 */
+	MD_NOT_READY,		/* do_md_run() is active, so 'array_state'
+				 * must not report that array is ready yet
+				 */
 };
 
 enum mddev_sb_flags {


