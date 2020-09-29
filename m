Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5A927C6EF
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731261AbgI2Ltx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:49:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730496AbgI2Ltv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:49:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 912D321924;
        Tue, 29 Sep 2020 11:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380191;
        bh=GPYWoZKXP7MhWfOEOBYPIt3Kdvsm642SUmfRVflRSR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGLu7krWYF5S4CfqXeGZ4/nAvAHjqnUHxcxHE6HTEFUMgASAFi+kUKhuZf1OJuteK
         v3NEGhoBrESlYunvCspI0JY8bZKMOwLmJlNjlLdA4P36p5Yv0GnGNY/k7IJTVCp0YR
         ebUyrXYPxULCTuLaBSam0UXc/M9jlZDvWc43dpoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.8 86/99] btrfs: fix put of uninitialized kobject after seed device delete
Date:   Tue, 29 Sep 2020 13:02:09 +0200
Message-Id: <20200929105933.967833986@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

commit b5ddcffa37778244d5e786fe32f778edf2bfc93e upstream.

The following test case leads to NULL kobject free error:

  mount seed /mnt
  add sprout to /mnt
  umount /mnt
  mount sprout to /mnt
  delete seed

  kobject: '(null)' (00000000dd2b87e4): is not initialized, yet kobject_put() is being called.
  WARNING: CPU: 1 PID: 15784 at lib/kobject.c:736 kobject_put+0x80/0x350
  RIP: 0010:kobject_put+0x80/0x350
  ::
  Call Trace:
  btrfs_sysfs_remove_devices_dir+0x6e/0x160 [btrfs]
  btrfs_rm_device.cold+0xa8/0x298 [btrfs]
  btrfs_ioctl+0x206c/0x22a0 [btrfs]
  ksys_ioctl+0xe2/0x140
  __x64_sys_ioctl+0x1e/0x29
  do_syscall_64+0x96/0x150
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7f4047c6288b
  ::

This is because, at the end of the seed device-delete, we try to remove
the seed's devid sysfs entry. But for the seed devices under the sprout
fs, we don't initialize the devid kobject yet. So add a kobject state
check, which takes care of the bug.

Fixes: 668e48af7a94 ("btrfs: sysfs, add devid/dev_state kobject and device attributes")
CC: stable@vger.kernel.org # 5.6+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/sysfs.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1165,10 +1165,12 @@ int btrfs_sysfs_remove_devices_dir(struc
 					  disk_kobj->name);
 		}
 
-		kobject_del(&one_device->devid_kobj);
-		kobject_put(&one_device->devid_kobj);
+		if (one_device->devid_kobj.state_initialized) {
+			kobject_del(&one_device->devid_kobj);
+			kobject_put(&one_device->devid_kobj);
 
-		wait_for_completion(&one_device->kobj_unregister);
+			wait_for_completion(&one_device->kobj_unregister);
+		}
 
 		return 0;
 	}
@@ -1181,10 +1183,12 @@ int btrfs_sysfs_remove_devices_dir(struc
 			sysfs_remove_link(fs_devices->devices_kobj,
 					  disk_kobj->name);
 		}
-		kobject_del(&one_device->devid_kobj);
-		kobject_put(&one_device->devid_kobj);
+		if (one_device->devid_kobj.state_initialized) {
+			kobject_del(&one_device->devid_kobj);
+			kobject_put(&one_device->devid_kobj);
 
-		wait_for_completion(&one_device->kobj_unregister);
+			wait_for_completion(&one_device->kobj_unregister);
+		}
 	}
 
 	return 0;


