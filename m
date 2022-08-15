Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD68594045
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349212AbiHOVkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349097AbiHOViw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:38:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEC82ED55;
        Mon, 15 Aug 2022 12:28:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A12BD60FB1;
        Mon, 15 Aug 2022 19:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91219C433C1;
        Mon, 15 Aug 2022 19:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591701;
        bh=3SHcPNsSd7kyJBhhcXsA1nXQfXffY39m27eP4DbjyVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKHAReK2RYNrl8HA+DpG5pv5om7kH/9af/oF+gBsTfFIagQ4vUWUi4raMKaiYMV/+
         NLKJgdGzMqmh7bW5bXjm28UebQiAOdHtxNWZNUs3OTDVQ2Pkv8zvbmgEFF494W9mBU
         Vq5jlwXLPPma0ROyxwUhN3JkGhZJP7VLm3tJXIak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0657/1095] iio: gyro: adis16130: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:56 +0200
Message-Id: <20220815180456.575004793@linuxfoundation.org>
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

[ Upstream commit ff3211b2ba9afac80ceb795d148831dd879b30b7 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 8e67875141b2 ("staging:iio:gyro: adis16130 cleanup, move to abi and bug fixes.")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-74-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/gyro/adis16130.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/gyro/adis16130.c b/drivers/iio/gyro/adis16130.c
index b9c952e65b55..33cde9e6fca5 100644
--- a/drivers/iio/gyro/adis16130.c
+++ b/drivers/iio/gyro/adis16130.c
@@ -41,7 +41,7 @@
 struct adis16130_state {
 	struct spi_device		*us;
 	struct mutex			buf_lock;
-	u8				buf[4] ____cacheline_aligned;
+	u8				buf[4] __aligned(IIO_DMA_MINALIGN);
 };
 
 static int adis16130_spi_read(struct iio_dev *indio_dev, u8 reg_addr, u32 *val)
-- 
2.35.1



