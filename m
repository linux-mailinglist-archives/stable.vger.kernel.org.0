Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF9763DFE7
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiK3Svm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbiK3Sva (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:51:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BB14666D
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:51:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8472161D56
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94034C433C1;
        Wed, 30 Nov 2022 18:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834288;
        bh=/YSZ8nbcA/DXPP9n/JqT/uG4NdyF9vNqvUJGcGQ4pEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdxiXcq9wIMPD1mWOKwR+j1Smg3ex/Z+og4SKFmvHE+PjY2Mp5vVDSe8nFIDhra23
         pBABtfWiucK2Zq8dPP2HtvdffcXTspOwBgq6StLc3DG37S63UCMOkmAStbXZ2PJVXb
         oypHEhoqvsZcqHqS/jaXDQ+ffy8Dqp7JjFWdsrHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Billy Tsai <billy_tsai@aspeedtech.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.0 171/289] iio: adc: aspeed: Remove the trim valid dts property.
Date:   Wed, 30 Nov 2022 19:22:36 +0100
Message-Id: <20221130180548.008181553@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Billy Tsai <billy_tsai@aspeedtech.com>

commit fdd0d6b2eb35c83d6b1226ad20b346a4b45ddfb8 upstream.

The dts property "aspeed,trim-data-valid" is currently used to determine
whether to read trimming data from the OTP register. If this is set on
a device without valid trimming data in the OTP the ADC will not function
correctly. This patch drops the use of this property and instead uses the
default (unprogrammed) OTP value of 0 to detect when a fallback value of
0x8 should be used rather then the value read from the OTP.

Fixes: d0a4c17b4073 ("iio: adc: aspeed: Get and set trimming data.")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Link: https://lore.kernel.org/r/20221114025057.10843-1-billy_tsai@aspeedtech.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/aspeed_adc.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -202,6 +202,8 @@ static int aspeed_adc_set_trim_data(stru
 				((scu_otp) &
 				 (data->model_data->trim_locate->field)) >>
 				__ffs(data->model_data->trim_locate->field);
+			if (!trimming_val)
+				trimming_val = 0x8;
 		}
 		dev_dbg(data->dev,
 			"trimming val = %d, offset = %08x, fields = %08x\n",
@@ -563,12 +565,9 @@ static int aspeed_adc_probe(struct platf
 	if (ret)
 		return ret;
 
-	if (of_find_property(data->dev->of_node, "aspeed,trim-data-valid",
-			     NULL)) {
-		ret = aspeed_adc_set_trim_data(indio_dev);
-		if (ret)
-			return ret;
-	}
+	ret = aspeed_adc_set_trim_data(indio_dev);
+	if (ret)
+		return ret;
 
 	if (of_find_property(data->dev->of_node, "aspeed,battery-sensing",
 			     NULL)) {


