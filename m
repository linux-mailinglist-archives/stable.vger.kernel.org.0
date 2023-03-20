Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC076C18F2
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbjCTP3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbjCTP2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:28:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6DD32CD2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:21:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 461A4CE12F9
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81956C4339B;
        Mon, 20 Mar 2023 15:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325698;
        bh=XhpReMj36BlNDK3+s+oxR1RtENo0vBcfeNHemoNRg9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0zLioNT3cG6jY/zC42Vg/onLbvFl5xFtfD+WbcQN+WXVq81Xsap0/TZZySBv8oLo
         xPeAOQWrJqLy/dRrQjB+354hVguxAr6lTqkz+5hBycLAs8lG6HDT739pvZl8a6hWzu
         dw4lOYAtWVzXoWK4PgvqcxnrwLDsqn2iRJvqRNVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lars-Peter Clausen <lars@metafoo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/198] hwmon: (adm1266) Set `can_sleep` flag for GPIO chip
Date:   Mon, 20 Mar 2023 15:53:58 +0100
Message-Id: <20230320145511.763737760@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit a5bb73b3f5db1a4e91402ad132b59b13d2651ed9 ]

The adm1266 driver uses I2C bus access in its GPIO chip `set` and `get`
implementation. This means these functions can sleep and the GPIO chip
should set the `can_sleep` property to true.

This will ensure that a warning is printed when trying to set or get the
GPIO value from a context that potentially can't sleep.

Fixes: d98dfad35c38 ("hwmon: (pmbus/adm1266) Add support for GPIOs")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20230314093146.2443845-1-lars@metafoo.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/adm1266.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/pmbus/adm1266.c b/drivers/hwmon/pmbus/adm1266.c
index ec5f932fc6f0f..1ac2b2f4c5705 100644
--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -301,6 +301,7 @@ static int adm1266_config_gpio(struct adm1266_data *data)
 	data->gc.label = name;
 	data->gc.parent = &data->client->dev;
 	data->gc.owner = THIS_MODULE;
+	data->gc.can_sleep = true;
 	data->gc.base = -1;
 	data->gc.names = data->gpio_names;
 	data->gc.ngpio = ARRAY_SIZE(data->gpio_names);
-- 
2.39.2



