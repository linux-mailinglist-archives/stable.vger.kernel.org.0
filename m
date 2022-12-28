Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7CF657BEC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiL1P1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbiL1P0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:26:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBB614038
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:26:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C2E4B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDCAC433D2;
        Wed, 28 Dec 2022 15:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241204;
        bh=w6tSwtVJrogUQ5n0DUJP5EJxltSvzFUg5JYhh3jG4IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbl4ig2/04lbzvamxRfcaubc5/TnMc2HoCPNtLy9ZMRQJMuKgcFgeW4kyE1I5aksb
         Noci5gcw6i9glZYe8OlVTyDw0fkbTnyxwaWjg4qtwdvYPgNy3yqeuMroz3G8VcKdBc
         XM6EfxL4b/iyJuvVc6UqDAztPWOdU2c6KqcoCY7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0219/1146] ipmi: kcs: Poll OBF briefly to reduce OBE latency
Date:   Wed, 28 Dec 2022 15:29:18 +0100
Message-Id: <20221228144336.094957522@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jeffery <andrew@aj.id.au>

[ Upstream commit f90bc0f97f2b65af233a37b2e32fc81871a1e3cf ]

The ASPEED KCS devices don't provide a BMC-side interrupt for the host
reading the output data register (ODR). The act of the host reading ODR
clears the output buffer full (OBF) flag in the status register (STR),
informing the BMC it can transmit a subsequent byte.

On the BMC side the KCS client must enable the OBE event *and* perform a
subsequent read of STR anyway to avoid races - the polling provides a
window for the host to read ODR if data was freshly written while
minimising BMC-side latency.

Fixes: 28651e6c4237 ("ipmi: kcs_bmc: Allow clients to control KCS IRQ state")
Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Message-Id: <20220812144741.240315-1-andrew@aj.id.au>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/kcs_bmc_aspeed.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/char/ipmi/kcs_bmc_aspeed.c b/drivers/char/ipmi/kcs_bmc_aspeed.c
index 19c32bf50e0e..2dea8cd5a09a 100644
--- a/drivers/char/ipmi/kcs_bmc_aspeed.c
+++ b/drivers/char/ipmi/kcs_bmc_aspeed.c
@@ -406,13 +406,31 @@ static void aspeed_kcs_check_obe(struct timer_list *timer)
 static void aspeed_kcs_irq_mask_update(struct kcs_bmc_device *kcs_bmc, u8 mask, u8 state)
 {
 	struct aspeed_kcs_bmc *priv = to_aspeed_kcs_bmc(kcs_bmc);
+	int rc;
+	u8 str;
 
 	/* We don't have an OBE IRQ, emulate it */
 	if (mask & KCS_BMC_EVENT_TYPE_OBE) {
-		if (KCS_BMC_EVENT_TYPE_OBE & state)
-			mod_timer(&priv->obe.timer, jiffies + OBE_POLL_PERIOD);
-		else
+		if (KCS_BMC_EVENT_TYPE_OBE & state) {
+			/*
+			 * Given we don't have an OBE IRQ, delay by polling briefly to see if we can
+			 * observe such an event before returning to the caller. This is not
+			 * incorrect because OBF may have already become clear before enabling the
+			 * IRQ if we had one, under which circumstance no event will be propagated
+			 * anyway.
+			 *
+			 * The onus is on the client to perform a race-free check that it hasn't
+			 * missed the event.
+			 */
+			rc = read_poll_timeout_atomic(aspeed_kcs_inb, str,
+						      !(str & KCS_BMC_STR_OBF), 1, 100, false,
+						      &priv->kcs_bmc, priv->kcs_bmc.ioreg.str);
+			/* Time for the slow path? */
+			if (rc == -ETIMEDOUT)
+				mod_timer(&priv->obe.timer, jiffies + OBE_POLL_PERIOD);
+		} else {
 			del_timer(&priv->obe.timer);
+		}
 	}
 
 	if (mask & KCS_BMC_EVENT_TYPE_IBF) {
-- 
2.35.1



