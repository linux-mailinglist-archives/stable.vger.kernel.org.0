Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2E7594ACE
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355979AbiHPAGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355626AbiHPABD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:01:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84774AD48;
        Mon, 15 Aug 2022 13:22:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A437B80EB1;
        Mon, 15 Aug 2022 20:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9FCC433D6;
        Mon, 15 Aug 2022 20:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594921;
        bh=DweMI5Mf3uuhoLOWQNcaUFo2iN49xJP4R8pDEYpunt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TsLE4vzbT9VxMYHBc3+2Nush8idbT2zY/AFdNLQDEv5YlQ3Bz6h7Ofc93SF6ClL/q
         7iJVlrbeF/EOw3+bfVZRuGGuFftbuzn/1rgIjxylo5W0QEvIGSnjrBChld1VMBwTA5
         HqcM2JUdvJqqL7hmse4yLefEbgPKpIYhEWryeT0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0601/1157] mtd: st_spi_fsm: Add a clk_disable_unprepare() in .probe()s error path
Date:   Mon, 15 Aug 2022 19:59:17 +0200
Message-Id: <20220815180503.706206239@linuxfoundation.org>
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

[ Upstream commit 28607b426c3d050714f250d0faeb99d2e9106e90 ]

For all but one error path clk_disable_unprepare() is already there. Add
it to the one location where it's missing.

Fixes: 481815a6193b ("mtd: st_spi_fsm: Handle clk_prepare_enable/clk_disable_unprepare.")
Fixes: 69d5af8d016c ("mtd: st_spi_fsm: Obtain and use EMI clock")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220607152458.232847-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index d3377b10fc0f..52a799cae402 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -2115,10 +2115,12 @@ static int stfsm_probe(struct platform_device *pdev)
 		(long long)fsm->mtd.size, (long long)(fsm->mtd.size >> 20),
 		fsm->mtd.erasesize, (fsm->mtd.erasesize >> 10));
 
-	return mtd_device_register(&fsm->mtd, NULL, 0);
-
+	ret = mtd_device_register(&fsm->mtd, NULL, 0);
+	if (ret) {
 err_clk_unprepare:
-	clk_disable_unprepare(fsm->clk);
+		clk_disable_unprepare(fsm->clk);
+	}
+
 	return ret;
 }
 
-- 
2.35.1



