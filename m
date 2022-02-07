Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176154ABDCF
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389109AbiBGLqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386790AbiBGLg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:36:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC2DC043181;
        Mon,  7 Feb 2022 03:36:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FFC960B20;
        Mon,  7 Feb 2022 11:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7712BC004E1;
        Mon,  7 Feb 2022 11:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233816;
        bh=DX9ZtOOKRH0mzrq1ltNPjopdAWTDfpB8KXDdSkYRa0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VwZtTThMYaLka2Bz9ylYBwSRYQqX3F3bmhDQmi1PjpUEBjx+kqoOE0bOEejqdPYTn
         s4mdLLqKAqgRksu9iEOvsgjiG7Pyf6JK30ws9HyvqMpXAk68xZRA9fctKaD5+jnIdY
         uSSMuRGSWlZ0vMoW3ZOTAXNOTD9axa6b9R96k1OE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.16 096/126] pinctrl: bcm2835: Fix a few error paths
Date:   Mon,  7 Feb 2022 12:07:07 +0100
Message-Id: <20220207103807.395308718@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

From: Florian Fainelli <f.fainelli@gmail.com>

commit 5297c693d8c8e08fa742e3112cf70723f7a04da2 upstream.

After commit 266423e60ea1 ("pinctrl: bcm2835: Change init order for gpio
hogs") a few error paths would not unwind properly the registration of
gpio ranges. Correct that by assigning a single error label and goto it
whenever we encounter a fatal error.

Fixes: 266423e60ea1 ("pinctrl: bcm2835: Change init order for gpio hogs")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220127215033.267227-1-f.fainelli@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -1264,16 +1264,18 @@ static int bcm2835_pinctrl_probe(struct
 				     sizeof(*girq->parents),
 				     GFP_KERNEL);
 	if (!girq->parents) {
-		pinctrl_remove_gpio_range(pc->pctl_dev, &pc->gpio_range);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto out_remove;
 	}
 
 	if (is_7211) {
 		pc->wake_irq = devm_kcalloc(dev, BCM2835_NUM_IRQS,
 					    sizeof(*pc->wake_irq),
 					    GFP_KERNEL);
-		if (!pc->wake_irq)
-			return -ENOMEM;
+		if (!pc->wake_irq) {
+			err = -ENOMEM;
+			goto out_remove;
+		}
 	}
 
 	/*
@@ -1301,8 +1303,10 @@ static int bcm2835_pinctrl_probe(struct
 
 		len = strlen(dev_name(pc->dev)) + 16;
 		name = devm_kzalloc(pc->dev, len, GFP_KERNEL);
-		if (!name)
-			return -ENOMEM;
+		if (!name) {
+			err = -ENOMEM;
+			goto out_remove;
+		}
 
 		snprintf(name, len, "%s:bank%d", dev_name(pc->dev), i);
 
@@ -1321,11 +1325,14 @@ static int bcm2835_pinctrl_probe(struct
 	err = gpiochip_add_data(&pc->gpio_chip, pc);
 	if (err) {
 		dev_err(dev, "could not add GPIO chip\n");
-		pinctrl_remove_gpio_range(pc->pctl_dev, &pc->gpio_range);
-		return err;
+		goto out_remove;
 	}
 
 	return 0;
+
+out_remove:
+	pinctrl_remove_gpio_range(pc->pctl_dev, &pc->gpio_range);
+	return err;
 }
 
 static struct platform_driver bcm2835_pinctrl_driver = {


