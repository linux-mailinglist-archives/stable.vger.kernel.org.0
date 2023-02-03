Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C6D688F3C
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 06:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbjBCF74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 00:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjBCF7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 00:59:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87BB6FD08
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 21:59:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7371860C43
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 05:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADDFC433D2;
        Fri,  3 Feb 2023 05:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675403993;
        bh=L0T9r3Q6kRB3rSavowk1BXyUtCTWFvlFfZEgIUyT5VU=;
        h=Subject:To:From:Date:From;
        b=KQylaZyOVNQRr2lJEvW/XW7kobFCupKBcZbW3sqfNHACAO/qzbX7/157M8rjb0l/b
         UhmxdkjYhtbI90ETCkVp0j1KX+qSlZ1MGBsoA+pHD0PKXGDH0fezUALD3vtXETnXmJ
         dLh3YmpuLWJ6r77gNbw5FRIhh6x6495nVUm5joCs=
Subject: patch "bus: mhi: ep: Only send -ENOTCONN status if client driver is" added to char-misc-testing
To:     manivannan.sadhasivam@linaro.org, quic_jhugo@quicinc.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Feb 2023 06:59:36 +0100
Message-ID: <1675403976136146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    bus: mhi: ep: Only send -ENOTCONN status if client driver is

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From e6cebcc27519dcf1652e604c73b9fd4f416987c0 Mon Sep 17 00:00:00 2001
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date: Wed, 28 Dec 2022 21:47:01 +0530
Subject: bus: mhi: ep: Only send -ENOTCONN status if client driver is
 available

For the STOP and RESET commands, only send the channel disconnect status
-ENOTCONN if client driver is available. Otherwise, it will result in
null pointer dereference.

Cc: <stable@vger.kernel.org> # 5.19
Fixes: e827569062a8 ("bus: mhi: ep: Add support for processing command rings")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://lore.kernel.org/r/20221228161704.255268-4-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/ep/main.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index 8b065a3cc848..7d68b00bdbcf 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -203,9 +203,11 @@ static int mhi_ep_process_cmd_ring(struct mhi_ep_ring *ring, struct mhi_ring_ele
 		mhi_ep_mmio_disable_chdb(mhi_cntrl, ch_id);
 
 		/* Send channel disconnect status to client drivers */
-		result.transaction_status = -ENOTCONN;
-		result.bytes_xferd = 0;
-		mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
+		if (mhi_chan->xfer_cb) {
+			result.transaction_status = -ENOTCONN;
+			result.bytes_xferd = 0;
+			mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
+		}
 
 		/* Set channel state to STOP */
 		mhi_chan->state = MHI_CH_STATE_STOP;
@@ -235,9 +237,11 @@ static int mhi_ep_process_cmd_ring(struct mhi_ep_ring *ring, struct mhi_ring_ele
 		mhi_ep_ring_reset(mhi_cntrl, ch_ring);
 
 		/* Send channel disconnect status to client driver */
-		result.transaction_status = -ENOTCONN;
-		result.bytes_xferd = 0;
-		mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
+		if (mhi_chan->xfer_cb) {
+			result.transaction_status = -ENOTCONN;
+			result.bytes_xferd = 0;
+			mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
+		}
 
 		/* Set channel state to DISABLED */
 		mhi_chan->state = MHI_CH_STATE_DISABLED;
-- 
2.39.1


