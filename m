Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20133A9F74
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbhFPPiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234912AbhFPPh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:37:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73F65613C2;
        Wed, 16 Jun 2021 15:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857721;
        bh=PIMvvOdcHM/UaNyjKsmWLK9cCLAZzAi4AH7zS+RZbIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3dMnzkr6OY5BuHGwOaXA68GLvDyIR9Q/AirkG3aEaxDYMSkN1J9lUlaBj4f69797
         fNBU1QmlCuy2awvhnpSCh89I4dlWQhhRJNDckoO9V20zZz6TQpWFiQdpqXLgaR322+
         NNtJvM7Q1VR6q6vw87yBjRPqzs1gnKewc52A2r18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Falkowski <maciej.falkowski9@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/38] ARM: OMAP1: Fix use of possibly uninitialized irq variable
Date:   Wed, 16 Jun 2021 17:33:22 +0200
Message-Id: <20210616152835.820371184@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



