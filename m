Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F56594AD7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356034AbiHPAGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356690AbiHPACt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:02:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9954DF35;
        Mon, 15 Aug 2022 13:24:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01E99B8119A;
        Mon, 15 Aug 2022 20:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47999C433D6;
        Mon, 15 Aug 2022 20:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595054;
        bh=sDltwdfM+bb1xgm1e4fTojwxAiLFI29C+V8cwlFn1WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ql4EuSVREq1otw21WCsfKiubJp6euvLbyXSSCd1PD6bFouwrZmqsQUj3epfiAmEE7
         F7TMsZzTzdsSMg7P1k17hhGB6ZswITrikGTm8vhJqL+kkneqlw1VdCz6zuhr05K6KP
         F+7NDhDBwY6ASvsxyOuYhcPzcYiGe7nZVcioV7Nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0642/1157] iio: adc: ad7476: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 19:59:58 +0200
Message-Id: <20220815180505.398710581@linuxfoundation.org>
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

[ Upstream commit 58b74555afc8affe4ae4f57d396349158433fc80 ]

 ____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Update the comment to reflect that DMA safety 'may' require separate
cachelines.

Fixes tag is unlikely to be the actual introdution of the problem but is
far enough back to cover any likely backporting.

Fixes: 7a28fe3c93d6 ("staging:iio:ad7476: Squash driver into a single file.")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-14-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7476.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ad7476.c b/drivers/iio/adc/ad7476.c
index a1e8b32671cf..94776f696290 100644
--- a/drivers/iio/adc/ad7476.c
+++ b/drivers/iio/adc/ad7476.c
@@ -44,13 +44,12 @@ struct ad7476_state {
 	struct spi_transfer		xfer;
 	struct spi_message		msg;
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 * Make the buffer large enough for one 16 bit sample and one 64 bit
 	 * aligned 64 bit timestamp.
 	 */
-	unsigned char data[ALIGN(2, sizeof(s64)) + sizeof(s64)]
-			____cacheline_aligned;
+	unsigned char data[ALIGN(2, sizeof(s64)) + sizeof(s64)] __aligned(IIO_DMA_MINALIGN);
 };
 
 enum ad7476_supported_device_ids {
-- 
2.35.1



