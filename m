Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1882A6159A2
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiKBDQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiKBDP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:15:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E23D20F6D
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:14:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F739616DB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFE3C433C1;
        Wed,  2 Nov 2022 03:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358891;
        bh=i+FsnbGFTN6tTpcL0ZMvMGaWZtMRklgZmpYaVlO14vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZbNVAlpZovKGJUaLTktqqOUYio81u4f/c0Un5nLtFUgrg+PGMR1Gli6vratvou5n/
         phtCh22E+dM2srYyH1dpk6nPkefvF6oJG4iZ+CB8qfPQHEi5C0fKZ4MbEOUgG3RLKi
         JblWau/PIW5qAXBXxtTZAGoER3HqycOzdt3PTCac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cosmin Tanislav <cosmin.tanislav@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 16/91] iio: temperature: ltc2983: allocate iio channels once
Date:   Wed,  2 Nov 2022 03:32:59 +0100
Message-Id: <20221102022055.508422883@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cosmin Tanislav <cosmin.tanislav@analog.com>

commit 4132f19173211856d35180958d2754f5c56d520a upstream.

Currently, every time the device wakes up from sleep, the
iio_chan array is reallocated, leaking the previous one
until the device is removed (basically never).

Move the allocation to the probe function to avoid this.

Signed-off-by: Cosmin Tanislav <cosmin.tanislav@analog.com>
Fixes: f110f3188e563 ("iio: temperature: Add support for LTC2983")
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221014123724.1401011-2-demonsingur@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/ltc2983.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -1376,13 +1376,6 @@ static int ltc2983_setup(struct ltc2983_
 		return ret;
 	}
 
-	st->iio_chan = devm_kzalloc(&st->spi->dev,
-				    st->iio_channels * sizeof(*st->iio_chan),
-				    GFP_KERNEL);
-
-	if (!st->iio_chan)
-		return -ENOMEM;
-
 	ret = regmap_update_bits(st->regmap, LTC2983_GLOBAL_CONFIG_REG,
 				 LTC2983_NOTCH_FREQ_MASK,
 				 LTC2983_NOTCH_FREQ(st->filter_notch_freq));
@@ -1494,6 +1487,12 @@ static int ltc2983_probe(struct spi_devi
 	if (ret)
 		return ret;
 
+	st->iio_chan = devm_kzalloc(&spi->dev,
+				    st->iio_channels * sizeof(*st->iio_chan),
+				    GFP_KERNEL);
+	if (!st->iio_chan)
+		return -ENOMEM;
+
 	ret = ltc2983_setup(st, true);
 	if (ret)
 		return ret;


