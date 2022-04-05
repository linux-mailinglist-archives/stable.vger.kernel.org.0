Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446BC4F3E7D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355740AbiDEMWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356222AbiDEKXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:23:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A5ABAB8B;
        Tue,  5 Apr 2022 03:08:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D650D616E7;
        Tue,  5 Apr 2022 10:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26CCC385A1;
        Tue,  5 Apr 2022 10:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153279;
        bh=AfgH4Qyrq4ocyIyW87RMBy6AWuM7pyFE0B/1ED0rGfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IL0DJoI0vbUYMn0r91Bgl/+RTCllXBl8zJB358bTjuiV0T8ANtq4ku/rescbAiG7S
         h0lU4FHCHTK5eyUoilgvP3WWpenRzf6CAUo3s8xOyWz41zyfrDqnHi59y5uKoqkyko
         CLnvUmDKAkPltdcHT7z8T5mAAEw/bCI7fEKVF8HM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/599] clocksource/drivers/timer-microchip-pit64b: Use notrace
Date:   Tue,  5 Apr 2022 09:27:33 +0200
Message-Id: <20220405070303.573361255@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,TVD_SPACE_RATIO,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit ff10ee97cb203262e88d9c8bc87369cbd4004a0c ]

Use notrace for mchp_pit64b_sched_read_clk() to avoid recursive call of
prepare_ftrace_return() when issuing:
echo function_graph > /sys/kernel/debug/tracing/current_tracer

Fixes: 625022a5f160 ("clocksource/drivers/timer-microchip-pit64b: Add Microchip PIT64B support")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220304133601.2404086-3-claudiu.beznea@microchip.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-microchip-pit64b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-microchip-pit64b.c b/drivers/clocksource/timer-microchip-pit64b.c
index 59e11ca8ee73..5c9485cb4e05 100644
--- a/drivers/clocksource/timer-microchip-pit64b.c
+++ b/drivers/clocksource/timer-microchip-pit64b.c
@@ -121,7 +121,7 @@ static u64 mchp_pit64b_clksrc_read(struct clocksource *cs)
 	return mchp_pit64b_cnt_read(mchp_pit64b_cs_base);
 }
 
-static u64 mchp_pit64b_sched_read_clk(void)
+static u64 notrace mchp_pit64b_sched_read_clk(void)
 {
 	return mchp_pit64b_cnt_read(mchp_pit64b_cs_base);
 }
-- 
2.34.1



