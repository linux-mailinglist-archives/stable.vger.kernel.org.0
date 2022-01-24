Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7156E49958E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344549AbiAXUwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:52:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43504 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388886AbiAXUtq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:49:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BC6C60B21;
        Mon, 24 Jan 2022 20:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ACEC340E5;
        Mon, 24 Jan 2022 20:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057385;
        bh=RU9LPponh3x6LDCbLu8EQDIpjKNBT5b5AgJqXCNloFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTi422rImM40VF3RVaIvuPZltCKeHczfnGOeT6ZNKHMiVtesXckFXgFtkFreK7YAa
         IFlpAwLBWC2BOIsk1eQ0xjBwDb3ZFPfrNFSVSQ62h0rn71XkoPWgiLLj9nARTEytND
         eENnpEgY1zgJQkrH5ogV3XtZkUwaaPXmdSCOARIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.15 788/846] gpio: mpc8xxx: Fix IRQ check in mpc8xxx_probe
Date:   Mon, 24 Jan 2022 19:45:05 +0100
Message-Id: <20220124184128.143034873@linuxfoundation.org>
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


