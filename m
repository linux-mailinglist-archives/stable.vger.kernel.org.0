Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B716B43EB
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbjCJOUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbjCJOTZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:19:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1833C449F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:17:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D38B8616F0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7C7C433EF;
        Fri, 10 Mar 2023 14:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457863;
        bh=9Bt9oD2D7jNwOMCRgy3jMKTAM8ba/E/Lby46bVgcp3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCAa6xPSqbEfGjJ5ghX3Fw6THkI0TEvai4GYEA6phPvkKhop45vbpj2Va6FRS1xab
         cnpxSmOOa7NrAtCeAzVNDhUeNHr6z3V0TorVr42xpLedAKGQREXweiy2nKyJC7IvIM
         0Go1YFwPIu88osqwCgTqll8FBNoy6oP9xSRIZbBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Samuel Holland <samuel@sholland.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Daniel Lezcano <daniel.lezcano@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 056/252] RISC-V: time: initialize hrtimer based broadcast clock event device
Date:   Fri, 10 Mar 2023 14:37:06 +0100
Message-Id: <20230310133720.507849160@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 8b3b8fbb4896984b5564789a42240e4b3caddb61 ]

Similarly to commit 022eb8ae8b5e ("ARM: 8938/1: kernel: initialize
broadcast hrtimer based clock event device"), RISC-V needs to initiate
hrtimer based broadcast clock event device before C3STOP can be used.
Otherwise, the introduction of C3STOP for the RISC-V arch timer in
commit 232ccac1bd9b ("clocksource/drivers/riscv: Events are stopped
during CPU suspend") leaves us without any broadcast timer registered.
This prevents the kernel from entering oneshot mode, which breaks timer
behaviour, for example clock_nanosleep().

A test app that sleeps each cpu for 6, 5, 4, 3 ms respectively, HZ=250
& C3STOP enabled, the sleep times are rounded up to the next jiffy:
== CPU: 1 ==      == CPU: 2 ==      == CPU: 3 ==      == CPU: 4 ==
Mean: 7.974992    Mean: 7.976534    Mean: 7.962591    Mean: 3.952179
Std Dev: 0.154374 Std Dev: 0.156082 Std Dev: 0.171018 Std Dev: 0.076193
Hi: 9.472000      Hi: 10.495000     Hi: 8.864000      Hi: 4.736000
Lo: 6.087000      Lo: 6.380000      Lo: 4.872000      Lo: 3.403000
Samples: 521      Samples: 521      Samples: 521      Samples: 521

Link: https://lore.kernel.org/linux-riscv/YzYTNQRxLr7Q9JR0@spud/
Fixes: 232ccac1bd9b ("clocksource/drivers/riscv: Events are stopped during CPU suspend")
Suggested-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Samuel Holland <samuel@sholland.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Link: https://lore.kernel.org/r/20230103141102.772228-2-apatel@ventanamicro.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/time.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kernel/time.c b/arch/riscv/kernel/time.c
index 15f4ab40e2221..50bb7e0d44ba3 100644
--- a/arch/riscv/kernel/time.c
+++ b/arch/riscv/kernel/time.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/of_clk.h>
+#include <linux/clockchips.h>
 #include <linux/clocksource.h>
 #include <linux/delay.h>
 #include <asm/sbi.h>
@@ -33,4 +34,6 @@ void __init time_init(void)
 
 	of_clk_init(NULL);
 	timer_probe();
+
+	tick_setup_hrtimer_broadcast();
 }
-- 
2.39.2



