Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D285B7419
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235549AbiIMPOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbiIMPNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:13:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08D178206;
        Tue, 13 Sep 2022 07:33:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12659B80F91;
        Tue, 13 Sep 2022 14:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F36AC433D7;
        Tue, 13 Sep 2022 14:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079188;
        bh=xytAVHZwHwPwmdJ/VUSQPzs4/Dax3kXJsgF0jSy/bVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFOKCzKAL1W/6Hjkx0Kb9jIuSrPULCucF53UTuKTgv61uXosD87uYTyi/J8AM9Bws
         VDqy3pniD2XP1N9zyAf2ADoLxGko1o99ZSW1Ifa8bLetHqEGVzCXssXpkHhZCrWgX3
         WTvSChCHbLx/O+ye0qky3QrQ2NZuaMxHfYF2Tcco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/108] clk: bcm: rpi: Fix error handling of raspberrypi_fw_get_rate
Date:   Tue, 13 Sep 2022 16:06:09 +0200
Message-Id: <20220913140355.283173080@linuxfoundation.org>
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

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 35f73cca1cecda0c1f8bb7d8be4ce5cd2d46ae8c ]

The function raspberrypi_fw_get_rate (e.g. used for the recalc_rate
hook) can fail to get the clock rate from the firmware. In this case
we cannot return a signed error value, which would be casted to
unsigned long. Fix this by returning 0 instead.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/20220625083643.4012-1-stefan.wahren@i2se.com
Fixes: 4e85e535e6cc ("clk: bcm283x: add driver interfacing with Raspberry Pi's firmware")
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-raspberrypi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
index 1654fd0eedc94..a790a8ca02ff4 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -113,7 +113,7 @@ static unsigned long raspberrypi_fw_pll_get_rate(struct clk_hw *hw,
 					 RPI_FIRMWARE_ARM_CLK_ID,
 					 &val);
 	if (ret)
-		return ret;
+		return 0;
 
 	return val * RPI_FIRMWARE_PLLB_ARM_DIV_RATE;
 }
-- 
2.35.1



