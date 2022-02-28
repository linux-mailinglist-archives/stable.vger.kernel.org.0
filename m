Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240594C76AE
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbiB1SFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240905AbiB1SEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:04:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495EC35259;
        Mon, 28 Feb 2022 09:47:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D9FA60915;
        Mon, 28 Feb 2022 17:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9609C340E7;
        Mon, 28 Feb 2022 17:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070459;
        bh=0fw9T+tZAvMBuO779pLSBg40CJqtPfcQQrG7q6rLaZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NT5F/PPmnY8sRUyHBWdqxReOQmuRg0RFw6FHypkF9e3f0kXp8Rwu1BMMQkLEs2xHE
         IuKMhI8pH/Q4vtOHDCdRfRwM92OkpcLtnpX4Mo4Q0pCJ9dY9SS3Ho6wIjjvcRKvlJO
         Le2APQga4zupR0AorM1WFsoEcdeAnDHrRcQX0lGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cosmin Tanislav <cosmin.tanislav@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.16 117/164] iio: adc: ad7124: fix mask used for setting AIN_BUFP & AIN_BUFM bits
Date:   Mon, 28 Feb 2022 18:24:39 +0100
Message-Id: <20220228172410.953885784@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cosmin Tanislav <demonsingur@gmail.com>

commit 0e33d15f1dce9e3a80a970ea7f0b27837168aeca upstream.

According to page 90 of the datasheet [1], AIN_BUFP is bit 6 and
AIN_BUFM is bit 5 of the CONFIG_0 -> CONFIG_7 registers.

Fix the mask used for setting these bits.

[1]: https://www.analog.com/media/en/technical-documentation/data-sheets/ad7124-8.pdf

Fixes: 0eaecea6e487 ("iio: adc: ad7124: Add buffered input support")
Signed-off-by: Cosmin Tanislav <cosmin.tanislav@analog.com>
Link: https://lore.kernel.org/r/20220112200036.694490-1-cosmin.tanislav@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7124.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -76,7 +76,7 @@
 #define AD7124_CONFIG_REF_SEL(x)	FIELD_PREP(AD7124_CONFIG_REF_SEL_MSK, x)
 #define AD7124_CONFIG_PGA_MSK		GENMASK(2, 0)
 #define AD7124_CONFIG_PGA(x)		FIELD_PREP(AD7124_CONFIG_PGA_MSK, x)
-#define AD7124_CONFIG_IN_BUFF_MSK	GENMASK(7, 6)
+#define AD7124_CONFIG_IN_BUFF_MSK	GENMASK(6, 5)
 #define AD7124_CONFIG_IN_BUFF(x)	FIELD_PREP(AD7124_CONFIG_IN_BUFF_MSK, x)
 
 /* AD7124_FILTER_X */


