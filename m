Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338D5594AC6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355854AbiHPAGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357140AbiHPADt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:03:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF759A9B2;
        Mon, 15 Aug 2022 13:25:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C17CB8119E;
        Mon, 15 Aug 2022 20:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C162DC433C1;
        Mon, 15 Aug 2022 20:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595143;
        bh=/abWgxfwLHAtA6csyAuy8ia+oSqJcSA0RuGdE9gcwn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UM4FEs9KYSIRSh1Z5qu60Ve58L2YGoYAy1EhZqGH2BmksQj2Gisl64TOjpeLgZzTu
         GJf4vsKyuQiLpgoxdOTur6SpN73UiBjZN9isWc3gE11ESy+O2dIz/+Hpl+IfUcZ9xu
         i/6mpbHEOhDb7EsiKah6jFRH56cHEedvNHWMW0zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0653/1157] iio: adc: max11100: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:09 +0200
Message-Id: <20220815180505.873123411@linuxfoundation.org>
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

[ Upstream commit 51f30d63145cc84cb8a8e0ec96f9a8b73e6b5448 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Update the comment to include 'may'.

Fixes: a8e7e88df9ec ("iio: adc: Add Maxim MAX11100 driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Jacopo Mondi <jacopo@jmondi.org>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-25-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max11100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/max11100.c b/drivers/iio/adc/max11100.c
index eb1ce6a0315c..49e38dca8fe2 100644
--- a/drivers/iio/adc/max11100.c
+++ b/drivers/iio/adc/max11100.c
@@ -33,10 +33,10 @@ struct max11100_state {
 	struct spi_device *spi;
 
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 */
-	u8 buffer[3] ____cacheline_aligned;
+	u8 buffer[3] __aligned(IIO_DMA_MINALIGN);
 };
 
 static const struct iio_chan_spec max11100_channels[] = {
-- 
2.35.1



