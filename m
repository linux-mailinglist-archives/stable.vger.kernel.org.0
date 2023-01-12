Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199BC667431
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjALODz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232681AbjALOD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:03:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA4C6174
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:03:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BA2A61F74
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2314CC433D2;
        Thu, 12 Jan 2023 14:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532204;
        bh=1VRA98DtIypg+5pvhqP+KOO6DnS43DUQXm/uUmTP+Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sI0jjtPLUQP+Efk1nsNH3/qRFX4xWb74yz6b8PxJ49QqM1NhsUYSKK4OAK7j8DPYk
         /FlexwRmjzAjt3In3lrOy/+0siLv1rpNmBEyg8pcepCn9RP2jGRBDe+2lRO5R6rH3D
         I1MAdRB3M4nWRJ35j9g0JBBjbDtYo4wbopOHQaEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Tony Lindgren <tony@atomide.com>,
        Daniel Lezcano <daniel.lezcano@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/783] clocksource/drivers/timer-ti-dm: Fix missing clk_disable_unprepare in dmtimer_systimer_init_clock()
Date:   Thu, 12 Jan 2023 14:46:41 +0100
Message-Id: <20230112135528.110941016@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 180d35a7c05d520314a590c99ad8643d0213f28b ]

If clk_get_rate() fails which is called after clk_prepare_enable(),
clk_disable_unprepare() need be called in error path to disable the
clock in dmtimer_systimer_init_clock().

Fixes: 52762fbd1c47 ("clocksource/drivers/timer-ti-dm: Add clockevent and clocksource support")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20221029114427.946520-1-yangyingliang@huawei.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-ti-dm-systimer.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-ti-dm-systimer.c b/drivers/clocksource/timer-ti-dm-systimer.c
index 2737407ff069..632523c1232f 100644
--- a/drivers/clocksource/timer-ti-dm-systimer.c
+++ b/drivers/clocksource/timer-ti-dm-systimer.c
@@ -345,8 +345,10 @@ static int __init dmtimer_systimer_init_clock(struct dmtimer_systimer *t,
 		return error;
 
 	r = clk_get_rate(clock);
-	if (!r)
+	if (!r) {
+		clk_disable_unprepare(clock);
 		return -ENODEV;
+	}
 
 	if (is_ick)
 		t->ick = clock;
-- 
2.35.1



