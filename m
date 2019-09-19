Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47259B868E
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392379AbfISWQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:16:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404461AbfISWQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:16:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6B1121924;
        Thu, 19 Sep 2019 22:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931398;
        bh=ig1QAX5ew4WFIw7Z0NgMyjHLCTDINWuxaWZVyI6TGbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXhpGHeatRj1f7a+Qd4zSeTFWoCzQpPCque7njSdb8MwB022pfXEUpmpqdTt5i+Bu
         rvd7SSE7Gwuo6KURx5LzeYvwzTL/CSSEAgkOu2338RbFLHBWj1u9N6KkBV+F9M7tKD
         UHUeshtgAWr/9Hbeg7eZ2SKmWzgrGU01iydGSGLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Tanwar <rahul.tanwar@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, alan@linux.intel.com,
        bp@alien8.de, cheol.yong.kim@intel.com, qi-ming.wu@intel.com,
        rahul.tanwar@intel.com, rppt@linux.ibm.com, tony.luck@intel.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 30/59] x86/apic: Fix arch_dynirq_lower_bound() bug for DT enabled machines
Date:   Fri, 20 Sep 2019 00:03:45 +0200
Message-Id: <20190919214805.641905580@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 96a8a68f9c793..566b7bc5deaa0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2342,7 +2342,13 @@ unsigned int arch_dynirq_lower_bound(unsigned int from)
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



