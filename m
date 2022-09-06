Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37DD5AE9D1
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240691AbiIFNgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240692AbiIFNf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:35:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563087AC22;
        Tue,  6 Sep 2022 06:33:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6F1D61549;
        Tue,  6 Sep 2022 13:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDC7C433D6;
        Tue,  6 Sep 2022 13:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471237;
        bh=2U7iI0nmhUphuAQOvU5vkJ0Ft2zgRmZO5Dr6eh1Hc7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9DbzcK5WMb60WBsHidxsIwhlEc+w4WfrcYoWuIoyztHrBOdvEI/1vGA1BBTAnPU0
         dRbYJsxeRdXLQuL6/MyA1WokSrhMpC5+zXTk+2lNfvCZruMQaQadHwr546tRv7X6LO
         77g+hGNHHhY0IDi9go1/hclC2Ofw4uTrdN6W7Fl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/80] gpio: pca953x: Add mutex_lock for regcache sync in PM
Date:   Tue,  6 Sep 2022 15:30:40 +0200
Message-Id: <20220906132818.811111055@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 518e26f11af2fe4f5bebf9a0351595d508c7077f ]

The regcache sync will set the cache_bypass = true, at that
time, when there is regmap write operation, it will bypass
the regmap cache, then the regcache sync will write back the
value from cache to register, which is not as our expectation.

Though regmap already use its internal lock to avoid such issue,
but this driver force disable the regmap internal lock in its
regmap config: disable_locking = true

To avoid this issue, use the driver's own lock to do the protect
in system PM.

Fixes: b76574300504 ("gpio: pca953x: Restore registers after suspend/resume cycle")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 957be5f69406a..3ad1a9e432c8a 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1162,7 +1162,9 @@ static int pca953x_suspend(struct device *dev)
 {
 	struct pca953x_chip *chip = dev_get_drvdata(dev);
 
+	mutex_lock(&chip->i2c_lock);
 	regcache_cache_only(chip->regmap, true);
+	mutex_unlock(&chip->i2c_lock);
 
 	if (atomic_read(&chip->wakeup_path))
 		device_set_wakeup_path(dev);
@@ -1185,13 +1187,17 @@ static int pca953x_resume(struct device *dev)
 		}
 	}
 
+	mutex_lock(&chip->i2c_lock);
 	regcache_cache_only(chip->regmap, false);
 	regcache_mark_dirty(chip->regmap);
 	ret = pca953x_regcache_sync(dev);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&chip->i2c_lock);
 		return ret;
+	}
 
 	ret = regcache_sync(chip->regmap);
+	mutex_unlock(&chip->i2c_lock);
 	if (ret) {
 		dev_err(dev, "Failed to restore register map: %d\n", ret);
 		return ret;
-- 
2.35.1



