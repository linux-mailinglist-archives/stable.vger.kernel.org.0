Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE70C634096
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 16:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiKVPwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 10:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiKVPwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 10:52:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577415FD2
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 07:52:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B80EB81BF8
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 15:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61651C433D6;
        Tue, 22 Nov 2022 15:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669132354;
        bh=uMbQK5ECFQZPuXX6lKPGLC+LRNZMG+UD35Oj2xV1WSY=;
        h=Subject:To:From:Date:From;
        b=hI5REeHSr+swn38mBtRgg0DlLYE+KpYjdWNttd5dj6knSy5NS+chRNQq4izAWPV+C
         CA1kxibR5rEzFogjzM78VXJXbX68E+CXG3GFTl/Ml55XY/2b0mDlN6UsYUn5XbUoOT
         jKxB9up7ZYfDkfHx14HwlK3vCn6y3HGnX27CP93E=
Subject: patch "usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1" added to usb-linus
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 22 Nov 2022 16:52:15 +0100
Message-ID: <1669132335583@kroah.com>
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

    usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7a21b27aafa3edead79ed97e6f22236be6b9f447 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Tue, 15 Nov 2022 04:22:18 -0500
Subject: usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1

Patch modifies the TD_SIZE in TRB before ZLP TRB.
The TD_SIZE in TRB before ZLP TRB must be set to 1 to force
processing ZLP TRB by controller.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20221115092218.421267-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 04dfcaa08dc4..2f29431f612e 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1763,10 +1763,15 @@ static u32 cdnsp_td_remainder(struct cdnsp_device *pdev,
 			      int trb_buff_len,
 			      unsigned int td_total_len,
 			      struct cdnsp_request *preq,
-			      bool more_trbs_coming)
+			      bool more_trbs_coming,
+			      bool zlp)
 {
 	u32 maxp, total_packet_count;
 
+	/* Before ZLP driver needs set TD_SIZE = 1. */
+	if (zlp)
+		return 1;
+
 	/* One TRB with a zero-length data packet. */
 	if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
 	    trb_buff_len == td_total_len)
@@ -1960,7 +1965,8 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 		/* Set the TRB length, TD size, and interrupter fields. */
 		remainder = cdnsp_td_remainder(pdev, enqd_len, trb_buff_len,
 					       full_len, preq,
-					       more_trbs_coming);
+					       more_trbs_coming,
+					       zero_len_trb);
 
 		length_field = TRB_LEN(trb_buff_len) | TRB_TD_SIZE(remainder) |
 			TRB_INTR_TARGET(0);
@@ -2025,7 +2031,7 @@ int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 
 	if (preq->request.length > 0) {
 		remainder = cdnsp_td_remainder(pdev, 0, preq->request.length,
-					       preq->request.length, preq, 1);
+					       preq->request.length, preq, 1, 0);
 
 		length_field = TRB_LEN(preq->request.length) |
 				TRB_TD_SIZE(remainder) | TRB_INTR_TARGET(0);
@@ -2226,7 +2232,7 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
 		/* Set the TRB length, TD size, & interrupter fields. */
 		remainder = cdnsp_td_remainder(pdev, running_total,
 					       trb_buff_len, td_len, preq,
-					       more_trbs_coming);
+					       more_trbs_coming, 0);
 
 		length_field = TRB_LEN(trb_buff_len) | TRB_INTR_TARGET(0);
 
-- 
2.38.1


