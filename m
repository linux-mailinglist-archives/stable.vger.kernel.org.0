Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2CB594FE1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiHPEeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiHPEdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:33:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FA04BD19;
        Mon, 15 Aug 2022 13:24:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3ABBB8119A;
        Mon, 15 Aug 2022 20:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0492AC433C1;
        Mon, 15 Aug 2022 20:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595080;
        bh=LqalBsGRa1zu1E5rLHt1XDvDX+e1QcLKHZ/M7/gLjvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IYspbKCjF1QbY17Xnt7J2p8R3LBIkkZbVZEiGoRd6Kv5jnxvMd4LjPhSTXa4dTPqa
         GbTgQPsdJ2L6VfUJ56NZ0iZWqVJclt84ltuYTDH/6GyhI8Dl3pJL2XoJjSvnu/u6i2
         tPw1WsoX2QMW8Z0QpRmIZYmUYxJN88XKmY9wNokc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0649/1157] iio: adc: hi8435: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:05 +0200
Message-Id: <20220815180505.698634919@linuxfoundation.org>
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

[ Upstream commit 48e4ae96b0b10f93de23b86fd34e573c44e95ab3 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 72aa29ce0a59 ("iio: adc: hi8435: Holt HI-8435 threshold detector")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-21-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/hi8435.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/hi8435.c b/drivers/iio/adc/hi8435.c
index 8eb0140df133..771fa12bdc02 100644
--- a/drivers/iio/adc/hi8435.c
+++ b/drivers/iio/adc/hi8435.c
@@ -49,7 +49,7 @@ struct hi8435_priv {
 
 	unsigned threshold_lo[2]; /* GND-Open and Supply-Open thresholds */
 	unsigned threshold_hi[2]; /* GND-Open and Supply-Open thresholds */
-	u8 reg_buffer[3] ____cacheline_aligned;
+	u8 reg_buffer[3] __aligned(IIO_DMA_MINALIGN);
 };
 
 static int hi8435_readb(struct hi8435_priv *priv, u8 reg, u8 *val)
-- 
2.35.1



