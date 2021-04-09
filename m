Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D8D35A0AB
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 16:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhDIOHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 10:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232615AbhDIOHm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 10:07:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1A9A60FF1;
        Fri,  9 Apr 2021 14:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617977249;
        bh=+2TWvfUetSIuRi55C8goQ2fg0pz0uwWe1hxPjFoVZN0=;
        h=Subject:To:From:Date:From;
        b=hpAuixpqd7ujgu5A4NpVeHIhyOBZkkrjeg0j7kHkC2gHb6PezcFeIwCJL/ECy8xTY
         Z12e/H1ecOKoymaFBpTksTOnkW6g9IEtKJyI4NHG2FIBgirxyvyqiILAlqp277YCwh
         pcaxCIiEDgDHvhv08vIYOh0Em1aw0P6ieJ1jkH0k=
Subject: patch "usb: roles: Call try_module_get() from" added to usb-testing
To:     hdegoede@redhat.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Apr 2021 16:07:17 +0200
Message-ID: <1617977237184101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: roles: Call try_module_get() from

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 3a2a91a2d51761557843996a66098eb7182b48b4 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Fri, 9 Apr 2021 14:41:36 +0200
Subject: usb: roles: Call try_module_get() from
 usb_role_switch_find_by_fwnode()

usb_role_switch_find_by_fwnode() returns a reference to the role-switch
which must be put by calling usb_role_switch_put().

usb_role_switch_put() calls module_put(sw->dev.parent->driver->owner),
add a matching try_module_get() to usb_role_switch_find_by_fwnode(),
making it behave the same as the other usb_role_switch functions
which return a reference.

This avoids a WARN_ON being hit at kernel/module.c:1158 due to the
module-refcount going below 0.

Fixes: c6919d5e0cd1 ("usb: roles: Add usb_role_switch_find_by_fwnode()")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210409124136.65591-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/roles/class.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/roles/class.c b/drivers/usb/roles/class.c
index 97f37077b7f9..33b637d0d8d9 100644
--- a/drivers/usb/roles/class.c
+++ b/drivers/usb/roles/class.c
@@ -189,6 +189,8 @@ usb_role_switch_find_by_fwnode(const struct fwnode_handle *fwnode)
 		return NULL;
 
 	dev = class_find_device_by_fwnode(role_class, fwnode);
+	if (dev)
+		WARN_ON(!try_module_get(dev->parent->driver->owner));
 
 	return dev ? to_role_switch(dev) : NULL;
 }
-- 
2.31.1


