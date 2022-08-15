Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9D5594A8A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348681AbiHPAEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353774AbiHOX6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:58:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C1410B4;
        Mon, 15 Aug 2022 13:22:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F1F861073;
        Mon, 15 Aug 2022 20:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33931C433C1;
        Mon, 15 Aug 2022 20:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594927;
        bh=CXsiMlpxl/lPeiBhHDsWcyx72OmLP0Buq3FF1+bOVWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3/hspFhrFmQ0BMlPcpjNeeqCpdxxlohtNpO1nl3N+ywrznB1aYqMAdJ+tQdCUMCq
         8SneZ7q8YjT9r+CCy8+Ggsmrvrrml8eijTvSoSjZlKeK59NFHjrTd2w+kC7gT4UL0t
         P21SYJC+VvFKuAFuub0N1epPuE/NBvG4KMNekWGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0602/1157] mtd: spear_smi: Drop if with an always false condition
Date:   Mon, 15 Aug 2022 19:59:18 +0200
Message-Id: <20220815180503.745446258@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 279d719be39d8edb37c9178c15e167a94c7bc0a0 ]

The remove callback is only called after probe completed successfully.
In this case platform_set_drvdata() was called with a non-NULL argument
and so dev is never NULL.

This is a preparation for making platform remove callbacks return void.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220603210758.148493-8-u.kleine-koenig@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/spear_smi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/mtd/devices/spear_smi.c b/drivers/mtd/devices/spear_smi.c
index f6febe6662db..f58742486d3d 100644
--- a/drivers/mtd/devices/spear_smi.c
+++ b/drivers/mtd/devices/spear_smi.c
@@ -1048,10 +1048,6 @@ static int spear_smi_remove(struct platform_device *pdev)
 	int i;
 
 	dev = platform_get_drvdata(pdev);
-	if (!dev) {
-		dev_err(&pdev->dev, "dev is null\n");
-		return -ENODEV;
-	}
 
 	/* clean up for all nor flash */
 	for (i = 0; i < dev->num_flashes; i++) {
-- 
2.35.1



