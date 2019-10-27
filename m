Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70FC0E6659
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbfJ0VK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729803AbfJ0VK6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:10:58 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68369214AF;
        Sun, 27 Oct 2019 21:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210657;
        bh=eYt9bNR4hsgMMTimXo/ASnjAaT0LBoTAxZWzmk/h4+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBvQq9VRw7ENbDcb7QmNgUi1DFIPBHB6AfbZpmtWC+lIR8kFT+qJTSXS9JyX63sl4
         8Y/opHd9LVkHw7Et8vP7VZOkB1hscCF763HbMknIDGxsutPUGFxae0ZOL9I1JtrbkW
         CrBM85bSJ6idx+xhi7tw8CK3klddo/IXCAnTmbnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 089/119] scsi: core: try to get module before removing device
Date:   Sun, 27 Oct 2019 22:01:06 +0100
Message-Id: <20191027203348.088831528@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufen Yu <yuyufen@huawei.com>

commit 77c301287ebae86cc71d03eb3806f271cb14da79 upstream.

We have a test case like block/001 in blktests, which will create a scsi
device by loading scsi_debug module and then try to delete the device by
sysfs interface. At the same time, it may remove the scsi_debug module.

And getting a invalid paging request BUG_ON as following:

[   34.625854] BUG: unable to handle page fault for address: ffffffffa0016bb8
[   34.629189] Oops: 0000 [#1] SMP PTI
[   34.629618] CPU: 1 PID: 450 Comm: bash Tainted: G        W         5.4.0-rc3+ #473
[   34.632524] RIP: 0010:scsi_proc_hostdir_rm+0x5/0xa0
[   34.643555] CR2: ffffffffa0016bb8 CR3: 000000012cd88000 CR4: 00000000000006e0
[   34.644545] Call Trace:
[   34.644907]  scsi_host_dev_release+0x6b/0x1f0
[   34.645511]  device_release+0x74/0x110
[   34.646046]  kobject_put+0x116/0x390
[   34.646559]  put_device+0x17/0x30
[   34.647041]  scsi_target_dev_release+0x2b/0x40
[   34.647652]  device_release+0x74/0x110
[   34.648186]  kobject_put+0x116/0x390
[   34.648691]  put_device+0x17/0x30
[   34.649157]  scsi_device_dev_release_usercontext+0x2e8/0x360
[   34.649953]  execute_in_process_context+0x29/0x80
[   34.650603]  scsi_device_dev_release+0x20/0x30
[   34.651221]  device_release+0x74/0x110
[   34.651732]  kobject_put+0x116/0x390
[   34.652230]  sysfs_unbreak_active_protection+0x3f/0x50
[   34.652935]  sdev_store_delete.cold.4+0x71/0x8f
[   34.653579]  dev_attr_store+0x1b/0x40
[   34.654103]  sysfs_kf_write+0x3d/0x60
[   34.654603]  kernfs_fop_write+0x174/0x250
[   34.655165]  __vfs_write+0x1f/0x60
[   34.655639]  vfs_write+0xc7/0x280
[   34.656117]  ksys_write+0x6d/0x140
[   34.656591]  __x64_sys_write+0x1e/0x30
[   34.657114]  do_syscall_64+0xb1/0x400
[   34.657627]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   34.658335] RIP: 0033:0x7f156f337130

During deleting scsi target, the scsi_debug module have been removed. Then,
sdebug_driver_template belonged to the module cannot be accessd, resulting
in scsi_proc_hostdir_rm() BUG_ON.

To fix the bug, we add scsi_device_get() in sdev_store_delete() to try to
increase refcount of module, avoiding the module been removed.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191015130556.18061-1-yuyufen@huawei.com
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_sysfs.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -722,6 +722,14 @@ sdev_store_delete(struct device *dev, st
 		  const char *buf, size_t count)
 {
 	struct kernfs_node *kn;
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	/*
+	 * We need to try to get module, avoiding the module been removed
+	 * during delete.
+	 */
+	if (scsi_device_get(sdev))
+		return -ENODEV;
 
 	kn = sysfs_break_active_protection(&dev->kobj, &attr->attr);
 	WARN_ON_ONCE(!kn);
@@ -736,9 +744,10 @@ sdev_store_delete(struct device *dev, st
 	 * state into SDEV_DEL.
 	 */
 	device_remove_file(dev, attr);
-	scsi_remove_device(to_scsi_device(dev));
+	scsi_remove_device(sdev);
 	if (kn)
 		sysfs_unbreak_active_protection(kn);
+	scsi_device_put(sdev);
 	return count;
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);


