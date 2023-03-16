Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED2B6BCEA7
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 12:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjCPLqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 07:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjCPLqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 07:46:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45185A8E9B
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 04:46:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2DAB61FE8
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 11:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A80C433EF;
        Thu, 16 Mar 2023 11:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678967160;
        bh=+9BRDoGOPVitJhMV7SoyNl4JHJNo6808ypbCsIn4eQ0=;
        h=Subject:To:From:Date:From;
        b=01tSQjccvSz9cqUGefi9okT7iw0F5zt4xxepfgxV7Bthrgw6OzO8V8wJQzE4uuSoA
         HoclelXR+FJ+aOhueX//a1lNJesNDSyexmoEahAyinq9/xBYiwE+hCKc4f1KK2iHuC
         i52e/Z6Omri/N9cbgJMsexfBVt7nlaN2vm9fKQIk=
Subject: patch "usb: cdnsp: Fixes issue with redundant Status Stage" added to usb-linus
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Mar 2023 12:45:49 +0100
Message-ID: <167896714988209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdnsp: Fixes issue with redundant Status Stage

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5bc38d33a5a1209fd4de65101d1ae8255ea12c6e Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Tue, 7 Mar 2023 06:14:20 -0500
Subject: usb: cdnsp: Fixes issue with redundant Status Stage

In some cases, driver trees to send Status Stage twice.
The first one from upper layer of gadget usb subsystem and
second time from controller driver.
This patch fixes this issue and remove tricky handling of
SET_INTERFACE from controller driver which is no longer
needed.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20230307111420.376056-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ep0.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-ep0.c b/drivers/usb/cdns3/cdnsp-ep0.c
index 9b8325f82499..d63d5d92f255 100644
--- a/drivers/usb/cdns3/cdnsp-ep0.c
+++ b/drivers/usb/cdns3/cdnsp-ep0.c
@@ -403,20 +403,6 @@ static int cdnsp_ep0_std_request(struct cdnsp_device *pdev,
 	case USB_REQ_SET_ISOCH_DELAY:
 		ret = cdnsp_ep0_set_isoch_delay(pdev, ctrl);
 		break;
-	case USB_REQ_SET_INTERFACE:
-		/*
-		 * Add request into pending list to block sending status stage
-		 * by libcomposite.
-		 */
-		list_add_tail(&pdev->ep0_preq.list,
-			      &pdev->ep0_preq.pep->pending_list);
-
-		ret = cdnsp_ep0_delegate_req(pdev, ctrl);
-		if (ret == -EBUSY)
-			ret = 0;
-
-		list_del(&pdev->ep0_preq.list);
-		break;
 	default:
 		ret = cdnsp_ep0_delegate_req(pdev, ctrl);
 		break;
@@ -474,9 +460,6 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 	else
 		ret = cdnsp_ep0_delegate_req(pdev, ctrl);
 
-	if (!len)
-		pdev->ep0_stage = CDNSP_STATUS_STAGE;
-
 	if (ret == USB_GADGET_DELAYED_STATUS) {
 		trace_cdnsp_ep0_status_stage("delayed");
 		return;
@@ -484,6 +467,6 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 out:
 	if (ret < 0)
 		cdnsp_ep0_stall(pdev);
-	else if (pdev->ep0_stage == CDNSP_STATUS_STAGE)
+	else if (!len && pdev->ep0_stage != CDNSP_STATUS_STAGE)
 		cdnsp_status_stage(pdev);
 }
-- 
2.40.0


