Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D179E6353E8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbiKWJBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236886AbiKWJBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:01:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0A0FFAB2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:01:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9337BB81EEE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCBDC433D6;
        Wed, 23 Nov 2022 09:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194075;
        bh=+ZiLR+3ZeLEPV0rgQYHksJTRzxDgYIBOlFg/wJaz8fM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lx4jf50bInDNL5glkc45K8afucGi01T/GdMoTJ4kkzUWTmvogjdwFxCo9dywGmsfy
         xGjbmdKPNb7QWFJ6VzdYRG66h3x6XwKo9EoBSHg2cBDnyAUvGlBjfotdqGDctttXNi
         YfSHpUg9HBNv8gQZCILDGTApeYt8YEw0lUyhZz7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 65/88] iio: adc: at91_adc: fix possible memory leak in at91_adc_allocate_trigger()
Date:   Wed, 23 Nov 2022 09:51:02 +0100
Message-Id: <20221123084550.871938911@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

commit 65f20301607d07ee279b0804d11a05a62a6c1a1c upstream.

If iio_trigger_register() returns error, it should call iio_trigger_free()
to give up the reference that hold in iio_trigger_alloc(), so that it can
call iio_trig_release() to free memory when the refcount hit to 0.

Fixes: 0e589d5fb317 ("ARM: AT91: IIO: Add AT91 ADC driver.")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221024084511.815096-1-yangyingliang@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/at91_adc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -618,8 +618,10 @@ static struct iio_trigger *at91_adc_allo
 	trig->ops = &at91_adc_trigger_ops;
 
 	ret = iio_trigger_register(trig);
-	if (ret)
+	if (ret) {
+		iio_trigger_free(trig);
 		return NULL;
+	}
 
 	return trig;
 }


