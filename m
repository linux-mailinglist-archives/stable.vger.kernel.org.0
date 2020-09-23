Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC96276272
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 22:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIWUt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 16:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIWUt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 16:49:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6603C0613CE;
        Wed, 23 Sep 2020 13:49:27 -0700 (PDT)
Date:   Wed, 23 Sep 2020 20:49:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1600894166;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=P67vKN6KS0X9wrFk5DBa0shC7FvVtbIQJ1X1reEZ86g=;
        b=OZiM/DNZYfWhxCT4fqSh/ecvC9HqwFPordWpT6+rRCbnUdGJ6PjEkddNARZjYRxWiGk19m
        8CpFUHyFz03g7SfArQGjtCUXo1XP6FBy2E25755Uf3UKm8X8RjAXfC2Mm2wmHZY59+/BHt
        J4mj7+FicaSQYzm7Hc2zWGXA+nxlrJFJ2RtmTO8jPOkx0SHb7CF22SuabjSWuXirRZAITw
        gml/d3pRJybq3YgZWOzsMmSRfa/VZN/IUC6Jp4fV1494E3zeJAH+TaspymVH4QbH6Z/xHL
        9/TtUmwKeeSGpGEXrTfjmdTrEn07r3W3dSPY7B/nZIYhPpnK8EMRO4JEoHjh2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1600894166;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=P67vKN6KS0X9wrFk5DBa0shC7FvVtbIQJ1X1reEZ86g=;
        b=7n6PVv0b4RxdwL9gFwe0Ge7WH5iiMpd6jdVhdtxcPr9eoQ/wq4fKgUM+PYoo+pTOg1R8x1
        oUFOc2zLPR1ffyDQ==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/ioapic: Unbreak check_timer()
Cc:     p_c_chan@hotmail.com, ecm4@mail.com, perdigao1@yahoo.com,
        matzes@users.sourceforge.net, rvelascog@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <160089416479.7002.4806425926069592182.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     86a82ae0b5095ea24c55898a3f025791e7958b21
Gitweb:        https://git.kernel.org/tip/86a82ae0b5095ea24c55898a3f025791e7958b21
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Wed, 23 Sep 2020 17:46:20 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 23 Sep 2020 22:44:56 +02:00

x86/ioapic: Unbreak check_timer()

Several people reported in the kernel bugzilla that between v4.12 and v4.13
the magic which works around broken hardware and BIOSes to find the proper
timer interrupt delivery mode stopped working for some older affected
platforms which need to fall back to ExtINT delivery mode.

The reason is that the core code changed to keep track of the masked and
disabled state of an interrupt line more accurately to avoid the expensive
hardware operations.

That broke an assumption in i8259_make_irq() which invokes

     disable_irq_nosync();
     irq_set_chip_and_handler();
     enable_irq();

Up to v4.12 this worked because enable_irq() unconditionally unmasked the
interrupt line, but after the state tracking improvements this is not
longer the case because the IO/APIC uses lazy disabling. So the line state
is unmasked which means that enable_irq() does not call into the new irq
chip to unmask it.

In principle this is a shortcoming of the core code, but it's more than
unclear whether the core code should try to reset state. At least this
cannot be done unconditionally as that would break other existing use cases
where the chip type is changed, e.g. when changing the trigger type, but
the callers expect the state to be preserved.

As the way how check_timer() is switching the delivery modes is truly
unique, the obvious fix is to simply unmask the i8259 manually after
changing the mode to ExtINT delivery and switching the irq chip to the
legacy PIC.

Note, that the fixes tag is not really precise, but identifies the commit
which broke the assumptions in the IO/APIC and i8259 code and that's the
kernel version to which this needs to be backported.

Fixes: bf22ff45bed6 ("genirq: Avoid unnecessary low level irq function calls")
Reported-by: p_c_chan@hotmail.com
Reported-by: ecm4@mail.com
Reported-by: perdigao1@yahoo.com
Reported-by: matzes@users.sourceforge.net
Reported-by: rvelascog@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: p_c_chan@hotmail.com
Tested-by: matzes@users.sourceforge.net
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=197769
---
 arch/x86/kernel/apic/io_apic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 779a89e..21f9c7f 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2243,6 +2243,7 @@ static inline void __init check_timer(void)
 	legacy_pic->init(0);
 	legacy_pic->make_irq(0);
 	apic_write(APIC_LVT0, APIC_DM_EXTINT);
+	legacy_pic->unmask(0);
 
 	unlock_ExtINT_logic();
 
