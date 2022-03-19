Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C936D4DE6A6
	for <lists+stable@lfdr.de>; Sat, 19 Mar 2022 08:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242378AbiCSHRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Mar 2022 03:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbiCSHRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Mar 2022 03:17:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D216283EC8
        for <stable@vger.kernel.org>; Sat, 19 Mar 2022 00:16:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1EC960F45
        for <stable@vger.kernel.org>; Sat, 19 Mar 2022 07:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94852C340F0;
        Sat, 19 Mar 2022 07:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647674182;
        bh=FZ8wIWnX044UtcP7/bwCCMzzEVnLroWplDLCoJvAu8Q=;
        h=Subject:To:From:Date:From;
        b=VIAbZnTBnJE3lJWrm+HJD0k4SGhd1ueoW+LP/i3nekRE+671WYeu2jqAH+TZvxBA1
         D/yvGqPR0KA7s8qmy4fSagVKoFs9gsr5ilYTfO1of45OxDGXXYJhmu78k4/JvXCNos
         k8l8Uxl/tq0pk0ZKDbQl7QibLiWtWcC6xVX3qPoU=
Subject: patch "mei: avoid iterator usage outside of list_for_each_entry" added to char-misc-next
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 19 Mar 2022 08:16:02 +0100
Message-ID: <1647674162122142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: avoid iterator usage outside of list_for_each_entry

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From c10187b1c5ebb8681ca467ab7b0ded5ea415d258 Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Tue, 8 Mar 2022 11:59:26 +0200
Subject: mei: avoid iterator usage outside of list_for_each_entry

Usage of the iterator outside of the list_for_each_entry
is considered harmful. https://lkml.org/lkml/2022/2/17/1032

Do not reference the loop variable outside of the loop,
by rearranging the orders of execution.
Instead of performing search loop and checking outside the loop
if the end of the list was hit and no matching element was found,
the execution is performed inside the loop upon a successful match
followed by a goto statement to the next step,
therefore no condition has to be performed after the loop has ended.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20220308095926.300412-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/interrupt.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index a67f4f2d33a9..0706322154cb 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -424,31 +424,26 @@ int mei_irq_read_handler(struct mei_device *dev,
 	list_for_each_entry(cl, &dev->file_list, link) {
 		if (mei_cl_hbm_equal(cl, mei_hdr)) {
 			cl_dbg(dev, cl, "got a message\n");
-			break;
+			ret = mei_cl_irq_read_msg(cl, mei_hdr, meta_hdr, cmpl_list);
+			goto reset_slots;
 		}
 	}
 
 	/* if no recipient cl was found we assume corrupted header */
-	if (&cl->link == &dev->file_list) {
-		/* A message for not connected fixed address clients
-		 * should be silently discarded
-		 * On power down client may be force cleaned,
-		 * silently discard such messages
-		 */
-		if (hdr_is_fixed(mei_hdr) ||
-		    dev->dev_state == MEI_DEV_POWER_DOWN) {
-			mei_irq_discard_msg(dev, mei_hdr, mei_hdr->length);
-			ret = 0;
-			goto reset_slots;
-		}
-		dev_err(dev->dev, "no destination client found 0x%08X\n",
-				dev->rd_msg_hdr[0]);
-		ret = -EBADMSG;
-		goto end;
+	/* A message for not connected fixed address clients
+	 * should be silently discarded
+	 * On power down client may be force cleaned,
+	 * silently discard such messages
+	 */
+	if (hdr_is_fixed(mei_hdr) ||
+	    dev->dev_state == MEI_DEV_POWER_DOWN) {
+		mei_irq_discard_msg(dev, mei_hdr, mei_hdr->length);
+		ret = 0;
+		goto reset_slots;
 	}
-
-	ret = mei_cl_irq_read_msg(cl, mei_hdr, meta_hdr, cmpl_list);
-
+	dev_err(dev->dev, "no destination client found 0x%08X\n", dev->rd_msg_hdr[0]);
+	ret = -EBADMSG;
+	goto end;
 
 reset_slots:
 	/* reset the number of slots and header */
-- 
2.35.1


