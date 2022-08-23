Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2510A59D9EB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351931AbiHWKDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352424AbiHWKBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:01:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9109E7C1FD;
        Tue, 23 Aug 2022 01:49:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB782B81C20;
        Tue, 23 Aug 2022 08:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1C3C433D6;
        Tue, 23 Aug 2022 08:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244271;
        bh=QCAT40jz6DzuhbQvwb9GjoIt8t1fPD3p63K10A1Y/jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MaZ/kjbPWpNrdc3rrPMaa2LrF3wRHCOUiwJUBAKsD1cIkOzNgdXEc6mcNWYigOf8M
         Y5Dcww8aZN/C22gBj9pZ6RJyIU85JkkkMgdHpYxUw1/QTGtFxDlPBN4UHQvhE9mQVx
         HCly2gaaJGzb/oSAXppSnVEjnSU+IYIkNjH9XnLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 065/244] pinctrl: amd: Dont save/restore interrupt status and wake status bits
Date:   Tue, 23 Aug 2022 10:23:44 +0200
Message-Id: <20220823080101.247252803@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit b8c824a869f220c6b46df724f85794349bafbf23 upstream.

Saving/restoring interrupt and wake status bits across suspend can
cause the suspend to fail if an IRQ is serviced across the
suspend cycle.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Fixes: 79d2c8bede2c ("pinctrl/amd: save pin registers over suspend/resume")
Link: https://lore.kernel.org/r/20220613064127.220416-3-Basavaraj.Natikar@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -912,6 +912,7 @@ static int amd_gpio_suspend(struct devic
 {
 	struct amd_gpio *gpio_dev = dev_get_drvdata(dev);
 	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	unsigned long flags;
 	int i;
 
 	for (i = 0; i < desc->npins; i++) {
@@ -920,7 +921,9 @@ static int amd_gpio_suspend(struct devic
 		if (!amd_gpio_should_save(gpio_dev, pin))
 			continue;
 
-		gpio_dev->saved_regs[i] = readl(gpio_dev->base + pin*4);
+		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+		gpio_dev->saved_regs[i] = readl(gpio_dev->base + pin * 4) & ~PIN_IRQ_PENDING;
+		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 	}
 
 	return 0;
@@ -930,6 +933,7 @@ static int amd_gpio_resume(struct device
 {
 	struct amd_gpio *gpio_dev = dev_get_drvdata(dev);
 	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	unsigned long flags;
 	int i;
 
 	for (i = 0; i < desc->npins; i++) {
@@ -938,7 +942,10 @@ static int amd_gpio_resume(struct device
 		if (!amd_gpio_should_save(gpio_dev, pin))
 			continue;
 
-		writel(gpio_dev->saved_regs[i], gpio_dev->base + pin*4);
+		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+		gpio_dev->saved_regs[i] |= readl(gpio_dev->base + pin * 4) & PIN_IRQ_PENDING;
+		writel(gpio_dev->saved_regs[i], gpio_dev->base + pin * 4);
+		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 	}
 
 	return 0;


