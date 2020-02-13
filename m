Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 581FA15C378
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbgBMPlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:41:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387603AbgBMP2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:32 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8808218AC;
        Thu, 13 Feb 2020 15:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607711;
        bh=Qm0xSLfvbGM27e3fE+H72stdknaIeAyPzTwdgyCF8Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cE5/v9VqbhP/dJw7eDw4+Jk3IdvwPEF4onedOGpm4YdA/rL50chWI34oSXc3DFifR
         0zuAv4GB+3HD2y70TID26RsC9bAtuGt8h5Eq8eFH+GzU0DJ49ECem2W1dyXYV9OJ8S
         wCvCgqB1EDVRaR7y9aKLFWM59pq51IiwaYDOQWpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.5 050/120] rtc: cmos: Stop using shared IRQ
Date:   Thu, 13 Feb 2020 07:20:46 -0800
Message-Id: <20200213151918.982561922@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit b6da197a2e9670df6f07e6698629e9ce95ab614e upstream.

As reported by Guilherme G. Piccoli:

---8<---8<---8<---

The rtc-cmos interrupt setting was changed in the commit 079062b28fb4
("rtc: cmos: prevent kernel warning on IRQ flags mismatch") in order
to allow shared interrupts; according to that commit's description,
some machine got kernel warnings due to the interrupt line being shared
between rtc-cmos and other hardware, and rtc-cmos didn't allow IRQ sharing
that time.

After the aforementioned commit though it was observed a huge increase
in lost HPET interrupts in some systems, observed through the following
kernel message:

[...] hpet1: lost 35 rtc interrupts

After investigation, it was narrowed down to the shared interrupts
usage when having the kernel option "irqpoll" enabled. In this case,
all IRQ handlers are called for non-timer interrupts, if such handlers
are setup in shared IRQ lines. The rtc-cmos IRQ handler could be set to
hpet_rtc_interrupt(), which will produce the kernel "lost interrupts"
message after doing work - lots of readl/writel to HPET registers, which
are known to be slow.

Although "irqpoll" is not a default kernel option, it's used in some contexts,
one being the kdump kernel (which is an already "impaired" kernel usually
running with 1 CPU available), so the performance burden could be considerable.
Also, the same issue would happen (in a shorter extent though) when using
"irqfixup" kernel option.

In a quick experiment, a virtual machine with uptime of 2 minutes produced
>300 calls to hpet_rtc_interrupt() when "irqpoll" was set, whereas without
sharing interrupts this number reduced to 1 interrupt. Machines with more
hardware than a VM should generate even more unnecessary HPET interrupts
in this scenario.

---8<---8<---8<---

After looking into the rtc-cmos driver history and DSDT table from
the Microsoft Surface 3, we may notice that Hans de Goede submitted
a correct fix (see dependency below). Thus, we simply revert
the culprit commit.

Fixes: 079062b28fb4 ("rtc: cmos: prevent kernel warning on IRQ flags mismatch")
Depends-on: a1e23a42f1bd ("rtc: cmos: Do not assume irq 8 for rtc when there are no legacy irqs")
Reported-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20200123131437.28157-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-cmos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -850,7 +850,7 @@ cmos_do_probe(struct device *dev, struct
 			rtc_cmos_int_handler = cmos_interrupt;
 
 		retval = request_irq(rtc_irq, rtc_cmos_int_handler,
-				IRQF_SHARED, dev_name(&cmos_rtc.rtc->dev),
+				0, dev_name(&cmos_rtc.rtc->dev),
 				cmos_rtc.rtc);
 		if (retval < 0) {
 			dev_dbg(dev, "IRQ %d is already in use\n", rtc_irq);


