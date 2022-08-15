Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CC8594FFD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiHPEfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbiHPEfQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:35:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F1AC59FE;
        Mon, 15 Aug 2022 13:26:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66248B811A0;
        Mon, 15 Aug 2022 20:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A685AC433C1;
        Mon, 15 Aug 2022 20:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595164;
        bh=K1mckkucQ53SKXsVQAHvieVbLZoUpM1bXDgk3yp9K1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5ozHlVznlfzCP9uCAEBLGzbVcDWR/ub2QcPMSffLJ5bnpXnOWJK3vkEh/y0KRxZJ
         94bFa08N/LQrv2HH0PTjHyxeSRdXXqoVIMt02/V6Bv7o6WLUhE1YXLLvyQdJ818qf1
         c92kVF6UUJ6XV/l73Wvl7WXIEMglEFN74JgHbu2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Paul Cercueil <paul@crapouillou.net>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0677/1157] iio: dac: ad5592r: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:33 +0200
Message-Id: <20220815180506.757471654@linuxfoundation.org>
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

[ Upstream commit 4a4a79c06caeec47003bcbee1cf3094479f26e24 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 56ca9db862bf ("iio: dac: Add support for the AD5592R/AD5593R ADCs/DACs")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Paul Cercueil <paul@crapouillou.net>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-49-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5592r-base.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad5592r-base.h b/drivers/iio/dac/ad5592r-base.h
index 2a22ef691996..cc7be426cbc8 100644
--- a/drivers/iio/dac/ad5592r-base.h
+++ b/drivers/iio/dac/ad5592r-base.h
@@ -14,6 +14,8 @@
 #include <linux/mutex.h>
 #include <linux/gpio/driver.h>
 
+#include <linux/iio/iio.h>
+
 struct device;
 struct ad5592r_state;
 
@@ -65,7 +67,7 @@ struct ad5592r_state {
 	u8 gpio_in;
 	u8 gpio_val;
 
-	__be16 spi_msg ____cacheline_aligned;
+	__be16 spi_msg __aligned(IIO_DMA_MINALIGN);
 	__be16 spi_msg_nop;
 };
 
-- 
2.35.1



