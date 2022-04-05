Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906AF4F4445
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237748AbiDEMSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242359AbiDEKcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:32:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491D9DE92E;
        Tue,  5 Apr 2022 03:18:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7BBDB81C98;
        Tue,  5 Apr 2022 10:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40616C385A0;
        Tue,  5 Apr 2022 10:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153926;
        bh=LyU0UCjIMK28Y/+3dy2ewi5N3bhvr2nkJBhF+Msbu9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zHFsjodAqc5T/rW7IHW7DlzEd/KWkwNHWxSvveE/sEqRKffP9WTavSHLi4pMxPetE
         x/F0xhC1yeN6AZo+H9FpPCh7UKicuHrXxMCypqbfO/0k5diDyVsD15BRAMjI/4+7JU
         u9CJiDo+cZW/guCD2LSfITTBKhq3lbATOUUrfon8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 396/599] iio: adc: Add check for devm_request_threaded_irq
Date:   Tue,  5 Apr 2022 09:31:30 +0200
Message-Id: <20220405070310.615265669@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit b30537a4cedcacf0ade2f33ebb7610178ed1e7d7 ]

As the potential failure of the devm_request_threaded_irq(),
it should be better to check the return value and return
error if fails.

Fixes: fa659a40b80b ("iio: adc: twl6030-gpadc: Use devm_* API family")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220224062849.3280966-1-jiasheng@iscas.ac.cn
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/twl6030-gpadc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/adc/twl6030-gpadc.c b/drivers/iio/adc/twl6030-gpadc.c
index c6416ad795ca..256177b15c51 100644
--- a/drivers/iio/adc/twl6030-gpadc.c
+++ b/drivers/iio/adc/twl6030-gpadc.c
@@ -911,6 +911,8 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
 	ret = devm_request_threaded_irq(dev, irq, NULL,
 				twl6030_gpadc_irq_handler,
 				IRQF_ONESHOT, "twl6030_gpadc", indio_dev);
+	if (ret)
+		return ret;
 
 	ret = twl6030_gpadc_enable_irq(TWL6030_GPADC_RT_SW1_EOC_MASK);
 	if (ret < 0) {
-- 
2.34.1



