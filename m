Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE2155D100
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbiF0Ldv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235891AbiF0Lcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:32:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A9CAD;
        Mon, 27 Jun 2022 04:29:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03EC1B8111A;
        Mon, 27 Jun 2022 11:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591CFC3411D;
        Mon, 27 Jun 2022 11:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329385;
        bh=e6qYBuNvaK9vJWUNHSGQdFOs57yjXaAesaxvVanYtg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x69AsPKMugb/Xdy9r9rXb7VCx3MwuaQfOg8DESYbP1D3XPdWjnbLlFNS1dwDVurJ4
         K4Q5pQT5Z2LmDQjU5mYp8r6K6HLBGzBVFlRd1AtIC1PL0OhiaHyeCi98tA3bX/5Yvd
         oLAnHv+MoXkPU/BCHfwN9fHPFkEMBt58FpS8Zghs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Rokosov <ddrokosov@sberdevices.ru>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 40/60] iio:accel:mxc4005: rearrange iio trigger get and register
Date:   Mon, 27 Jun 2022 13:21:51 +0200
Message-Id: <20220627111928.869433949@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
References: <20220627111927.641837068@linuxfoundation.org>
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

commit 9354c224c9b4f55847a0de3e968cba2ebf15af3b upstream.

IIO trigger interface function iio_trigger_get() should be called after
iio_trigger_register() (or its devm analogue) strictly, because of
iio_trigger_get() acquires module refcnt based on the trigger->owner
pointer, which is initialized inside iio_trigger_register() to
THIS_MODULE.
If this call order is wrong, the next iio_trigger_put() (from sysfs
callback or "delete module" path) will dereference "default" module
refcnt, which is incorrect behaviour.

Fixes: 47196620c82f ("iio: mxc4005: add data ready trigger for mxc4005")
Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220524181150.9240-4-ddrokosov@sberdevices.ru
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/mxc4005.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/accel/mxc4005.c
+++ b/drivers/iio/accel/mxc4005.c
@@ -462,8 +462,6 @@ static int mxc4005_probe(struct i2c_clie
 		data->dready_trig->dev.parent = &client->dev;
 		data->dready_trig->ops = &mxc4005_trigger_ops;
 		iio_trigger_set_drvdata(data->dready_trig, indio_dev);
-		indio_dev->trig = data->dready_trig;
-		iio_trigger_get(indio_dev->trig);
 		ret = devm_iio_trigger_register(&client->dev,
 						data->dready_trig);
 		if (ret) {
@@ -471,6 +469,8 @@ static int mxc4005_probe(struct i2c_clie
 				"failed to register trigger\n");
 			return ret;
 		}
+
+		indio_dev->trig = iio_trigger_get(data->dready_trig);
 	}
 
 	return devm_iio_device_register(&client->dev, indio_dev);


