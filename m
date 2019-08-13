Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B818C0FC
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 20:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfHMSrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 14:47:08 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:50885 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725923AbfHMSrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 14:47:07 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 5C2BB343;
        Tue, 13 Aug 2019 14:47:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 13 Aug 2019 14:47:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pq7pNX
        djThYOT/BPlonBwTSECBfj6lnAe65hVWMA+fk=; b=14cg5DB4o55QHejCcAqz4I
        fGi5+POQc4SpeedUSi8pYNde3g48rq/L9UtVrpMwajYTaleUnaUCbzO0G3Oa9iAC
        iFqCvz3Dxcn7dzZDu7tXVOy6t9UMpkBLMnHet5/SGsC6L1L/ouUmMaKv2h5FjhPt
        +Jdg9kZnQFDXGtu+785vHDB4gFVoEdCUfe4CKtWxJiq/8WVnc0a8b2ujhNS4W8G0
        Ek6Olz7opjK3GdjHyQFN4uxlKqJfC3tnchEZFaZUYZGcxQVqFuFpxQ+k1yu4Eyk9
        yjXxLmCZZrD6rzMBQiZ0OZB4BzHGJK4TM/zER6WM6uY0Zc7srtyt6OSUBdSkHgzg
        ==
X-ME-Sender: <xms:qAVTXUECaU56iGBCXLpil84C2_yBB-kjJyGi-o7KvhH_V6HxjYUOqw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddviedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:qAVTXWvt6FDEaj6dj2bO13_t0Y_l_kMcjHxGR85brw5Ad7-N-EjW1Q>
    <xmx:qAVTXXS3QXAiEQEXa5S1n9rW1V84Q5uG8VRxuZbXTA2IeQTzkEMP-Q>
    <xmx:qAVTXZGCmsh9U8Z54985Vw-tJFK1DLQnya7mDIF2HYvJHVq6Y6c-BQ>
    <xmx:qQVTXeZOm_DQECUMAVbbQ9RgSryIElOkKe1oPRQdqDuWDePWaah-Ow>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 63E9E80063;
        Tue, 13 Aug 2019 14:47:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] can: rcar_canfd: fix possible IRQ storm on high load" failed to apply to 4.9-stable tree
To:     nikita.yoush@cogentembedded.com, mkl@pengutronix.de,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 13 Aug 2019 20:47:02 +0200
Message-ID: <156572202224474@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d4b890aec4bea7334ca2ca56fd3b12fb48a00cd1 Mon Sep 17 00:00:00 2001
From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Date: Wed, 26 Jun 2019 16:08:48 +0300
Subject: [PATCH] can: rcar_canfd: fix possible IRQ storm on high load

We have observed rcar_canfd driver entering IRQ storm under high load,
with following scenario:
- rcar_canfd_global_interrupt() in entered due to Rx available,
- napi_schedule_prep() is called, and sets NAPIF_STATE_SCHED in state
- Rx fifo interrupts are masked,
- rcar_canfd_global_interrupt() is entered again, this time due to
  error interrupt (e.g. due to overflow),
- since scheduled napi poller has not yet executed, condition for calling
  napi_schedule_prep() from rcar_canfd_global_interrupt() remains true,
  thus napi_schedule_prep() gets called and sets NAPIF_STATE_MISSED flag
  in state,
- later, napi poller function rcar_canfd_rx_poll() gets executed, and
  calls napi_complete_done(),
- due to NAPIF_STATE_MISSED flag in state, this call does not clear
  NAPIF_STATE_SCHED flag from state,
- on return from napi_complete_done(), rcar_canfd_rx_poll() unmasks Rx
  interrutps,
- Rx interrupt happens, rcar_canfd_global_interrupt() gets called
  and calls napi_schedule_prep(),
- since NAPIF_STATE_SCHED is set in state at this time, this call
  returns false,
- due to that false return, rcar_canfd_global_interrupt() returns
  without masking Rx interrupt
- and this results into IRQ storm: unmasked Rx interrupt happens again
  and again is misprocessed in the same way.

This patch fixes that scenario by unmasking Rx interrupts only when
napi_complete_done() returns true, which means it has cleared
NAPIF_STATE_SCHED in state.

Fixes: dd3bd23eb438 ("can: rcar_canfd: Add Renesas R-Car CAN FD driver")
Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 05410008aa6b..de34a4b82d4a 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1508,10 +1508,11 @@ static int rcar_canfd_rx_poll(struct napi_struct *napi, int quota)
 
 	/* All packets processed */
 	if (num_pkts < quota) {
-		napi_complete_done(napi, num_pkts);
-		/* Enable Rx FIFO interrupts */
-		rcar_canfd_set_bit(priv->base, RCANFD_RFCC(ridx),
-				   RCANFD_RFCC_RFIE);
+		if (napi_complete_done(napi, num_pkts)) {
+			/* Enable Rx FIFO interrupts */
+			rcar_canfd_set_bit(priv->base, RCANFD_RFCC(ridx),
+					   RCANFD_RFCC_RFIE);
+		}
 	}
 	return num_pkts;
 }

