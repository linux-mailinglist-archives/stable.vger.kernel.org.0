Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB403594AA1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352697AbiHPAFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357057AbiHPADh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:03:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EED16E619;
        Mon, 15 Aug 2022 13:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8926B811A0;
        Mon, 15 Aug 2022 20:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B3EC433C1;
        Mon, 15 Aug 2022 20:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595137;
        bh=SKMP35W+5RYcCpTlONFWVCGGNxzI2fUXOAlmrPnng1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwQWB61r0CfGaeDS0PiZXGZSEBjgvss/9Qu3MgI0+1pLUfbLgjLLoVSVTD5jDY2eb
         YSa/aZGy36a65KPa7CbMz2oajvfIQFXZUMIV7iyOlCnZGKZFLV1wYTms6BO3d/bORd
         ghZopMB9dxS0lSeNKSryRnuuilLWIXjEzAQP3qJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Cosmin Tanislav <cosmin.tanislav@analog.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0669/1157] iio: addac: ad74413r: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:25 +0200
Message-Id: <20220815180506.465369771@linuxfoundation.org>
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

[ Upstream commit 00eb2b8a077062557772234019ecd6045b8b6298 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Update the comment to include 'may'.

Fixes: fea251b6a5db ("iio: addac: add AD74413R driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Cosmin Tanislav <cosmin.tanislav@analog.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-41-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/addac/ad74413r.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/addac/ad74413r.c b/drivers/iio/addac/ad74413r.c
index acd230a6af35..6a66d7a65db7 100644
--- a/drivers/iio/addac/ad74413r.c
+++ b/drivers/iio/addac/ad74413r.c
@@ -77,13 +77,13 @@ struct ad74413r_state {
 	struct spi_transfer	adc_samples_xfer[AD74413R_CHANNEL_MAX + 1];
 
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 */
 	struct {
 		u8 rx_buf[AD74413R_FRAME_SIZE * AD74413R_CHANNEL_MAX];
 		s64 timestamp;
-	} adc_samples_buf ____cacheline_aligned;
+	} adc_samples_buf __aligned(IIO_DMA_MINALIGN);
 
 	u8	adc_samples_tx_buf[AD74413R_FRAME_SIZE * AD74413R_CHANNEL_MAX];
 	u8	reg_tx_buf[AD74413R_FRAME_SIZE];
-- 
2.35.1



