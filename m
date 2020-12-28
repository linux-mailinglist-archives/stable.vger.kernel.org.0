Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219022E4240
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408383AbgL1PTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:19:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408361AbgL1OCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50B942064B;
        Mon, 28 Dec 2020 14:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164157;
        bh=dGkwR58gCPNHqew9aQ3P6k2jfU/BXmEuTJGFymR8K2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzDjQOY5HlCrTVIg/ex/uofBZmruoml1xESkTjEmu5QSh6AdcItjz9nVRJ4Xc6peg
         un0YsJCf5o4sE4bou7A67cLFQL1xa0KQY2mCjbyHOFneBSOj21ADBNcBLvw/jGer6y
         b3uwTnwcdwCf5HY6jtJgAu8ryyviAD+VipmTZct8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/717] scsi: aacraid: Improve compat_ioctl handlers
Date:   Mon, 28 Dec 2020 13:40:49 +0100
Message-Id: <20201228125023.437041198@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 077054215a7f787e389a807ece8a39247abbbc1e ]

The use of compat_alloc_user_space() can be easily replaced by handling
compat arguments in the regular handler, and this will make it work for
big-endian kernels as well, which at the moment get an invalid indirect
pointer argument.

Calling aac_ioctl() instead of aac_compat_do_ioctl() means the compat and
native code paths behave the same way again, which they stopped when the
adapter health check was added only in the native function.

Link: https://lore.kernel.org/r/20201030164450.1253641-1-arnd@kernel.org
Fixes: 572ee53a9bad ("scsi: aacraid: check adapter health")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aacraid/commctrl.c | 22 ++++++++++--
 drivers/scsi/aacraid/linit.c    | 61 ++-------------------------------
 2 files changed, 22 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index e3e157a749880..1b1da162f5f6b 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -25,6 +25,7 @@
 #include <linux/completion.h>
 #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
+#include <linux/compat.h>
 #include <linux/delay.h> /* ssleep prototype */
 #include <linux/kthread.h>
 #include <linux/uaccess.h>
@@ -226,6 +227,12 @@ static int open_getadapter_fib(struct aac_dev * dev, void __user *arg)
 	return status;
 }
 
+struct compat_fib_ioctl {
+	u32	fibctx;
+	s32	wait;
+	compat_uptr_t fib;
+};
+
 /**
  *	next_getadapter_fib	-	get the next fib
  *	@dev: adapter to use
@@ -243,8 +250,19 @@ static int next_getadapter_fib(struct aac_dev * dev, void __user *arg)
 	struct list_head * entry;
 	unsigned long flags;
 
-	if(copy_from_user((void *)&f, arg, sizeof(struct fib_ioctl)))
-		return -EFAULT;
+	if (in_compat_syscall()) {
+		struct compat_fib_ioctl cf;
+
+		if (copy_from_user(&cf, arg, sizeof(struct compat_fib_ioctl)))
+			return -EFAULT;
+
+		f.fibctx = cf.fibctx;
+		f.wait = cf.wait;
+		f.fib = compat_ptr(cf.fib);
+	} else {
+		if (copy_from_user(&f, arg, sizeof(struct fib_ioctl)))
+			return -EFAULT;
+	}
 	/*
 	 *	Verify that the HANDLE passed in was a valid AdapterFibContext
 	 *
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 8f3772480582c..0a82afaf40285 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1182,63 +1182,6 @@ static long aac_cfg_ioctl(struct file *file,
 	return aac_do_ioctl(aac, cmd, (void __user *)arg);
 }
 
-#ifdef CONFIG_COMPAT
-static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd, unsigned long arg)
-{
-	long ret;
-	switch (cmd) {
-	case FSACTL_MINIPORT_REV_CHECK:
-	case FSACTL_SENDFIB:
-	case FSACTL_OPEN_GET_ADAPTER_FIB:
-	case FSACTL_CLOSE_GET_ADAPTER_FIB:
-	case FSACTL_SEND_RAW_SRB:
-	case FSACTL_GET_PCI_INFO:
-	case FSACTL_QUERY_DISK:
-	case FSACTL_DELETE_DISK:
-	case FSACTL_FORCE_DELETE_DISK:
-	case FSACTL_GET_CONTAINERS:
-	case FSACTL_SEND_LARGE_FIB:
-		ret = aac_do_ioctl(dev, cmd, (void __user *)arg);
-		break;
-
-	case FSACTL_GET_NEXT_ADAPTER_FIB: {
-		struct fib_ioctl __user *f;
-
-		f = compat_alloc_user_space(sizeof(*f));
-		ret = 0;
-		if (clear_user(f, sizeof(*f)))
-			ret = -EFAULT;
-		if (copy_in_user(f, (void __user *)arg, sizeof(struct fib_ioctl) - sizeof(u32)))
-			ret = -EFAULT;
-		if (!ret)
-			ret = aac_do_ioctl(dev, cmd, f);
-		break;
-	}
-
-	default:
-		ret = -ENOIOCTLCMD;
-		break;
-	}
-	return ret;
-}
-
-static int aac_compat_ioctl(struct scsi_device *sdev, unsigned int cmd,
-			    void __user *arg)
-{
-	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
-	if (!capable(CAP_SYS_RAWIO))
-		return -EPERM;
-	return aac_compat_do_ioctl(dev, cmd, (unsigned long)arg);
-}
-
-static long aac_compat_cfg_ioctl(struct file *file, unsigned cmd, unsigned long arg)
-{
-	if (!capable(CAP_SYS_RAWIO))
-		return -EPERM;
-	return aac_compat_do_ioctl(file->private_data, cmd, arg);
-}
-#endif
-
 static ssize_t aac_show_model(struct device *device,
 			      struct device_attribute *attr, char *buf)
 {
@@ -1523,7 +1466,7 @@ static const struct file_operations aac_cfg_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= aac_cfg_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl   = aac_compat_cfg_ioctl,
+	.compat_ioctl   = aac_cfg_ioctl,
 #endif
 	.open		= aac_cfg_open,
 	.llseek		= noop_llseek,
@@ -1536,7 +1479,7 @@ static struct scsi_host_template aac_driver_template = {
 	.info				= aac_info,
 	.ioctl				= aac_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl			= aac_compat_ioctl,
+	.compat_ioctl			= aac_ioctl,
 #endif
 	.queuecommand			= aac_queuecommand,
 	.bios_param			= aac_biosparm,
-- 
2.27.0



