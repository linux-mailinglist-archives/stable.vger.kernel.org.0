Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C0013FE18
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391577AbgAPXcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:32:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391571AbgAPXcb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:32:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9036D20684;
        Thu, 16 Jan 2020 23:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217551;
        bh=ZtOLED+HzresPEo2yXdyGD4jaScfbyJgvGIZpJddPBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPLgUOrwaYmKSaLJPylJg8j09lO9oYdg/Cqt7j9sONZxtHvBjSv6Cxv3iX3Hc2Dd7
         NQgfe9Z0pQizHE0Hjp11JNyJNP3wfmbBHLFeD6KflRDtgrfJIewO+IgFb5bG5VAfX3
         AsbRFAcpx0pFZax7SBbWSiww7mhHzrbSsZtL3nEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.14 44/71] scsi: sd: enable compat ioctls for sed-opal
Date:   Fri, 17 Jan 2020 00:18:42 +0100
Message-Id: <20200116231715.862762618@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 142b2ac82e31c174936c5719fa12ae28f51a55b7 upstream.

The sed_ioctl() function is written to be compatible between
32-bit and 64-bit processes, however compat mode is only
wired up for nvme, not for sd.

Add the missing call to sed_ioctl() in sd_compat_ioctl().

Fixes: d80210f25ff0 ("sd: add support for TCG OPAL self encrypting disks")
Cc: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1697,20 +1697,30 @@ static void sd_rescan(struct device *dev
 static int sd_compat_ioctl(struct block_device *bdev, fmode_t mode,
 			   unsigned int cmd, unsigned long arg)
 {
-	struct scsi_device *sdev = scsi_disk(bdev->bd_disk)->device;
+	struct gendisk *disk = bdev->bd_disk;
+	struct scsi_disk *sdkp = scsi_disk(disk);
+	struct scsi_device *sdev = sdkp->device;
+	void __user *p = compat_ptr(arg);
 	int error;
 
+	error = scsi_verify_blk_ioctl(bdev, cmd);
+	if (error < 0)
+		return error;
+
 	error = scsi_ioctl_block_when_processing_errors(sdev, cmd,
 			(mode & FMODE_NDELAY) != 0);
 	if (error)
 		return error;
+
+	if (is_sed_ioctl(cmd))
+		return sed_ioctl(sdkp->opal_dev, cmd, p);
 	       
 	/* 
 	 * Let the static ioctl translation table take care of it.
 	 */
 	if (!sdev->host->hostt->compat_ioctl)
 		return -ENOIOCTLCMD; 
-	return sdev->host->hostt->compat_ioctl(sdev, cmd, (void __user *)arg);
+	return sdev->host->hostt->compat_ioctl(sdev, cmd, p);
 }
 #endif
 


