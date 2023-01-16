Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EA666C88E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbjAPQkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbjAPQjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:39:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E52B2CC7A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:28:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AF8A61086
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAE1C433EF;
        Mon, 16 Jan 2023 16:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886501;
        bh=OV8BHpx51mmQKsWSdkfKftu4o1hnqnq+cd+KOsfAHgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDAZoWQr4muXfzOf7+Ck0veeg1rJOGzNgrme1lKGDVUdF9xg7hssDxrwWQgkzQgV/
         /5W0TZV88jZY43dGmRNpjqVftEzMTT1qEPbwIrRV0FnPkYQkVERMPLYtl7oqHmDfmd
         KA9hkXmpN+lTcnLBWkSkzmVbMKyL51XFSToCtVQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.4 447/658] iio: adc: ad_sigma_delta: do not use internal iio_dev lock
Date:   Mon, 16 Jan 2023 16:48:55 +0100
Message-Id: <20230116154929.949628351@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
@@ -283,10 +283,10 @@ int ad_sigma_delta_single_conversion(str
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
@@ -325,7 +325,7 @@ out:
 	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_IDLE);
 	sigma_delta->bus_locked = false;
 	spi_bus_unlock(sigma_delta->spi->master);
-	mutex_unlock(&indio_dev->mlock);
+	iio_device_release_direct_mode(indio_dev);
 
 	if (ret)
 		return ret;


