Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC0E64330D
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbiLETeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbiLETdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:33:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6490E2D778
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:28:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0286FB80EFD
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA59C433D6;
        Mon,  5 Dec 2022 19:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268510;
        bh=ipSJSQkL1kzU648WQdGvF8202dy1RqdSgpRc+thfUTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjW/Zv51zbaVmFmklMd/TPy+qbLdTxJT2sUXkAGVkS6lGdpMsuclV8cMPFSsEwkMS
         ZZv7icHm7E/1J+OTcmaHncHRb0KsGm1ck4DPaqqk1I10tcYVjkU4Z6AZEuWcxoBLd4
         OW0uz01aw0DTp09d1kGaA2z9YPaX8wWKku5SK6CU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Conor Dooley <conor.dooley@microchip.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Samuel Holland <samuel@sholland.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 121/124] Revert "clocksource/drivers/riscv: Events are stopped during CPU suspend"
Date:   Mon,  5 Dec 2022 20:10:27 +0100
Message-Id: <20221205190811.886494481@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit d9f15a9de44affe733e34f93bc184945ba277e6d ]

This reverts commit 232ccac1bd9b5bfe73895f527c08623e7fa0752d.

On the subject of suspend, the RISC-V SBI spec states:

  This does not cover whether any given events actually reach the hart or
  not, just what the hart will do if it receives an event. On PolarFire
  SoC, and potentially other SiFive based implementations, events from the
  RISC-V timer do reach a hart during suspend. This is not the case for the
  implementation on the Allwinner D1 - there timer events are not received
  during suspend.

To fix this, the CLOCK_EVT_FEAT_C3STOP (mis)feature was enabled for the
timer driver - but this has broken both RCU stall detection and timers
generally on PolarFire SoC and potentially other SiFive based
implementations.

If an AXI read to the PCIe controller on PolarFire SoC times out, the
system will stall, however, with CLOCK_EVT_FEAT_C3STOP active, the system
just locks up without RCU stalling:

	io scheduler mq-deadline registered
	io scheduler kyber registered
	microchip-pcie 2000000000.pcie: host bridge /soc/pcie@2000000000 ranges:
	microchip-pcie 2000000000.pcie:      MEM 0x2008000000..0x2087ffffff -> 0x0008000000
	microchip-pcie 2000000000.pcie: sec error in pcie2axi buffer
	microchip-pcie 2000000000.pcie: ded error in pcie2axi buffer
	microchip-pcie 2000000000.pcie: axi read request error
	microchip-pcie 2000000000.pcie: axi read timeout
	microchip-pcie 2000000000.pcie: sec error in pcie2axi buffer
	microchip-pcie 2000000000.pcie: ded error in pcie2axi buffer
	microchip-pcie 2000000000.pcie: sec error in pcie2axi buffer
	microchip-pcie 2000000000.pcie: ded error in pcie2axi buffer
	microchip-pcie 2000000000.pcie: sec error in pcie2axi buffer
	microchip-pcie 2000000000.pcie: ded error in pcie2axi buffer
	Freeing initrd memory: 7332K

Similarly issues were reported with clock_nanosleep() - with a test app
that sleeps each cpu for 6, 5, 4, 3 ms respectively, HZ=250 & the blamed
commit in place, the sleep times are rounded up to the next jiffy:

== CPU: 1 ==      == CPU: 2 ==      == CPU: 3 ==      == CPU: 4 ==
Mean: 7.974992    Mean: 7.976534    Mean: 7.962591    Mean: 3.952179
Std Dev: 0.154374 Std Dev: 0.156082 Std Dev: 0.171018 Std Dev: 0.076193
Hi: 9.472000      Hi: 10.495000     Hi: 8.864000      Hi: 4.736000
Lo: 6.087000      Lo: 6.380000      Lo: 4.872000      Lo: 3.403000
Samples: 521      Samples: 521      Samples: 521      Samples: 521

Fortunately, the D1 has a second timer, which is "currently used in
preference to the RISC-V/SBI timer driver" so a revert here does not
hurt operation of D1 in its current form.

Ultimately, a DeviceTree property (or node) will be added to encode the
behaviour of the timers, but until then revert the addition of
CLOCK_EVT_FEAT_C3STOP.

Fixes: 232ccac1bd9b ("clocksource/drivers/riscv: Events are stopped during CPU suspend")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Acked-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/linux-riscv/YzYTNQRxLr7Q9JR0@spud/
Link: https://github.com/riscv-non-isa/riscv-sbi-doc/issues/98/
Link: https://lore.kernel.org/linux-riscv/bf6d3b1f-f703-4a25-833e-972a44a04114@sholland.org/
Link: https://lore.kernel.org/r/20221122121620.3522431-1-conor.dooley@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-riscv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index 969a552da8d2..a0d66fabf073 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -51,7 +51,7 @@ static int riscv_clock_next_event(unsigned long delta,
 static unsigned int riscv_clock_event_irq;
 static DEFINE_PER_CPU(struct clock_event_device, riscv_clock_event) = {
 	.name			= "riscv_timer_clockevent",
-	.features		= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP,
+	.features		= CLOCK_EVT_FEAT_ONESHOT,
 	.rating			= 100,
 	.set_next_event		= riscv_clock_next_event,
 };
-- 
2.35.1



