Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E271F594A96
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352411AbiHPAEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355290AbiHPAAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:00:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DC6491C4;
        Mon, 15 Aug 2022 13:21:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA8ED61058;
        Mon, 15 Aug 2022 20:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0C4C433D6;
        Mon, 15 Aug 2022 20:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594918;
        bh=mXRncFbX1rhnBroBNy3dqVvrGlP+7CSJazY55cdca20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lbBWeacqHW5XKxKzKa0Sj/b6Zh0FjfVZ+WmyXUgCUQIX0wpAFYs6SbTTMhaKiwH0j
         eXg5RUbNZF+fL3Prxu986TPDBnhrBp4eX5jl3aWXswpjPtnrjCFRHyv86WOEWAwhNU
         Rum++MaCZM7UULyLzYJVgoWCC4IXEeHm9yGIwZK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0600/1157] mtd: spear_smi: Dont skip cleanup after mtd_device_unregister() failed
Date:   Mon, 15 Aug 2022 19:59:16 +0200
Message-Id: <20220815180503.666525013@linuxfoundation.org>
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

[ Upstream commit 0057568b391488a5940635cbda562ea397bf4bdd ]

If mtd_device_unregister() fails (which it doesn't when used correctly),
the resources bound by the nand chip should be freed anyhow as returning
an error value doesn't prevent the device getting unbound.

Instead use WARN_ON on the return value similar to how other drivers do
it.

This is a preparation for making platform remove callbacks return void.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220603210758.148493-7-u.kleine-koenig@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/spear_smi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/devices/spear_smi.c b/drivers/mtd/devices/spear_smi.c
index 24073518587f..f6febe6662db 100644
--- a/drivers/mtd/devices/spear_smi.c
+++ b/drivers/mtd/devices/spear_smi.c
@@ -1045,7 +1045,7 @@ static int spear_smi_remove(struct platform_device *pdev)
 {
 	struct spear_smi *dev;
 	struct spear_snor_flash *flash;
-	int ret, i;
+	int i;
 
 	dev = platform_get_drvdata(pdev);
 	if (!dev) {
@@ -1060,9 +1060,7 @@ static int spear_smi_remove(struct platform_device *pdev)
 			continue;
 
 		/* clean up mtd stuff */
-		ret = mtd_device_unregister(&flash->mtd);
-		if (ret)
-			dev_err(&pdev->dev, "error removing mtd\n");
+		WARN_ON(mtd_device_unregister(&flash->mtd));
 	}
 
 	clk_disable_unprepare(dev->clk);
-- 
2.35.1



