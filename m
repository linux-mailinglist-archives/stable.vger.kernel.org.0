Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF245AEBFE
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbiIFOLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241566AbiIFOKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:10:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C36870BF;
        Tue,  6 Sep 2022 06:47:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2843FB818D0;
        Tue,  6 Sep 2022 13:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841D9C433D6;
        Tue,  6 Sep 2022 13:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471956;
        bh=B/g7M6eYXSuCJAoK0UhP9agxHOqqTFv8Ur6bBGZt7kI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PlYFI9MFfA0kbGBuy9ZKsaoOJfSsPANJA0r32nrwMhUfIN9TML4sF+pE/SlHnOsPK
         uR4j/zYhTMssEyYnCTtvs+FD/BHZsw3GbXyGDd+NXPjhvDFbivE5a2J6uqpM7NnjLC
         R3rRGEWuAwU5+K0hxigewv+lmSa3rTIR7INRe5xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 096/155] gpio: pca953x: Add mutex_lock for regcache sync in PM
Date:   Tue,  6 Sep 2022 15:30:44 +0200
Message-Id: <20220906132833.536944372@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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
index ecd7d169470b0..2925f4d8cef36 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1175,7 +1175,9 @@ static int pca953x_suspend(struct device *dev)
 {
 	struct pca953x_chip *chip = dev_get_drvdata(dev);
 
+	mutex_lock(&chip->i2c_lock);
 	regcache_cache_only(chip->regmap, true);
+	mutex_unlock(&chip->i2c_lock);
 
 	if (atomic_read(&chip->wakeup_path))
 		device_set_wakeup_path(dev);
@@ -1198,13 +1200,17 @@ static int pca953x_resume(struct device *dev)
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



