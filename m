Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C8F499598
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442110AbiAXUxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:53:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43976 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392046AbiAXUuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:50:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA50160C39;
        Mon, 24 Jan 2022 20:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA97C340E5;
        Mon, 24 Jan 2022 20:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057419;
        bh=EtWA7L7BqdpMoJktY/5B7XDbMJPG7DdHQWCd5GNvgoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NymyGXlv0H4tCYr1C77KT2o76vAhXqrw1Sc5CCOFErtu5jMf2dIUvEbtva1z0f89l
         w85dLjn3hF3jioWUbL8yr25ouyU51d5yR6g5nJ2HqiWeAzlVuTCclTNPX3k4WZL5pI
         oO/GxYSZVWSj0TRqQ7wkHqgHBl3mCET4qAxjoVzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.15 789/846] gpio: idt3243x: Fix IRQ check in idt_gpio_probe
Date:   Mon, 24 Jan 2022 19:45:06 +0100
Message-Id: <20220124184128.183129646@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit 30fee1d7462a446ade399c0819717a830cbdca69 upstream.

platform_get_irq() returns negative error number instead 0 on failure.
And the doc of platform_get_irq() provides a usage example:

    int irq = platform_get_irq(pdev, 0);
    if (irq < 0)
        return irq;

Fix the check of return value to catch errors correctly.

Fixes: 4195926aedca ("gpio: Add support for IDT 79RC3243x GPIO controller")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-idt3243x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-idt3243x.c
+++ b/drivers/gpio/gpio-idt3243x.c
@@ -164,8 +164,8 @@ static int idt_gpio_probe(struct platfor
 			return PTR_ERR(ctrl->pic);
 
 		parent_irq = platform_get_irq(pdev, 0);
-		if (!parent_irq)
-			return -EINVAL;
+		if (parent_irq < 0)
+			return parent_irq;
 
 		girq = &ctrl->gc.irq;
 		girq->chip = &idt_gpio_irqchip;


