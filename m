Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2D65E9174
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 09:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiIYHgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 03:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiIYHgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 03:36:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11463BC4E
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 00:36:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AD2FB80D3E
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 07:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21EDC433D6;
        Sun, 25 Sep 2022 07:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664091361;
        bh=ndmIGJgnsDTjewdTFXPwI3dBy3b8dGtKx71PKcKCc1I=;
        h=Subject:To:Cc:From:Date:From;
        b=ufSz0lNIJX63SIvi6+g1g/dVfUVPvkhV7XmOJPCCGPAi0xLolgynmkTI4PJ1t62i9
         C/aaMJoj/4bkpLCmG8HKkXZ7RxrPoRRhDdJoBGcMcqBZvMf7qimEU0PwQVFO9mwqCj
         qp7Joxo28fudqTfCsorbhZc8/X/AkhJjnIbebmT4=
Subject: FAILED: patch "[PATCH] counter: 104-quad-8: Fix skipped IRQ lines during events" failed to apply to 5.19-stable tree
To:     william.gray@linaro.org, gregkh@linuxfoundation.org,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 25 Sep 2022 09:35:58 +0200
Message-ID: <16640913585139@kroah.com>
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


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

2bc54aaa65d2 ("counter: 104-quad-8: Fix skipped IRQ lines during events configuration")
daae1ee572d1 ("counter: 104-quad-8: Implement and utilize register structures")
b6e9cded90d4 ("counter: 104-quad-8: Utilize iomap interface")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2bc54aaa65d2126ae629919175708a28ce7ef06e Mon Sep 17 00:00:00 2001
From: William Breathitt Gray <william.gray@linaro.org>
Date: Thu, 22 Sep 2022 07:20:56 -0400
Subject: [PATCH] counter: 104-quad-8: Fix skipped IRQ lines during events
 configuration

IRQ trigger configuration is skipped if it has already been set before;
however, the IRQ line still needs to be OR'd to irq_enabled because
irq_enabled is reset for every events_configure call. This patch moves
the irq_enabled OR operation update to before the irq_trigger check so
that IRQ line enablement is not skipped.

Fixes: c95cc0d95702 ("counter: 104-quad-8: Fix persistent enabled events bug")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220815122301.2750-1-william.gray@linaro.org/
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Link: https://lore.kernel.org/r/179eed11eaf225dbd908993b510df0c8f67b1230.1663844776.git.william.gray@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 62c2b7ac4339..4407203e0c9b 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -449,6 +449,9 @@ static int quad8_events_configure(struct counter_device *counter)
 			return -EINVAL;
 		}
 
+		/* Enable IRQ line */
+		irq_enabled |= BIT(event_node->channel);
+
 		/* Skip configuration if it is the same as previously set */
 		if (priv->irq_trigger[event_node->channel] == next_irq_trigger)
 			continue;
@@ -462,9 +465,6 @@ static int quad8_events_configure(struct counter_device *counter)
 			  priv->irq_trigger[event_node->channel] << 3;
 		iowrite8(QUAD8_CTR_IOR | ior_cfg,
 			 &priv->reg->channel[event_node->channel].control);
-
-		/* Enable IRQ line */
-		irq_enabled |= BIT(event_node->channel);
 	}
 
 	iowrite8(irq_enabled, &priv->reg->index_interrupt);

