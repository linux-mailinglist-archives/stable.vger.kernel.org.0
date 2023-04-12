Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F636DEF59
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjDLItn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjDLItl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:49:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D395086A0
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:49:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FDC963158
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE696C433EF;
        Wed, 12 Apr 2023 08:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289363;
        bh=8IB+ucdDt31Jyifm0bLFn77fP6TY3eYS8Tp5eLHf5DY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTRSKfZ7FLGVYDbLO4Fo3DoVItocU/+sl9RYEe8WFlBAnON1CyQcxPqss0Cr7Ez5m
         q3QCwYpZe7WcnFRuferSBrJV7eMgT7xplU7zGI6Tvmjxl973R17kjI54EO93szRpQ/
         ryelm53i6DyWoHv2zUS5Sgd1T0wIFtuaQAf8OZ3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ian Ray <ian.ray@ge.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.2 071/173] drivers: iio: adc: ltc2497: fix LSB shift
Date:   Wed, 12 Apr 2023 10:33:17 +0200
Message-Id: <20230412082840.927722073@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Ray <ian.ray@ge.com>

commit 6327a930ab7bfa1ab33bcdffd5f5f4b1e7131504 upstream.

Correct the "sub_lsb" shift for the ltc2497 and drop the sub_lsb element
which is now constant.

An earlier version of the code shifted by 14 but this was a consequence
of reading three bytes into a __be32 buffer and using be32_to_cpu(), so
eight extra bits needed to be skipped.  Now we use get_unaligned_be24()
and thus the additional skip is wrong.

Fixes: 2187cfeb3626 ("drivers: iio: adc: ltc2497: LTC2499 support")
Signed-off-by: Ian Ray <ian.ray@ge.com>
Link: https://lore.kernel.org/r/20230127125714.44608-1-ian.ray@ge.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ltc2497.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/ltc2497.c
+++ b/drivers/iio/adc/ltc2497.c
@@ -28,7 +28,6 @@ struct ltc2497_driverdata {
 	struct ltc2497core_driverdata common_ddata;
 	struct i2c_client *client;
 	u32 recv_size;
-	u32 sub_lsb;
 	/*
 	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
@@ -65,10 +64,10 @@ static int ltc2497_result_and_measure(st
 		 * equivalent to a sign extension.
 		 */
 		if (st->recv_size == 3) {
-			*val = (get_unaligned_be24(st->data.d8) >> st->sub_lsb)
+			*val = (get_unaligned_be24(st->data.d8) >> 6)
 				- BIT(ddata->chip_info->resolution + 1);
 		} else {
-			*val = (be32_to_cpu(st->data.d32) >> st->sub_lsb)
+			*val = (be32_to_cpu(st->data.d32) >> 6)
 				- BIT(ddata->chip_info->resolution + 1);
 		}
 
@@ -122,7 +121,6 @@ static int ltc2497_probe(struct i2c_clie
 	st->common_ddata.chip_info = chip_info;
 
 	resolution = chip_info->resolution;
-	st->sub_lsb = 31 - (resolution + 1);
 	st->recv_size = BITS_TO_BYTES(resolution) + 1;
 
 	return ltc2497core_probe(dev, indio_dev);


