Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1125729A0A9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409504AbgJ0AcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409344AbgJZXvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C9C720773;
        Mon, 26 Oct 2020 23:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756298;
        bh=Pbmu5Z2n6hLZhkNrjuufr/TN6gPMjaaa1cOfSrZ4FaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjVU6c13O3mJwdIPFhiWA9XXvia4jrOhxmIpZujw4zi562TS2z9jFDcMrDakVdeUx
         lvO89Fgn68eZGXt0K7vJv4viuL9/n4GAhlR8InVJvNhA7rI87IlD5UdksXJPoMSIf8
         NnXOJlX+WFPU06Y38qvr9ljedQJyRrLq0NzPAz0c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jamie Iles <jamie@nuviainc.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.9 125/147] gfs2: use-after-free in sysfs deregistration
Date:   Mon, 26 Oct 2020 19:48:43 -0400
Message-Id: <20201026234905.1022767-125-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jamie Iles <jamie@nuviainc.com>

[ Upstream commit c2a04b02c060c4858762edce4674d5cba3e5a96f ]

syzkaller found the following splat with CONFIG_DEBUG_KOBJECT_RELEASE=y:

  Read of size 1 at addr ffff000028e896b8 by task kworker/1:2/228

  CPU: 1 PID: 228 Comm: kworker/1:2 Tainted: G S                5.9.0-rc8+ #101
  Hardware name: linux,dummy-virt (DT)
  Workqueue: events kobject_delayed_cleanup
  Call trace:
   dump_backtrace+0x0/0x4d8
   show_stack+0x34/0x48
   dump_stack+0x174/0x1f8
   print_address_description.constprop.0+0x5c/0x550
   kasan_report+0x13c/0x1c0
   __asan_report_load1_noabort+0x34/0x60
   memcmp+0xd0/0xd8
   gfs2_uevent+0xc4/0x188
   kobject_uevent_env+0x54c/0x1240
   kobject_uevent+0x2c/0x40
   __kobject_del+0x190/0x1d8
   kobject_delayed_cleanup+0x2bc/0x3b8
   process_one_work+0x96c/0x18c0
   worker_thread+0x3f0/0xc30
   kthread+0x390/0x498
   ret_from_fork+0x10/0x18

  Allocated by task 1110:
   kasan_save_stack+0x28/0x58
   __kasan_kmalloc.isra.0+0xc8/0xe8
   kasan_kmalloc+0x10/0x20
   kmem_cache_alloc_trace+0x1d8/0x2f0
   alloc_super+0x64/0x8c0
   sget_fc+0x110/0x620
   get_tree_bdev+0x190/0x648
   gfs2_get_tree+0x50/0x228
   vfs_get_tree+0x84/0x2e8
   path_mount+0x1134/0x1da8
   do_mount+0x124/0x138
   __arm64_sys_mount+0x164/0x238
   el0_svc_common.constprop.0+0x15c/0x598
   do_el0_svc+0x60/0x150
   el0_svc+0x34/0xb0
   el0_sync_handler+0xc8/0x5b4
   el0_sync+0x15c/0x180

  Freed by task 228:
   kasan_save_stack+0x28/0x58
   kasan_set_track+0x28/0x40
   kasan_set_free_info+0x24/0x48
   __kasan_slab_free+0x118/0x190
   kasan_slab_free+0x14/0x20
   slab_free_freelist_hook+0x6c/0x210
   kfree+0x13c/0x460

Use the same pattern as f2fs + ext4 where the kobject destruction must
complete before allowing the FS itself to be freed.  This means that we
need an explicit free_sbd in the callers.

Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Jamie Iles <jamie@nuviainc.com>
[Also go to fail_free when init_names fails.]
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/incore.h     |  1 +
 fs/gfs2/ops_fstype.c | 22 +++++-----------------
 fs/gfs2/super.c      |  1 +
 fs/gfs2/sys.c        |  5 ++++-
 4 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index ca2ec02436ec7..387e99d6eda9e 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -705,6 +705,7 @@ struct gfs2_sbd {
 	struct super_block *sd_vfs;
 	struct gfs2_pcpu_lkstats __percpu *sd_lkstats;
 	struct kobject sd_kobj;
+	struct completion sd_kobj_unregister;
 	unsigned long sd_flags;	/* SDF_... */
 	struct gfs2_sb_host sd_sb;
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 6d18d2c91add2..5bd602a290f72 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1062,26 +1062,14 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 
 	error = init_names(sdp, silent);
-	if (error) {
-		/* In this case, we haven't initialized sysfs, so we have to
-		   manually free the sdp. */
-		free_sbd(sdp);
-		sb->s_fs_info = NULL;
-		return error;
-	}
+	if (error)
+		goto fail_free;
 
 	snprintf(sdp->sd_fsname, sizeof(sdp->sd_fsname), "%s", sdp->sd_table_name);
 
 	error = gfs2_sys_fs_add(sdp);
-	/*
-	 * If we hit an error here, gfs2_sys_fs_add will have called function
-	 * kobject_put which causes the sysfs usage count to go to zero, which
-	 * causes sysfs to call function gfs2_sbd_release, which frees sdp.
-	 * Subsequent error paths here will call gfs2_sys_fs_del, which also
-	 * kobject_put to free sdp.
-	 */
 	if (error)
-		return error;
+		goto fail_free;
 
 	gfs2_create_debugfs_file(sdp);
 
@@ -1179,9 +1167,9 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 	gfs2_lm_unmount(sdp);
 fail_debug:
 	gfs2_delete_debugfs_file(sdp);
-	/* gfs2_sys_fs_del must be the last thing we do, since it causes
-	 * sysfs to call function gfs2_sbd_release, which frees sdp. */
 	gfs2_sys_fs_del(sdp);
+fail_free:
+	free_sbd(sdp);
 	sb->s_fs_info = NULL;
 	return error;
 }
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 9f4d9e7be8397..a28cf447b6b12 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -736,6 +736,7 @@ static void gfs2_put_super(struct super_block *sb)
 
 	/*  At this point, we're through participating in the lockspace  */
 	gfs2_sys_fs_del(sdp);
+	free_sbd(sdp);
 }
 
 /**
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index d28c41bd69b05..c3e72dba7418a 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -303,7 +303,7 @@ static void gfs2_sbd_release(struct kobject *kobj)
 {
 	struct gfs2_sbd *sdp = container_of(kobj, struct gfs2_sbd, sd_kobj);
 
-	free_sbd(sdp);
+	complete(&sdp->sd_kobj_unregister);
 }
 
 static struct kobj_type gfs2_ktype = {
@@ -655,6 +655,7 @@ int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 	sprintf(ro, "RDONLY=%d", sb_rdonly(sb));
 	sprintf(spectator, "SPECTATOR=%d", sdp->sd_args.ar_spectator ? 1 : 0);
 
+	init_completion(&sdp->sd_kobj_unregister);
 	sdp->sd_kobj.kset = gfs2_kset;
 	error = kobject_init_and_add(&sdp->sd_kobj, &gfs2_ktype, NULL,
 				     "%s", sdp->sd_table_name);
@@ -685,6 +686,7 @@ int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 fail_reg:
 	fs_err(sdp, "error %d adding sysfs files\n", error);
 	kobject_put(&sdp->sd_kobj);
+	wait_for_completion(&sdp->sd_kobj_unregister);
 	sb->s_fs_info = NULL;
 	return error;
 }
@@ -695,6 +697,7 @@ void gfs2_sys_fs_del(struct gfs2_sbd *sdp)
 	sysfs_remove_group(&sdp->sd_kobj, &tune_group);
 	sysfs_remove_group(&sdp->sd_kobj, &lock_module_group);
 	kobject_put(&sdp->sd_kobj);
+	wait_for_completion(&sdp->sd_kobj_unregister);
 }
 
 static int gfs2_uevent(struct kset *kset, struct kobject *kobj,
-- 
2.25.1

