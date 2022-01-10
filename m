Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD61489209
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241135AbiAJHho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241511AbiAJHfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:35:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEFBC028BF6;
        Sun,  9 Jan 2022 23:31:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9476B81161;
        Mon, 10 Jan 2022 07:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027FFC36AED;
        Mon, 10 Jan 2022 07:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799870;
        bh=QGV9ybegpgxeb4XkMaOZjZs9eMIf49iusznKtxoQzC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMSyJ16aGyQLKgeufj9I8QcRBwgOcMwd0yQqwP48qebYRCtau2wL8528CqwUJRagK
         zrmfcputES+QOv3y42c2zAdZw2JxD0JYNQlbqYXeMphVsrBEnqSgeepzdNE3RpIy/5
         vjRgJHwl4SOAMWl0Mh74rPFJrvD/LnvLxd2q/98I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Nikita Travkin <nikita@trvn.ru>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 43/43] Input: zinitix - make sure the IRQ is allocated before it gets enabled
Date:   Mon, 10 Jan 2022 08:23:40 +0100
Message-Id: <20220110071818.798892318@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Travkin <nikita@trvn.ru>

commit cf73ed894ee939d6706d65e0cd186e4a64e3af6d upstream.

Since irq request is the last thing in the driver probe, it happens
later than the input device registration. This means that there is a
small time window where if the open method is called the driver will
attempt to enable not yet available irq.

Fix that by moving the irq request before the input device registration.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Fixes: 26822652c85e ("Input: add zinitix touchscreen driver")
Signed-off-by: Nikita Travkin <nikita@trvn.ru>
Link: https://lore.kernel.org/r/20220106072840.36851-2-nikita@trvn.ru
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/zinitix.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/input/touchscreen/zinitix.c
+++ b/drivers/input/touchscreen/zinitix.c
@@ -488,6 +488,15 @@ static int zinitix_ts_probe(struct i2c_c
 		return error;
 	}
 
+	error = devm_request_threaded_irq(&client->dev, client->irq,
+					  NULL, zinitix_ts_irq_handler,
+					  IRQF_ONESHOT,
+					  client->name, bt541);
+	if (error) {
+		dev_err(&client->dev, "Failed to request IRQ: %d\n", error);
+		return error;
+	}
+
 	error = zinitix_init_input_dev(bt541);
 	if (error) {
 		dev_err(&client->dev,
@@ -514,13 +523,6 @@ static int zinitix_ts_probe(struct i2c_c
 	}
 
 	irq_set_status_flags(client->irq, IRQ_NOAUTOEN);
-	error = devm_request_threaded_irq(&client->dev, client->irq,
-					  NULL, zinitix_ts_irq_handler,
-					  IRQF_ONESHOT, client->name, bt541);
-	if (error) {
-		dev_err(&client->dev, "Failed to request IRQ: %d\n", error);
-		return error;
-	}
 
 	return 0;
 }


