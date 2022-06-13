Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537B9548E73
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377609AbiFMNdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378405AbiFMNb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:31:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37AB70377;
        Mon, 13 Jun 2022 04:26:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A88660B6E;
        Mon, 13 Jun 2022 11:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFD5C34114;
        Mon, 13 Jun 2022 11:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119562;
        bh=YbAO6dc61CTVZPXA3H0275LCoBrPznmVp9BrsF0I538=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PX/yJ57aC5zIuOo+3dmGAbh8Ct2uyeX8HyGE3mGTp1IuGp+EBQqHNP9K6wNkG3dAS
         JYdS/ZfeBMkPCBWdgKrJuu83CXmVgD30IAP7BekaUlyFsQM5Npks//MHKNK1OiOr8p
         N1Y/q1a/EEh9D+YOSxqerEeo7NBtYQVia2P33PXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Anup Patel <anup@brainfault.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 058/339] clocksource/drivers/riscv: Events are stopped during CPU suspend
Date:   Mon, 13 Jun 2022 12:08:03 +0200
Message-Id: <20220613094928.281945592@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 232ccac1bd9b5bfe73895f527c08623e7fa0752d ]

Some implementations of the SBI time extension depend on hart-local
state (for example, CSRs) that are lost or hardware that is powered
down when a CPU is suspended. To be safe, the clockevents driver
cannot assume that timer IRQs will be received during CPU suspend.

Fixes: 62b019436814 ("clocksource: new RISC-V SBI timer driver")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20220509012121.40031-1-samuel@sholland.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-riscv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index 1767f8bf2013..593d5a957b69 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -34,7 +34,7 @@ static int riscv_clock_next_event(unsigned long delta,
 static unsigned int riscv_clock_event_irq;
 static DEFINE_PER_CPU(struct clock_event_device, riscv_clock_event) = {
 	.name			= "riscv_timer_clockevent",
-	.features		= CLOCK_EVT_FEAT_ONESHOT,
+	.features		= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP,
 	.rating			= 100,
 	.set_next_event		= riscv_clock_next_event,
 };
-- 
2.35.1



