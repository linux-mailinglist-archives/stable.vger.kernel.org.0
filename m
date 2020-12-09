Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0BF02D48B3
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 19:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732768AbgLISOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 13:14:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbgLISOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 13:14:39 -0500
Subject: patch "driver: core: Fix list corruption after device_del()" added to driver-core-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607537638;
        bh=71vQWHIq5qHf5ccKDp3bTIq4vJMPFE46BAnfLa40TMo=;
        h=To:From:Date:From;
        b=RWtQe0sG2vI/Dy4DIDrj4TulegTwS4aweCyuPVhLdkSbmfyen3XPLSLrVE8kZQl1W
         RkfL0ZB9TWve3F7AYtx6qy95YcdoAVSDkWIWAHvbcjyU6FywsrrFN3+RbPgysH6+2i
         7u3UdUJ+A01TUM7E6kn5dalB2bKpsTbzYxb3bbwU=
To:     tiwai@suse.de, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, saravanak@google.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 19:15:14 +0100
Message-ID: <16075377148670@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver: core: Fix list corruption after device_del()

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the driver-core-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 66482f640755b31cb94371ff6cef17400cda6db5 Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Tue, 8 Dec 2020 20:03:26 +0100
Subject: driver: core: Fix list corruption after device_del()

The device_links_purge() function (called from device_del()) tries to
remove the links.needs_suppliers list entry, but it's using
list_del(), hence it doesn't initialize after the removal.  This is OK
for normal cases where device_del() is called via device_destroy().
However, it's not guaranteed that the device object will be really
deleted soon after device_del().  In a minor case like HD-audio codec
reconfiguration that re-initializes the device after device_del(), it
may lead to a crash by the corrupted list entry.

As a simple fix, replace list_del() with list_del_init() in order to
make the list intact after the device_del() call.

Fixes: e2ae9bcc4aaa ("driver core: Add support for linking devices during device addition")
Cc: <stable@vger.kernel.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20201208190326.27531-1-tiwai@suse.de
Cc: Saravana Kannan <saravanak@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 1165a80f8010..ba5a3cac6571 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1384,7 +1384,7 @@ static void device_links_purge(struct device *dev)
 		return;
 
 	mutex_lock(&wfs_lock);
-	list_del(&dev->links.needs_suppliers);
+	list_del_init(&dev->links.needs_suppliers);
 	mutex_unlock(&wfs_lock);
 
 	/*
-- 
2.29.2


