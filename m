Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A4F594A88
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240822AbiHPAE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356647AbiHPACn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:02:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F62169C6B;
        Mon, 15 Aug 2022 13:24:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5048DB8119A;
        Mon, 15 Aug 2022 20:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E701C433D7;
        Mon, 15 Aug 2022 20:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595042;
        bh=lsmzj/AJNxpW82MJ0n7UhPVJrrdtR21WmrkW9gz57Pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1QaLmzDPas2Z4rNg2QvXsBVM8iIndZoVWKEQLB9eiUFmbL0ZLVmt2duyba0x6P0PE
         AiIOR03//2e+oSYwRHOKuKfIqarX5SUCmElmrP0HdxwTWPDFQLWpQ4sqhX/uEga1zC
         bNfJrffK9jHBN/unG/5Lu5etTCXOlw0uELsb1Ups=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0638/1157] iio: adc: ad7266: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 19:59:54 +0200
Message-Id: <20220815180505.228977864@linuxfoundation.org>
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

[ Upstream commit b990cdfe7536a8da7e134d516350402981300016 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Update the comment to reflect that DMA safety 'may' require separate
cachelines.

Fixes: 54e018da3141 ("iio:ad7266: Mark transfer buffer as __be16")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-10-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7266.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad7266.c b/drivers/iio/adc/ad7266.c
index f20d39f0bc01..468c2656d2be 100644
--- a/drivers/iio/adc/ad7266.c
+++ b/drivers/iio/adc/ad7266.c
@@ -37,7 +37,7 @@ struct ad7266_state {
 	struct gpio_desc	*gpios[3];
 
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 * The buffer needs to be large enough to hold two samples (4 bytes) and
 	 * the naturally aligned timestamp (8 bytes).
@@ -45,7 +45,7 @@ struct ad7266_state {
 	struct {
 		__be16 sample[2];
 		s64 timestamp;
-	} data ____cacheline_aligned;
+	} data __aligned(IIO_DMA_MINALIGN);
 };
 
 static int ad7266_wakeup(struct ad7266_state *st)
-- 
2.35.1



