Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5571C1AED6A
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 15:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgDRNvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 09:51:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbgDRNtC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 09:49:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4BE822244;
        Sat, 18 Apr 2020 13:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217741;
        bh=59ExLV4e8OBoYTLJp6gv5Rvmogu6A7pDA+M2DHt5blg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PdALYUhed0t62MXe+gdSmA8jVIN33K0iQEqo0luxGt1+VF4Y3Qi4YKJ8xmE7Zn7x1
         mTmN0NXG69tauikqiEDLFOK5H/ggFzzxUMXTR99KHDNimcj2rlbpIG7YKZUgfNNQx4
         Z93SKfMjL58kuoNY//bdzJUDCDTW9s84LNzglvMs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Boris Fiuczynski <fiuczy@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 36/73] s390/cio: avoid duplicated 'ADD' uevents
Date:   Sat, 18 Apr 2020 09:47:38 -0400
Message-Id: <20200418134815.6519-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418134815.6519-1-sashal@kernel.org>
References: <20200418134815.6519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cornelia Huck <cohuck@redhat.com>

[ Upstream commit 05ce3e53f375295c2940390b2b429e506e07655c ]

The common I/O layer delays the ADD uevent for subchannels and
delegates generating this uevent to the individual subchannel
drivers. The io_subchannel driver will do so when the associated
ccw_device has been registered -- but unconditionally, so more
ADD uevents will be generated if a subchannel has been unbound
from the io_subchannel driver and later rebound.

To fix this, only generate the ADD event if uevents were still
suppressed for the device.

Fixes: fa1a8c23eb7d ("s390: cio: Delay uevents for subchannels")
Message-Id: <20200327124503.9794-2-cohuck@redhat.com>
Reported-by: Boris Fiuczynski <fiuczy@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Boris Fiuczynski <fiuczy@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/device.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 0c6245fc77069..983f9c9e08deb 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -849,8 +849,10 @@ static void io_subchannel_register(struct ccw_device *cdev)
 	 * Now we know this subchannel will stay, we can throw
 	 * our delayed uevent.
 	 */
-	dev_set_uevent_suppress(&sch->dev, 0);
-	kobject_uevent(&sch->dev.kobj, KOBJ_ADD);
+	if (dev_get_uevent_suppress(&sch->dev)) {
+		dev_set_uevent_suppress(&sch->dev, 0);
+		kobject_uevent(&sch->dev.kobj, KOBJ_ADD);
+	}
 	/* make it known to the system */
 	ret = ccw_device_add(cdev);
 	if (ret) {
@@ -1058,8 +1060,11 @@ static int io_subchannel_probe(struct subchannel *sch)
 		 * Throw the delayed uevent for the subchannel, register
 		 * the ccw_device and exit.
 		 */
-		dev_set_uevent_suppress(&sch->dev, 0);
-		kobject_uevent(&sch->dev.kobj, KOBJ_ADD);
+		if (dev_get_uevent_suppress(&sch->dev)) {
+			/* should always be the case for the console */
+			dev_set_uevent_suppress(&sch->dev, 0);
+			kobject_uevent(&sch->dev.kobj, KOBJ_ADD);
+		}
 		cdev = sch_get_cdev(sch);
 		rc = ccw_device_add(cdev);
 		if (rc) {
-- 
2.20.1

