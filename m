Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0817C60BAEA
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbiJXUmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234792AbiJXUlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:41:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF9217F664;
        Mon, 24 Oct 2022 11:50:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 219CCB819AD;
        Mon, 24 Oct 2022 12:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7941AC433C1;
        Mon, 24 Oct 2022 12:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615533;
        bh=de93994sNvEfasj0JU76mGj23QzHTw6KLverZZxUaC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tiOmOuADgLtyQNrfSfQiNn3y249wGp6NQABguOVeisS4zVneVqKH1G7qaiiWXXB+Y
         HIOHubIWMBKO9V/7x7vAh+AAGCJvVLZmH2t9rxMVhq9I46oFubqO7khPkMziAzazPV
         +hqlfFnuSLFqEz62itswIulS5mIXuIr9ejKbrL3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 287/530] media: uvcvideo: Fix memory leak in uvc_gpio_parse
Date:   Mon, 24 Oct 2022 13:30:31 +0200
Message-Id: <20221024113058.047779137@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit f0f078457f18f10696888f8d0e6aba9deb9cde92 ]

Previously the unit buffer was allocated before checking the IRQ for
privacy GPIO. In case of error, the unit buffer was leaked.

Allocate the unit buffer after the IRQ to avoid it.

Addresses-Coverity-ID: 1474639 ("Resource leak")

Fixes: 2886477ff987 ("media: uvcvideo: Implement UVC_EXT_GPIO_UNIT")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 9a791d8ef200..72fff7264b54 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1534,10 +1534,6 @@ static int uvc_gpio_parse(struct uvc_device *dev)
 	if (IS_ERR_OR_NULL(gpio_privacy))
 		return PTR_ERR_OR_ZERO(gpio_privacy);
 
-	unit = uvc_alloc_entity(UVC_EXT_GPIO_UNIT, UVC_EXT_GPIO_UNIT_ID, 0, 1);
-	if (!unit)
-		return -ENOMEM;
-
 	irq = gpiod_to_irq(gpio_privacy);
 	if (irq < 0) {
 		if (irq != EPROBE_DEFER)
@@ -1546,6 +1542,10 @@ static int uvc_gpio_parse(struct uvc_device *dev)
 		return irq;
 	}
 
+	unit = uvc_alloc_entity(UVC_EXT_GPIO_UNIT, UVC_EXT_GPIO_UNIT_ID, 0, 1);
+	if (!unit)
+		return -ENOMEM;
+
 	unit->gpio.gpio_privacy = gpio_privacy;
 	unit->gpio.irq = irq;
 	unit->gpio.bControlSize = 1;
-- 
2.35.1



