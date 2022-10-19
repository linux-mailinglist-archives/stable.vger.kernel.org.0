Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43C7603DFC
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiJSJIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbiJSJHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:07:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2965D3B9A7;
        Wed, 19 Oct 2022 01:59:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 357EF6185F;
        Wed, 19 Oct 2022 08:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F49C433D6;
        Wed, 19 Oct 2022 08:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169914;
        bh=3ajESlv4+6Ko2mnHLGQYwrzZxL4zpE5YzF667e3vUp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZ+vBfLSKF+ZLS5nuFKZ/GZId0sNkDmRO0o7h0DXN7xuzl99PuisqsPGTtpkLbSMV
         Sb3XCSlwnLc11TSxqoFIoNwh4sbx37GnKZGrUr3z4ItaSvvU+AqUBbkCEhEVmWwNYw
         t+g1GXE5WInKmHdbLgMKo9fSJcIh0HsMs02/SsSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 457/862] iio: adc: at91-sama5d2_adc: fix AT91_SAMA5D2_MR_TRACKTIM_MAX
Date:   Wed, 19 Oct 2022 10:29:04 +0200
Message-Id: <20221019083310.175512156@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 279430c1d88c..ac9ef89fba17 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -77,7 +77,7 @@ struct at91_adc_reg_layout {
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



