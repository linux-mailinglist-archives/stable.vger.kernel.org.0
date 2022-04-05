Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCF64F3845
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376512AbiDELWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349444AbiDEJtw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9DFF26AE2;
        Tue,  5 Apr 2022 02:46:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88BF261368;
        Tue,  5 Apr 2022 09:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9535DC385A1;
        Tue,  5 Apr 2022 09:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151962;
        bh=LyU0UCjIMK28Y/+3dy2ewi5N3bhvr2nkJBhF+Msbu9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zW+kGawfPQpxI7jhp5XoM4Ut+8anmAbUWstN3lA42xNcrgJouIYGgoNyuFykwPEMp
         ybPlcc2UZ/Eygx6MP6epByvJqbNH8zJjA2MI91akGlOgzCe68MyBZB56tuunAn/ctv
         RZNExar+TX68WRNNTJ1eUFvd6XAwts0Agpbq0oF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 604/913] iio: adc: Add check for devm_request_threaded_irq
Date:   Tue,  5 Apr 2022 09:27:46 +0200
Message-Id: <20220405070357.945319330@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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



