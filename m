Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2C5595029
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiHPEhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiHPEg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:36:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53E39C527;
        Mon, 15 Aug 2022 13:26:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93446B8119A;
        Mon, 15 Aug 2022 20:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89EDC433C1;
        Mon, 15 Aug 2022 20:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595211;
        bh=5lzskJ0NY1Iz1wrIBAvJmV+7D2DRoPG61KDnsiVFxoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLuvq854JD6Ls6a/iPD1N5luwJa7uKKNde5Ho0PZVB9V4IknAUI4xpR0H8t5JwVNj
         HKggu1zbHnO2c9owUdQ1eBvxBh/hA3FwheKfBlo2NU+CLHAzWg4AzZPWWAf9D0LodV
         MLAzSutIPDJ08Sr8zdlD2T4kVVEk02NmO7ALvaNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0660/1157] iio: adc: ti-adc12138: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:16 +0200
Message-Id: <20220815180506.127120384@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 76890c3bce6003caf53b283c49a210280cb8ea33 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 50a6edb1b6e0 ("iio: adc: add ADC12130/ADC12132/ADC12138 ADC driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-32-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-adc12138.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti-adc12138.c b/drivers/iio/adc/ti-adc12138.c
index 59d75d09604f..c0a72d72f3a9 100644
--- a/drivers/iio/adc/ti-adc12138.c
+++ b/drivers/iio/adc/ti-adc12138.c
@@ -55,7 +55,7 @@ struct adc12138 {
 	 */
 	__be16 data[20] __aligned(8);
 
-	u8 tx_buf[2] ____cacheline_aligned;
+	u8 tx_buf[2] __aligned(IIO_DMA_MINALIGN);
 	u8 rx_buf[2];
 };
 
-- 
2.35.1



