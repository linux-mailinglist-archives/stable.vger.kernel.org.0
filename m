Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB0A446DF5
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 13:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbhKFMwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 08:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbhKFMwM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Nov 2021 08:52:12 -0400
X-Greylist: delayed 2235 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 06 Nov 2021 05:49:31 PDT
Received: from hall.aurel32.net (hall.aurel32.net [IPv6:2001:bc8:30d7:100::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DBFC061570;
        Sat,  6 Nov 2021 05:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
        ; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
        Subject:Content-ID:Content-Description:X-Debbugs-Cc;
        bh=V6NxyZAsmQ9Ecs/pOfHmHEdOE4Q/uPjz2C6NqFY+UYY=; b=VAc4uB9l3Z99oV+SRhcohK8WCK
        yLU7ifHOhQVtJyqpC//LwUfa2TSPwZOnwK8ZB00QmFxeD+ZdAE98LFjWZ5iVu2BquNEM6cL7qL3iN
        P+TduN1admJROGoTrwl9qcNe6Mx4GMxVOKruH14oK4T81bzEu1bGjibYUgDcBST4rV3/ryFb9o0iC
        cLa2Bd9x0SK1aJoAwErz40I+JPxmzJF2Vb5YLOyR12pf3piHIbRqwA8tfv1wAAG3n840ao3li3KUT
        iwYYPEPUVcF12WBMgn5jso9zQGlWiiGjFtleCDzWnNtzHylBadXyCas3dHPW3GRcqUIsKHSycYoH7
        WKW3xbeA==;
Received: from [2a01:e34:ec5d:a741:8a4c:7c4e:dc4c:1787] (helo=ohm.rr44.fr)
        by hall.aurel32.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <aurelien@aurel32.net>)
        id 1mjKY4-0006fC-7b; Sat, 06 Nov 2021 13:11:52 +0100
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.94.2)
        (envelope-from <aurelien@aurel32.net>)
        id 1mjKY3-005ytP-FV; Sat, 06 Nov 2021 13:11:51 +0100
Date:   Sat, 6 Nov 2021 13:11:51 +0100
From:   Aurelien Jarno <aurelien@aurel32.net>
To:     guoren@kernel.org
Cc:     anup@brainfault.org, atish.patra@wdc.com, maz@kernel.org,
        tglx@linutronix.de, palmer@dabbelt.com,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        Guo Ren <guoren@linux.alibaba.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Nikita Shubin <nikita.shubin@maquefel.me>,
        stable@vger.kernel.org
Subject: Re: [PATCH V7] irqchip/sifive-plic: Fixup EOI failed when masked
Message-ID: <YYZxB0LN2iYhj+nz@aurel32.net>
Mail-Followup-To: guoren@kernel.org, anup@brainfault.org,
        atish.patra@wdc.com, maz@kernel.org, tglx@linutronix.de,
        palmer@dabbelt.com, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, Guo Ren <guoren@linux.alibaba.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Nikita Shubin <nikita.shubin@maquefel.me>, stable@vger.kernel.org
References: <20211105094748.3894453-1-guoren@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105094748.3894453-1-guoren@kernel.org>
User-Agent: Mutt/2.0.5 (2021-01-21)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-11-05 17:47, guoren@kernel.org wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
> 
> When using "devm_request_threaded_irq(,,,,IRQF_ONESHOT,,)" in the driver,
> only the first interrupt could be handled, and continue irq is blocked by
> hw. Because the riscv plic couldn't complete masked irq source which has
> been disabled in enable register. The bug was firstly reported in [1].
> 
> Here is the description of Interrupt Completion in PLIC spec [2]:
> 
> The PLIC signals it has completed executing an interrupt handler by
> writing the interrupt ID it received from the claim to the claim/complete
> register. The PLIC does not check whether the completion ID is the same
> as the last claim ID for that target. If the completion ID does not match
> an interrupt source that is currently enabled for the target, the
>                          ^^ ^^^^^^^^^ ^^^^^^^
> completion is silently ignored.
> 
> [1] http://lists.infradead.org/pipermail/linux-riscv/2021-July/007441.html
> [2] https://github.com/riscv/riscv-plic-spec/blob/8bc15a35d07c9edf7b5d23fec9728302595ffc4d/riscv-plic.adoc
> 
> Fixes: bb0fed1c60cc ("irqchip/sifive-plic: Switch to fasteoi flow")
> Reported-by: Vincent Pelletier <plr.vincent@gmail.com>
> Tested-by: Nikita Shubin <nikita.shubin@maquefel.me>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Cc: stable@vger.kernel.org
> Cc: Anup Patel <anup@brainfault.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Atish Patra <atish.patra@wdc.com>
> Cc: Nikita Shubin <nikita.shubin@maquefel.me>
> Cc: incent Pelletier <plr.vincent@gmail.com>

Thanks for this patch. From what I understand, it fixes among other
things the possibility to read the DA9063 RTC more than once.

Does it means that we could now enable it in the device tree? I mean
something like the following patch that unfortunately I can't test now:

diff --git a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
index 2e4ea84f27e7..c357b48582f7 100644
--- a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
@@ -70,6 +70,10 @@ pmic@58 {
 		interrupts = <1 IRQ_TYPE_LEVEL_LOW>;
 		interrupt-controller;
 
+		onkey {
+			compatible = "dlg,da9063-onkey";
+		};
+
 		regulators {
 			vdd_bcore1: bcore1 {
 				regulator-min-microvolt = <900000>;
@@ -205,6 +209,14 @@ vdd_ldo11: ldo11 {
 				regulator-always-on;
 			};
 		};
+
+		rtc {
+			compatible = "dlg,da9063-rtc";
+		};
+
+		wdt {
+			compatible = "dlg,da9063-watchdog";
+		};
 	};
 };

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                 http://www.aurel32.net
