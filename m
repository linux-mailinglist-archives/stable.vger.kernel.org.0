Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32B2549210
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377563AbiFMNdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377862AbiFMNaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:30:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F196E8C8;
        Mon, 13 Jun 2022 04:25:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DD1C9CE110D;
        Mon, 13 Jun 2022 11:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEA2C3411E;
        Mon, 13 Jun 2022 11:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119504;
        bh=u3g6ye2lF1PUMaUH3OK098oauGnVr/Y/SqRnFmjCthM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1+bBFlKjO0ob4Dn1ZmUccCVO/lZpPhj7yvTApMcIdMEjXYG0gvFBWzOOsLo4G11Z
         0qHPSxUZT6yADIuMtt5hobed5QIPG6r/6mbyOzMa68JxQD5DNRzG+qvPvwIKycxILm
         cS78wJd1lsUjpce5XrOhv1CLOsr0tqgqqIuEpqUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cixi Geng <cixi.geng1@unisoc.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 037/339] iio: adc: sc27xx: Fine tune the scale calibration values
Date:   Mon, 13 Jun 2022 12:07:42 +0200
Message-Id: <20220613094927.644650258@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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
index aee076c8e2b1..cfe003cc4f0b 100644
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



