Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D4E4C75E9
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237146AbiB1R46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239430AbiB1RxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:53:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52AA9399D;
        Mon, 28 Feb 2022 09:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92697614CC;
        Mon, 28 Feb 2022 17:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97030C340E7;
        Mon, 28 Feb 2022 17:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070017;
        bh=/hYQGTqQQmB6eHTb99rmYrwWLM/X1AuUSuVmxovmtDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJopDP9Lcx0vkDVnDDqP0QLCTnVehtN45Ne+2AVWHjPvzqCC9+Z17x5cM27E52gG5
         12Y6NYqvrmKmHdTSC8n1hZVKCMiOOWgqjbIJl7N7Leh8OukFGM9aE3Obh66cZncJ/r
         LEWImMYM3Ahv8DwaBwIgQkmXhnLNnD79C5BhhPwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Pineda <julia.pineda@analog.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 096/139] iio:imu:adis16480: fix buffering for devices with no burst mode
Date:   Mon, 28 Feb 2022 18:24:30 +0100
Message-Id: <20220228172357.703817331@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

commit b0e85f95e30d4d2dc22ea123a30dba36406879a1 upstream.

The trigger handler defined in the driver assumes that burst mode is
being used. Hence, for devices that do not support it, we have to use
the adis library default trigger implementation.

Tested-by: Julia Pineda <julia.pineda@analog.com>
Fixes: 941f130881fa9 ("iio: adis16480: support burst read function")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220114132608.241-1-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis16480.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis16480.c b/drivers/iio/imu/adis16480.c
index ed129321a14d..f9b4540db1f4 100644
--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -1403,6 +1403,7 @@ static int adis16480_probe(struct spi_device *spi)
 {
 	const struct spi_device_id *id = spi_get_device_id(spi);
 	const struct adis_data *adis16480_data;
+	irq_handler_t trigger_handler = NULL;
 	struct iio_dev *indio_dev;
 	struct adis16480 *st;
 	int ret;
@@ -1474,8 +1475,12 @@ static int adis16480_probe(struct spi_device *spi)
 		st->clk_freq = st->chip_info->int_clk;
 	}
 
+	/* Only use our trigger handler if burst mode is supported */
+	if (adis16480_data->burst_len)
+		trigger_handler = adis16480_trigger_handler;
+
 	ret = devm_adis_setup_buffer_and_trigger(&st->adis, indio_dev,
-						 adis16480_trigger_handler);
+						 trigger_handler);
 	if (ret)
 		return ret;
 
-- 
2.35.1



