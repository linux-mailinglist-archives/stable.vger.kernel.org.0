Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC65D549466
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354238AbiFMLcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354534AbiFML3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:29:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E4E205C6;
        Mon, 13 Jun 2022 03:45:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F22E61016;
        Mon, 13 Jun 2022 10:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E40EC34114;
        Mon, 13 Jun 2022 10:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117099;
        bh=R7Ai4jnL60FXxpcklSo4vI6jPD0lfh8NErbALngp7OA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJ6PVvAQ7aVMuXZ0ugZ47Tg/Vk1+mSBCJWTZprvVuRV60mePBaXVUoXC8DlIFWfVV
         0JaHHAU/q/SpS+u97Cah2u6GCP5izL7JfDiWC7/u4jPQu0WAPN4LDtPUiV0MEA4cSQ
         dh58lBswYQiQ94BXzl6X7seiGbojQb5AGemu0aqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cixi Geng <cixi.geng1@unisoc.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 298/411] iio: adc: sc27xx: Fine tune the scale calibration values
Date:   Mon, 13 Jun 2022 12:09:31 +0200
Message-Id: <20220613094937.694734487@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

[ Upstream commit 5a7a184b11c6910f47600ff5cbbee34168f701a8 ]

Small adjustment the scale calibration value for the sc2731,
use new name sc2731_[big|small]_scale_graph_calib, and remove
the origin [big|small]_scale_graph_calib struct for unused.

Fixes: 8ba0dbfd07a35 (iio: adc: sc27xx: Add ADC scale calibration)
Signed-off-by: Cixi Geng <cixi.geng1@unisoc.com>
Link: https://lore.kernel.org/r/20220419142458.884933-4-gengcixi@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/sc27xx_adc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/adc/sc27xx_adc.c b/drivers/iio/adc/sc27xx_adc.c
index dcc01cdcff3f..5b79c8b9ccde 100644
--- a/drivers/iio/adc/sc27xx_adc.c
+++ b/drivers/iio/adc/sc27xx_adc.c
@@ -103,14 +103,14 @@ static struct sc27xx_adc_linear_graph small_scale_graph = {
 	100, 341,
 };
 
-static const struct sc27xx_adc_linear_graph big_scale_graph_calib = {
-	4200, 856,
-	3600, 733,
+static const struct sc27xx_adc_linear_graph sc2731_big_scale_graph_calib = {
+	4200, 850,
+	3600, 728,
 };
 
-static const struct sc27xx_adc_linear_graph small_scale_graph_calib = {
-	1000, 833,
-	100, 80,
+static const struct sc27xx_adc_linear_graph sc2731_small_scale_graph_calib = {
+	1000, 838,
+	100, 84,
 };
 
 static int sc27xx_adc_get_calib_data(u32 calib_data, int calib_adc)
@@ -130,11 +130,11 @@ static int sc27xx_adc_scale_calibration(struct sc27xx_adc_data *data,
 	size_t len;
 
 	if (big_scale) {
-		calib_graph = &big_scale_graph_calib;
+		calib_graph = &sc2731_big_scale_graph_calib;
 		graph = &big_scale_graph;
 		cell_name = "big_scale_calib";
 	} else {
-		calib_graph = &small_scale_graph_calib;
+		calib_graph = &sc2731_small_scale_graph_calib;
 		graph = &small_scale_graph;
 		cell_name = "small_scale_calib";
 	}
-- 
2.35.1



