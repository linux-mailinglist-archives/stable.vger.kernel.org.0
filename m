Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063AB6AECD9
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjCGR6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjCGR57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:57:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC499F077
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:52:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D048961507
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6341C4339B;
        Tue,  7 Mar 2023 17:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211552;
        bh=V3e9yIEPHQEu54S32WuwDM4b1JaPpugn6OxAPPMnFQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjTO+dZ4us91D6+sANEJheQCxuGz3GzloqHPCy3PehCrmGZyC6bP27gCx3cL2J8ql
         oovXVmb7gDjDVEwBmRz6rbSYfD2GIJfbRakZRWZiifH1jaJVSkiV/cExc4khyYSxAi
         uqEBAdxWqYzzZ01GUvVvraIyWHg2AYzw9dSLtWDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.2 0900/1001] dm: send just one event on resize, not two
Date:   Tue,  7 Mar 2023 18:01:12 +0100
Message-Id: <20230307170101.055886417@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 7533afa1d27ba1234146d31d2402c195cf195962 upstream.

Device mapper sends an uevent when the device is suspended, using the
function set_capacity_and_notify. However, this causes a race condition
with udev.

Udev skips scanning dm devices that are suspended. If we send an uevent
while we are suspended, udev will be racing with device mapper resume
code. If the device mapper resume code wins the race, udev will process
the uevent after the device is resumed and it will properly scan the
device.

However, if udev wins the race, it will receive the uevent, find out that
the dm device is suspended and skip scanning the device. This causes bugs
such as systemd unmounting the device - see
https://bugzilla.redhat.com/show_bug.cgi?id=2158628

This commit fixes this race.

We replace the function set_capacity_and_notify with set_capacity, so that
the uevent is not sent at this point. In do_resume, we detect if the
capacity has changed and we pass a boolean variable need_resize_uevent to
dm_kobject_uevent. dm_kobject_uevent adds "RESIZE=1" to the uevent if
need_resize_uevent is set.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Tested-by: Peter Rajnoha <prajnoha@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |   13 ++++++++++---
 drivers/md/dm.c       |   27 +++++++++++++--------------
 drivers/md/dm.h       |    2 +-
 3 files changed, 24 insertions(+), 18 deletions(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -482,7 +482,7 @@ static struct mapped_device *dm_hash_ren
 		dm_table_event(table);
 	dm_put_live_table(hc->md, srcu_idx);
 
-	if (!dm_kobject_uevent(hc->md, KOBJ_CHANGE, param->event_nr))
+	if (!dm_kobject_uevent(hc->md, KOBJ_CHANGE, param->event_nr, false))
 		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
 	md = hc->md;
@@ -995,7 +995,7 @@ static int dev_remove(struct file *filp,
 
 	dm_ima_measure_on_device_remove(md, false);
 
-	if (!dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr))
+	if (!dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr, false))
 		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
 	dm_put(md);
@@ -1129,6 +1129,7 @@ static int do_resume(struct dm_ioctl *pa
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	struct dm_table *new_map, *old_map = NULL;
+	bool need_resize_uevent = false;
 
 	down_write(&_hash_lock);
 
@@ -1149,6 +1150,8 @@ static int do_resume(struct dm_ioctl *pa
 
 	/* Do we need to load a new map ? */
 	if (new_map) {
+		sector_t old_size, new_size;
+
 		/* Suspend if it isn't already suspended */
 		if (param->flags & DM_SKIP_LOCKFS_FLAG)
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
@@ -1157,6 +1160,7 @@ static int do_resume(struct dm_ioctl *pa
 		if (!dm_suspended_md(md))
 			dm_suspend(md, suspend_flags);
 
+		old_size = dm_get_size(md);
 		old_map = dm_swap_table(md, new_map);
 		if (IS_ERR(old_map)) {
 			dm_sync_table(md);
@@ -1164,6 +1168,9 @@ static int do_resume(struct dm_ioctl *pa
 			dm_put(md);
 			return PTR_ERR(old_map);
 		}
+		new_size = dm_get_size(md);
+		if (old_size && new_size && old_size != new_size)
+			need_resize_uevent = true;
 
 		if (dm_table_get_mode(new_map) & FMODE_WRITE)
 			set_disk_ro(dm_disk(md), 0);
@@ -1176,7 +1183,7 @@ static int do_resume(struct dm_ioctl *pa
 		if (!r) {
 			dm_ima_measure_on_device_resume(md, new_map ? true : false);
 
-			if (!dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr))
+			if (!dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr, need_resize_uevent))
 				param->flags |= DM_UEVENT_GENERATED_FLAG;
 		}
 	}
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2171,10 +2171,7 @@ static struct dm_table *__bind(struct ma
 	if (size != dm_get_size(md))
 		memset(&md->geometry, 0, sizeof(md->geometry));
 
-	if (!get_capacity(md->disk))
-		set_capacity(md->disk, size);
-	else
-		set_capacity_and_notify(md->disk, size);
+	set_capacity(md->disk, size);
 
 	dm_table_event_callback(t, event_callback, md);
 
@@ -2967,23 +2964,25 @@ EXPORT_SYMBOL_GPL(dm_internal_resume_fas
  * Event notification.
  *---------------------------------------------------------------*/
 int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
-		       unsigned cookie)
+		      unsigned cookie, bool need_resize_uevent)
 {
 	int r;
 	unsigned noio_flag;
 	char udev_cookie[DM_COOKIE_LENGTH];
-	char *envp[] = { udev_cookie, NULL };
-
-	noio_flag = memalloc_noio_save();
-
-	if (!cookie)
-		r = kobject_uevent(&disk_to_dev(md->disk)->kobj, action);
-	else {
+	char *envp[3] = { NULL, NULL, NULL };
+	char **envpp = envp;
+	if (cookie) {
 		snprintf(udev_cookie, DM_COOKIE_LENGTH, "%s=%u",
 			 DM_COOKIE_ENV_VAR_NAME, cookie);
-		r = kobject_uevent_env(&disk_to_dev(md->disk)->kobj,
-				       action, envp);
+		*envpp++ = udev_cookie;
 	}
+	if (need_resize_uevent) {
+		*envpp++ = "RESIZE=1";
+	}
+
+	noio_flag = memalloc_noio_save();
+
+	r = kobject_uevent_env(&disk_to_dev(md->disk)->kobj, action, envp);
 
 	memalloc_noio_restore(noio_flag);
 
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -203,7 +203,7 @@ int dm_get_table_device(struct mapped_de
 void dm_put_table_device(struct mapped_device *md, struct dm_dev *d);
 
 int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
-		      unsigned cookie);
+		      unsigned cookie, bool need_resize_uevent);
 
 void dm_internal_suspend(struct mapped_device *md);
 void dm_internal_resume(struct mapped_device *md);


