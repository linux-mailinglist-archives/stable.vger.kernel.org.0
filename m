Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 903E3F1937
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 15:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfKFO5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 09:57:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727275AbfKFO5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 09:57:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F692217F4;
        Wed,  6 Nov 2019 14:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573052239;
        bh=hbwWpMZFkfHtoyMPMYMJxksdK3sAGM0VwaCGXmq+H+o=;
        h=Subject:To:From:Date:From;
        b=n3TYQaHuwt1HhjdqbiW7EH+oDvLAFkXvWuEmwPpZLeUF3PITGYKrfM/D7BCOmFr0t
         XdpQg6J3fMd+f4jj8Kc5bUoa9C8WjzKohSus1828zh+fSgbRmX9DLMu943lhJycN4n
         WAK6yMUdqzFfyd1dkzR7T8gwtGtdEgr857PiX7AQ=
Subject: patch "mei: bus: prefix device names on bus with the bus name" added to char-misc-next
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 06 Nov 2019 15:57:05 +0100
Message-ID: <157305222591179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: bus: prefix device names on bus with the bus name

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 7a2b9e6ec84588b0be65cc0ae45a65bac431496b Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Tue, 5 Nov 2019 17:05:13 +0200
Subject: mei: bus: prefix device names on bus with the bus name

Add parent device name to the name of devices on bus to avoid
device names collisions for same client UUID available
from different MEI heads. Namely this prevents sysfs collision under
/sys/bus/mei/device/

In the device part leave just UUID other parameters that are
required for device matching are not required here and are
just bloating the name.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20191105150514.14010-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/bus.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 985bd4fd3328..53bb394ccba6 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -873,15 +873,16 @@ static const struct device_type mei_cl_device_type = {
 
 /**
  * mei_cl_bus_set_name - set device name for me client device
+ *  <controller>-<client device>
+ *  Example: 0000:00:16.0-55213584-9a29-4916-badf-0fb7ed682aeb
  *
  * @cldev: me client device
  */
 static inline void mei_cl_bus_set_name(struct mei_cl_device *cldev)
 {
-	dev_set_name(&cldev->dev, "mei:%s:%pUl:%02X",
-		     cldev->name,
-		     mei_me_cl_uuid(cldev->me_cl),
-		     mei_me_cl_ver(cldev->me_cl));
+	dev_set_name(&cldev->dev, "%s-%pUl",
+		     dev_name(cldev->bus->dev),
+		     mei_me_cl_uuid(cldev->me_cl));
 }
 
 /**
-- 
2.23.0


