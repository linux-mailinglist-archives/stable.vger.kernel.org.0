Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F147603EE8
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbiJSJXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbiJSJV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:21:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E32372B66;
        Wed, 19 Oct 2022 02:10:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 511C3617F1;
        Wed, 19 Oct 2022 09:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4F7C433D7;
        Wed, 19 Oct 2022 09:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170467;
        bh=RGwrKnkrt+w/nHMKlIsALNrzbvtZrXpoRBaBl2bJTIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjJO+cO7V57mrH7uRl65DC+/Grj18uQxhZuHe8En9ynIYR/06cSjgQWBPhS63aVo0
         awlksJ1Tr23IOEfUsiWl6iGSvkmf0saegBWu/TaVzeR+4qxa2Tg5L4YgJrrjO1FAb6
         kUVWVzm8kxQM8L0rEnByeb9JcT8xxYVjfZH2Q0aI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kunkun Jiang <jiangkunkun@huawei.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 639/862] clocksource/drivers/arm_arch_timer: Fix handling of ARM erratum 858921
Date:   Wed, 19 Oct 2022 10:32:06 +0200
Message-Id: <20221019083318.160511306@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunkun Jiang <jiangkunkun@huawei.com>

[ Upstream commit 6c3b62d93e195f78c1437c8fa7581e9b2f00886e ]

The commit a38b71b0833e ("clocksource/drivers/arm_arch_timer:
Move system register timer programming over to CVAL") moves the
programming of the timers from the countdown timer (TVAL) over
to the comparator (CVAL). This makes it necessary to read the
counter when programming next event. However, the workaround of
Cortex-A73 erratum 858921 does not set the corresponding
set_next_event_phys and set_next_event_virt.

Add the appropriate hooks to apply the erratum mitigation when
programming the next timer event.

Fixes: a38b71b0833e ("clocksource/drivers/arm_arch_timer: Move system register timer programming over to CVAL")
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20220914061424.1260-1-jiangkunkun@huawei.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/arm_arch_timer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 8122a1646925..a7ff77550e17 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -473,6 +473,8 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.desc = "ARM erratum 858921",
 		.read_cntpct_el0 = arm64_858921_read_cntpct_el0,
 		.read_cntvct_el0 = arm64_858921_read_cntvct_el0,
+		.set_next_event_phys = erratum_set_next_event_phys,
+		.set_next_event_virt = erratum_set_next_event_virt,
 	},
 #endif
 #ifdef CONFIG_SUN50I_ERRATUM_UNKNOWN1
-- 
2.35.1



