Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779FD5940A8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348165AbiHOVco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348691AbiHOVbu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:31:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B6EF14F4;
        Mon, 15 Aug 2022 12:24:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 377A0B81126;
        Mon, 15 Aug 2022 19:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E217C433C1;
        Mon, 15 Aug 2022 19:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591464;
        bh=s4e9UgebQLPV4QdXY6YUNgIrkfi/fdUQw7qqKd56Jo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mU9nlAK2T7NySVWOotPt8W+x0C7aOCvW29A2rltNXECviKmNOCHS+oYrP4EHySyFA
         aue8gGOe8RaCoyhJLNbzLfBTQWunIcm+hE1deOWBS7c9kNhOpvfR18678vVSfbIr7N
         Fpz/Gw/L20c5EruuyTUWgMhzd9aEdAZ+iPmFWDAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Cosmin Tanislav <demonsingur@gmail.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0589/1095] iio: accel: adxl367: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 19:59:48 +0200
Message-Id: <20220815180453.932463861@linuxfoundation.org>
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

[ Upstream commit e1f956a804df9074fb5de557563d153ae25252e7 ]

____cacheline_aligned is insufficient guarantee for non-coherent DMA.
Switch to the updated IIO_DMA_MINALIGN definition.

Update comment to reflect that DMA safety may require separate
cachelines.

Fixes: cbab791c5e2a5 ("iio: accel: add ADXL367 driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Cosmin Tanislav <demonsingur@gmail.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-5-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl367.c     | 2 +-
 drivers/iio/accel/adxl367_spi.c | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/accel/adxl367.c b/drivers/iio/accel/adxl367.c
index 62960134ea19..d680bec05efc 100644
--- a/drivers/iio/accel/adxl367.c
+++ b/drivers/iio/accel/adxl367.c
@@ -179,7 +179,7 @@ struct adxl367_state {
 	unsigned int	fifo_set_size;
 	unsigned int	fifo_watermark;
 
-	__be16		fifo_buf[ADXL367_FIFO_SIZE] ____cacheline_aligned;
+	__be16		fifo_buf[ADXL367_FIFO_SIZE] __aligned(IIO_DMA_MINALIGN);
 	__be16		sample_buf;
 	u8		act_threshold_buf[2];
 	u8		inact_time_buf[2];
diff --git a/drivers/iio/accel/adxl367_spi.c b/drivers/iio/accel/adxl367_spi.c
index 26dfc821ebbe..118c894015a5 100644
--- a/drivers/iio/accel/adxl367_spi.c
+++ b/drivers/iio/accel/adxl367_spi.c
@@ -9,6 +9,8 @@
 #include <linux/regmap.h>
 #include <linux/spi/spi.h>
 
+#include <linux/iio/iio.h>
+
 #include "adxl367.h"
 
 #define ADXL367_SPI_WRITE_COMMAND	0x0A
@@ -28,10 +30,10 @@ struct adxl367_spi_state {
 	struct spi_transfer	fifo_xfer[2];
 
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
-	 * transfer buffers to live in their own cache lines.
+	 * DMA (thus cache coherency maintenance) may require the
+	 * transfer buffers live in their own cache lines.
 	 */
-	u8			reg_write_tx_buf[1] ____cacheline_aligned;
+	u8			reg_write_tx_buf[1] __aligned(IIO_DMA_MINALIGN);
 	u8			reg_read_tx_buf[2];
 	u8			fifo_tx_buf[1];
 };
-- 
2.35.1



