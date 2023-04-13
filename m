Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097916E04A3
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjDMCkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjDMCkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:40:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD259753;
        Wed, 12 Apr 2023 19:38:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51F5563AAE;
        Thu, 13 Apr 2023 02:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F24C433D2;
        Thu, 13 Apr 2023 02:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353472;
        bh=NZrnd8QS9D7YxLacsJYmOPmK2ytxRfYPCgRmL+pnBik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYXo3yH/SgL2PUJgqAAzI4K1KJkN7Drshf4no/OrVfHh5tKeyhf/wve+dHLM3Wdxy
         lzkU5p5LfojsbZXmoZ/hZCqvgnvf2MVdhPuf+hHBxTEBWGQ98/nZdiI5IX6sJbc5vr
         wNWaIe/X33b0ZusdQSRbfgmzXTtTIZhwKmUsE7F2N9l3wCjAmB9HKCbR8K9gX331Sq
         OMlkS9hAm7el6ibtTkHb80KmEoTmNULXV3Qmp5FLB5QvpOcK4mNHIeDEjb+5jFQvJ2
         UZr8jR1HEGwWkyOOK8qbq0LVIVJj6mPkkH5NIX5zwa7JD5qEq6t6gr0C6e42vsvVUM
         TqLIoN/tig9KQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Patrik=20Dahlstr=C3=B6m?= <risca@dalakolonin.se>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 2/4] iio: adc: palmas_gpadc: fix NULL dereference on rmmod
Date:   Wed, 12 Apr 2023 22:37:42 -0400
Message-Id: <20230413023746.74984-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023746.74984-1-sashal@kernel.org>
References: <20230413023746.74984-1-sashal@kernel.org>
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
index f4756671cddb6..6ed0d151ad21a 100644
--- a/drivers/iio/adc/palmas_gpadc.c
+++ b/drivers/iio/adc/palmas_gpadc.c
@@ -628,7 +628,7 @@ static int palmas_gpadc_probe(struct platform_device *pdev)
 
 static int palmas_gpadc_remove(struct platform_device *pdev)
 {
-	struct iio_dev *indio_dev = dev_to_iio_dev(&pdev->dev);
+	struct iio_dev *indio_dev = dev_get_drvdata(&pdev->dev);
 	struct palmas_gpadc *adc = iio_priv(indio_dev);
 
 	if (adc->wakeup1_enable || adc->wakeup2_enable)
-- 
2.39.2

