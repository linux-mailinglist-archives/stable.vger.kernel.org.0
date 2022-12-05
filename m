Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4580D643334
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbiLETfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbiLETei (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:34:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B061AF
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:30:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DB316130C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9785DC433D7;
        Mon,  5 Dec 2022 19:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268609;
        bh=fikWHTejil3pXHr0mPdz6jYf7Q8BwEXd4iM7yIb2Yig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njHAKgCRdvfMarBTR9K9hzTJJQHEGt3qldHTnkJf1+7opWolXJld1hhd5EjDQi8ry
         Nk0CQuJ2uHZu0VCFrFkQ1Ns7UfkIssg5qRmZXNXDhjag9YEa0dKQRF9OCUAMLSQVV0
         eOCK2aa/bEiNTik2O86F0qVfKfwevmMq3wn/1TPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Gazzillo <paul@pgazz.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 12/92] iio: light: rpr0521: add missing Kconfig dependencies
Date:   Mon,  5 Dec 2022 20:09:25 +0100
Message-Id: <20221205190803.899611132@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Gazzillo <paul@pgazz.com>

[ Upstream commit 6ac12303572ef9ace5603c2c07f5f1b00a33f580 ]

Fix an implicit declaration of function error for rpr0521 under some configs

When CONFIG_RPR0521 is enabled without CONFIG_IIO_TRIGGERED_BUFFER,
the build results in "implicit declaration of function" errors, e.g.,
  drivers/iio/light/rpr0521.c:434:3: error: implicit declaration of function
           'iio_trigger_poll_chained' [-Werror=implicit-function-declaration]
    434 |   iio_trigger_poll_chained(data->drdy_trigger0);
        |   ^~~~~~~~~~~~~~~~~~~~~~~~

This fix adds select dependencies to RPR0521's configuration declaration.

Fixes: e12ffd241c00 ("iio: light: rpr0521 triggered buffer")
Signed-off-by: Paul Gazzillo <paul@pgazz.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216678
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221110214729.ls5ixav5kxpeftk7@device
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
index 917f9becf9c7..dd52eff9ba2a 100644
--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -294,6 +294,8 @@ config RPR0521
 	tristate "ROHM RPR0521 ALS and proximity sensor driver"
 	depends on I2C
 	select REGMAP_I2C
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say Y here if you want to build support for ROHM's RPR0521
 	  ambient light and proximity sensor device.
-- 
2.35.1



