Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630515FD0D8
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbiJMAaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbiJMA1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:27:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F69EDCAE6;
        Wed, 12 Oct 2022 17:25:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58701B81CEA;
        Thu, 13 Oct 2022 00:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79288C433D6;
        Thu, 13 Oct 2022 00:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620699;
        bh=gXnngsA66M7S05m7QK1AIEjykKSHGcIRBKoj9aJYtgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCUnyWce7iBGGkV+ZyhZICwLzSap9ldVlaA/ADusnhSf28A2yAP1hbHu0l/Qg1JIM
         OjDt3fUWmjxF0mii1DE74YI7Nlc+xioq19+Xw7QNsF0Hv56ZZwEIaHABLrX/iAnp4v
         3kzOzXjmuWRLgCGGE+2IxDwGgJ1J7W5AoAGdz4Q0CVmfWR56HfKq6YOhGlor5CZfVy
         hSzOiubwD3SiSf86xuHCEK96mQGrJd9adzTLYlv6/ixZLZT6KeYxQ92oK7I5slyxEM
         HnLc4tTm8vBnQj4+hz9aqEwGY1+iFphBjG+S2hRH/lRCZprEe+UjX/L57QJ8UkzcEV
         XWxnjPTFM+BzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mturquette@baylibre.com,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        nsaenz@kernel.org, iivanov@suse.de, linux-clk@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 33/33] clk: bcm2835: Make peripheral PLLC critical
Date:   Wed, 12 Oct 2022 20:23:32 -0400
Message-Id: <20221013002334.1894749-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002334.1894749-1-sashal@kernel.org>
References: <20221013002334.1894749-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 6c5422851d8be8c7451e968fd2e6da41b6109e17 ]

When testing for a series affecting the VEC, it was discovered that
turning off and on the VEC clock is crashing the system.

It turns out that, when disabling the VEC clock, it's the only child of
the PLLC-per clock which will also get disabled. The source of the crash
is PLLC-per being disabled.

It's likely that some other device might not take a clock reference that
it actually needs, but it's unclear which at this point. Let's make
PLLC-per critical so that we don't have that crash.

Reported-by: Noralf Trønnes <noralf@tronnes.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20220926084509.12233-1-maxime@cerno.tech
Reviewed-by: Stefan Wahren <stefan.wahren@i2se.com>
Acked-by: Noralf Trønnes <noralf@tronnes.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-bcm2835.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
index 178886823b90..20381b1c2695 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -1786,7 +1786,7 @@ static const struct bcm2835_clk_desc clk_desc_array[] = {
 		.load_mask = CM_PLLC_LOADPER,
 		.hold_mask = CM_PLLC_HOLDPER,
 		.fixed_divider = 1,
-		.flags = CLK_SET_RATE_PARENT),
+		.flags = CLK_IS_CRITICAL | CLK_SET_RATE_PARENT),
 
 	/*
 	 * PLLD is the display PLL, used to drive DSI display panels.
-- 
2.35.1

