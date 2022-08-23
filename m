Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7A559DF03
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242455AbiHWLYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349217AbiHWLVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:21:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F408313F35;
        Tue, 23 Aug 2022 02:23:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB1226098A;
        Tue, 23 Aug 2022 09:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8917C433D7;
        Tue, 23 Aug 2022 09:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246602;
        bh=yvVhweyN6JrAzA1zbQPZB2dG1BZ53GFIrONbDq3SudI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=teMbwuHo2Xp4YZQjXAUssUc1wFYfjn4uL2NwXKMnrC4XaKW8ByDEjM0NiWLkI0EDL
         Bwx8U3OSg/OKfSuSdsaxhXvhweIdbtDm3UkAFk6ll99ixtl8DOR+gWIXGF4WTZxN3Z
         Ec8WW/eZJ7UPoAI4z/OsvUEDTLDPeP5Ehm+lmgDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 160/389] mtd: st_spi_fsm: Add a clk_disable_unprepare() in .probe()s error path
Date:   Tue, 23 Aug 2022 10:23:58 +0200
Message-Id: <20220823080122.285256017@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
index f4d1667daaf9..41b5a236276b 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -2116,10 +2116,12 @@ static int stfsm_probe(struct platform_device *pdev)
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



