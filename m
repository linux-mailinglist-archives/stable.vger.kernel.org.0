Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7442414560A
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbgAVNTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:19:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbgAVNTK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:19:10 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F2E924125;
        Wed, 22 Jan 2020 13:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699148;
        bh=kgNi9qHfEk/Y5DK1tI9BT79jIxNoVU5JLcti2ui/KPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGxA3j+iHTpMG6VkC+v5k5QNN8J1ZCO0TMcEPNQWxH/TV+TKgCGb5V+0MbjBE6QEG
         qVrGAAIqDDLl0G0GutdjQU/uR0YhaarwnK7xWCp7xE/olglodJ1tvuiOc9416bf9Nt
         obUrAOkr+B+CwLk1bMswXjrEtuEQF9On3uvDsusk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 055/222] scsi: fnic: fix invalid stack access
Date:   Wed, 22 Jan 2020 10:27:21 +0100
Message-Id: <20200122092837.588744767@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 42ec15ceaea74b5f7a621fc6686cbf69ca66c4cf upstream.

gcc -O3 warns that some local variables are not properly initialized:

drivers/scsi/fnic/vnic_dev.c: In function 'fnic_dev_hang_notify':
drivers/scsi/fnic/vnic_dev.c:511:16: error: 'a0' is used uninitialized in this function [-Werror=uninitialized]
  vdev->args[0] = *a0;
  ~~~~~~~~~~~~~~^~~~~
drivers/scsi/fnic/vnic_dev.c:691:6: note: 'a0' was declared here
  u64 a0, a1;
      ^~
drivers/scsi/fnic/vnic_dev.c:512:16: error: 'a1' is used uninitialized in this function [-Werror=uninitialized]
  vdev->args[1] = *a1;
  ~~~~~~~~~~~~~~^~~~~
drivers/scsi/fnic/vnic_dev.c:691:10: note: 'a1' was declared here
  u64 a0, a1;
          ^~
drivers/scsi/fnic/vnic_dev.c: In function 'fnic_dev_mac_addr':
drivers/scsi/fnic/vnic_dev.c:512:16: error: 'a1' is used uninitialized in this function [-Werror=uninitialized]
  vdev->args[1] = *a1;
  ~~~~~~~~~~~~~~^~~~~
drivers/scsi/fnic/vnic_dev.c:698:10: note: 'a1' was declared here
  u64 a0, a1;
          ^~

Apparently the code relies on the local variables occupying adjacent memory
locations in the same order, but this is of course not guaranteed.

Use an array of two u64 variables where needed to make it work correctly.

I suspect there is also an endianness bug here, but have not digged in deep
enough to be sure.

Fixes: 5df6d737dd4b ("[SCSI] fnic: Add new Cisco PCI-Express FCoE HBA")
Fixes: mmtom ("init/Kconfig: enable -O3 for all arches")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200107201602.4096790-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/fnic/vnic_dev.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -688,26 +688,26 @@ int vnic_dev_soft_reset_done(struct vnic
 
 int vnic_dev_hang_notify(struct vnic_dev *vdev)
 {
-	u64 a0, a1;
+	u64 a0 = 0, a1 = 0;
 	int wait = 1000;
 	return vnic_dev_cmd(vdev, CMD_HANG_NOTIFY, &a0, &a1, wait);
 }
 
 int vnic_dev_mac_addr(struct vnic_dev *vdev, u8 *mac_addr)
 {
-	u64 a0, a1;
+	u64 a[2] = {};
 	int wait = 1000;
 	int err, i;
 
 	for (i = 0; i < ETH_ALEN; i++)
 		mac_addr[i] = 0;
 
-	err = vnic_dev_cmd(vdev, CMD_MAC_ADDR, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_MAC_ADDR, &a[0], &a[1], wait);
 	if (err)
 		return err;
 
 	for (i = 0; i < ETH_ALEN; i++)
-		mac_addr[i] = ((u8 *)&a0)[i];
+		mac_addr[i] = ((u8 *)&a)[i];
 
 	return 0;
 }
@@ -732,30 +732,30 @@ void vnic_dev_packet_filter(struct vnic_
 
 void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
 {
-	u64 a0 = 0, a1 = 0;
+	u64 a[2] = {};
 	int wait = 1000;
 	int err;
 	int i;
 
 	for (i = 0; i < ETH_ALEN; i++)
-		((u8 *)&a0)[i] = addr[i];
+		((u8 *)&a)[i] = addr[i];
 
-	err = vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a[0], &a[1], wait);
 	if (err)
 		pr_err("Can't add addr [%pM], %d\n", addr, err);
 }
 
 void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
 {
-	u64 a0 = 0, a1 = 0;
+	u64 a[2] = {};
 	int wait = 1000;
 	int err;
 	int i;
 
 	for (i = 0; i < ETH_ALEN; i++)
-		((u8 *)&a0)[i] = addr[i];
+		((u8 *)&a)[i] = addr[i];
 
-	err = vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a[0], &a[1], wait);
 	if (err)
 		pr_err("Can't del addr [%pM], %d\n", addr, err);
 }


