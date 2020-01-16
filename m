Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A66F513FED6
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389830AbgAPX3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:29:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391256AbgAPX3U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:29:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB96620684;
        Thu, 16 Jan 2020 23:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217359;
        bh=zHD7mt4VoObRY4neNvHEq27BL84g2X3hkWMwzQYHW34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USx5oAauixdOhgXQEGi0JERra6o9Og2LynvDHNr2Rj2QPy1JiYvbxEnD4PNwur66P
         kYUA21UHXwT4TH/UpxAsaMxGXboV8jf/o6L7yoc3cJ65r9VVxmf919kkOXSJsI74XF
         0RyMjJyw4LMI+wXYbXD8VKlyRcAc582/IpzxrtGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.19 50/84] scsi: sd: enable compat ioctls for sed-opal
Date:   Fri, 17 Jan 2020 00:18:24 +0100
Message-Id: <20200116231719.690181556@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
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
@@ -1685,20 +1685,30 @@ static void sd_rescan(struct device *dev
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
 


