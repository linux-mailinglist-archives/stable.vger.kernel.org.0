Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53B559500D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiHPEgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiHPEgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:36:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5DC168141;
        Mon, 15 Aug 2022 13:27:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2EB961135;
        Mon, 15 Aug 2022 20:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28DFC433D7;
        Mon, 15 Aug 2022 20:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595251;
        bh=f0Y2ZsGdh78QdS44CPibR4Lziv2kKW+UdddkPXcdlQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5pUX7a1MSfEEy85vd7dNJ8rho9Jwsk1QNhW41dhWVyM2pIm0OZSN1kyohsoJImA1
         299fpHsgHPq8ddWvahWepT/JadrtAVGG8pxFK5AvzT2i+eLdLZXxcA3qAf1+VaMcSj
         2U/kZ8BB9LAGENQmvsSz8TtxrX6Ndf1wlIuyu+Eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0688/1157] iio: dac: ltc2688: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:44 +0200
Message-Id: <20220815180507.149798602@linuxfoundation.org>
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

[ Upstream commit 2030708377a219b548a9a36da57d3852382baf1d ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Update the comment to include 'may'.

Fixes: 832cb9eeb931 ("iio: dac: add support for ltc2688")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-60-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ltc2688.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/dac/ltc2688.c b/drivers/iio/dac/ltc2688.c
index 937b0d25a11c..28bdde2d3088 100644
--- a/drivers/iio/dac/ltc2688.c
+++ b/drivers/iio/dac/ltc2688.c
@@ -91,10 +91,10 @@ struct ltc2688_state {
 	struct mutex lock;
 	int vref;
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 */
-	u8 tx_data[6] ____cacheline_aligned;
+	u8 tx_data[6] __aligned(IIO_DMA_MINALIGN);
 	u8 rx_data[3];
 };
 
-- 
2.35.1



