Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BD7561C57
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbiF3NwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235454AbiF3Nvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:51:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1FE43ED6;
        Thu, 30 Jun 2022 06:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EA6DB82AF5;
        Thu, 30 Jun 2022 13:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF02CC34115;
        Thu, 30 Jun 2022 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596964;
        bh=M5eWI8GLqMBs1KZpLYLx0aef5pNK01Mfwl3xIvzEc+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kjn9qvrFr8fN3GexzXxIIXo6lRrkG2OdB+kLl17cUruOdfT5Hg8rg8u/u23CLiKcv
         ytCWlVNuYps3HKy1wFX5WycWfLGTF+iyuUtn2gw0fqZ/ZZUM3prfFtPEhLnTDSinrY
         MIJRck2/B+APnQLRWyUTCk+PQfihNbv9oEvNnllQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Rokosov <ddrokosov@sberdevices.ru>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 15/35] iio:accel:bma180: rearrange iio trigger get and register
Date:   Thu, 30 Jun 2022 15:46:26 +0200
Message-Id: <20220630133232.891429035@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.433955678@linuxfoundation.org>
References: <20220630133232.433955678@linuxfoundation.org>
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

commit e5f3205b04d7f95a2ef43bce4b454a7f264d6923 upstream.

IIO trigger interface function iio_trigger_get() should be called after
iio_trigger_register() (or its devm analogue) strictly, because of
iio_trigger_get() acquires module refcnt based on the trigger->owner
pointer, which is initialized inside iio_trigger_register() to
THIS_MODULE.
If this call order is wrong, the next iio_trigger_put() (from sysfs
callback or "delete module" path) will dereference "default" module
refcnt, which is incorrect behaviour.

Fixes: 0668a4e4d297 ("iio: accel: bma180: Fix indio_dev->trig assignment")
Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220524181150.9240-2-ddrokosov@sberdevices.ru
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/bma180.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -782,11 +782,12 @@ static int bma180_probe(struct i2c_clien
 		data->trig->dev.parent = &client->dev;
 		data->trig->ops = &bma180_trigger_ops;
 		iio_trigger_set_drvdata(data->trig, indio_dev);
-		indio_dev->trig = iio_trigger_get(data->trig);
 
 		ret = iio_trigger_register(data->trig);
 		if (ret)
 			goto err_trigger_free;
+
+		indio_dev->trig = iio_trigger_get(data->trig);
 	}
 
 	ret = iio_triggered_buffer_setup(indio_dev, NULL,


