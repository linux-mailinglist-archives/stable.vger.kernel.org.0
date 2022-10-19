Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF53603D9E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbiJSJFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiJSJE0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:04:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6251AC3B0;
        Wed, 19 Oct 2022 01:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43AE5617D1;
        Wed, 19 Oct 2022 08:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F65CC433D6;
        Wed, 19 Oct 2022 08:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169771;
        bh=4VSYuPSAObcReK/9L0QMwHxCF101x1ZYOeGQCscVZRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xA2M8yJfsxEoruSqLaTlbOoIKhz62Lqk3e6YAvnghseeGA4a/W93OBLJL3KwgIAjd
         6/aUUuIU5KiO7jEp3WaF28Hf9ryNl9nzEMaB+4nWABl6ePGBqOv1hI9wHubKcIEODW
         TGyqmv1YPrAGS1GFBe7c2qfy9FbHv010bJkMPdlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 402/862] ASoC: da7219: Fix an error handling path in da7219_register_dai_clks()
Date:   Wed, 19 Oct 2022 10:28:09 +0200
Message-Id: <20221019083307.703059785@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit abb4e4349afe7eecdb0499582f1c777031e3a7c8 ]

If clk_hw_register() fails, the corresponding clk should not be
unregistered.

To handle errors from loops, clean up partial iterations before doing the
goto.  So add a clk_hw_unregister().
Then use a while (--i >= 0) loop in the unwind section.

Fixes: 78013a1cf297 ("ASoC: da7219: Fix clock handling around codec level probe")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/e4acceab57a0d9e477a8d5890a45c5309e553e7c.1663875789.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/da7219.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/da7219.c b/sound/soc/codecs/da7219.c
index 50ecf30e6136..4746c8700451 100644
--- a/sound/soc/codecs/da7219.c
+++ b/sound/soc/codecs/da7219.c
@@ -2196,6 +2196,7 @@ static int da7219_register_dai_clks(struct snd_soc_component *component)
 			dai_clk_lookup = clkdev_hw_create(dai_clk_hw, init.name,
 							  "%s", dev_name(dev));
 			if (!dai_clk_lookup) {
+				clk_hw_unregister(dai_clk_hw);
 				ret = -ENOMEM;
 				goto err;
 			} else {
@@ -2217,12 +2218,12 @@ static int da7219_register_dai_clks(struct snd_soc_component *component)
 	return 0;
 
 err:
-	do {
+	while (--i >= 0) {
 		if (da7219->dai_clks_lookup[i])
 			clkdev_drop(da7219->dai_clks_lookup[i]);
 
 		clk_hw_unregister(&da7219->dai_clks_hw[i]);
-	} while (i-- > 0);
+	}
 
 	if (np)
 		kfree(da7219->clk_hw_data);
-- 
2.35.1



