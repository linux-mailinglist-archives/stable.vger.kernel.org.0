Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DE05EA434
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236400AbiIZLlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237925AbiIZLlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:41:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E076F562;
        Mon, 26 Sep 2022 03:45:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B258860B60;
        Mon, 26 Sep 2022 10:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0873C433D6;
        Mon, 26 Sep 2022 10:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189064;
        bh=si0seKvv98k5bMX+1E90yQcsN2cXUqLrbUsACStHoD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfpevmzsNbHb+BZoe9YFElxipzfJ6Nee4aUtSmonCq93eawYF7ymoPeeZ6nc7vKU2
         pedxQkfxfM0WjcTMassqHBcfeHyzwzbtuTXtdNGI4dxH3mZCMc0g5szi8VWmsmpepD
         KxAtT244dSgVyRzdXh6gcqGOhK7kBdCQuhwb0LAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thorsten Scherer <t.scherer@eckelmann.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.19 060/207] can: flexcan: flexcan_mailbox_read() fix return value for drop = true
Date:   Mon, 26 Sep 2022 12:10:49 +0200
Message-Id: <20220926100809.290756560@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit a09721dd47c8468b3f2fdd73f40422699ffe26dd upstream.

The following happened on an i.MX25 using flexcan with many packets on
the bus:

The rx-offload queue reached a length more than skb_queue_len_max. In
can_rx_offload_offload_one() the drop variable was set to true which
made the call to .mailbox_read() (here: flexcan_mailbox_read()) to
_always_ return ERR_PTR(-ENOBUFS) and drop the rx'ed CAN frame. So
can_rx_offload_offload_one() returned ERR_PTR(-ENOBUFS), too.

can_rx_offload_irq_offload_fifo() looks as follows:

| 	while (1) {
| 		skb = can_rx_offload_offload_one(offload, 0);
| 		if (IS_ERR(skb))
| 			continue;
| 		if (!skb)
| 			break;
| 		...
| 	}

The flexcan driver wrongly always returns ERR_PTR(-ENOBUFS) if drop is
requested, even if there is no CAN frame pending. As the i.MX25 is a
single core CPU, while the rx-offload processing is active, there is
no thread to process packets from the offload queue. So the queue
doesn't get any shorter and this results is a tight loop.

Instead of always returning ERR_PTR(-ENOBUFS) if drop is requested,
return NULL if no CAN frame is pending.

Changes since v1: https://lore.kernel.org/all/20220810144536.389237-1-u.kleine-koenig@pengutronix.de
- don't break in can_rx_offload_irq_offload_fifo() in case of an error,
  return NULL in flexcan_mailbox_read() in case of no pending CAN frame
  instead

Fixes: 4e9c9484b085 ("can: rx-offload: Prepare for CAN FD support")
Link: https://lore.kernel.org/all/20220811094254.1864367-1-mkl@pengutronix.de
Cc: stable@vger.kernel.org # v5.5
Suggested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Tested-by: Thorsten Scherer <t.scherer@eckelmann.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/flexcan/flexcan-core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -941,11 +941,6 @@ static struct sk_buff *flexcan_mailbox_r
 	u32 reg_ctrl, reg_id, reg_iflag1;
 	int i;
 
-	if (unlikely(drop)) {
-		skb = ERR_PTR(-ENOBUFS);
-		goto mark_as_read;
-	}
-
 	mb = flexcan_get_mb(priv, n);
 
 	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX) {
@@ -974,6 +969,11 @@ static struct sk_buff *flexcan_mailbox_r
 		reg_ctrl = priv->read(&mb->can_ctrl);
 	}
 
+	if (unlikely(drop)) {
+		skb = ERR_PTR(-ENOBUFS);
+		goto mark_as_read;
+	}
+
 	if (reg_ctrl & FLEXCAN_MB_CNT_EDL)
 		skb = alloc_canfd_skb(offload->dev, &cfd);
 	else


