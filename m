Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1687B27CCF1
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgI2Mkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729457AbgI2LOo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:14:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B299321D46;
        Tue, 29 Sep 2020 11:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378083;
        bh=g3SQ2oPbsCvb/719uNW9uFHtAfDY6nGDf0B5JFFjAn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1N+dZi+8dX2QHgy46f0LDleYw6GB9HNPPR/w+4e7AffedgGwH5mW0z9rL8Ev22Uqb
         IKozNJOxlnnHsSQYX3mP3TEWk88WUlp5QDCbCkrRh0tQezHKvZKtvab+dy4GJJrYkE
         TUDFzrLBlV+12OgtNYnEWCyYddD5k/GDJJiZR0Yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, p_c_chan@hotmail.com, ecm4@mail.com,
        perdigao1@yahoo.com, matzes@users.sourceforge.net,
        rvelascog@gmail.com, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 025/166] x86/ioapic: Unbreak check_timer()
Date:   Tue, 29 Sep 2020 12:58:57 +0200
Message-Id: <20200929105936.455185291@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 86a82ae0b5095ea24c55898a3f025791e7958b21 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/apic/io_apic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2160,6 +2160,7 @@ static inline void __init check_timer(vo
 	legacy_pic->init(0);
 	legacy_pic->make_irq(0);
 	apic_write(APIC_LVT0, APIC_DM_EXTINT);
+	legacy_pic->unmask(0);
 
 	unlock_ExtINT_logic();
 


