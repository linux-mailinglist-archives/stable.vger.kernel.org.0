Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7EA45B745E
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbiIMPXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbiIMPWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:22:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C897C313;
        Tue, 13 Sep 2022 07:37:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 504F2614DC;
        Tue, 13 Sep 2022 14:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D124C433D6;
        Tue, 13 Sep 2022 14:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079193;
        bh=Kyy9xZYix6uz9tqHGg9WpSyoGzNzR+34Qwb26q1+AOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRdA8IJ6WhKqdlP7wEvvlPygnu8cx9o3YskdZI2c8ARGtTjQFuJOWjYKKtnuJEFc5
         NB0BRQqvTXVgnBJoytIPAak8Zj9Efy72fyGNsNQleKb7mOXJt+/vA802QkVGlQ7UZA
         1cKtW+C+XPafASE2djUs5YiCx9g924N/JVyG6Ea0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/108] gpio: pca953x: Add mutex_lock for regcache sync in PM
Date:   Tue, 13 Sep 2022 16:06:11 +0200
Message-Id: <20220913140355.364949902@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
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
index 317f54f19477e..c81d73d5e0159 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1198,7 +1198,9 @@ static int pca953x_suspend(struct device *dev)
 {
 	struct pca953x_chip *chip = dev_get_drvdata(dev);
 
+	mutex_lock(&chip->i2c_lock);
 	regcache_cache_only(chip->regmap, true);
+	mutex_unlock(&chip->i2c_lock);
 
 	if (atomic_read(&chip->wakeup_path))
 		device_set_wakeup_path(dev);
@@ -1221,13 +1223,17 @@ static int pca953x_resume(struct device *dev)
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



