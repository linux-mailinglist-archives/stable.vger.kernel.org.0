Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6584D6E4A
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 12:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiCLLFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 06:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiCLLFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 06:05:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7197120C2FF
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 03:03:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EA6D60B2A
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 11:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF449C340EB;
        Sat, 12 Mar 2022 11:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647083034;
        bh=DnZImco8qxAfTWzfXHiO5p4YDTvJc+nsPEtQg0aNXIY=;
        h=Subject:To:Cc:From:Date:From;
        b=ITKLBaSbu7AxFuKVbYcPSGod4scXcRV1fBW/wTmCqrpUcongjPKVieI3JRGo0YqK0
         cuSb+h8NlXx8pM+D1hpLgRwVrrb8VrsB/KMSRYP9HSIXMe+E7aE3ZGkYozzKYQEcHl
         HxuldEnB8UmviPxEUoSNX7Aey82AYrEfSrzxM3h8=
Subject: FAILED: patch "[PATCH] net: macb: Fix lost RX packet wakeup race in NAPI receive" failed to apply to 4.9-stable tree
To:     robert.hancock@calian.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, scott.mcnutt@siriusxm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 12 Mar 2022 12:03:50 +0100
Message-ID: <164708303096192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

From 0bf476fc3624e3a72af4ba7340d430a91c18cd67 Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Thu, 3 Mar 2022 12:10:27 -0600
Subject: [PATCH] net: macb: Fix lost RX packet wakeup race in NAPI receive

There is an oddity in the way the RSR register flags propagate to the
ISR register (and the actual interrupt output) on this hardware: it
appears that RSR register bits only result in ISR being asserted if the
interrupt was actually enabled at the time, so enabling interrupts with
RSR bits already set doesn't trigger an interrupt to be raised. There
was already a partial fix for this race in the macb_poll function where
it checked for RSR bits being set and re-triggered NAPI receive.
However, there was a still a race window between checking RSR and
actually enabling interrupts, where a lost wakeup could happen. It's
necessary to check again after enabling interrupts to see if RSR was set
just prior to the interrupt being enabled, and re-trigger receive in that
case.

This issue was noticed in a point-to-point UDP request-response protocol
which periodically saw timeouts or abnormally high response times due to
received packets not being processed in a timely fashion. In many
applications, more packets arriving, including TCP retransmissions, would
cause the original packet to be processed, thus masking the issue.

Fixes: 02f7a34f34e3 ("net: macb: Re-enable RX interrupt only when RX is done")
Cc: stable@vger.kernel.org
Co-developed-by: Scott McNutt <scott.mcnutt@siriusxm.com>
Signed-off-by: Scott McNutt <scott.mcnutt@siriusxm.com>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Tested-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 98498a76ae16..d13f06cf0308 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1573,7 +1573,14 @@ static int macb_poll(struct napi_struct *napi, int budget)
 	if (work_done < budget) {
 		napi_complete_done(napi, work_done);
 
-		/* Packets received while interrupts were disabled */
+		/* RSR bits only seem to propagate to raise interrupts when
+		 * interrupts are enabled at the time, so if bits are already
+		 * set due to packets received while interrupts were disabled,
+		 * they will not cause another interrupt to be generated when
+		 * interrupts are re-enabled.
+		 * Check for this case here. This has been seen to happen
+		 * around 30% of the time under heavy network load.
+		 */
 		status = macb_readl(bp, RSR);
 		if (status) {
 			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
@@ -1581,6 +1588,22 @@ static int macb_poll(struct napi_struct *napi, int budget)
 			napi_reschedule(napi);
 		} else {
 			queue_writel(queue, IER, bp->rx_intr_mask);
+
+			/* In rare cases, packets could have been received in
+			 * the window between the check above and re-enabling
+			 * interrupts. Therefore, a double-check is required
+			 * to avoid losing a wakeup. This can potentially race
+			 * with the interrupt handler doing the same actions
+			 * if an interrupt is raised just after enabling them,
+			 * but this should be harmless.
+			 */
+			status = macb_readl(bp, RSR);
+			if (unlikely(status)) {
+				queue_writel(queue, IDR, bp->rx_intr_mask);
+				if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
+					queue_writel(queue, ISR, MACB_BIT(RCOMP));
+				napi_schedule(napi);
+			}
 		}
 	}
 

