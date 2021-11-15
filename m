Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC06451367
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348230AbhKOTvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:51:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245753AbhKOTVK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C74AD632F7;
        Mon, 15 Nov 2021 18:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001637;
        bh=BQRMNvmJRzCvnlsMGT/ELfWssZ1bdxZhEXVknYcY8RM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bBB8hqWDk4rxZD+GrB+1EZFEY3PBEZLXcmaBlUVzsK/iysHjdPkRy5BAcWZJEkyKL
         +9SiuJsA50RlNttlVSNRCRT9qNI6oalYv7rBoxDv62Lbqr7rrlqesL0SS24ZRJkrXW
         IMzolq6OEA5wrbCqR1gEmlT4qeGcCZEutRYbLU6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/917] floppy: fix calling platform_device_unregister() on invalid drives
Date:   Mon, 15 Nov 2021 17:55:59 +0100
Message-Id: <20211115165437.735263116@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit 662167e59d2f3c15a44a88088fc6c1a67c8a3650 ]

platform_device_unregister() should only be called when
a respective platform_device_register() is called. However
the floppy driver currently allows failures when registring
a drive and a bail out could easily cause an invalid call
to platform_device_unregister() where it was not intended.

Fix this by adding a bool to keep track of when the platform
device was registered for a drive.

This does not fix any known panic / bug. This issue was found
through code inspection while preparing the driver to use the
up and coming support for device_add_disk() error handling.
>From what I can tell from code inspection, chances of this
ever happening should be insanely small, perhaps OOM.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20210927220302.1073499-5-mcgrof@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 9538146e520e0..3592a6277d0bb 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4478,6 +4478,7 @@ static const struct blk_mq_ops floppy_mq_ops = {
 };
 
 static struct platform_device floppy_device[N_DRIVE];
+static bool registered[N_DRIVE];
 
 static bool floppy_available(int drive)
 {
@@ -4693,6 +4694,8 @@ static int __init do_floppy_init(void)
 		if (err)
 			goto out_remove_drives;
 
+		registered[drive] = true;
+
 		device_add_disk(&floppy_device[drive].dev, disks[drive][0],
 				NULL);
 	}
@@ -4703,7 +4706,8 @@ out_remove_drives:
 	while (drive--) {
 		if (floppy_available(drive)) {
 			del_gendisk(disks[drive][0]);
-			platform_device_unregister(&floppy_device[drive]);
+			if (registered[drive])
+				platform_device_unregister(&floppy_device[drive]);
 		}
 	}
 out_release_dma:
@@ -4946,7 +4950,8 @@ static void __exit floppy_module_exit(void)
 				if (disks[drive][i])
 					del_gendisk(disks[drive][i]);
 			}
-			platform_device_unregister(&floppy_device[drive]);
+			if (registered[drive])
+				platform_device_unregister(&floppy_device[drive]);
 		}
 		for (i = 0; i < ARRAY_SIZE(floppy_type); i++) {
 			if (disks[drive][i])
-- 
2.33.0



