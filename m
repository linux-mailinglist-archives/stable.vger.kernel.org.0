Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B3A594AF3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344218AbiHPAIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbiHPAET (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:04:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6B1A0603;
        Mon, 15 Aug 2022 13:28:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC333B8119A;
        Mon, 15 Aug 2022 20:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D203C43140;
        Mon, 15 Aug 2022 20:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595308;
        bh=8JYCwawIHQS3LdXXjJNiUBr2d0Z9c75h0r0YDjxkPdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eIvnZtUIoOyms80OkQkUaVlAl/z8poiXb4mJ78jUqX3QqMbv27GyIomCVFrcBHvgo
         0U0sQnicqboaUPiaJqaIj2+YNi3tpvgf/zGnTggyZsxW61RwlpkwPjjhEDOom4Tkwb
         67+pzOzT+T+Vmc0mWrRODEgU4ORjA1Moe1RuZdC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0690/1157] iio: dac: ti-dac082s085: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:46 +0200
Message-Id: <20220815180507.231057145@linuxfoundation.org>
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

[ Upstream commit 03a0cc77f164e4e59b970d50c6e9a6caf06dae80 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 61011264c1af ("iio: dac: Add Texas Instruments 8/10/12-bit 2/4-channel DAC driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-62-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ti-dac082s085.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ti-dac082s085.c b/drivers/iio/dac/ti-dac082s085.c
index 106ce3546419..8e1590e3cc8b 100644
--- a/drivers/iio/dac/ti-dac082s085.c
+++ b/drivers/iio/dac/ti-dac082s085.c
@@ -55,7 +55,7 @@ struct ti_dac_chip {
 	bool powerdown;
 	u8 powerdown_mode;
 	u8 resolution;
-	u8 buf[2] ____cacheline_aligned;
+	u8 buf[2] __aligned(IIO_DMA_MINALIGN);
 };
 
 #define WRITE_NOT_UPDATE(chan)	(0x00 | (chan) << 6)
-- 
2.35.1



