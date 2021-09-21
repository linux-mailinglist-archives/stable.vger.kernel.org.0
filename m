Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC03D41378A
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 18:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhIUQ2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 12:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhIUQ2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 12:28:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DF2261002;
        Tue, 21 Sep 2021 16:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632241645;
        bh=XfmNiDtkhhVUBaEm0dMJS79+3iNKgza/zJYYb85zifw=;
        h=Subject:To:From:Date:From;
        b=Cx6ROjE7aCNVpMMk10QWwZh9WXWQFxfTvpHAR28VDLxkfLLKa5LNWJYhO+t55tkKc
         pZMSplKYiP5c8B0w3dmNBoezVWKM2lAzMBZsDtuIyEJMso86zhEaTK4WS61jOJmckX
         m7raJ/9jnyFcWlmoJWwFjSWk6ZraCGmUj0sqidpY=
Subject: patch "driver core: fw_devlink: Improve handling of cyclic dependencies" added to driver-core-linus
To:     saravanak@google.com, gregkh@linuxfoundation.org,
        m.szyprowski@samsung.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Sep 2021 18:27:23 +0200
Message-ID: <1632241643248116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver core: fw_devlink: Improve handling of cyclic dependencies

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2de9d8e0d2fe3a1eb632def2245529067cb35db5 Mon Sep 17 00:00:00 2001
From: Saravana Kannan <saravanak@google.com>
Date: Wed, 15 Sep 2021 10:09:37 -0700
Subject: driver core: fw_devlink: Improve handling of cyclic dependencies

When we have a dependency of the form:

Device-A -> Device-C
	Device-B

Device-C -> Device-B

Where,
* Indentation denotes "child of" parent in previous line.
* X -> Y denotes X is consumer of Y based on firmware (Eg: DT).

We have cyclic dependency: device-A -> device-C -> device-B -> device-A

fw_devlink current treats device-C -> device-B dependency as an invalid
dependency and doesn't enforce it but leaves the rest of the
dependencies as is.

While the current behavior is necessary, it is not sufficient if the
false dependency in this example is actually device-A -> device-C. When
this is the case, device-C will correctly probe defer waiting for
device-B to be added, but device-A will be incorrectly probe deferred by
fw_devlink waiting on device-C to probe successfully. Due to this, none
of the devices in the cycle will end up probing.

To fix this, we need to go relax all the dependencies in the cycle like
we already do in the other instances where fw_devlink detects cycles.
A real world example of this was reported[1] and analyzed[2].

[1] - https://lore.kernel.org/lkml/0a2c4106-7f48-2bb5-048e-8c001a7c3fda@samsung.com/
[2] - https://lore.kernel.org/lkml/CAGETcx8peaew90SWiux=TyvuGgvTQOmO4BFALz7aj0Za5QdNFQ@mail.gmail.com/

Fixes: f9aa460672c9 ("driver core: Refactor fw_devlink feature")
Cc: stable <stable@vger.kernel.org>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20210915170940.617415-2-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index e65dd803a453..316df6027093 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1772,14 +1772,21 @@ static int fw_devlink_create_devlink(struct device *con,
 	 * be broken by applying logic. Check for these types of cycles and
 	 * break them so that devices in the cycle probe properly.
 	 *
-	 * If the supplier's parent is dependent on the consumer, then
-	 * the consumer-supplier dependency is a false dependency. So,
-	 * treat it as an invalid link.
+	 * If the supplier's parent is dependent on the consumer, then the
+	 * consumer and supplier have a cyclic dependency. Since fw_devlink
+	 * can't tell which of the inferred dependencies are incorrect, don't
+	 * enforce probe ordering between any of the devices in this cyclic
+	 * dependency. Do this by relaxing all the fw_devlink device links in
+	 * this cycle and by treating the fwnode link between the consumer and
+	 * the supplier as an invalid dependency.
 	 */
 	sup_dev = fwnode_get_next_parent_dev(sup_handle);
 	if (sup_dev && device_is_dependent(con, sup_dev)) {
-		dev_dbg(con, "Not linking to %pfwP - False link\n",
-			sup_handle);
+		dev_info(con, "Fixing up cyclic dependency with %pfwP (%s)\n",
+			 sup_handle, dev_name(sup_dev));
+		device_links_write_lock();
+		fw_devlink_relax_cycle(con, sup_dev);
+		device_links_write_unlock();
 		ret = -EINVAL;
 	} else {
 		/*
-- 
2.33.0


