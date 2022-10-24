Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5784960A5D4
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbiJXMbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbiJXM3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:29:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9E7165A4;
        Mon, 24 Oct 2022 05:03:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BCAFB81211;
        Mon, 24 Oct 2022 12:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817AFC4314C;
        Mon, 24 Oct 2022 12:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612827;
        bh=cX7muafZA+6IXcnJmeJJuaf5i1SDb/EPnsgDONjK2lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tCZqH/jbW83hOoF+uBj5fCh/RjLd2N9/KAC8fEjA2D62Q5/3KP+ccGzIt7gq4bXY5
         dgZFCvHFCUfLNXmjAsoYV9mtIbJWQEopDM8n86W0GIosMd2M7sP5jrXAubaIxfrB5k
         UznCfAmumCDM1SCVhT6Aj7qFfgxDdlYFefC+bz4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 117/229] iio: adc: at91-sama5d2_adc: fix AT91_SAMA5D2_MR_TRACKTIM_MAX
Date:   Mon, 24 Oct 2022 13:30:36 +0200
Message-Id: <20221024113002.783265313@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit bb73d5d9164c57c4bb916739a98e5cd8e0a5ed8c ]

All ADC HW versions handled by this driver (SAMA5D2, SAM9X60, SAMA7G5)
have MR.TRACKTIM on 4 bits. Fix AT91_SAMA5D2_MR_TRACKTIM_MAX to reflect
this.

Fixes: 27e177190891 ("iio:adc:at91_adc8xx: introduce new atmel adc driver")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220803102855.2191070-2-claudiu.beznea@microchip.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/at91-sama5d2_adc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index 129c3adad4c0..141badb8707e 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -81,7 +81,7 @@
 #define	AT91_SAMA5D2_MR_ANACH		BIT(23)
 /* Tracking Time */
 #define	AT91_SAMA5D2_MR_TRACKTIM(v)	((v) << 24)
-#define	AT91_SAMA5D2_MR_TRACKTIM_MAX	0xff
+#define	AT91_SAMA5D2_MR_TRACKTIM_MAX	0xf
 /* Transfer Time */
 #define	AT91_SAMA5D2_MR_TRANSFER(v)	((v) << 28)
 #define	AT91_SAMA5D2_MR_TRANSFER_MAX	0x3
-- 
2.35.1



