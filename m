Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54A4419B6E
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbhI0RTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237030AbhI0RQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D81561391;
        Mon, 27 Sep 2021 17:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762693;
        bh=xjg8zAQ/CJkYG2lqXOjkXxr42zbWEVMf1dL6QD4ZLEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqrLc44wXr+0J7nc8koeo1r/U3gHYl5D8oROgLyIunpXMrpuVx1TnDFgnmpKggNmi
         hNiW4ktaagMmkMjpqDTfzgmxQkqskBqwv6MRZmeuf3L5CBLlrj6XyseS91DoMqxGEd
         ceRzPqVDcut1nO/1sljI90KzUyotQtToKCAjPgPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 5.14 017/162] Revert "USB: bcma: Add a check for devm_gpiod_get"
Date:   Mon, 27 Sep 2021 19:01:03 +0200
Message-Id: <20210927170234.044214613@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

commit d91adc5322ab53df4b6d1989242bfb6c63163eb2 upstream.

This reverts commit f3de5d857bb2362b00e2a8d4bc886cd49dcb66db.

That commit broke USB on all routers that have USB always powered on and
don't require toggling any GPIO. It's a majority of devices actually.

The original code worked and seemed safe: vcc GPIO is optional and
bcma_hci_platform_power_gpio() takes care of checking the pointer before
using it.

This revert fixes:
[   10.801127] bcma_hcd: probe of bcma0:11 failed with error -2

Fixes: f3de5d857bb2 ("USB: bcma: Add a check for devm_gpiod_get")
Cc: stable <stable@vger.kernel.org>
Cc: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20210831065419.18371-1-zajec5@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/bcma-hcd.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/host/bcma-hcd.c
+++ b/drivers/usb/host/bcma-hcd.c
@@ -406,12 +406,9 @@ static int bcma_hcd_probe(struct bcma_de
 		return -ENOMEM;
 	usb_dev->core = core;
 
-	if (core->dev.of_node) {
+	if (core->dev.of_node)
 		usb_dev->gpio_desc = devm_gpiod_get(&core->dev, "vcc",
 						    GPIOD_OUT_HIGH);
-		if (IS_ERR(usb_dev->gpio_desc))
-			return PTR_ERR(usb_dev->gpio_desc);
-	}
 
 	switch (core->id.id) {
 	case BCMA_CORE_USB20_HOST:


