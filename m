Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAD96ECEA2
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbjDXNeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjDXNdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:33:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0776EA8
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:33:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F27D6237B
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335DDC433D2;
        Mon, 24 Apr 2023 13:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343206;
        bh=RC0twR+9KcpAPJ8hxqhLhYX2V4A/kj6xICjHVzzfHFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjQ444vTb7AKyeddyXvlzNHao9UB1roea1ZKDF5NZ8ptUhsjYUmiDkO+yjoh1bWQh
         HUkzba/VggbBC87qZO0Ebw0meBIPXUEqggAF/oV6b7Ej4CT0iTgkoKypQ5QZM0DXTL
         4kjfPa1MvG2GF/1Y4H5IUvpetkFgBx0Cx2FWoCEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.2 104/110] iio: adc: at91-sama5d2_adc: fix an error code in at91_adc_allocate_trigger()
Date:   Mon, 24 Apr 2023 15:18:06 +0200
Message-Id: <20230424131140.476871324@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

commit 73a428b37b9b538f8f8fe61caa45e7f243bab87c upstream.

The at91_adc_allocate_trigger() function is supposed to return error
pointers.  Returning a NULL will cause an Oops.

Fixes: 5e1a1da0f8c9 ("iio: adc: at91-sama5d2_adc: add hw trigger and buffer support")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/5d728f9d-31d1-410d-a0b3-df6a63a2c8ba@kili.mountain
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/at91-sama5d2_adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -1409,7 +1409,7 @@ static struct iio_trigger *at91_adc_allo
 	trig = devm_iio_trigger_alloc(&indio->dev, "%s-dev%d-%s", indio->name,
 				iio_device_id(indio), trigger_name);
 	if (!trig)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	trig->dev.parent = indio->dev.parent;
 	iio_trigger_set_drvdata(trig, indio);


