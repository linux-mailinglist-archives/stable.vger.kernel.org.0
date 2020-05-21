Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B041DC90F
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 10:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgEUIzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 04:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbgEUIzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 04:55:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9AC520721;
        Thu, 21 May 2020 08:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590051303;
        bh=p5uTUfT5tFLviN2WXM4u0rgOBnU0irVHuCpG2aEs0MA=;
        h=Subject:To:From:Date:From;
        b=bsAkyfwq7AOEZ+zTkpT9ey4nzjR1Vf9WYgCnWHj4VNFNLBxaVi5g9jhbam5srB8/y
         2gz6MxPaw307WeQFqCZPjQvPymy+hVlF5p2uTDvJM3SCidOevoSHPnJmvKFi4YQgwD
         gpljya4Oqva56yLVgGsBEW90huGTzZCCmIo19kVc=
Subject: patch "driver core: Fix handling of SYNC_STATE_ONLY + STATELESS device links" added to driver-core-linus
To:     saravanak@google.com, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 21 May 2020 10:55:01 +0200
Message-ID: <159005130120762@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver core: Fix handling of SYNC_STATE_ONLY + STATELESS device links

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 44e960490ddf868fc9135151c4a658936e771dc2 Mon Sep 17 00:00:00 2001
From: Saravana Kannan <saravanak@google.com>
Date: Tue, 19 May 2020 21:36:26 -0700
Subject: driver core: Fix handling of SYNC_STATE_ONLY + STATELESS device links

Commit 21c27f06587d ("driver core: Fix SYNC_STATE_ONLY device link
implementation") didn't completely fix STATELESS + SYNC_STATE_ONLY
handling.

What looks like an optimization in that commit is actually a bug that
causes an if condition to always take the else path. This prevents
reordering of devices in the dpm_list when a DL_FLAG_STATELESS device
link is create on top of an existing DL_FLAG_SYNC_STATE_ONLY device
link.

Fixes: 21c27f06587d ("driver core: Fix SYNC_STATE_ONLY device link implementation")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20200520043626.181820-1-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4e0e430315d9..0cad34f1eede 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -360,12 +360,14 @@ struct device_link *device_link_add(struct device *consumer,
 
 		if (flags & DL_FLAG_STATELESS) {
 			kref_get(&link->kref);
-			link->flags |= DL_FLAG_STATELESS;
 			if (link->flags & DL_FLAG_SYNC_STATE_ONLY &&
-			    !(link->flags & DL_FLAG_STATELESS))
+			    !(link->flags & DL_FLAG_STATELESS)) {
+				link->flags |= DL_FLAG_STATELESS;
 				goto reorder;
-			else
+			} else {
+				link->flags |= DL_FLAG_STATELESS;
 				goto out;
+			}
 		}
 
 		/*
-- 
2.26.2


