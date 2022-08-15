Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33C25940BC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244503AbiHOVgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348725AbiHOVfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:35:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3322FA6C79;
        Mon, 15 Aug 2022 12:25:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66D93B810C6;
        Mon, 15 Aug 2022 19:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5AFC433C1;
        Mon, 15 Aug 2022 19:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591499;
        bh=Y2GwHYK57VPhob4MMTy54v3pRXav3yAzyrwJQXChdOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfmO18ltOjGXlUwG6W/l+AdwcCTFaAKmZqehKbPk2gd0LbXk+eQmyYhUP4s1rHltF
         fm4qoO0c+tBILe60Vfb4xPafJkj68Pm/63bRxvK55/zO/37EzE3Fhz0hjZhx+qCOto
         RbSY3WvRwMLZP43eliA+4mPNFxGkjWFyk9B9Sv3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0599/1095] iio: adc: ad7766: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 19:59:58 +0200
Message-Id: <20220815180454.332627555@linuxfoundation.org>
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

[ Upstream commit 009ae227a1dace2d4d27c804e5bd65907e1d0557 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Update the comment to reflect the fact DMA safety 'may' require
separate cachelines.

Fixes: aa16c6bd0e09 ("iio:adc: Add support for AD7766/AD7767")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-16-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7766.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ad7766.c b/drivers/iio/adc/ad7766.c
index 51ee9482e0df..3079a0872947 100644
--- a/drivers/iio/adc/ad7766.c
+++ b/drivers/iio/adc/ad7766.c
@@ -45,13 +45,12 @@ struct ad7766 {
 	struct spi_message msg;
 
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 * Make the buffer large enough for one 24 bit sample and one 64 bit
 	 * aligned 64 bit timestamp.
 	 */
-	unsigned char data[ALIGN(3, sizeof(s64)) + sizeof(s64)]
-			____cacheline_aligned;
+	unsigned char data[ALIGN(3, sizeof(s64)) + sizeof(s64)]	__aligned(IIO_DMA_MINALIGN);
 };
 
 /*
-- 
2.35.1



