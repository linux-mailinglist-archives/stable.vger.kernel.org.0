Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE9D657B71
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbiL1PWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbiL1PV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:21:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACECC14035
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:21:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBF5261544
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6D6C433D2;
        Wed, 28 Dec 2022 15:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240895;
        bh=lo4z5B9MN2WhtIyWkl9mUfMw5lBDx+wz5fxdV6qibew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ueYMtpfH+FNd1QkM68a79hfxZs6PHVK+LaUQgTCM/cbuueQt/uTzF3RCbAzj7cOVv
         /bMUAqMO1HQT42K50StYkjYHnj4ayRN/aTI+KuJEoy4mDBcpeEQYkhKu2BaJUxdpOY
         /oMEyR1sOVurXxc6K2XhCdpB3Gh0s4zlIFnAH5UI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0215/1073] ipmi: kcs: Poll OBF briefly to reduce OBE latency
Date:   Wed, 28 Dec 2022 15:30:03 +0100
Message-Id: <20221228144333.856035528@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index cdc88cde1e9a..417e5a3ccfae 100644
--- a/drivers/char/ipmi/kcs_bmc_aspeed.c
+++ b/drivers/char/ipmi/kcs_bmc_aspeed.c
@@ -399,13 +399,31 @@ static void aspeed_kcs_check_obe(struct timer_list *timer)
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



