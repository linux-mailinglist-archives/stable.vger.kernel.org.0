Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A66B59DF3A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354943AbiHWKaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354531AbiHWK2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:28:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99309A407F;
        Tue, 23 Aug 2022 02:06:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D82F4B81C53;
        Tue, 23 Aug 2022 09:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4EAC433C1;
        Tue, 23 Aug 2022 09:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245563;
        bh=mEH2bvmY8Id/t3eHeCjcTSSGLBfWCQpEEuV3o9xiOhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGW/Z5TPLdzeWX7veGvjXTrcd5+9undvcKWCnBKTFpdCY0FIyIflXODqfkd1z6Sn8
         8kr99AvntsuuaPH8yQpHlDeaNvPLZkm0YsHVQlInKJ8vD/PrLphBzMH9JJDyrybCnw
         d68iiKV4vg+wtI4KhTmhtIth92D3aG7FIvxIBg78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 118/287] mtd: st_spi_fsm: Add a clk_disable_unprepare() in .probe()s error path
Date:   Tue, 23 Aug 2022 10:24:47 +0200
Message-Id: <20220823080104.358527106@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
index 55d4a77f3b7f..533096c88ae1 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -2120,10 +2120,12 @@ static int stfsm_probe(struct platform_device *pdev)
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



