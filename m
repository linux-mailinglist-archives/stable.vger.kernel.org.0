Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAFA6AE99E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjCGR0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbjCGRZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:25:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FB497FF8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:20:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C4AD61506
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2428AC433A0;
        Tue,  7 Mar 2023 17:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209638;
        bh=CVtAXUjfOWyXtdCD7IOhtwx1KkDlNylxNmr3yMck988=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fh0HRldOGTJpBXRpn+GTtJdzgfROiyy2PJhlQXz2U6ty8mp7ma0HyL/AIAtOU1dam
         kWKgip1XY5gOB47z7cmk0kJ0uiASliUJCZEsL/1TW+m/nZw2NXYeiGrOQl/hO6QZso
         hpiQhh64rZKNz6d1abcaJBZ54maVHxyHIfjfWbsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matt Evans <mev@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0283/1001] clocksource/drivers/riscv: Patch riscv_clock_next_event() jump before first use
Date:   Tue,  7 Mar 2023 17:50:55 +0100
Message-Id: <20230307170033.944582297@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Evans <mev@rivosinc.com>

[ Upstream commit 225b9596cb0227c1c1b1e4a836dad43595c3e61a ]

A static key is used to select between SBI and Sstc timer usage in
riscv_clock_next_event(), but currently the direction is resolved
after cpuhp_setup_state() is called (which sets the next event).  The
first event will therefore fall through the sbi_set_timer() path; this
breaks Sstc-only systems.  So, apply the jump patching before first
use.

Fixes: 9f7a8ff6391f ("RISC-V: Prefer sstc extension if available")
Signed-off-by: Matt Evans <mev@rivosinc.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/CDDAB2D0-264E-42F3-8E31-BA210BEB8EC1@rivosinc.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-riscv.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index a0d66fabf0732..a01c2bd241349 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -177,6 +177,11 @@ static int __init riscv_timer_init_dt(struct device_node *n)
 		return error;
 	}
 
+	if (riscv_isa_extension_available(NULL, SSTC)) {
+		pr_info("Timer interrupt in S-mode is available via sstc extension\n");
+		static_branch_enable(&riscv_sstc_available);
+	}
+
 	error = cpuhp_setup_state(CPUHP_AP_RISCV_TIMER_STARTING,
 			 "clockevents/riscv/timer:starting",
 			 riscv_timer_starting_cpu, riscv_timer_dying_cpu);
@@ -184,11 +189,6 @@ static int __init riscv_timer_init_dt(struct device_node *n)
 		pr_err("cpu hp setup state failed for RISCV timer [%d]\n",
 		       error);
 
-	if (riscv_isa_extension_available(NULL, SSTC)) {
-		pr_info("Timer interrupt in S-mode is available via sstc extension\n");
-		static_branch_enable(&riscv_sstc_available);
-	}
-
 	return error;
 }
 
-- 
2.39.2



