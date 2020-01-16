Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAB813FF85
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbgAPXYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:24:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387716AbgAPXYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:24:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6656D206D9;
        Thu, 16 Jan 2020 23:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217088;
        bh=ti9OQzTrR39hfLZ/0pUi+SVIH06RaO/hmG3omslXZAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGDRdEvmIt8E5Z70OBVIF38a1dAXIu3oBNag2UZ/Fcwe99uVUQwxRW01PvRx/O55Z
         ZVfoP0wPDCxvXeb+n8+5DfXQkDp58MHLwtrRf/8/hIAE/Udf9JtUc+qkg7zBbX09bR
         4cNuKpiUMV1pq2XOSoOoHXTrRs5Ccly/xzlDhLMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.4 127/203] scsi: sd: enable compat ioctls for sed-opal
Date:   Fri, 17 Jan 2020 00:17:24 +0100
Message-Id: <20200116231756.312596106@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
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
@@ -1694,20 +1694,30 @@ static void sd_rescan(struct device *dev
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
 


