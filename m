Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754D44BE694
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351323AbiBUQ7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 11:59:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350922AbiBUQ7U (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 21 Feb 2022 11:59:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE77E22BCE
        for <Stable@vger.kernel.org>; Mon, 21 Feb 2022 08:58:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A873B815A5
        for <Stable@vger.kernel.org>; Mon, 21 Feb 2022 16:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48A6C340E9;
        Mon, 21 Feb 2022 16:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645462734;
        bh=ZBr2II2sW2Ic5SHSJq01dEwQK/WJnUstATebT8Ul54s=;
        h=Subject:To:From:Date:From;
        b=hRq58LnSUkdZ1VBiQoXk1gBZI1yVPlH0KCPoJVICpohjoU6+XsQSTJJ1tti6XjOfR
         eomlZzi6O0Kha0rW3Hxj6wBFYunVFHxn+6Nr/3vgPY9hZgBs+Q9it4wQW0lhjF8D1d
         Wh1yI1i4iWTlEiI2lzbMNmkSUSsGhAMc6g14QxjA=
Subject: patch "iio:imu:adis16480: fix buffering for devices with no burst mode" added to char-misc-linus
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, julia.pineda@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 17:58:41 +0100
Message-ID: <1645462721145145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:imu:adis16480: fix buffering for devices with no burst mode

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b0e85f95e30d4d2dc22ea123a30dba36406879a1 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Fri, 14 Jan 2022 14:26:08 +0100
Subject: iio:imu:adis16480: fix buffering for devices with no burst mode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The trigger handler defined in the driver assumes that burst mode is
being used. Hence, for devices that do not support it, we have to use
the adis library default trigger implementation.

Tested-by: Julia Pineda <julia.pineda@analog.com>
Fixes: 941f130881fa9 ("iio: adis16480: support burst read function")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220114132608.241-1-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
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


