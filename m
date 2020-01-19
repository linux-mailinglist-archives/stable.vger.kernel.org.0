Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAFEF141E54
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 14:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgASNnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 08:43:31 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:33475 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgASNnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 08:43:31 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AB88A4ED;
        Sun, 19 Jan 2020 08:43:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 08:43:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=H6rcM7
        yo6vH+Fh+svEZ8P3ftIfDrAkwZUjOuDoGm+Uc=; b=veJ/QRZKb65M3XJ4rmNmzH
        riivP6XqaGrmIzF4TNwQX7ZsaF4IqZGTDMTXUgudGN6p4r4KZ3H/2HGFmYiZUmTy
        jq6z82eyW7pBLTpxtbVxBMguMJt/8pRXWiqgOIkcqD+sHXFmOfbPM0O5SI2nDKXg
        sJeSVxeF8qLxezO2s7GNiE3BnVvqYK7GS9OQtcvir7xezdPqRejW+xNDcqMvMwPe
        oYfzkw1nsPD+CXRZrMyGZYtMTZl8OC70YQGjjq+eFHnrGmMfphMc0p7L9fYVG6DW
        W4vdCbnzLmoOccGM2iHOFQFKZl6Rh01hldjEoVoCPvty32SRxkinkRr4dlRhRgFw
        ==
X-ME-Sender: <xms:Al0kXrqD8hHAd3aGvJQON29i7QAYdAMURAV4-IcL6PiAm-K9uv-8Eg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekgedrvdeguddrudelje
    drieejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Al0kXnXhYCcbxfJmIfwxYzMiku0BIVSUIIRDn-MgxLw6hvkpaTOxGA>
    <xmx:Al0kXnrCNYz-qTmQV1OZvglPSleTU6tMuP8US0JBeGsS8DnPhZfJdQ>
    <xmx:Al0kXogfdFlR47UCv1vypY9TAkXJX2E0ir5x7UUoc0qsMulrhGIX7w>
    <xmx:Al0kXoaAxjf41uZyegaQwI-pP15jG5ow8vkiKTEi_vaNAwP-ETkTQg>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id B1C3A80059;
        Sun, 19 Jan 2020 08:43:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] scsi: fnic: fix invalid stack access" failed to apply to 4.9-stable tree
To:     arnd@arndb.de, martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 14:43:27 +0100
Message-ID: <157944140770121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 42ec15ceaea74b5f7a621fc6686cbf69ca66c4cf Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 7 Jan 2020 21:15:49 +0100
Subject: [PATCH] scsi: fnic: fix invalid stack access

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

diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index 1f55b9e4e74a..1b88a3b53eee 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -688,26 +688,26 @@ int vnic_dev_soft_reset_done(struct vnic_dev *vdev, int *done)
 
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
@@ -732,30 +732,30 @@ void vnic_dev_packet_filter(struct vnic_dev *vdev, int directed, int multicast,
 
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

