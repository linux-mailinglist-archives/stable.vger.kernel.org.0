Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6AE5AE9D8
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240729AbiIFNfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240625AbiIFNfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:35:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FE37820C;
        Tue,  6 Sep 2022 06:33:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9489B8162F;
        Tue,  6 Sep 2022 13:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16281C433D6;
        Tue,  6 Sep 2022 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471221;
        bh=HHBB9KyuFX+GW7Ogc+UaflVg9kT9RKJe53j3ymPYA2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ts9Emv/8JjuCWbkBHpies4LsMY96Bwi/39MuWm/A8KZIjSXFj05CPUCNf+Mc1f40W
         +ZntpQKDk3WZVCUwYzpvcou12iwFOCF8ovAnO3e5VvlIj0ASvY/Ki7/6Zfz9nACXbV
         dAcdIPmRcu7eqteXayOpEL6mi5pggHO1Fz+Nsnlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 38/80] clk: bcm: rpi: Fix error handling of raspberrypi_fw_get_rate
Date:   Tue,  6 Sep 2022 15:30:35 +0200
Message-Id: <20220906132818.585072990@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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
index f89b9cfc43099..2c12bd5ac1388 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -139,7 +139,7 @@ static unsigned long raspberrypi_fw_get_rate(struct clk_hw *hw,
 	ret = raspberrypi_clock_property(rpi->firmware, data,
 					 RPI_FIRMWARE_GET_CLOCK_RATE, &val);
 	if (ret)
-		return ret;
+		return 0;
 
 	return val;
 }
-- 
2.35.1



