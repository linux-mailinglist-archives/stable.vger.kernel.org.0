Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2470608893
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiJVITx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233420AbiJVIRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:17:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7938F2DCB20;
        Sat, 22 Oct 2022 00:57:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEEBEB82E20;
        Sat, 22 Oct 2022 07:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D62EC4314A;
        Sat, 22 Oct 2022 07:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425048;
        bh=vztPcq+ueD48m1OWcvEhlTUc1YYDivfSgveLuANnp5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYGGOcM8clajXlOnYN2ZOq8S02oG8NmvOYa4i9kpwAOK74b7pSOJnUyXRr7BqGFWT
         OtXmBbktJOHzCjVZmqtFiT68xknUbpLKkk7Tr8wCYirIBKjxnN3u5zgUjyRxjBtC7u
         e1CAvVqGSAPnN2TopA/ZWlN2JqVA6ozQnmJutNYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 373/717] iio: adc: at91-sama5d2_adc: lock around oversampling and sample freq
Date:   Sat, 22 Oct 2022 09:24:12 +0200
Message-Id: <20221022072513.514936648@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 9780a23ed5a0a0a63683e078f576719a98d4fb70 ]

.read_raw()/.write_raw() could be called asynchronously from user space
or other in kernel drivers. Without locking on st->lock these could be
called asynchronously while there is a conversion in progress. Read will
be harmless but changing registers while conversion is in progress may
lead to inconsistent results. Thus, to avoid this lock st->lock.

Fixes: 27e177190891 ("iio:adc:at91_adc8xx: introduce new atmel adc driver")
Fixes: 6794e23fa3fe ("iio: adc: at91-sama5d2_adc: add support for oversampling resolution")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220803102855.2191070-4-claudiu.beznea@microchip.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/at91-sama5d2_adc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index c3301c749164..40a95d2fd5c8 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -1542,10 +1542,10 @@ static int at91_adc_read_info_raw(struct iio_dev *indio_dev,
 		ret = at91_adc_read_position(st, chan->channel,
 					     &tmp_val);
 		*val = tmp_val;
-		mutex_unlock(&st->lock);
-		iio_device_release_direct_mode(indio_dev);
 		if (ret > 0)
 			ret = at91_adc_adjust_val_osr(st, val);
+		mutex_unlock(&st->lock);
+		iio_device_release_direct_mode(indio_dev);
 
 		return ret;
 	}
@@ -1558,10 +1558,10 @@ static int at91_adc_read_info_raw(struct iio_dev *indio_dev,
 		ret = at91_adc_read_pressure(st, chan->channel,
 					     &tmp_val);
 		*val = tmp_val;
-		mutex_unlock(&st->lock);
-		iio_device_release_direct_mode(indio_dev);
 		if (ret > 0)
 			ret = at91_adc_adjust_val_osr(st, val);
+		mutex_unlock(&st->lock);
+		iio_device_release_direct_mode(indio_dev);
 
 		return ret;
 	}
@@ -1650,16 +1650,20 @@ static int at91_adc_write_raw(struct iio_dev *indio_dev,
 		/* if no change, optimize out */
 		if (val == st->oversampling_ratio)
 			return 0;
+		mutex_lock(&st->lock);
 		st->oversampling_ratio = val;
 		/* update ratio */
 		at91_adc_config_emr(st);
+		mutex_unlock(&st->lock);
 		return 0;
 	case IIO_CHAN_INFO_SAMP_FREQ:
 		if (val < st->soc_info.min_sample_rate ||
 		    val > st->soc_info.max_sample_rate)
 			return -EINVAL;
 
+		mutex_lock(&st->lock);
 		at91_adc_setup_samp_freq(indio_dev, val);
+		mutex_unlock(&st->lock);
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.35.1



