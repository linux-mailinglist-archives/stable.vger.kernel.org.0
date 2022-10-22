Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48AC6087A4
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbiJVIFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiJVIC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:02:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A292A389D;
        Sat, 22 Oct 2022 00:51:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00275B82E2E;
        Sat, 22 Oct 2022 07:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FB6C433C1;
        Sat, 22 Oct 2022 07:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425045;
        bh=fovrxAuJ3o96EOTwBjosV8bf3uk9mILlEB7h0L0riGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTq5uIOsyejF94AIvQtqM4JOT7D6eyYS4/0KEvSmNCijXijNLRdmSuNSWM0ZslHw9
         LNWkGfTXzBvoyXwrHexQWS6P5z6Aa17CU1Ui0zjvitsEqYINWrp4r/92f8nMoOVYuT
         e/zHjuSj+2qQTyyMUi5jW92O6Iq+RuswDnpYdssY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 372/717] iio: adc: at91-sama5d2_adc: check return status for pressure and touch
Date:   Sat, 22 Oct 2022 09:24:11 +0200
Message-Id: <20221022072513.311158038@linuxfoundation.org>
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

[ Upstream commit d84ace944a3b24529798dbae1340dea098473155 ]

Check return status of at91_adc_read_position() and
at91_adc_read_pressure() in at91_adc_read_info_raw().

Fixes: 6794e23fa3fe ("iio: adc: at91-sama5d2_adc: add support for oversampling resolution")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220803102855.2191070-3-claudiu.beznea@microchip.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/at91-sama5d2_adc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index 32b6f157b803..c3301c749164 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -1544,8 +1544,10 @@ static int at91_adc_read_info_raw(struct iio_dev *indio_dev,
 		*val = tmp_val;
 		mutex_unlock(&st->lock);
 		iio_device_release_direct_mode(indio_dev);
+		if (ret > 0)
+			ret = at91_adc_adjust_val_osr(st, val);
 
-		return at91_adc_adjust_val_osr(st, val);
+		return ret;
 	}
 	if (chan->type == IIO_PRESSURE) {
 		ret = iio_device_claim_direct_mode(indio_dev);
@@ -1558,8 +1560,10 @@ static int at91_adc_read_info_raw(struct iio_dev *indio_dev,
 		*val = tmp_val;
 		mutex_unlock(&st->lock);
 		iio_device_release_direct_mode(indio_dev);
+		if (ret > 0)
+			ret = at91_adc_adjust_val_osr(st, val);
 
-		return at91_adc_adjust_val_osr(st, val);
+		return ret;
 	}
 
 	/* in this case we have a voltage channel */
-- 
2.35.1



