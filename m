Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6726755D8D4
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238649AbiF0Ly2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238139AbiF0LvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:51:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A939659D;
        Mon, 27 Jun 2022 04:44:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33506612B1;
        Mon, 27 Jun 2022 11:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38667C341CD;
        Mon, 27 Jun 2022 11:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330265;
        bh=VLQyzPYvXcOhroRTJOIwWKIJLr+kYg5ugNy72uYPY+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cb282QUTV84x8dd7IUORV6SHLAIyXbknlGxp0HtLVH3HIUeAbh8Hix6cm6SZgwizN
         O1AvdT0s9IdXvKUVdjsRGy5U8Ooagax8dNLdR57JBHNRqTbYshlUSTRk0MTFHyZ8wE
         LbjrmD22Q7s0JwncPN7ixVCzCLOF7HD1mg9RSbwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Rokosov <ddrokosov@sberdevices.ru>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.18 132/181] iio:chemical:ccs811: rearrange iio trigger get and register
Date:   Mon, 27 Jun 2022 13:21:45 +0200
Message-Id: <20220627111948.517998122@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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

From: Dmitry Rokosov <DDRokosov@sberdevices.ru>

commit d710359c0b445e8c03e24f19ae2fb79ce7282260 upstream.

IIO trigger interface function iio_trigger_get() should be called after
iio_trigger_register() (or its devm analogue) strictly, because of
iio_trigger_get() acquires module refcnt based on the trigger->owner
pointer, which is initialized inside iio_trigger_register() to
THIS_MODULE.
If this call order is wrong, the next iio_trigger_put() (from sysfs
callback or "delete module" path) will dereference "default" module
refcnt, which is incorrect behaviour.

Fixes: f1f065d7ac30 ("iio: chemical: ccs811: Add support for data ready trigger")
Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220524181150.9240-5-ddrokosov@sberdevices.ru
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/ccs811.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/chemical/ccs811.c
+++ b/drivers/iio/chemical/ccs811.c
@@ -499,11 +499,11 @@ static int ccs811_probe(struct i2c_clien
 
 		data->drdy_trig->ops = &ccs811_trigger_ops;
 		iio_trigger_set_drvdata(data->drdy_trig, indio_dev);
-		indio_dev->trig = data->drdy_trig;
-		iio_trigger_get(indio_dev->trig);
 		ret = iio_trigger_register(data->drdy_trig);
 		if (ret)
 			goto err_poweroff;
+
+		indio_dev->trig = iio_trigger_get(data->drdy_trig);
 	}
 
 	ret = iio_triggered_buffer_setup(indio_dev, NULL,


