Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5EDF5EA29C
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237368AbiIZLLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237390AbiIZLK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:10:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284C05FF6C;
        Mon, 26 Sep 2022 03:35:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D945B60B60;
        Mon, 26 Sep 2022 10:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E739BC433D6;
        Mon, 26 Sep 2022 10:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188452;
        bh=r+0DVuaIGotR9kbJXXW7hRwVS86iHwtwFFKFcHbvqG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qIIU0FI6GDiQWfvPPnYMy8Zk7jWinqxJtzb2YMaJiDbwT2Dz8M6jw9pRzmZpKzBna
         3J9dIPNXQHD7x3BpwnRUNKxnEayStTY1ypxD9M/tyHMrZIna3t5jH0LR9CpWyRUesp
         P7BbJGjk+7Rr7c3Zt9sdSJxoJ3ZgW4SvD+tHjEVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/148] iio: adc: mcp3911: correct "microchip,device-addr" property
Date:   Mon, 26 Sep 2022 12:10:46 +0200
Message-Id: <20220926100756.509543258@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit cfbd76d5c9c449739bb74288d982bccf9ff822f4 ]

Go for the right property name that is documented in the bindings.

Fixes: 3a89b289df5d ("iio: adc: add support for mcp3911")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220722130726.7627-3-marcus.folkesson@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/mcp3911.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/mcp3911.c b/drivers/iio/adc/mcp3911.c
index 608842632925..7eecbfd491a4 100644
--- a/drivers/iio/adc/mcp3911.c
+++ b/drivers/iio/adc/mcp3911.c
@@ -217,7 +217,14 @@ static int mcp3911_config(struct mcp3911 *adc)
 	u32 configreg;
 	int ret;
 
-	device_property_read_u32(dev, "device-addr", &adc->dev_addr);
+	ret = device_property_read_u32(dev, "microchip,device-addr", &adc->dev_addr);
+
+	/*
+	 * Fallback to "device-addr" due to historical mismatch between
+	 * dt-bindings and implementation
+	 */
+	if (ret)
+		device_property_read_u32(dev, "device-addr", &adc->dev_addr);
 	if (adc->dev_addr > 3) {
 		dev_err(&adc->spi->dev,
 			"invalid device address (%i). Must be in range 0-3.\n",
-- 
2.35.1



