Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3149B63B10F
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 19:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbiK1SUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 13:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbiK1ST0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 13:19:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BB82E9EB
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 10:04:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 608A461351
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 18:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4159AC433C1;
        Mon, 28 Nov 2022 18:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669658684;
        bh=UMFJfCDbhNIea/iWj0ZWzfPCWktnTX6rDHaX/tmzUIk=;
        h=Subject:To:From:Date:From;
        b=RwjCkfMSig1fx+0G9fWQ49mmSTeNFEerTekLG0RgEmmGmTSqWsu4g7OrsTor18JV2
         ABYGvwGLEqT1p3UEaolRywOl1tItWaHzUmzN53QSsCMf3VmJ1zfetCER7gjlsQ169y
         c8jxAiQhCUeFuMJ6WVh2+ORVI5ogGK0Ecr6XgmT0=
Subject: patch "usb: cdnsp: fix lack of ZLP for ep0" added to usb-testing
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Nov 2022 19:04:42 +0100
Message-ID: <16696586823672@kroah.com>
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

    usb: cdnsp: fix lack of ZLP for ep0

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From c4069289acc0ffd3b52cfb8a756ae8774a195bfd Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Tue, 22 Nov 2022 03:51:38 -0500
Subject: usb: cdnsp: fix lack of ZLP for ep0

Patch implements the handling of ZLP for control transfer.
To send the ZLP driver must prepare the extra TRB in TD with
length set to zero and TRB type to TRB_NORMAL.
The first TRB must have set TRB_CHAIN flag, TD_SIZE = 1
and TRB type to TRB_DATA.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: <stable@vger.kernel.org>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20221122085138.332434-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c | 42 ++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 2f29431f612e..b23e543b3a3d 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -2006,10 +2006,11 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 
 int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 {
-	u32 field, length_field, remainder;
+	u32 field, length_field, zlp = 0;
 	struct cdnsp_ep *pep = preq->pep;
 	struct cdnsp_ring *ep_ring;
 	int num_trbs;
+	u32 maxp;
 	int ret;
 
 	ep_ring = cdnsp_request_to_transfer_ring(pdev, preq);
@@ -2019,26 +2020,33 @@ int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 	/* 1 TRB for data, 1 for status */
 	num_trbs = (pdev->three_stage_setup) ? 2 : 1;
 
+	maxp = usb_endpoint_maxp(pep->endpoint.desc);
+
+	if (preq->request.zero && preq->request.length &&
+	    (preq->request.length % maxp == 0)) {
+		num_trbs++;
+		zlp = 1;
+	}
+
 	ret = cdnsp_prepare_transfer(pdev, preq, num_trbs);
 	if (ret)
 		return ret;
 
 	/* If there's data, queue data TRBs */
-	if (pdev->ep0_expect_in)
-		field = TRB_TYPE(TRB_DATA) | TRB_IOC;
-	else
-		field = TRB_ISP | TRB_TYPE(TRB_DATA) | TRB_IOC;
-
 	if (preq->request.length > 0) {
-		remainder = cdnsp_td_remainder(pdev, 0, preq->request.length,
-					       preq->request.length, preq, 1, 0);
+		field = TRB_TYPE(TRB_DATA);
 
-		length_field = TRB_LEN(preq->request.length) |
-				TRB_TD_SIZE(remainder) | TRB_INTR_TARGET(0);
+		if (zlp)
+			field |= TRB_CHAIN;
+		else
+			field |= TRB_IOC | (pdev->ep0_expect_in ? 0 : TRB_ISP);
 
 		if (pdev->ep0_expect_in)
 			field |= TRB_DIR_IN;
 
+		length_field = TRB_LEN(preq->request.length) |
+			       TRB_TD_SIZE(zlp) | TRB_INTR_TARGET(0);
+
 		cdnsp_queue_trb(pdev, ep_ring, true,
 				lower_32_bits(preq->request.dma),
 				upper_32_bits(preq->request.dma), length_field,
@@ -2046,6 +2054,20 @@ int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 				TRB_SETUPID(pdev->setup_id) |
 				pdev->setup_speed);
 
+		if (zlp) {
+			field = TRB_TYPE(TRB_NORMAL) | TRB_IOC;
+
+			if (!pdev->ep0_expect_in)
+				field = TRB_ISP;
+
+			cdnsp_queue_trb(pdev, ep_ring, true,
+					lower_32_bits(preq->request.dma),
+					upper_32_bits(preq->request.dma), 0,
+					field | ep_ring->cycle_state |
+					TRB_SETUPID(pdev->setup_id) |
+					pdev->setup_speed);
+		}
+
 		pdev->ep0_stage = CDNSP_DATA_STAGE;
 	}
 
-- 
2.38.1


