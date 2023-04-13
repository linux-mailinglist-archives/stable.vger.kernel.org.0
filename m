Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2FD6E04B2
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjDMClI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbjDMCkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:40:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F35076B6;
        Wed, 12 Apr 2023 19:38:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DD3563A8C;
        Thu, 13 Apr 2023 02:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A508C433EF;
        Thu, 13 Apr 2023 02:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353492;
        bh=J9KqHldngAsZFq9DGqTpcL3zgkhC+XFuMoW6LdTsWHk=;
        h=From:To:Cc:Subject:Date:From;
        b=kF4A/3hQ9SRmjzrsLkccHSue9iWUjC4Ks4cHawuD9kNmmu4Jj63BdmE5VJHca/VbX
         Gr/XmS+OlBnLqrZM0vmy1i/fsplzx4q41wKolzxIBr/7Hct1dq9PEf50XKmxCGHQ58
         tD8O8K8LtyKNaWTOM6Yw33Q+snl25seoWAcmOEln1ogkpi/A18oWxqrYwP0TJquaQf
         0oFUvNB9nqU+v4M1DEe1wgfKxy8WzPqjCvaFXz/BM1VhrSfYaflxIgwCpj6XZzLn0I
         HJRHROp9BALTOMpZ9m/DRVliVgRulg+1xLA5GUv1ZWul+e+Gxo44irLK+P5QYhgcew
         xjLd5OfeTJJWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Patrik=20Dahlstr=C3=B6m?= <risca@dalakolonin.se>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/2] iio: adc: palmas_gpadc: fix NULL dereference on rmmod
Date:   Wed, 12 Apr 2023 22:38:06 -0400
Message-Id: <20230413023809.75099-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 7dcd4213d38a0..6b76622b4fbfa 100644
--- a/drivers/iio/adc/palmas_gpadc.c
+++ b/drivers/iio/adc/palmas_gpadc.c
@@ -633,7 +633,7 @@ static int palmas_gpadc_probe(struct platform_device *pdev)
 
 static int palmas_gpadc_remove(struct platform_device *pdev)
 {
-	struct iio_dev *indio_dev = dev_to_iio_dev(&pdev->dev);
+	struct iio_dev *indio_dev = dev_get_drvdata(&pdev->dev);
 	struct palmas_gpadc *adc = iio_priv(indio_dev);
 
 	if (adc->wakeup1_enable || adc->wakeup2_enable)
-- 
2.39.2

