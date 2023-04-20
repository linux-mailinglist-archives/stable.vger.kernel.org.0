Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF7F6E9207
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 13:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbjDTLHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 07:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbjDTLFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 07:05:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E9C8A43;
        Thu, 20 Apr 2023 04:04:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FC78647AD;
        Thu, 20 Apr 2023 11:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A891C433D2;
        Thu, 20 Apr 2023 11:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681988597;
        bh=qhfSTW77Ij2nesFY/gKw6hsMkvyp2+Wd2BeZDFndKUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYYL698L1i3bhg6FNtYBdWkuNF0Rkd2YaV7Is8CSYTjKqpc2I7eJP2Lt7ynMwdE/2
         epAS147IiznNK99ib6ZBD2aTuQ6D17DWv/rxfh/SCX2ZNCXnmSa6686+nLqMedXiuL
         o/E+68p+PpJ0iiuYcyBUiM9VJjDPLn11N+5dKhJZhJbIzZniFjjvQ4E0vjE5F+N7QE
         PRDqrGpES+YokA/8Tt5ut1x7EPuSpIMHQAtq+BCHA4Hu/VMkWtleZlrQi+mug5Ftbx
         QCHIPsuumRDsmcj+RgJttjc3iTYqpJdG9Q4XYYOtFVkhVslWM8yMppQn4cDE8li4hL
         9LUH8B016cUjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Patrik=20Dahlstr=C3=B6m?= <risca@dalakolonin.se>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 4/7] iio: adc: palmas_gpadc: fix NULL dereference on rmmod
Date:   Thu, 20 Apr 2023 07:03:04 -0400
Message-Id: <20230420110308.506181-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420110308.506181-1-sashal@kernel.org>
References: <20230420110308.506181-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrik Dahlström <risca@dalakolonin.se>

[ Upstream commit 49f76c499d38bf67803438eee88c8300d0f6ce09 ]

Calling dev_to_iio_dev() on a platform device pointer is undefined and
will make adc NULL.

Signed-off-by: Patrik Dahlström <risca@dalakolonin.se>
Link: https://lore.kernel.org/r/20230313205029.1881745-1-risca@dalakolonin.se
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/palmas_gpadc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/palmas_gpadc.c b/drivers/iio/adc/palmas_gpadc.c
index f9c8385c72d3d..496aab94570a1 100644
--- a/drivers/iio/adc/palmas_gpadc.c
+++ b/drivers/iio/adc/palmas_gpadc.c
@@ -638,7 +638,7 @@ static int palmas_gpadc_probe(struct platform_device *pdev)
 
 static int palmas_gpadc_remove(struct platform_device *pdev)
 {
-	struct iio_dev *indio_dev = dev_to_iio_dev(&pdev->dev);
+	struct iio_dev *indio_dev = dev_get_drvdata(&pdev->dev);
 	struct palmas_gpadc *adc = iio_priv(indio_dev);
 
 	if (adc->wakeup1_enable || adc->wakeup2_enable)
-- 
2.39.2

