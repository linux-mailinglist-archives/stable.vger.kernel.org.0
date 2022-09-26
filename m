Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B4F5EA347
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237804AbiIZLWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237807AbiIZLVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:21:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD1652DCB;
        Mon, 26 Sep 2022 03:39:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06C6BB8095B;
        Mon, 26 Sep 2022 10:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574A5C433C1;
        Mon, 26 Sep 2022 10:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188691;
        bh=7jIX1eO5MlqnSi3lZjMBU0j0suGQ+LCLwFMu/hNvCQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHA8/ZeDk+Eojuvq4Hh+pz8HXYvyOvey4q84ss933BVf4axFfW0zk7VKHtFzmY4hV
         rJMkoVZWp9jKerth4nC5Twj1No+pu8EekIWh/24gCHnfPaJfkuYle4GVonVM0gDBux
         tvd0SM9Q196JA0eO7rLkxVb5vWTKuBa5zLS6bXQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thorsten Scherer <t.scherer@eckelmann.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 048/148] can: flexcan: flexcan_mailbox_read() fix return value for drop = true
Date:   Mon, 26 Sep 2022 12:11:22 +0200
Message-Id: <20220926100757.825342970@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 drivers/net/can/flexcan.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1036,11 +1036,6 @@ static struct sk_buff *flexcan_mailbox_r
 	u32 reg_ctrl, reg_id, reg_iflag1;
 	int i;
 
-	if (unlikely(drop)) {
-		skb = ERR_PTR(-ENOBUFS);
-		goto mark_as_read;
-	}
-
 	mb = flexcan_get_mb(priv, n);
 
 	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX) {
@@ -1069,6 +1064,11 @@ static struct sk_buff *flexcan_mailbox_r
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


