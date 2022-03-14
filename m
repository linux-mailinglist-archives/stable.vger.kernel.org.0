Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0393F4D8458
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237612AbiCNMX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243824AbiCNMVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:21:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F413B4A3F2;
        Mon, 14 Mar 2022 05:17:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81CD760919;
        Mon, 14 Mar 2022 12:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEA7C340E9;
        Mon, 14 Mar 2022 12:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260225;
        bh=CH/J95vdQnlAbRzSL0ePqsW0YLUrXPuAGDS0UJ2TWiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vz//EfnuYVg3C6J9ARprXm+gO7Z2j2SzWRrhpyqYc9jbLdb7ETYJlMgxr4cEU/v0+
         nVOK0WAYGYOqo+AkHZIY4nQrUvS3To5O8CLt1YdqGIcfQmylBzrzOVhmvzORbnWKW/
         S1iSomCBkVQOuhRZSee6gc012rmVUbET5xcT+1HI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott McNutt <scott.mcnutt@siriusxm.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 091/121] net: macb: Fix lost RX packet wakeup race in NAPI receive
Date:   Mon, 14 Mar 2022 12:54:34 +0100
Message-Id: <20220314112746.657290307@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Robert Hancock <robert.hancock@calian.com>

commit 0bf476fc3624e3a72af4ba7340d430a91c18cd67 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1614,7 +1614,14 @@ static int macb_poll(struct napi_struct
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
@@ -1622,6 +1629,22 @@ static int macb_poll(struct napi_struct
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
 


