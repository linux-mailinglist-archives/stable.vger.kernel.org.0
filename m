Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAC1499B2C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574735AbiAXVuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52066 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457381AbiAXVld (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A81BB811FC;
        Mon, 24 Jan 2022 21:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804F2C340E4;
        Mon, 24 Jan 2022 21:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060490;
        bh=EtWA7L7BqdpMoJktY/5B7XDbMJPG7DdHQWCd5GNvgoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6comMHNeu4CT1rHyCM3kaHIu63EOlQfy/T2qE31EGGVrRivTFWz34SQAQU6c/CLJ
         5rceZjERHwYfCBp8ATYsLGzA6mQvlwKbzoFhZA0XmvOKaDwx6auq5PZy2A8xHpuBpE
         8NqpcdfpUgG7cc1VSHmmwZiAejeFdxIx2xN+2VfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.16 0965/1039] gpio: idt3243x: Fix IRQ check in idt_gpio_probe
Date:   Mon, 24 Jan 2022 19:45:54 +0100
Message-Id: <20220124184157.726618119@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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


