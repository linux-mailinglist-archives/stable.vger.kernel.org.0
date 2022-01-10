Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8116D48927F
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241784AbiAJHnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241603AbiAJHlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:41:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E0DC03327E;
        Sun,  9 Jan 2022 23:34:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47BE161194;
        Mon, 10 Jan 2022 07:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302E6C36AED;
        Mon, 10 Jan 2022 07:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800094;
        bh=NZv5gSNC3MtaZrP/A7651LQm0HtR/srezfufRg09D5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNVGrboA3ABpYiBgXiAF2ic8K2Uhy6rlEsaN3oZSFvE1ZBIaSljuTR2v4RC2Ry2EE
         wiAGNEaaAw1xBOB6vAZ4v37uYzr8oINVeCpcuRWIyqF3LgxnisN9fCkSlZeob1OHgz
         utZT16FF1TcPpzOepxZgxjgpgGhY490rlHmwl4Iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Nikita Travkin <nikita@trvn.ru>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 70/72] Input: zinitix - make sure the IRQ is allocated before it gets enabled
Date:   Mon, 10 Jan 2022 08:23:47 +0100
Message-Id: <20220110071823.930427846@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Travkin <nikita@trvn.ru>

[ Upstream commit cf73ed894ee939d6706d65e0cd186e4a64e3af6d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/zinitix.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/input/touchscreen/zinitix.c b/drivers/input/touchscreen/zinitix.c
index b8d901099378d..1e70b8d2a8d79 100644
--- a/drivers/input/touchscreen/zinitix.c
+++ b/drivers/input/touchscreen/zinitix.c
@@ -488,6 +488,15 @@ static int zinitix_ts_probe(struct i2c_client *client)
 		return error;
 	}
 
+	error = devm_request_threaded_irq(&client->dev, client->irq,
+					  NULL, zinitix_ts_irq_handler,
+					  IRQF_ONESHOT | IRQF_NO_AUTOEN,
+					  client->name, bt541);
+	if (error) {
+		dev_err(&client->dev, "Failed to request IRQ: %d\n", error);
+		return error;
+	}
+
 	error = zinitix_init_input_dev(bt541);
 	if (error) {
 		dev_err(&client->dev,
@@ -513,15 +522,6 @@ static int zinitix_ts_probe(struct i2c_client *client)
 		return -EINVAL;
 	}
 
-	error = devm_request_threaded_irq(&client->dev, client->irq,
-					  NULL, zinitix_ts_irq_handler,
-					  IRQF_ONESHOT | IRQF_NO_AUTOEN,
-					  client->name, bt541);
-	if (error) {
-		dev_err(&client->dev, "Failed to request IRQ: %d\n", error);
-		return error;
-	}
-
 	return 0;
 }
 
-- 
2.34.1



