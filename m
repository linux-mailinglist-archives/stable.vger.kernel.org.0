Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDC22CE087
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 22:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgLCVVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 16:21:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbgLCVVg (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 3 Dec 2020 16:21:36 -0500
Subject: patch "counter: microchip-tcb-capture: Fix CMR value check" added to staging-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607030438;
        bh=Rz06E/5JaqPlya3Prpnf2Yt4nfr9ftz4BTSpCZgE0tM=;
        h=To:From:Date:From;
        b=iyAFTXyDk5IsYfvfnxRppTrO2LAOC3xzRoOQi+lDD46WnRAqV2I44gKtIWH/jCTEc
         bKJAx9dWVdgWMWuHhQeecZVgeXhRjkyZwfBi4P9ipvihuLZYFIu3a3n2tzaqmVLcYz
         OcXpfDwoNmd1NFuQyzXhjRnCgWKTjoC1q0qY5qV0=
To:     vilhelm.gray@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, alexandre.belloni@bootlin.com,
        kamel.bouhara@bootlin.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Dec 2020 22:19:19 +0100
Message-ID: <160703035925418@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    counter: microchip-tcb-capture: Fix CMR value check

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 3418bd7cfce0bd8ef1ccedc4655f9f86f6c3b0ca Mon Sep 17 00:00:00 2001
From: William Breathitt Gray <vilhelm.gray@gmail.com>
Date: Sat, 14 Nov 2020 18:28:05 -0500
Subject: counter: microchip-tcb-capture: Fix CMR value check

The ATMEL_TC_ETRGEDG_* defines are not masks but rather possible values
for CMR. This patch fixes the action_get() callback to properly check
for these values rather than mask them.

Fixes: 106b104137fd ("counter: Add microchip TCB capture counter")
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Acked-by: Kamel Bouhara <kamel.bouhara@bootlin.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201114232805.253108-1-vilhelm.gray@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/counter/microchip-tcb-capture.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/counter/microchip-tcb-capture.c b/drivers/counter/microchip-tcb-capture.c
index 039c54a78aa5..710acc0a3704 100644
--- a/drivers/counter/microchip-tcb-capture.c
+++ b/drivers/counter/microchip-tcb-capture.c
@@ -183,16 +183,20 @@ static int mchp_tc_count_action_get(struct counter_device *counter,
 
 	regmap_read(priv->regmap, ATMEL_TC_REG(priv->channel[0], CMR), &cmr);
 
-	*action = MCHP_TC_SYNAPSE_ACTION_NONE;
-
-	if (cmr & ATMEL_TC_ETRGEDG_NONE)
+	switch (cmr & ATMEL_TC_ETRGEDG) {
+	default:
 		*action = MCHP_TC_SYNAPSE_ACTION_NONE;
-	else if (cmr & ATMEL_TC_ETRGEDG_RISING)
+		break;
+	case ATMEL_TC_ETRGEDG_RISING:
 		*action = MCHP_TC_SYNAPSE_ACTION_RISING_EDGE;
-	else if (cmr & ATMEL_TC_ETRGEDG_FALLING)
+		break;
+	case ATMEL_TC_ETRGEDG_FALLING:
 		*action = MCHP_TC_SYNAPSE_ACTION_FALLING_EDGE;
-	else if (cmr & ATMEL_TC_ETRGEDG_BOTH)
+		break;
+	case ATMEL_TC_ETRGEDG_BOTH:
 		*action = MCHP_TC_SYNAPSE_ACTION_BOTH_EDGE;
+		break;
+	}
 
 	return 0;
 }
-- 
2.29.2


