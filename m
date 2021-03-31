Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B86334C991
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhC2IaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234698AbhC2I24 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:28:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E9CB614A7;
        Mon, 29 Mar 2021 08:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006535;
        bh=lhAd/C0Oh0fcxGjzmcjpSz9Owt59gi0Y5cgrRYKJO6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGeNyghsUurGLflkkiK1hcrnTpwYjSzV6zsPeKQo9MIIlYTT9Mk0RKJgAaIHleLzo
         pB1A5t/s2qqJaDeI9QCUgZxASaTLZJL5MjHTzGTRZXcRl3h9HE/lctPVQjI0lltyDi
         l0LZL/uMNjAvr+Tbm6gtvR1iCaCzXhiz1pBH+b4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomer Tayar <ttayar@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 036/254] habanalabs: Disable file operations after device is removed
Date:   Mon, 29 Mar 2021 09:55:52 +0200
Message-Id: <20210329075634.335492396@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomer Tayar <ttayar@habana.ai>

[ Upstream commit ffd123fe839700366ea79b19ac3683bf56817372 ]

A device can be removed from the PCI subsystem while a process holds the
file descriptor opened.
In such a case, the driver attempts to kill the process, but as it is
still possible that the process will be alive after this step, the
device removal will complete, and we will end up with a process object
that points to a device object which was already released.

To prevent the usage of this released device object, disable the
following file operations for this process object, and avoid the cleanup
steps when the file descriptor is eventually closed.
The latter is just a best effort, as memory leak will occur.

Signed-off-by: Tomer Tayar <ttayar@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/device.c       | 40 ++++++++++++++++---
 .../misc/habanalabs/common/habanalabs_ioctl.c | 12 ++++++
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/habanalabs/common/device.c b/drivers/misc/habanalabs/common/device.c
index 6785329eee27..82c0306a9210 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -93,12 +93,19 @@ void hl_hpriv_put(struct hl_fpriv *hpriv)
 static int hl_device_release(struct inode *inode, struct file *filp)
 {
 	struct hl_fpriv *hpriv = filp->private_data;
+	struct hl_device *hdev = hpriv->hdev;
+
+	filp->private_data = NULL;
+
+	if (!hdev) {
+		pr_crit("Closing FD after device was removed. Memory leak will occur and it is advised to reboot.\n");
+		put_pid(hpriv->taskpid);
+		return 0;
+	}
 
 	hl_cb_mgr_fini(hpriv->hdev, &hpriv->cb_mgr);
 	hl_ctx_mgr_fini(hpriv->hdev, &hpriv->ctx_mgr);
 
-	filp->private_data = NULL;
-
 	hl_hpriv_put(hpriv);
 
 	return 0;
@@ -107,16 +114,19 @@ static int hl_device_release(struct inode *inode, struct file *filp)
 static int hl_device_release_ctrl(struct inode *inode, struct file *filp)
 {
 	struct hl_fpriv *hpriv = filp->private_data;
-	struct hl_device *hdev;
+	struct hl_device *hdev = hpriv->hdev;
 
 	filp->private_data = NULL;
 
-	hdev = hpriv->hdev;
+	if (!hdev) {
+		pr_err("Closing FD after device was removed\n");
+		goto out;
+	}
 
 	mutex_lock(&hdev->fpriv_list_lock);
 	list_del(&hpriv->dev_node);
 	mutex_unlock(&hdev->fpriv_list_lock);
-
+out:
 	put_pid(hpriv->taskpid);
 
 	kfree(hpriv);
@@ -136,8 +146,14 @@ static int hl_device_release_ctrl(struct inode *inode, struct file *filp)
 static int hl_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct hl_fpriv *hpriv = filp->private_data;
+	struct hl_device *hdev = hpriv->hdev;
 	unsigned long vm_pgoff;
 
+	if (!hdev) {
+		pr_err_ratelimited("Trying to mmap after device was removed! Please close FD\n");
+		return -ENODEV;
+	}
+
 	vm_pgoff = vma->vm_pgoff;
 	vma->vm_pgoff = HL_MMAP_OFFSET_VALUE_GET(vm_pgoff);
 
@@ -884,6 +900,16 @@ static int device_kill_open_processes(struct hl_device *hdev, u32 timeout)
 	return -EBUSY;
 }
 
+static void device_disable_open_processes(struct hl_device *hdev)
+{
+	struct hl_fpriv *hpriv;
+
+	mutex_lock(&hdev->fpriv_list_lock);
+	list_for_each_entry(hpriv, &hdev->fpriv_list, dev_node)
+		hpriv->hdev = NULL;
+	mutex_unlock(&hdev->fpriv_list_lock);
+}
+
 /*
  * hl_device_reset - reset the device
  *
@@ -1538,8 +1564,10 @@ void hl_device_fini(struct hl_device *hdev)
 		HL_PENDING_RESET_LONG_SEC);
 
 	rc = device_kill_open_processes(hdev, HL_PENDING_RESET_LONG_SEC);
-	if (rc)
+	if (rc) {
 		dev_crit(hdev->dev, "Failed to kill all open processes\n");
+		device_disable_open_processes(hdev);
+	}
 
 	hl_cb_pool_fini(hdev);
 
diff --git a/drivers/misc/habanalabs/common/habanalabs_ioctl.c b/drivers/misc/habanalabs/common/habanalabs_ioctl.c
index d25892d61ec9..0805e1173d54 100644
--- a/drivers/misc/habanalabs/common/habanalabs_ioctl.c
+++ b/drivers/misc/habanalabs/common/habanalabs_ioctl.c
@@ -5,6 +5,8 @@
  * All Rights Reserved.
  */
 
+#define pr_fmt(fmt)	"habanalabs: " fmt
+
 #include <uapi/misc/habanalabs.h>
 #include "habanalabs.h"
 
@@ -667,6 +669,11 @@ long hl_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	const struct hl_ioctl_desc *ioctl = NULL;
 	unsigned int nr = _IOC_NR(cmd);
 
+	if (!hdev) {
+		pr_err_ratelimited("Sending ioctl after device was removed! Please close FD\n");
+		return -ENODEV;
+	}
+
 	if ((nr >= HL_COMMAND_START) && (nr < HL_COMMAND_END)) {
 		ioctl = &hl_ioctls[nr];
 	} else {
@@ -685,6 +692,11 @@ long hl_ioctl_control(struct file *filep, unsigned int cmd, unsigned long arg)
 	const struct hl_ioctl_desc *ioctl = NULL;
 	unsigned int nr = _IOC_NR(cmd);
 
+	if (!hdev) {
+		pr_err_ratelimited("Sending ioctl after device was removed! Please close FD\n");
+		return -ENODEV;
+	}
+
 	if (nr == _IOC_NR(HL_IOCTL_INFO)) {
 		ioctl = &hl_ioctls_control[nr];
 	} else {
-- 
2.30.1



