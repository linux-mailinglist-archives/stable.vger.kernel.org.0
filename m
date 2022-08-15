Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7334959411D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348517AbiHOVgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348854AbiHOVf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:35:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8152F6D;
        Mon, 15 Aug 2022 12:25:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3C5860FDA;
        Mon, 15 Aug 2022 19:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB85C433C1;
        Mon, 15 Aug 2022 19:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591517;
        bh=2oBrmztX5ILvCe0bc7Fv7LeINu6uTnScN9hYYDlqA7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUczLce0h4M6Mmhptn9Qk+2WISlNLI5BIWk6nsgKhk9BsDeizTLo1lyMqosbYef1j
         LoTX3ojYXSNj0pYSRw7n39R4+fmaqow5XGwyLlSf2SIdUT0HsCscZbEpWRSlm6YuzE
         dWWOLkxmuAqAS9M4tE7W1lT5kwbDfTKvn5uemaP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0605/1095] iio: adc: ltc2496: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:04 +0200
Message-Id: <20220815180454.558946978@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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



