Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67901BCBE4
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 21:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgD1S0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:26:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728834AbgD1S0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:26:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30F4F214AF;
        Tue, 28 Apr 2020 18:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098409;
        bh=59ExLV4e8OBoYTLJp6gv5Rvmogu6A7pDA+M2DHt5blg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEelMOF3TFbmZDIUqthJNGKHNnjs3Mjf6suC8W2ouwwxYqX7T3PgfwO/wf4VNK2p+
         /CY2qE83Tm8myfGxDyulD5IzfALTfUg66EmohdtNlSDjko37eMsHjLLRMBYAbUmAmO
         YeDJhqqrsqKDw9fXxPz8C2SYJMYJBUEdmpmGDUSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris Fiuczynski <fiuczy@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 028/167] s390/cio: avoid duplicated ADD uevents
Date:   Tue, 28 Apr 2020 20:23:24 +0200
Message-Id: <20200428182228.771007857@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



