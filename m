Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9117C594E06
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343767AbiHPAre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347379AbiHPApz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:45:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26758193575;
        Mon, 15 Aug 2022 13:41:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 68B0ACE12C3;
        Mon, 15 Aug 2022 20:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BDAC433C1;
        Mon, 15 Aug 2022 20:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596101;
        bh=JZRzT6MKwH3wfXnCqb3JoOM/VuQDVZXVrq4guwvAIrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAzykYs2PTWfIzgQP4dasvXyUKG+MszZb9nLUdZJVYSvatcQQpDdhWX+bhWpvHOCU
         xvYlrhoHl80CvyFjM6YcvOffC+c/pIVtfZRdq5vDwdsUpdIP0S0R3BUHtF8jZnCvcC
         RWh/Fy5rKjnyKDdo50+kbfLhvck1GCQQzfexedCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Michael Kawano <mkawano@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0938/1157] vfio/ccw: Remove UUID from s390 debug log
Date:   Mon, 15 Aug 2022 20:04:54 +0200
Message-Id: <20220815180517.040893764@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kawano <mkawano@linux.ibm.com>

[ Upstream commit 3566ee1d776c1393393564b2514f9cd52a49c16e ]

As vfio-ccw devices are created/destroyed, the uuid of the associated
mdevs that are recorded in $S390DBF/vfio_ccw_msg/sprintf get lost.
This is because a pointer to the UUID is stored instead of the UUID
itself, and that memory may have been repurposed if/when the logs are
examined. The result is usually garbage UUID data in the logs, though
there is an outside chance of an oops happening here.

Simply remove the UUID from the traces, as the subchannel number will
provide useful configuration information for problem determination,
and is stored directly into the log instead of a pointer.

As we were the only consumer of mdev_uuid(), remove that too.

Cc: Kirti Wankhede <kwankhede@nvidia.com>
Signed-off-by: Michael Kawano <mkawano@linux.ibm.com>
Fixes: 60e05d1cf0875 ("vfio-ccw: add some logging")
Fixes: b7701dfbf9832 ("vfio-ccw: Register a chp_event callback for vfio-ccw")
[farman: reworded commit message, added Fixes: tags]
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
Link: https://lore.kernel.org/r/20220707135737.720765-2-farman@linux.ibm.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_drv.c |  5 ++---
 drivers/s390/cio/vfio_ccw_fsm.c | 26 ++++++++++++--------------
 drivers/s390/cio/vfio_ccw_ops.c |  8 ++++----
 include/linux/mdev.h            |  5 -----
 4 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index ee182cfb467d..35055eb94115 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -14,7 +14,6 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/slab.h>
-#include <linux/uuid.h>
 #include <linux/mdev.h>
 
 #include <asm/isc.h>
@@ -358,8 +357,8 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
 		return 0;
 
 	trace_vfio_ccw_chp_event(private->sch->schid, mask, event);
-	VFIO_CCW_MSG_EVENT(2, "%pUl (%x.%x.%04x): mask=0x%x event=%d\n",
-			   mdev_uuid(private->mdev), sch->schid.cssid,
+	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: mask=0x%x event=%d\n",
+			   sch->schid.cssid,
 			   sch->schid.ssid, sch->schid.sch_no,
 			   mask, event);
 
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 8483a266051c..bbcc5b486749 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/vfio.h>
-#include <linux/mdev.h>
 
 #include "ioasm.h"
 #include "vfio_ccw_private.h"
@@ -242,7 +241,6 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 	union orb *orb;
 	union scsw *scsw = &private->scsw;
 	struct ccw_io_region *io_region = private->io_region;
-	struct mdev_device *mdev = private->mdev;
 	char *errstr = "request";
 	struct subchannel_id schid = get_schid(private);
 
@@ -256,8 +254,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		if (orb->tm.b) {
 			io_region->ret_code = -EOPNOTSUPP;
 			VFIO_CCW_MSG_EVENT(2,
-					   "%pUl (%x.%x.%04x): transport mode\n",
-					   mdev_uuid(mdev), schid.cssid,
+					   "sch %x.%x.%04x: transport mode\n",
+					   schid.cssid,
 					   schid.ssid, schid.sch_no);
 			errstr = "transport mode";
 			goto err_out;
@@ -265,8 +263,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		io_region->ret_code = cp_init(&private->cp, orb);
 		if (io_region->ret_code) {
 			VFIO_CCW_MSG_EVENT(2,
-					   "%pUl (%x.%x.%04x): cp_init=%d\n",
-					   mdev_uuid(mdev), schid.cssid,
+					   "sch %x.%x.%04x: cp_init=%d\n",
+					   schid.cssid,
 					   schid.ssid, schid.sch_no,
 					   io_region->ret_code);
 			errstr = "cp init";
@@ -276,8 +274,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		io_region->ret_code = cp_prefetch(&private->cp);
 		if (io_region->ret_code) {
 			VFIO_CCW_MSG_EVENT(2,
-					   "%pUl (%x.%x.%04x): cp_prefetch=%d\n",
-					   mdev_uuid(mdev), schid.cssid,
+					   "sch %x.%x.%04x: cp_prefetch=%d\n",
+					   schid.cssid,
 					   schid.ssid, schid.sch_no,
 					   io_region->ret_code);
 			errstr = "cp prefetch";
@@ -289,8 +287,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		io_region->ret_code = fsm_io_helper(private);
 		if (io_region->ret_code) {
 			VFIO_CCW_MSG_EVENT(2,
-					   "%pUl (%x.%x.%04x): fsm_io_helper=%d\n",
-					   mdev_uuid(mdev), schid.cssid,
+					   "sch %x.%x.%04x: fsm_io_helper=%d\n",
+					   schid.cssid,
 					   schid.ssid, schid.sch_no,
 					   io_region->ret_code);
 			errstr = "cp fsm_io_helper";
@@ -300,16 +298,16 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		return;
 	} else if (scsw->cmd.fctl & SCSW_FCTL_HALT_FUNC) {
 		VFIO_CCW_MSG_EVENT(2,
-				   "%pUl (%x.%x.%04x): halt on io_region\n",
-				   mdev_uuid(mdev), schid.cssid,
+				   "sch %x.%x.%04x: halt on io_region\n",
+				   schid.cssid,
 				   schid.ssid, schid.sch_no);
 		/* halt is handled via the async cmd region */
 		io_region->ret_code = -EOPNOTSUPP;
 		goto err_out;
 	} else if (scsw->cmd.fctl & SCSW_FCTL_CLEAR_FUNC) {
 		VFIO_CCW_MSG_EVENT(2,
-				   "%pUl (%x.%x.%04x): clear on io_region\n",
-				   mdev_uuid(mdev), schid.cssid,
+				   "sch %x.%x.%04x: clear on io_region\n",
+				   schid.cssid,
 				   schid.ssid, schid.sch_no);
 		/* clear is handled via the async cmd region */
 		io_region->ret_code = -EOPNOTSUPP;
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index b49e2e9db2dc..0e05bff78b8e 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -131,8 +131,8 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 	private->mdev = mdev;
 	private->state = VFIO_CCW_STATE_IDLE;
 
-	VFIO_CCW_MSG_EVENT(2, "mdev %pUl, sch %x.%x.%04x: create\n",
-			   mdev_uuid(mdev), private->sch->schid.cssid,
+	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: create\n",
+			   private->sch->schid.cssid,
 			   private->sch->schid.ssid,
 			   private->sch->schid.sch_no);
 
@@ -154,8 +154,8 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(mdev->dev.parent);
 
-	VFIO_CCW_MSG_EVENT(2, "mdev %pUl, sch %x.%x.%04x: remove\n",
-			   mdev_uuid(mdev), private->sch->schid.cssid,
+	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: remove\n",
+			   private->sch->schid.cssid,
 			   private->sch->schid.ssid,
 			   private->sch->schid.sch_no);
 
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index bb539794f54a..47ad3b104d9e 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -65,11 +65,6 @@ struct mdev_driver {
 	struct device_driver driver;
 };
 
-static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
-{
-	return &mdev->uuid;
-}
-
 extern struct bus_type mdev_bus_type;
 
 int mdev_register_device(struct device *dev, struct mdev_driver *mdev_driver);
-- 
2.35.1



