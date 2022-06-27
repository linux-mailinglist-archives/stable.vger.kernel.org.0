Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D3455CE31
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238669AbiF0LwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238401AbiF0LvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:51:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43368265C;
        Mon, 27 Jun 2022 04:44:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6C1A61240;
        Mon, 27 Jun 2022 11:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE1FC3411D;
        Mon, 27 Jun 2022 11:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330245;
        bh=BNLFPZpsAc5Nj2RvB66h6RKzrBanhSoyZjQoghUykW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWEag8nIJMpqQl026y++H/kFvIyxh58LgyTEPCA4c7Q20ilsGo58Zi3LMSp2/JMeR
         YNcyo5FckHHqnQbc5HF3T9RkGEB0SCjwFY3+FDims7u+CchsecO8xuFUHxJrVg7Oop
         8HoJXwgF7AHUO4OJPu1UmHSij+9umNjhz3KXo9Ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Rokosov <ddrokosov@sberdevices.ru>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.18 130/181] iio:humidity:hts221: rearrange iio trigger get and register
Date:   Mon, 27 Jun 2022 13:21:43 +0200
Message-Id: <20220627111948.460505700@linuxfoundation.org>
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

commit 10b9c2c33ac706face458feab8965f11743c98c0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/humidity/hts221_buffer.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iio/humidity/hts221_buffer.c
+++ b/drivers/iio/humidity/hts221_buffer.c
@@ -135,9 +135,12 @@ int hts221_allocate_trigger(struct iio_d
 
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


