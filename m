Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5B66E9202
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 13:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbjDTLIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 07:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234400AbjDTLHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 07:07:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFF3A5C1;
        Thu, 20 Apr 2023 04:04:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17547647C3;
        Thu, 20 Apr 2023 11:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7819C433EF;
        Thu, 20 Apr 2023 11:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681988629;
        bh=J9KqHldngAsZFq9DGqTpcL3zgkhC+XFuMoW6LdTsWHk=;
        h=From:To:Cc:Subject:Date:From;
        b=KfgtvhCtFK4WbgYWVYxjLpctK3BxssqyoCL8eA56KwPjEpZfcvhmHdu67X+L8wDIQ
         pQrw2tbR0VrS6nYZggxRvQqPBWESJ7kfiT+PK+8D7ZKQG2CGkbYkL0+s7/IHo1nQ3X
         o83F/XOAKGlfkifm/myIdVqrzmit9DbZkYMWRjfvPWvYB+m22CAs/L2bHhv3ouxI0x
         2uklFKF631cLmZNpE39Zhyv97ouBi4sRrQ33TZ0n8pYHeYx5u3kfxKJ19m7VzN9rYx
         QEcEeW1iGBpFGG7CG62YBYnmFScymzwHZefWzKr+WZa2e4GGUVOToxdlrHCeetGrzE
         7gKuAI00fwLSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Patrik=20Dahlstr=C3=B6m?= <risca@dalakolonin.se>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/2] iio: adc: palmas_gpadc: fix NULL dereference on rmmod
Date:   Thu, 20 Apr 2023 07:03:44 -0400
Message-Id: <20230420110347.506392-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
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

