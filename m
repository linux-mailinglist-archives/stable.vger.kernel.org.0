Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF43595041
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiHPEir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiHPEiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:38:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CC39F753;
        Mon, 15 Aug 2022 13:27:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 520C361133;
        Mon, 15 Aug 2022 20:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440A2C433C1;
        Mon, 15 Aug 2022 20:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595270;
        bh=9zNDmu/zOk4ltrP6s2+OhrMweR1ou95kUO+IEG4hVQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WH0sRHIBJIEUgj9beD5Kkqd2hyf3vFR40wTDtfysgMcc6jejhuQBtL6qlzlZu9/4V
         wa3vIGTlcd2/LXxCTSPdBG1qew+QMq56lmajN15DUsaYIjY25yW6/8AirIiXkdq8zb
         BEoaaGrkwnMVSwSHWn9iwevcV8mszZUjkaxhzW5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0711/1157] iio: potentiometer: max5481: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:01:07 +0200
Message-Id: <20220815180507.983758460@linuxfoundation.org>
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

[ Upstream commit ec1ac1c0e7a14657d729159ccfbea72f434bdaf1 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: df1fd2de118e ("iio: max5481: Add support for Maxim digital potentiometers")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-83-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/potentiometer/max5481.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/potentiometer/max5481.c b/drivers/iio/potentiometer/max5481.c
index 098d144a8fdd..b40e5ac218d7 100644
--- a/drivers/iio/potentiometer/max5481.c
+++ b/drivers/iio/potentiometer/max5481.c
@@ -44,7 +44,7 @@ static const struct max5481_cfg max5481_cfg[] = {
 struct max5481_data {
 	struct spi_device *spi;
 	const struct max5481_cfg *cfg;
-	u8 msg[3] ____cacheline_aligned;
+	u8 msg[3] __aligned(IIO_DMA_MINALIGN);
 };
 
 #define MAX5481_CHANNEL {					\
-- 
2.35.1



