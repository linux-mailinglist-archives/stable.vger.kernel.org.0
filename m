Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B6F603BDF
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiJSIkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiJSIju (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:39:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD78814C0;
        Wed, 19 Oct 2022 01:39:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88913617D1;
        Wed, 19 Oct 2022 08:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D194C433D6;
        Wed, 19 Oct 2022 08:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168704;
        bh=ua2YKCret8Q3QdpyymxKIeW3ykV2g5RTC7x+GcOzxVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXgbJ2Q+GPQIHGGeDXoFXdfDPF8o9Eta5Inl6wFNqDZP8r3Wrq3vkYmXmegQcEgsz
         FNilUXbvBTh4qP991iqwT4x8ERwZrybFH6hPLlPOXaYhLa5Vca+sLTS3FAuGbSwPDX
         k+2xlTx7Ml1O4ioEjY+4hs7R6xy8u8o/rqjJ1vk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.0 026/862] iio: adc: ad7923: fix channel readings for some variants
Date:   Wed, 19 Oct 2022 10:21:53 +0200
Message-Id: <20221019083251.144378655@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

commit f4f43f01cff2f29779343ade755191afd2581c77 upstream.

Some of the supported devices have 4 or 2 LSB trailing bits that should
not be taken into account. Hence we need to shift these bits out which
fits perfectly on the scan type shift property. This change fixes both
raw and buffered reads.

Fixes: f2f7a449707e ("iio:adc:ad7923: Add support for the ad7904/ad7914/ad7924")
Fixes: 851644a60d20 ("iio: adc: ad7923: Add support for the ad7908/ad7918/ad7928")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220912081223.173584-2-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7923.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7923.c
+++ b/drivers/iio/adc/ad7923.c
@@ -93,6 +93,7 @@ enum ad7923_id {
 			.sign = 'u',					\
 			.realbits = (bits),				\
 			.storagebits = 16,				\
+			.shift = 12 - (bits),				\
 			.endianness = IIO_BE,				\
 		},							\
 	}
@@ -268,7 +269,8 @@ static int ad7923_read_raw(struct iio_de
 			return ret;
 
 		if (chan->address == EXTRACT(ret, 12, 4))
-			*val = EXTRACT(ret, 0, 12);
+			*val = EXTRACT(ret, chan->scan_type.shift,
+				       chan->scan_type.realbits);
 		else
 			return -EIO;
 


