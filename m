Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C049658474
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbiL1Q5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbiL1Q4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:56:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7965F1E3F6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:51:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3610EB8188B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E2FC433D2;
        Wed, 28 Dec 2022 16:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246315;
        bh=PWAOx/uPdeAVFzHXjcr55cEGzHjdl+ffaSB39FB4smY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5MmkFN0GuBSGl2hiOaZ9R2zZTB2SvQ9uIhliCqsnMqSoQpRw2k/KPhUKH+15/AWe
         dcg7p9PhSTqHGJTNRqNwj8Lx5aXmZAKmhZSAAUlyY9QJLvus6pYmvcnLymk67UruSg
         hGWMDiXMDcRkeoAB3jBokqRyR1C8gT9mFzU7MZJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stable@vger.kernel.org
Subject: [PATCH 6.0 1048/1073] iio: adc: ad_sigma_delta: do not use internal iio_dev lock
Date:   Wed, 28 Dec 2022 15:43:56 +0100
Message-Id: <20221228144356.676136355@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Nuno Sá <nuno.sa@analog.com>

commit 20228a1d5a55e7db0c6720840f2c7d2b48c55f69 upstream.

Drop 'mlock' usage by making use of iio_device_claim_direct_mode().
This change actually makes sure we cannot do a single conversion while
buffering is enable. Note there was a potential race in the previous
code since we were only acquiring the lock after checking if the bus is
enabled.

Fixes: af3008485ea0 ("iio:adc: Add common code for ADI Sigma Delta devices")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: <Stable@vger.kernel.org> #No rush as race is very old.
Link: https://lore.kernel.org/r/20220920112821.975359-2-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad_sigma_delta.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -281,10 +281,10 @@ int ad_sigma_delta_single_conversion(str
 	unsigned int data_reg;
 	int ret = 0;
 
-	if (iio_buffer_enabled(indio_dev))
-		return -EBUSY;
+	ret = iio_device_claim_direct_mode(indio_dev);
+	if (ret)
+		return ret;
 
-	mutex_lock(&indio_dev->mlock);
 	ad_sigma_delta_set_channel(sigma_delta, chan->address);
 
 	spi_bus_lock(sigma_delta->spi->master);
@@ -323,7 +323,7 @@ out:
 	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_IDLE);
 	sigma_delta->bus_locked = false;
 	spi_bus_unlock(sigma_delta->spi->master);
-	mutex_unlock(&indio_dev->mlock);
+	iio_device_release_direct_mode(indio_dev);
 
 	if (ret)
 		return ret;


