Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0BC55C83F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbiF0Ia0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 04:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233555AbiF0IaY (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 27 Jun 2022 04:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086F362F2
        for <Stable@vger.kernel.org>; Mon, 27 Jun 2022 01:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 467D261030
        for <Stable@vger.kernel.org>; Mon, 27 Jun 2022 08:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C968C3411D;
        Mon, 27 Jun 2022 08:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656318621;
        bh=hhvbLZYLBhJwFJo+Mjn4xU+CMyerSs2asO2RPLCuYO0=;
        h=Subject:To:Cc:From:Date:From;
        b=Qgnf/gXf+Z0bjZ+Ue01mIREcNSFeb0IEcxLWkhbo5lJSCkylS4cE0Brp4G7bJicZV
         dSqelLHIGBUii8pbWum7VOTsk4U1VqjWlQ+Lt6RyMkxJDEpqfkqWa1s2u3WzE+SDVr
         cg1Eu96GVXOwzKECXwkvP8euGsA+rZN0TPJ/bUn4=
Subject: FAILED: patch "[PATCH] iio:humidity:hts221: rearrange iio trigger get and register" failed to apply to 4.9-stable tree
To:     DDRokosov@sberdevices.ru, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com,
        ddrokosov@sberdevices.ru
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jun 2022 10:30:06 +0200
Message-ID: <16563186061488@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 10b9c2c33ac706face458feab8965f11743c98c0 Mon Sep 17 00:00:00 2001
From: Dmitry Rokosov <DDRokosov@sberdevices.ru>
Date: Tue, 24 May 2022 18:14:46 +0000
Subject: [PATCH] iio:humidity:hts221: rearrange iio trigger get and register

IIO trigger interface function iio_trigger_get() should be called after
iio_trigger_register() (or its devm analogue) strictly, because of
iio_trigger_get() acquires module refcnt based on the trigger->owner
pointer, which is initialized inside iio_trigger_register() to
THIS_MODULE.
If this call order is wrong, the next iio_trigger_put() (from sysfs
callback or "delete module" path) will dereference "default" module
refcnt, which is incorrect behaviour.

Fixes: e4a70e3e7d84 ("iio: humidity: add support to hts221 rh/temp combo device")
Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220524181150.9240-6-ddrokosov@sberdevices.ru
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/humidity/hts221_buffer.c b/drivers/iio/humidity/hts221_buffer.c
index f29692b9d2db..66b32413cf5e 100644
--- a/drivers/iio/humidity/hts221_buffer.c
+++ b/drivers/iio/humidity/hts221_buffer.c
@@ -135,9 +135,12 @@ int hts221_allocate_trigger(struct iio_dev *iio_dev)
 
 	iio_trigger_set_drvdata(hw->trig, iio_dev);
 	hw->trig->ops = &hts221_trigger_ops;
+
+	err = devm_iio_trigger_register(hw->dev, hw->trig);
+
 	iio_dev->trig = iio_trigger_get(hw->trig);
 
-	return devm_iio_trigger_register(hw->dev, hw->trig);
+	return err;
 }
 
 static int hts221_buffer_preenable(struct iio_dev *iio_dev)

