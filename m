Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB084594AB5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353442AbiHPAGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356654AbiHPACo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:02:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEC21617FC;
        Mon, 15 Aug 2022 13:24:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FEE560EE9;
        Mon, 15 Aug 2022 20:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911C5C433C1;
        Mon, 15 Aug 2022 20:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595058;
        bh=t39TPq0Qi6nLwofCxmJh29LPIR/lAo6j3QHCbsl6r3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ir50u9V+poOHSp/r1mFU2EPv8KMyOnacVHgEnaY3MPynuKqRa5d8CqaHrKkXsbLRj
         zEmtv9opWzfxyD2/5zcpKlOIYHLPvyQsByHaIpk3xVF+kM3H9rLfLAHRyKMPWmOnS1
         owNWLNUZuiOUnHEQNByhNhIu10cQnPyNDmu+wIMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0643/1157] iio: adc: ad7606: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 19:59:59 +0200
Message-Id: <20220815180505.445628878@linuxfoundation.org>
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

[ Upstream commit 6268c6eebb13f228d418f9adaca848b3ed5b3cf9 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_ALIGN definition.

Update the comment to reflect the fact DMA safety 'may' require
separate cachelines.

Fixes: 7989b4bb23fe ("iio: adc: ad7616: Add support for AD7616 ADC")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-15-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7606.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad7606.h b/drivers/iio/adc/ad7606.h
index 4f82d7c9acfd..2dc4f599f9df 100644
--- a/drivers/iio/adc/ad7606.h
+++ b/drivers/iio/adc/ad7606.h
@@ -116,11 +116,11 @@ struct ad7606_state {
 	struct completion		completion;
 
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 * 16 * 16-bit samples + 64-bit timestamp
 	 */
-	unsigned short			data[20] ____cacheline_aligned;
+	unsigned short			data[20] __aligned(IIO_DMA_MINALIGN);
 	__be16				d16[2];
 };
 
-- 
2.35.1



