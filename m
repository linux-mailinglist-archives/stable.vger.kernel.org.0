Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7257B594FE2
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiHPEeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiHPEdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:33:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C21F162C6D;
        Mon, 15 Aug 2022 13:24:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26D9E60EE9;
        Mon, 15 Aug 2022 20:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16133C433C1;
        Mon, 15 Aug 2022 20:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595083;
        bh=2oBrmztX5ILvCe0bc7Fv7LeINu6uTnScN9hYYDlqA7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVtzcFisL80nWC9WymGLppC6Q1z2e62UCgYuacNDYHq4RpmrCDujHc4Rr9XQTkLmJ
         mGas4l11M1/LKSKPrKG3yeTZdeipS9xkQKdxMoGiz2d+UB0iXPCOBWq+xq+wZ0RKQl
         FZZiPi1wMPz/2AkTNxQWfDPrRcSNz8BYj/HI4gaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0650/1157] iio: adc: ltc2496: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:06 +0200
Message-Id: <20220815180505.743485775@linuxfoundation.org>
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

[ Upstream commit 1673b7ca2dc1fb3b8d7c94a112496c02d34ae449 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Update the comment to include 'may'.

Fixes: e4c5c4dfaa88 ("iio: adc: new driver to support Linear technology's ltc2496")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-22-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ltc2496.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ltc2496.c b/drivers/iio/adc/ltc2496.c
index 5a55f79f2574..dfb3bb5997e5 100644
--- a/drivers/iio/adc/ltc2496.c
+++ b/drivers/iio/adc/ltc2496.c
@@ -24,10 +24,10 @@ struct ltc2496_driverdata {
 	struct spi_device *spi;
 
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 */
-	unsigned char rxbuf[3] ____cacheline_aligned;
+	unsigned char rxbuf[3] __aligned(IIO_DMA_MINALIGN);
 	unsigned char txbuf[3];
 };
 
-- 
2.35.1



