Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944F139E1F4
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhFGQOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231577AbhFGQO3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C19E0613C7;
        Mon,  7 Jun 2021 16:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082358;
        bh=PIMvvOdcHM/UaNyjKsmWLK9cCLAZzAi4AH7zS+RZbIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=egYDQ0EEo3v+t3tqFI2PeC8PH8CO+Gfe0E3CLIK9fadGToOVdWC3BPQypo7dHWAHk
         KSBDOQEFYkZ4ays3Zj60Md8fK5NZJWwman0nRtyC3Yq9RY2eoX6rt5yYzWgQMk9L/u
         IJ1r3q3v3guXyuMiOInbzr3CGXRDZzCaei6fjahdHzctClkIYmiswMkm4N7Oc/uoVk
         PPLAI25OKwI5XC7OOa2umhvGe0U73xWcME7qncht3GJkgjpIjsqIh49mPxraKKt5hL
         aa9h1iFeHoLLzWLbaiPY4LJ7c2HiiHd8ir7Biwh2X0IVNfEypEKs04/5+yQD5/klbW
         9nnjVBtUaIhjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maciej Falkowski <maciej.falkowski9@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.12 18/49] ARM: OMAP1: Fix use of possibly uninitialized irq variable
Date:   Mon,  7 Jun 2021 12:11:44 -0400
Message-Id: <20210607161215.3583176-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Falkowski <maciej.falkowski9@gmail.com>

[ Upstream commit 3c4e0147c269738a19c7d70cd32395600bcc0714 ]

The current control flow of IRQ number assignment to `irq` variable
allows a request of IRQ of unspecified value,
generating a warning under Clang compilation with omap1_defconfig on
linux-next:

arch/arm/mach-omap1/pm.c:656:11: warning: variable 'irq' is used
uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
        else if (cpu_is_omap16xx())
                 ^~~~~~~~~~~~~~~~~
./arch/arm/mach-omap1/include/mach/soc.h:123:30: note: expanded from macro
'cpu_is_omap16xx'
                                        ^~~~~~~~~~~~~
arch/arm/mach-omap1/pm.c:658:18: note: uninitialized use occurs here
        if (request_irq(irq, omap_wakeup_interrupt, 0, "peripheral wakeup",
                        ^~~
arch/arm/mach-omap1/pm.c:656:7: note: remove the 'if' if its condition is
always true
        else if (cpu_is_omap16xx())
             ^~~~~~~~~~~~~~~~~~~~~~
arch/arm/mach-omap1/pm.c:611:9: note: initialize the variable 'irq' to
silence this warning
        int irq;
               ^
                = 0
1 warning generated.

The patch provides a default value to the `irq` variable
along with a validity check.

Signed-off-by: Maciej Falkowski <maciej.falkowski9@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1324
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap1/pm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 2c1e2b32b9b3..a745d64d4699 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -655,9 +655,13 @@ static int __init omap_pm_init(void)
 		irq = INT_7XX_WAKE_UP_REQ;
 	else if (cpu_is_omap16xx())
 		irq = INT_1610_WAKE_UP_REQ;
-	if (request_irq(irq, omap_wakeup_interrupt, 0, "peripheral wakeup",
-			NULL))
-		pr_err("Failed to request irq %d (peripheral wakeup)\n", irq);
+	else
+		irq = -1;
+
+	if (irq >= 0) {
+		if (request_irq(irq, omap_wakeup_interrupt, 0, "peripheral wakeup", NULL))
+			pr_err("Failed to request irq %d (peripheral wakeup)\n", irq);
+	}
 
 	/* Program new power ramp-up time
 	 * (0 for most boards since we don't lower voltage when in deep sleep)
-- 
2.30.2

