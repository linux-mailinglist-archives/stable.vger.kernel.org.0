Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7EE481C61
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 14:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbhL3NMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 08:12:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36238 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236208AbhL3NMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 08:12:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF5F2616C6
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 13:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA1CC36AE9;
        Thu, 30 Dec 2021 13:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640869962;
        bh=BI+Jha0u43XjIqIjdzbPytin7EsdbGKw29/iLJe9UuA=;
        h=Subject:To:From:Date:From;
        b=cG06dMdHUC3wtGh4sHqI4sZqsA313dhfNo5UV2DY8jcDJlPh3dYT/55AP0ZC7qQsw
         tlBQ1sSP9lm8jjJar1VCrJY3PNMMy0dCU7AxcM8qY9n4F7QouJAejiSq0SB62s6QeZ
         OtoVNsoyA0ddBMbxt/PZmXgnhsLdBqmRkrO9yres=
Subject: patch "mei: hbm: fix client dma reply status" added to char-misc-testing
To:     alexander.usyskin@intel.com, emmanuel.grumbach@intel.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 30 Dec 2021 14:12:31 +0100
Message-ID: <164086995115965@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: hbm: fix client dma reply status

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 6b0b80ac103b2a40c72a47c301745fd1f4ef4697 Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Tue, 28 Dec 2021 10:20:47 +0200
Subject: mei: hbm: fix client dma reply status

Don't blindly copy status value received from the firmware
into internal client status field,
It may be positive and ERR_PTR(ret) will translate it
into an invalid address and the caller will crash.

Put the error code into the client status on failure.

Fixes: 369aea845951 ("mei: implement client dma setup.")
Cc: <stable@vger.kernel.org> # v5.11+
Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Tested-by: : Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20211228082047.378115-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hbm.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index be41843df75b..cebcca6d6d3e 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -672,10 +672,14 @@ static void mei_hbm_cl_dma_map_res(struct mei_device *dev,
 	if (!cl)
 		return;
 
-	dev_dbg(dev->dev, "cl dma map result = %d\n", res->status);
-	cl->status = res->status;
-	if (!cl->status)
+	if (res->status) {
+		dev_err(dev->dev, "cl dma map failed %d\n", res->status);
+		cl->status = -EFAULT;
+	} else {
+		dev_dbg(dev->dev, "cl dma map succeeded\n");
 		cl->dma_mapped = 1;
+		cl->status = 0;
+	}
 	wake_up(&cl->wait);
 }
 
@@ -698,10 +702,14 @@ static void mei_hbm_cl_dma_unmap_res(struct mei_device *dev,
 	if (!cl)
 		return;
 
-	dev_dbg(dev->dev, "cl dma unmap result = %d\n", res->status);
-	cl->status = res->status;
-	if (!cl->status)
+	if (res->status) {
+		dev_err(dev->dev, "cl dma unmap failed %d\n", res->status);
+		cl->status = -EFAULT;
+	} else {
+		dev_dbg(dev->dev, "cl dma unmap succeeded\n");
 		cl->dma_mapped = 0;
+		cl->status = 0;
+	}
 	wake_up(&cl->wait);
 }
 
-- 
2.34.1


