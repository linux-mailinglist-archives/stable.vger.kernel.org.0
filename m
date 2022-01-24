Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F76549A4CA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371936AbiAYAKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2364010AbiAXXqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:46:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE70C0617A8;
        Mon, 24 Jan 2022 13:41:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48029B81233;
        Mon, 24 Jan 2022 21:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B20C340E4;
        Mon, 24 Jan 2022 21:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060488;
        bh=RU9LPponh3x6LDCbLu8EQDIpjKNBT5b5AgJqXCNloFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y4sPFk93mlJ9DxmxIxBnAHY1e0J8/FmqqbDVPQZFs1Ed72rOPbGPaj5CsL7i2Uovn
         dMehCfw2KatUHKlUbRHsLwYw1XLTJAYZVwltmzXzQ9E4oit50+xk7oE+ibEzDVk9Y+
         jj+CSAIEyF5xRSAKjWPyImGmOS/30xoQjFDYHe8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.16 0964/1039] gpio: mpc8xxx: Fix IRQ check in mpc8xxx_probe
Date:   Mon, 24 Jan 2022 19:45:53 +0100
Message-Id: <20220124184157.689790247@linuxfoundation.org>
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

commit 0b39536cc699db6850c426db7f9cb45923de40c5 upstream.

platform_get_irq() returns negative error number instead 0 on failure.
And the doc of platform_get_irq() provides a usage example:

    int irq = platform_get_irq(pdev, 0);
    if (irq < 0)
        return irq;

Fix the check of return value to catch errors correctly.

Fixes: 76c47d1449fc ("gpio: mpc8xxx: Add ACPI support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mpc8xxx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -388,8 +388,8 @@ static int mpc8xxx_probe(struct platform
 	}
 
 	mpc8xxx_gc->irqn = platform_get_irq(pdev, 0);
-	if (!mpc8xxx_gc->irqn)
-		return 0;
+	if (mpc8xxx_gc->irqn < 0)
+		return mpc8xxx_gc->irqn;
 
 	mpc8xxx_gc->irq = irq_domain_create_linear(fwnode,
 						   MPC8XXX_GPIO_PINS,


