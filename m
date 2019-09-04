Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34629A8B5F
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387480AbfIDQCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387471AbfIDQCn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:02:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F20412070C;
        Wed,  4 Sep 2019 16:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612962;
        bh=zMZ3NN5Ec3j2NtL7lZrB4gu39QodgcLY7Q9IEA1DIFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QctGoLFc1Brxc8BbZ0bQJdU9RJP8jBDGe/WsG3b4rdwFx1bR/N5K0kGzMr9FXR1OL
         Svhys2WcmHLNvw5gqHqZVhzY7aaZOlVZbzGaR75pAEGl8XqvE4OaDZDr2UepYwWBed
         2JfJxvaO78Tcv05KjDqehH4962zUf3YXX8ymCmK0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Rahul Tanwar <rahul.tanwar@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, alan@linux.intel.com,
        bp@alien8.de, cheol.yong.kim@intel.com, qi-ming.wu@intel.com,
        rahul.tanwar@intel.com, rppt@linux.ibm.com, tony.luck@intel.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 14/27] x86/apic: Fix arch_dynirq_lower_bound() bug for DT enabled machines
Date:   Wed,  4 Sep 2019 12:02:07 -0400
Message-Id: <20190904160220.4545-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160220.4545-1-sashal@kernel.org>
References: <20190904160220.4545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 3e5bedc2c258341702ddffbd7688c5e6eb01eafa ]

Rahul Tanwar reported the following bug on DT systems:

> 'ioapic_dynirq_base' contains the virtual IRQ base number. Presently, it is
> updated to the end of hardware IRQ numbers but this is done only when IOAPIC
> configuration type is IOAPIC_DOMAIN_LEGACY or IOAPIC_DOMAIN_STRICT. There is
> a third type IOAPIC_DOMAIN_DYNAMIC which applies when IOAPIC configuration
> comes from devicetree.
>
> See dtb_add_ioapic() in arch/x86/kernel/devicetree.c
>
> In case of IOAPIC_DOMAIN_DYNAMIC (DT/OF based system), 'ioapic_dynirq_base'
> remains to zero initialized value. This means that for OF based systems,
> virtual IRQ base will get set to zero.

Such systems will very likely not even boot.

For DT enabled machines ioapic_dynirq_base is irrelevant and not
updated, so simply map the IRQ base 1:1 instead.

Reported-by: Rahul Tanwar <rahul.tanwar@linux.intel.com>
Tested-by: Rahul Tanwar <rahul.tanwar@linux.intel.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: alan@linux.intel.com
Cc: bp@alien8.de
Cc: cheol.yong.kim@intel.com
Cc: qi-ming.wu@intel.com
Cc: rahul.tanwar@intel.com
Cc: rppt@linux.ibm.com
Cc: tony.luck@intel.com
Link: http://lkml.kernel.org/r/20190821081330.1187-1-rahul.tanwar@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d34629d70421f..09dd95cabfc28 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2346,7 +2346,13 @@ unsigned int arch_dynirq_lower_bound(unsigned int from)
 	 * dmar_alloc_hwirq() may be called before setup_IO_APIC(), so use
 	 * gsi_top if ioapic_dynirq_base hasn't been initialized yet.
 	 */
-	return ioapic_initialized ? ioapic_dynirq_base : gsi_top;
+	if (!ioapic_initialized)
+		return gsi_top;
+	/*
+	 * For DT enabled machines ioapic_dynirq_base is irrelevant and not
+	 * updated. So simply return @from if ioapic_dynirq_base == 0.
+	 */
+	return ioapic_dynirq_base ? : from;
 }
 
 #ifdef CONFIG_X86_32
-- 
2.20.1

