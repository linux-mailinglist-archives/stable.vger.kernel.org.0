Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7FC6540E96
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353418AbiFGSyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354132AbiFGSqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C550D1208AE;
        Tue,  7 Jun 2022 11:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99CF3618DE;
        Tue,  7 Jun 2022 18:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6340C385A5;
        Tue,  7 Jun 2022 18:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624811;
        bh=ezIWh8hccCcDbpXP8PsD5HOqPX41+iBX/icva8GXBPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHw4OmfBli4eUjSNe1g2MRUruafS5ntcbh6Jdc3tuYE8Pu/C6Rl36AcOaEN4NzKkF
         k+LvAOYWt5GtifIauiQq4COtxsnMCUti3iyBO6RAy2HiJD4tM9YHRuIjTS6UN+6F43
         kIqGbw9h3VJm71ufv6RjIgjiNWqlHquDJWL5O4fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 462/667] hwrng: omap3-rom - fix using wrong clk_disable() in omap_rom_rng_runtime_resume()
Date:   Tue,  7 Jun 2022 19:02:07 +0200
Message-Id: <20220607164948.565816520@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit e4e62bbc6aba49a5edb3156ec65f6698ff37d228 ]

'ddata->clk' is enabled by clk_prepare_enable(), it should be disabled
by clk_disable_unprepare().

Fixes: 8d9d4bdc495f ("hwrng: omap3-rom - Use runtime PM instead of custom functions")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/omap3-rom-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_random/omap3-rom-rng.c
index e0d77fa048fb..f06e4f95114f 100644
--- a/drivers/char/hw_random/omap3-rom-rng.c
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -92,7 +92,7 @@ static int __maybe_unused omap_rom_rng_runtime_resume(struct device *dev)
 
 	r = ddata->rom_rng_call(0, 0, RNG_GEN_PRNG_HW_INIT);
 	if (r != 0) {
-		clk_disable(ddata->clk);
+		clk_disable_unprepare(ddata->clk);
 		dev_err(dev, "HW init failed: %d\n", r);
 
 		return -EIO;
-- 
2.35.1



