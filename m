Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2DE1B682E
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgDWXNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:13:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50072 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728506AbgDWXGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:51 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvY-0004mp-RF; Fri, 24 Apr 2020 00:06:40 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvU-00E6v2-Cr; Fri, 24 Apr 2020 00:06:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Luo Jiaxing" <luojiaxing@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James Bottomley" <James.Bottomley@HansenPartnership.com>,
        "John Garry" <john.garry@huawei.com>
Date:   Fri, 24 Apr 2020 00:06:35 +0100
Message-ID: <lsq.1587683028.993324332@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 168/245] scsi: enclosure: Fix stale device oops with
 hot replug
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 529244bd1afc102ab164429d338d310d5d65e60d upstream.

Doing an add/remove/add on a SCSI device in an enclosure leads to an oops
caused by poisoned values in the enclosure device list pointers.  The
reason is because we are keeping the enclosure device across the enclosed
device add/remove/add but the current code is doing a
device_add/device_del/device_add on it.  This is the wrong thing to do in
sysfs, so fix it by not doing a device_del on the enclosure device simply
because of a hot remove of the drive in the slot.

[mkp: added missing email addresses]

Fixes: 43d8eb9cfd0a ("[SCSI] ses: add support for enclosure component hot removal")
Link: https://lore.kernel.org/r/1578532892.3852.10.camel@HansenPartnership.com
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Reported-by: Luo Jiaxing <luojiaxing@huawei.com>
Tested-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/misc/enclosure.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -364,10 +364,9 @@ int enclosure_remove_device(struct enclo
 		cdev = &edev->component[i];
 		if (cdev->dev == dev) {
 			enclosure_remove_links(cdev);
-			device_del(&cdev->cdev);
 			put_device(dev);
 			cdev->dev = NULL;
-			return device_add(&cdev->cdev);
+			return 0;
 		}
 	}
 	return -ENODEV;

