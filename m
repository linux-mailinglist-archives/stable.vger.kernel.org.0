Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB3F5AAF41
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbiIBMfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236999AbiIBMeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:34:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A84DEA63;
        Fri,  2 Sep 2022 05:28:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE35262109;
        Fri,  2 Sep 2022 12:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F90C433C1;
        Fri,  2 Sep 2022 12:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121665;
        bh=JTYxFQLfUjY3t704BsxDxE+D5RtOCrFe01IOPYQEJwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RhHqtX51bjo1UOeiN1dpkS/F4hDt1+Yvz+3raIAijLkunjZz3FcrPdWYSUMGKoFgQ
         e/LHZhQeNZgQoZN4xwxfEHww+Xjrg8t8yHzAkdxB5zbtKl9BIMeMrezMAl/0p8bEwr
         Jd/YW6nxYivB7dqYH4oaQDzKSXz3pmmhroR4TnjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 07/77] pinctrl: amd: Dont save/restore interrupt status and wake status bits
Date:   Fri,  2 Sep 2022 14:18:16 +0200
Message-Id: <20220902121403.862256116@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
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
@@ -793,6 +793,7 @@ static int amd_gpio_suspend(struct devic
 {
 	struct amd_gpio *gpio_dev = dev_get_drvdata(dev);
 	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	unsigned long flags;
 	int i;
 
 	for (i = 0; i < desc->npins; i++) {
@@ -801,7 +802,9 @@ static int amd_gpio_suspend(struct devic
 		if (!amd_gpio_should_save(gpio_dev, pin))
 			continue;
 
-		gpio_dev->saved_regs[i] = readl(gpio_dev->base + pin*4);
+		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+		gpio_dev->saved_regs[i] = readl(gpio_dev->base + pin * 4) & ~PIN_IRQ_PENDING;
+		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 	}
 
 	return 0;
@@ -811,6 +814,7 @@ static int amd_gpio_resume(struct device
 {
 	struct amd_gpio *gpio_dev = dev_get_drvdata(dev);
 	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	unsigned long flags;
 	int i;
 
 	for (i = 0; i < desc->npins; i++) {
@@ -819,7 +823,10 @@ static int amd_gpio_resume(struct device
 		if (!amd_gpio_should_save(gpio_dev, pin))
 			continue;
 
-		writel(gpio_dev->saved_regs[i], gpio_dev->base + pin*4);
+		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+		gpio_dev->saved_regs[i] |= readl(gpio_dev->base + pin * 4) & PIN_IRQ_PENDING;
+		writel(gpio_dev->saved_regs[i], gpio_dev->base + pin * 4);
+		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 	}
 
 	return 0;


