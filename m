Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76ACD3D096D
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 09:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbhGUGak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 02:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234622AbhGUGaa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 02:30:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D366A6113C;
        Wed, 21 Jul 2021 07:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626851467;
        bh=gNU6dzgAiXi1NfTZJ/e73Ow6wLE28QVdLvXEhn+QRi4=;
        h=Subject:To:From:Date:From;
        b=A7pCRY+YVbyd2XCMkBoBCBqnxQPCZve7iEcZYkgyBJ6HUUmy0EoGVSs8YPZHZSIjY
         0z1+IoDQcljuawRZQacAWJZmcSzpfFBJtsrXElBVCzQMNntYvRK0SWWd7mUulKPp3X
         Ctm87skinaF43FvLlXSzEPbHH4858RCrSL2h12k4=
Subject: patch "usb: typec: tipd: Don't block probing of consumer of "connector"" added to usb-linus
To:     martin.kepplinger@puri.sm, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 09:10:57 +0200
Message-ID: <1626851457760@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tipd: Don't block probing of consumer of "connector"

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 57560ee95cb7f91cf0bc31d4ae8276e0dcfe17aa Mon Sep 17 00:00:00 2001
From: Martin Kepplinger <martin.kepplinger@puri.sm>
Date: Wed, 14 Jul 2021 08:18:07 +0200
Subject: usb: typec: tipd: Don't block probing of consumer of "connector"
 nodes

Similar as with tcpm this patch lets fw_devlink know not to wait on the
fwnode to be populated as a struct device.

Without this patch, USB functionality can be broken on some previously
supported boards.

Fixes: 28ec344bb891 ("usb: typec: tcpm: Don't block probing of consumers of "connector" nodes")
Cc: stable <stable@vger.kernel.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Link: https://lore.kernel.org/r/20210714061807.5737-1-martin.kepplinger@puri.sm
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index 938219bc1b4b..21b3ae25c76d 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -629,6 +629,15 @@ static int tps6598x_probe(struct i2c_client *client)
 	if (!fwnode)
 		return -ENODEV;
 
+	/*
+	 * This fwnode has a "compatible" property, but is never populated as a
+	 * struct device. Instead we simply parse it to read the properties.
+	 * This breaks fw_devlink=on. To maintain backward compatibility
+	 * with existing DT files, we work around this by deleting any
+	 * fwnode_links to/from this fwnode.
+	 */
+	fw_devlink_purge_absent_suppliers(fwnode);
+
 	tps->role_sw = fwnode_usb_role_switch_get(fwnode);
 	if (IS_ERR(tps->role_sw)) {
 		ret = PTR_ERR(tps->role_sw);
-- 
2.32.0


