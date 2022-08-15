Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A56594FC1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiHPEcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiHPEcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:32:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEF7EB3;
        Mon, 15 Aug 2022 13:22:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55C9660F60;
        Mon, 15 Aug 2022 20:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5642FC433D6;
        Mon, 15 Aug 2022 20:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594933;
        bh=VGslUow4e0bUUqVOwE8Ov4b9PU8fkbBMNLmIyFUG9RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExsZnuu/0303q0Idu2Cs94ZQt2w/E3wJNTdskRjS4BcLoWXf3NgZSePX60Dkyb0Bg
         ck3jv2Np+DeVp1Y4Z5AS3pAzldwSEltDCK4hToeIg+/fC2g/wFV0NoEedPDUHw7t7Z
         TjSFZpUkBi06iTTE1eoyLMQlnnTyoNsbaoFE5xpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0604/1157] mtd: st_spi_fsm: Disable clock only after device was unregistered
Date:   Mon, 15 Aug 2022 19:59:20 +0200
Message-Id: <20220815180503.834627235@linuxfoundation.org>
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

[ Upstream commit cd043c613e21bb6f039057043da759471706adf5 ]

Until mtd_device_unregister() returns the device is expected to be
operational. So only disable the clock after the mtd is unregistered.

Fixes: 1fefc8ecb834 ("mtd: st_spi_fsm: add missing clk_disable_unprepare() in stfsm_remove()")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220607152458.232847-4-u.kleine-koenig@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index a5a4b612480c..9f6d4dd8bade 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -2128,10 +2128,10 @@ static int stfsm_remove(struct platform_device *pdev)
 {
 	struct stfsm *fsm = platform_get_drvdata(pdev);
 
-	clk_disable_unprepare(fsm->clk);
-
 	WARN_ON(mtd_device_unregister(&fsm->mtd));
 
+	clk_disable_unprepare(fsm->clk);
+
 	return 0;
 }
 
-- 
2.35.1



