Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B29160A773
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbiJXMut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbiJXMt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:49:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4173D6334D;
        Mon, 24 Oct 2022 05:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED085612DA;
        Mon, 24 Oct 2022 12:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5BAC433C1;
        Mon, 24 Oct 2022 12:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613500;
        bh=+8Fenf4HrWzODfw9fMvEQLB9TNK5G1Ue1PYCowkizws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WU8piDmTGdTnhiSpJPjMdESdyfkSWwEKd90dLlSuiYxYXN4j8b+AZUkSjXIkFhs7E
         eB03uHLTQ/AY3kO00gtGRWey2jaUmXY0HCE1iHQxrBisJbqbO7AaSOiF9cSiYvLea2
         zinoLXQLBz5aQ2Uai2it5q+BG1zxtfHvr/xfaByI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/255] iio: adc: at91-sama5d2_adc: lock around oversampling and sample freq
Date:   Mon, 24 Oct 2022 13:30:30 +0200
Message-Id: <20221024113006.524130719@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 20ef858d65c7..734762084968 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -1321,10 +1321,10 @@ static int at91_adc_read_info_raw(struct iio_dev *indio_dev,
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
@@ -1337,10 +1337,10 @@ static int at91_adc_read_info_raw(struct iio_dev *indio_dev,
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
@@ -1433,16 +1433,20 @@ static int at91_adc_write_raw(struct iio_dev *indio_dev,
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



