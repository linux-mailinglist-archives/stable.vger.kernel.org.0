Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACBD6431E9
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbiLETWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbiLETVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:21:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A5A62C5
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:17:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2485F61325
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BB7C433D6;
        Mon,  5 Dec 2022 19:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267864;
        bh=JNbBR9TbNTyNLhN3lNv/n5ubonlD3iXy0XFRkO3t1aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8pCe5bBzOwnmA+lxvzPcvqzIwFQyghpss0gZXZmJAskoNyvJewDKo3cor+XlSZ97
         a/KHlNcMgyT2pcVbVYMI5VQKpT/+69yaU89VO5XJX7YjlKe3z6KKhKwsWu8p1PqkbC
         n3FQMn+vnPq6z6FJejTXOujex8YRnKfXI+uYdEtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Gazzillo <paul@pgazz.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 41/77] iio: light: rpr0521: add missing Kconfig dependencies
Date:   Mon,  5 Dec 2022 20:09:32 +0100
Message-Id: <20221205190802.331209407@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
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
index 2356ed9285df..67eda9643df5 100644
--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -237,6 +237,8 @@ config RPR0521
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



