Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E888D4F3558
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345152AbiDEKkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbiDEJlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:41:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBF4BB910;
        Tue,  5 Apr 2022 02:26:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96361B81C9F;
        Tue,  5 Apr 2022 09:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACD8C385A3;
        Tue,  5 Apr 2022 09:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150780;
        bh=68aLZg2k8y7k/NuHYgwWso1X6n6Cr9BCaz8zPh9HeQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHYQjkGZ0w74Xnqvzel/JOXCb9a/Q9nWJmFBbqlBUrwfZwGLdzZNG9lr9bKNjiIwT
         Ur+vX3tLaPsSdV7/fRlIYwGkJitrjq+VN/gWqufTBb8uol5evobWCs8yRa4EJ3jnSr
         rp22oHDdBSNSgFigJtIdNerfwdNxdG2J17yjD5TY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=D0=9C=D0=B8=D1=85=D0=B0=D0=B8=D0=BB?= 
        <vrserver1@gmail.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.15 164/913] media: gpio-ir-tx: fix transmit with long spaces on Orange Pi PC
Date:   Tue,  5 Apr 2022 09:20:26 +0200
Message-Id: <20220405070344.761908684@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 5ad05ecad4326ddaa26a83ba2233a67be24c1aaa upstream.

Calling udelay for than 1000us does not always yield the correct
results.

Cc: stable@vger.kernel.org
Reported-by: Михаил <vrserver1@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/gpio-ir-tx.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/drivers/media/rc/gpio-ir-tx.c
+++ b/drivers/media/rc/gpio-ir-tx.c
@@ -48,11 +48,29 @@ static int gpio_ir_tx_set_carrier(struct
 	return 0;
 }
 
+static void delay_until(ktime_t until)
+{
+	/*
+	 * delta should never exceed 0.5 seconds (IR_MAX_DURATION) and on
+	 * m68k ndelay(s64) does not compile; so use s32 rather than s64.
+	 */
+	s32 delta;
+
+	while (true) {
+		delta = ktime_us_delta(until, ktime_get());
+		if (delta <= 0)
+			return;
+
+		/* udelay more than 1ms may not work */
+		delta = min(delta, 1000);
+		udelay(delta);
+	}
+}
+
 static void gpio_ir_tx_unmodulated(struct gpio_ir *gpio_ir, uint *txbuf,
 				   uint count)
 {
 	ktime_t edge;
-	s32 delta;
 	int i;
 
 	local_irq_disable();
@@ -63,9 +81,7 @@ static void gpio_ir_tx_unmodulated(struc
 		gpiod_set_value(gpio_ir->gpio, !(i % 2));
 
 		edge = ktime_add_us(edge, txbuf[i]);
-		delta = ktime_us_delta(edge, ktime_get());
-		if (delta > 0)
-			udelay(delta);
+		delay_until(edge);
 	}
 
 	gpiod_set_value(gpio_ir->gpio, 0);
@@ -97,9 +113,7 @@ static void gpio_ir_tx_modulated(struct
 		if (i % 2) {
 			// space
 			edge = ktime_add_us(edge, txbuf[i]);
-			delta = ktime_us_delta(edge, ktime_get());
-			if (delta > 0)
-				udelay(delta);
+			delay_until(edge);
 		} else {
 			// pulse
 			ktime_t last = ktime_add_us(edge, txbuf[i]);


