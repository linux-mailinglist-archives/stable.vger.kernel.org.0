Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF6166E279
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 16:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbjAQPli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 10:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbjAQPke (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 10:40:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C33841B7E
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 07:38:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAB81B81673
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 15:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EF4C433D2;
        Tue, 17 Jan 2023 15:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673969892;
        bh=KZfNFfExBRKW3vmV5CqMjuGmAvR2sfVi9GPv5FLj9Fk=;
        h=Subject:To:From:Date:From;
        b=F7Bn13z2JygVfzhnAWip96XsSqKvkJ+cRjX0ZmsJc8xMgE6rZ5ihRvMePPqudcjBP
         EBk5jf3rFvM8H7+Q8mRZczXmdvkUH8JvflDad6TpdlrOEmqAecsHkyyUa2Lrnma5hy
         yA4zbKaA6jZlIBAFd9EV3eUqzDqmxa5qIAIrjuAQ=
Subject: patch "usb: cdns3: remove fetched trb from cache before dequeuing" added to usb-linus
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Jan 2023 16:38:10 +0100
Message-ID: <1673969890247247@kroah.com>
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

    usb: cdns3: remove fetched trb from cache before dequeuing

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1301c7b9f7efad2f11ef924e317c18ebd714fc9a Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Tue, 15 Nov 2022 05:00:39 -0500
Subject: usb: cdns3: remove fetched trb from cache before dequeuing

After doorbell DMA fetches the TRB. If during dequeuing request
driver changes NORMAL TRB to LINK TRB but doesn't delete it from
controller cache then controller will handle cached TRB and packet
can be lost.

The example scenario for this issue looks like:
1. queue request - set doorbell
2. dequeue request
3. send OUT data packet from host
4. Device will accept this packet which is unexpected
5. queue new request - set doorbell
6. Device lost the expected packet.

By setting DFLUSH controller clears DRDY bit and stop DMA transfer.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20221115100039.441295-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index 5adcb349718c..ccfaebca6faa 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2614,6 +2614,7 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 	u8 req_on_hw_ring = 0;
 	unsigned long flags;
 	int ret = 0;
+	int val;
 
 	if (!ep || !request || !ep->desc)
 		return -EINVAL;
@@ -2649,6 +2650,13 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 
 	/* Update ring only if removed request is on pending_req_list list */
 	if (req_on_hw_ring && link_trb) {
+		/* Stop DMA */
+		writel(EP_CMD_DFLUSH, &priv_dev->regs->ep_cmd);
+
+		/* wait for DFLUSH cleared */
+		readl_poll_timeout_atomic(&priv_dev->regs->ep_cmd, val,
+					  !(val & EP_CMD_DFLUSH), 1, 1000);
+
 		link_trb->buffer = cpu_to_le32(TRB_BUFFER(priv_ep->trb_pool_dma +
 			((priv_req->end_trb + 1) * TRB_SIZE)));
 		link_trb->control = cpu_to_le32((le32_to_cpu(link_trb->control) & TRB_CYCLE) |
@@ -2660,6 +2668,10 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 
 	cdns3_gadget_giveback(priv_ep, priv_req, -ECONNRESET);
 
+	req = cdns3_next_request(&priv_ep->pending_req_list);
+	if (req)
+		cdns3_rearm_transfer(priv_ep, 1);
+
 not_found:
 	spin_unlock_irqrestore(&priv_dev->lock, flags);
 	return ret;
-- 
2.39.0


