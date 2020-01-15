Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A480D13BB2E
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 09:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgAOIfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 03:35:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgAOIfD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 03:35:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E668724655;
        Wed, 15 Jan 2020 08:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579077302;
        bh=WBIGiFXyqRrzyD69nW4NuL7EDxmmrLrGMHr6JuolPzo=;
        h=Subject:To:From:Date:From;
        b=tEExjS2I8nD1zMxA5/t4Nv4rvzJOnu3FZJUhbbK/w7AWNigRIDC8c1hI9DIMx9iQU
         PBqZ80eyk1qoDyQCv/+8iE1dqthPGCLlairLvkFho208OpT1In87L8xye3Geb6MuD1
         K7j0m5yc9shQ9J8YeZXkvxBLNKNh+kiy1AxbhxBE=
Subject: patch "driver core: Fix test_async_driver_probe if NUMA is disabled" added to driver-core-next
To:     linux@roeck-us.net, alexander.h.duyck@linux.intel.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Jan 2020 09:34:50 +0100
Message-ID: <1579077290147167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver core: Fix test_async_driver_probe if NUMA is disabled

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 264d25275a46fce5da501874fa48a2ae5ec571c8 Mon Sep 17 00:00:00 2001
From: Guenter Roeck <linux@roeck-us.net>
Date: Wed, 27 Nov 2019 12:24:53 -0800
Subject: driver core: Fix test_async_driver_probe if NUMA is disabled

Since commit 57ea974fb871 ("driver core: Rewrite test_async_driver_probe
to cover serialization and NUMA affinity"), running the test with NUMA
disabled results in warning messages similar to the following.

test_async_driver test_async_driver.12: NUMA node mismatch -1 != 0

If CONFIG_NUMA=n, dev_to_node(dev) returns -1, and numa_node_id()
returns 0. Both are widely used, so it appears risky to change return
values. Augment the check with IS_ENABLED(CONFIG_NUMA) instead
to fix the problem.

Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Fixes: 57ea974fb871 ("driver core: Rewrite test_async_driver_probe to cover serialization and NUMA affinity")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable <stable@vger.kernel.org>
Acked-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Link: https://lore.kernel.org/r/20191127202453.28087-1-linux@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/test/test_async_driver_probe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/test/test_async_driver_probe.c b/drivers/base/test/test_async_driver_probe.c
index f4b1d8e54daf..3bb7beb127a9 100644
--- a/drivers/base/test/test_async_driver_probe.c
+++ b/drivers/base/test/test_async_driver_probe.c
@@ -44,7 +44,8 @@ static int test_probe(struct platform_device *pdev)
 	 * performing an async init on that node.
 	 */
 	if (dev->driver->probe_type == PROBE_PREFER_ASYNCHRONOUS) {
-		if (dev_to_node(dev) != numa_node_id()) {
+		if (IS_ENABLED(CONFIG_NUMA) &&
+		    dev_to_node(dev) != numa_node_id()) {
 			dev_warn(dev, "NUMA node mismatch %d != %d\n",
 				 dev_to_node(dev), numa_node_id());
 			atomic_inc(&warnings);
-- 
2.24.1


