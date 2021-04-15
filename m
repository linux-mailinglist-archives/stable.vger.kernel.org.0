Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C593604C1
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 10:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhDOIrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 04:47:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231687AbhDOIrC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 04:47:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0FB3611C0;
        Thu, 15 Apr 2021 08:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618476398;
        bh=j3LLu2VI5Hbe/+aqo7Op/kkIE7Oeyw2F4ogtvG1xMtw=;
        h=Subject:To:From:Date:From;
        b=RQ5XQQYwNKKC/sh7dLrwFK7sVIj2smvjhRqt2Z7Hyv2jJHZxZXPUn+eylrBc3BRkZ
         /t+mEOuputAyRQCCVrH/B3bqE3bgwpS7lYuSKmOeInowhVqlxtWuFiOh6zLdmTUMTc
         u0LcDydVgSBYw/nldXWSu0FNYYqe4rGixGyfGvxk=
Subject: patch "software node: Allow node addition to already existing device" added to driver-core-testing
To:     heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org,
        pierre-louis.bossart@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Apr 2021 10:36:24 +0200
Message-ID: <16184757842027@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    software node: Allow node addition to already existing device

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the driver-core-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From b622b24519f5b008f6d4e20e5675eaffa8fbd87b Mon Sep 17 00:00:00 2001
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Wed, 14 Apr 2021 10:54:38 +0300
Subject: software node: Allow node addition to already existing device

If the node is added to an already exiting device, the node
needs to be also linked to the device separately.

This will make sure the reference count is kept in balance
also when the node is injected to a device afterwards.

Fixes: e68d0119e328 ("software node: Introduce device_add_software_node()")
Reported-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210414075438.64547-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/swnode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index 740333629b42..3cc11b813f28 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -1045,6 +1045,7 @@ int device_add_software_node(struct device *dev, const struct software_node *nod
 	}
 
 	set_secondary_fwnode(dev, &swnode->fwnode);
+	software_node_notify(dev, KOBJ_ADD);
 
 	return 0;
 }
@@ -1118,8 +1119,8 @@ int software_node_notify(struct device *dev, unsigned long action)
 
 	switch (action) {
 	case KOBJ_ADD:
-		ret = sysfs_create_link(&dev->kobj, &swnode->kobj,
-					"software_node");
+		ret = sysfs_create_link_nowarn(&dev->kobj, &swnode->kobj,
+					       "software_node");
 		if (ret)
 			break;
 
-- 
2.31.1


