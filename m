Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E08A6DEDFF
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjDLIjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjDLIi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:38:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8283C31
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:38:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A5BB62A97
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E1FC433EF;
        Wed, 12 Apr 2023 08:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288585;
        bh=lSqPxSsTW1AKCJv797Qp26kKwfLSRBHeLdp+bOjVA8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VyCIoLtu7sLm6MSZj1Exxcb7qVeqGpq6vzIkVicxPRdQ5KAv1ixrsfPGg2JU1hyJC
         9qIlG+FDkdcdESbagzVWKu0bo8K3DzTCc6OUpNvGvmfl0mTWVt+3+sHUgW4BCnSw+F
         ZHKjjkVwBZNKF+w6a8kA8HYYlggpQHIcvW+Fyvtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gustav Ekelund <gustaek@axis.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 34/93] net: dsa: mv88e6xxx: Reset mv88e6393x force WD event bit
Date:   Wed, 12 Apr 2023 10:33:35 +0200
Message-Id: <20230412082824.534012016@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustav Ekelund <gustaek@axis.com>

[ Upstream commit 089b91a0155c4de1209a07ff2a7dd299ff3ece47 ]

The force watchdog event bit is not cleared during SW reset in the
mv88e6393x switch. This is a different behavior compared to mv886390 which
clears the force WD event bit as advertised. This causes a force WD event
to be handled over and over again as the SW reset following the event never
clears the force WD event bit.

Explicitly clear the watchdog event register to 0 in irq_action when
handling an event to prevent the switch from sending continuous interrupts.
Marvell aren't aware of any other stuck bits apart from the force WD
bit.

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family"
Signed-off-by: Gustav Ekelund <gustaek@axis.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  2 +-
 drivers/net/dsa/mv88e6xxx/global2.c | 20 ++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/global2.h |  1 +
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8a030dc0b8a36..bc363fca2895f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4967,7 +4967,7 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	 * .port_set_upstream_port method.
 	 */
 	.set_egress_port = mv88e6393x_set_egress_port,
-	.watchdog_ops = &mv88e6390_watchdog_ops,
+	.watchdog_ops = &mv88e6393x_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6393x_port_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index fa65ecd9cb853..ec49939968fac 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -931,6 +931,26 @@ const struct mv88e6xxx_irq_ops mv88e6390_watchdog_ops = {
 	.irq_free = mv88e6390_watchdog_free,
 };
 
+static int mv88e6393x_watchdog_action(struct mv88e6xxx_chip *chip, int irq)
+{
+	mv88e6390_watchdog_action(chip, irq);
+
+	/* Fix for clearing the force WD event bit.
+	 * Unreleased erratum on mv88e6393x.
+	 */
+	mv88e6xxx_g2_write(chip, MV88E6390_G2_WDOG_CTL,
+			   MV88E6390_G2_WDOG_CTL_UPDATE |
+			   MV88E6390_G2_WDOG_CTL_PTR_EVENT);
+
+	return IRQ_HANDLED;
+}
+
+const struct mv88e6xxx_irq_ops mv88e6393x_watchdog_ops = {
+	.irq_action = mv88e6393x_watchdog_action,
+	.irq_setup = mv88e6390_watchdog_setup,
+	.irq_free = mv88e6390_watchdog_free,
+};
+
 static irqreturn_t mv88e6xxx_g2_watchdog_thread_fn(int irq, void *dev_id)
 {
 	struct mv88e6xxx_chip *chip = dev_id;
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index f3e27573a3864..89ba09b663a26 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -361,6 +361,7 @@ int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip *chip, int target,
 extern const struct mv88e6xxx_irq_ops mv88e6097_watchdog_ops;
 extern const struct mv88e6xxx_irq_ops mv88e6250_watchdog_ops;
 extern const struct mv88e6xxx_irq_ops mv88e6390_watchdog_ops;
+extern const struct mv88e6xxx_irq_ops mv88e6393x_watchdog_ops;
 
 extern const struct mv88e6xxx_avb_ops mv88e6165_avb_ops;
 extern const struct mv88e6xxx_avb_ops mv88e6352_avb_ops;
-- 
2.39.2



