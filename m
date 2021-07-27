Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBD33D7543
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 14:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhG0MpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 08:45:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231840AbhG0MpX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 08:45:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58F2261A3F;
        Tue, 27 Jul 2021 12:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627389923;
        bh=6qZguGzEO0pxr2E427LcgzBF+MlhHYFmYsBz4jDaPVI=;
        h=Subject:To:From:Date:From;
        b=oiXgiiT3yADMcASquU9ezLKktECKiilEdnn/+uIFMajRlwHSjdhdkL5D4EUk6SLYu
         kb9ZwIno3DdwusztanVwNOtm84CgntFCG1mWf8T/i6CB4zsdT8i0gjZJDm9yvFxN3i
         OTr8HTo7csjY8ZUroeZl+RROSj377iiD4ZCq43ms=
Subject: patch "drivers core: Fix oops when driver probe fails" added to driver-core-linus
To:     filip@mg6.at, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 27 Jul 2021 14:45:20 +0200
Message-ID: <162738992037229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    drivers core: Fix oops when driver probe fails

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4d1014c1816c0395eca5d1d480f196a4c63119d0 Mon Sep 17 00:00:00 2001
From: Filip Schauer <filip@mg6.at>
Date: Tue, 27 Jul 2021 13:23:11 +0200
Subject: drivers core: Fix oops when driver probe fails

dma_range_map is freed to early, which might cause an oops when
a driver probe fails.
 Call trace:
  is_free_buddy_page+0xe4/0x1d4
  __free_pages+0x2c/0x88
  dma_free_contiguous+0x64/0x80
  dma_direct_free+0x38/0xb4
  dma_free_attrs+0x88/0xa0
  dmam_release+0x28/0x34
  release_nodes+0x78/0x8c
  devres_release_all+0xa8/0x110
  really_probe+0x118/0x2d0
  __driver_probe_device+0xc8/0xe0
  driver_probe_device+0x54/0xec
  __driver_attach+0xe0/0xf0
  bus_for_each_dev+0x7c/0xc8
  driver_attach+0x30/0x3c
  bus_add_driver+0x17c/0x1c4
  driver_register+0xc0/0xf8
  __platform_driver_register+0x34/0x40
  ...

This issue is introduced by commit d0243bbd5dd3 ("drivers core:
Free dma_range_map when driver probe failed"). It frees
dma_range_map before the call to devres_release_all, which is too
early. The solution is to free dma_range_map only after
devres_release_all.

Fixes: d0243bbd5dd3 ("drivers core: Free dma_range_map when driver probe failed")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Filip Schauer <filip@mg6.at>
Link: https://lore.kernel.org/r/20210727112311.GA7645@DESKTOP-E8BN1B0.localdomain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index daeb9b5763ae..437cd61343b2 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -653,8 +653,6 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	else if (drv->remove)
 		drv->remove(dev);
 probe_failed:
-	kfree(dev->dma_range_map);
-	dev->dma_range_map = NULL;
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DRIVER_NOT_BOUND, dev);
@@ -662,6 +660,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	device_links_no_driver(dev);
 	devres_release_all(dev);
 	arch_teardown_dma_ops(dev);
+	kfree(dev->dma_range_map);
+	dev->dma_range_map = NULL;
 	driver_sysfs_remove(dev);
 	dev->driver = NULL;
 	dev_set_drvdata(dev, NULL);
-- 
2.32.0


