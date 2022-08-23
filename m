Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF07059D6CB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349641AbiHWJ1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350464AbiHWJZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:25:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1804E90830;
        Tue, 23 Aug 2022 01:36:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 829B6614F5;
        Tue, 23 Aug 2022 08:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A867C433C1;
        Tue, 23 Aug 2022 08:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243717;
        bh=YPFGWF+SZ3nfFejBqr/SAmSzFD052TPPo811pYAyxFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJCsBt15vXH0R7p/F2hgD6OLcsoL0Q1hCK3SYz1FpkccsAIHtgNU7LYH4PTsq45ZF
         QWYRtgvcRrafUetZIo/glmWm7Mk4/wtzt35v4jXgKksD8R3bmiKjpG3ERC+ExgCZzI
         4okWyzlaZf/L7RuJKxg2nu2xZaE1P0sv41lY7VLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 335/365] ASoC: nau8821: Dont unconditionally free interrupt
Date:   Tue, 23 Aug 2022 10:03:56 +0200
Message-Id: <20220823080132.229436719@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 2d86cef353b8f3d20b16f8c5615742fd6938c801 ]

The remove() operation unconditionally frees the interrupt for the device
but we may not actually have an interrupt so there might be nothing to
free. Since the interrupt is requested after all other resources we don't
need the explicit free anyway, unwinding is guaranteed to be safe, so just
delete the remove() function and let devm take care of things.

Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Tested-by: Zheyu Ma <zheyuma97@gmail.com>
Link: https://lore.kernel.org/r/20220718140405.57233-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8821.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index ce4e7f46bb06..e078d2ffb3f6 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1665,15 +1665,6 @@ static int nau8821_i2c_probe(struct i2c_client *i2c)
 	return ret;
 }
 
-static int nau8821_i2c_remove(struct i2c_client *i2c_client)
-{
-	struct nau8821 *nau8821 = i2c_get_clientdata(i2c_client);
-
-	devm_free_irq(nau8821->dev, nau8821->irq, nau8821);
-
-	return 0;
-}
-
 static const struct i2c_device_id nau8821_i2c_ids[] = {
 	{ "nau8821", 0 },
 	{ }
@@ -1703,7 +1694,6 @@ static struct i2c_driver nau8821_driver = {
 		.acpi_match_table = ACPI_PTR(nau8821_acpi_match),
 	},
 	.probe_new = nau8821_i2c_probe,
-	.remove = nau8821_i2c_remove,
 	.id_table = nau8821_i2c_ids,
 };
 module_i2c_driver(nau8821_driver);
-- 
2.35.1



