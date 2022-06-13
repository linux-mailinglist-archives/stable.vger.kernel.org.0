Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94B854979F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353875AbiFMMzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357676AbiFMMyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:54:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A04A663FE;
        Mon, 13 Jun 2022 04:13:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FADB60B6B;
        Mon, 13 Jun 2022 11:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D7FC385A5;
        Mon, 13 Jun 2022 11:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118793;
        bh=4vviVn1+C2VUpSO971tgRUItAVlhTOzZO6vrIeqv1ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l86CBaqZKtXo9mPSL8EmZg8oQYq4OUVaUKvmop510D/T340DOwy3VMKKKjvoQXM7Q
         Ag7xW2fsbhVYQw4dvpCK0vD+jc6aqEQ32R8rzDSqov45kY2AMGYKEbeEn+zwxIPI6m
         C6V+BxEYh+UkcFG5HNj0YDOSYZ+nEOy866yyIWgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cixi Geng <cixi.geng1@unisoc.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/247] iio: adc: sc27xx: fix read big scale voltage not right
Date:   Mon, 13 Jun 2022 12:08:52 +0200
Message-Id: <20220613094923.850639169@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cixi Geng <cixi.geng1@unisoc.com>

[ Upstream commit ad930a75613282400179361e220e58b87386b8c7 ]

Fix wrong configuration value of SC27XX_ADC_SCALE_MASK and
SC27XX_ADC_SCALE_SHIFT by spec documetation.

Fixes: 5df362a6cf49c (iio: adc: Add Spreadtrum SC27XX PMICs ADC support)
Signed-off-by: Cixi Geng <cixi.geng1@unisoc.com>
Reviewed-by: Baolin Wang <baolin.wang7@gmail.com>
Link: https://lore.kernel.org/r/20220419142458.884933-3-gengcixi@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/sc27xx_adc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/sc27xx_adc.c b/drivers/iio/adc/sc27xx_adc.c
index 00098caf6d9e..aee076c8e2b1 100644
--- a/drivers/iio/adc/sc27xx_adc.c
+++ b/drivers/iio/adc/sc27xx_adc.c
@@ -36,8 +36,8 @@
 
 /* Bits and mask definition for SC27XX_ADC_CH_CFG register */
 #define SC27XX_ADC_CHN_ID_MASK		GENMASK(4, 0)
-#define SC27XX_ADC_SCALE_MASK		GENMASK(10, 8)
-#define SC27XX_ADC_SCALE_SHIFT		8
+#define SC27XX_ADC_SCALE_MASK		GENMASK(10, 9)
+#define SC27XX_ADC_SCALE_SHIFT		9
 
 /* Bits definitions for SC27XX_ADC_INT_EN registers */
 #define SC27XX_ADC_IRQ_EN		BIT(0)
-- 
2.35.1



