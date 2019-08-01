Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8617D723
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbfHAIUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:02 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34301 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbfHAIUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:02 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so31879045plt.1
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ThYg/2PcaE2XPc0i5Ecb1/dXdxeDGNU8nmJ2xJHUWI=;
        b=qgyOciaZcnLJ+ScinWgYbGi83v03wFAdwHmCXOCF3q0l+t90McwWECzJNQCizBct0B
         InVe2nVLoCD9H0AnZ/kurROlNkLnrqZihINvdtTgq+jfMdHAUnuDVUAiZ3afxOI4dPC6
         ylEeHV6fkGaTE+dmiReo1opsGMKACSLNHUF+kT6wWe4VB3YKMGXo1CaKyR4hTD5izZYm
         xGoZBt+jJuG7OOJfsUpSANOWnaHZw7qFL1R1VybKfR4mnst6IwhzLyCNhEbavZBguJPM
         GZR8M7SHdrjtWcLdpEqNImqQBPZXnTSxFQKwzZ7LoZi+FD9QrMGi6RuvxJeUk9BFFQLz
         /Ppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ThYg/2PcaE2XPc0i5Ecb1/dXdxeDGNU8nmJ2xJHUWI=;
        b=jmyXXx2vdgARIsZwQ89Pb6mmSsGYh9Y/zwg8lFiiHcoVsts9dUfpl/EmdGrxvDscVF
         iq8lwk0gjRxlURuH3XG6gz1eiZaE2OeMMOVWl0HzcspdUEr0JECbX1LGALLxNj1B1D16
         544S4/Q8TMfgTj6ARpjmTNJylCL1vBwPcHF0t5x9n1VqRqmFuZmCiMRs6da2uwv0cLVM
         yyw6SbT+5YQ4Q0SR1ZMYxvLaCzqlwECrSEID2Q+WdgdmJ2dooBlo/6s9W2qnqZutAqCS
         P4VxiXNTiOrMBR0uU1oGDaHyCrhml39ghDcV87DkznUmsVtm0w4d79dJJKQ2cKK4apxO
         wNSg==
X-Gm-Message-State: APjAAAWc9Q451KJ/DYkFz31kJqngXk0xip0Xed2BFeFabB87bCuH3S2A
        3snZZ+p0ncjOGekhxv1XGRJ8mAY8dNk=
X-Google-Smtp-Source: APXvYqx1QQ7xXlLGULtzj9QyhS4Rr6IH3S1/6j0ENAHznJBWvqCZRhX84aieeJqPGOpKRufRa0gQkg==
X-Received: by 2002:a17:902:2a27:: with SMTP id i36mr122339377plb.161.1564647601352;
        Thu, 01 Aug 2019 01:20:01 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id cx22sm3895076pjb.25.2019.08.01.01.20.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:00 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 10/47] ARM: bugs: prepare processor bug infrastructure
Date:   Thu,  1 Aug 2019 13:45:54 +0530
Message-Id: <31d400e2535e6502cfa192169c054a02c3385185.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit a5b9177f69329314721aa7022b7e69dab23fa1f0 upstream.

Prepare the processor bug infrastructure so that it can be expanded to
check for per-processor bugs.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/bugs.h | 4 ++--
 arch/arm/kernel/Makefile    | 1 +
 arch/arm/kernel/bugs.c      | 9 +++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/kernel/bugs.c

diff --git a/arch/arm/include/asm/bugs.h b/arch/arm/include/asm/bugs.h
index a97f1ea708d1..ed122d294f3f 100644
--- a/arch/arm/include/asm/bugs.h
+++ b/arch/arm/include/asm/bugs.h
@@ -10,10 +10,10 @@
 #ifndef __ASM_BUGS_H
 #define __ASM_BUGS_H
 
-#ifdef CONFIG_MMU
 extern void check_writebuffer_bugs(void);
 
-#define check_bugs() check_writebuffer_bugs()
+#ifdef CONFIG_MMU
+extern void check_bugs(void);
 #else
 #define check_bugs() do { } while (0)
 #endif
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 3c789496297f..f936cec24f72 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -30,6 +30,7 @@ else
 obj-y		+= entry-armv.o
 endif
 
+obj-$(CONFIG_MMU)		+= bugs.o
 obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
 obj-$(CONFIG_ISA_DMA_API)	+= dma.o
 obj-$(CONFIG_FIQ)		+= fiq.o fiqasm.o
diff --git a/arch/arm/kernel/bugs.c b/arch/arm/kernel/bugs.c
new file mode 100644
index 000000000000..88024028bb70
--- /dev/null
+++ b/arch/arm/kernel/bugs.c
@@ -0,0 +1,9 @@
+// SPDX-Identifier: GPL-2.0
+#include <linux/init.h>
+#include <asm/bugs.h>
+#include <asm/proc-fns.h>
+
+void __init check_bugs(void)
+{
+	check_writebuffer_bugs();
+}
-- 
2.21.0.rc0.269.g1a574e7a288b

