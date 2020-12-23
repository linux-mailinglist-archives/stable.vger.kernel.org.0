Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD532E163E
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgLWCUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:20:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728722AbgLWCUJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98064229C5;
        Wed, 23 Dec 2020 02:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689994;
        bh=8zxW0Coq79vbFKcoFtkC/3t6V/TI80uwbocuc8zfZKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+zSVQVPQw3Bxj6OdH4XybodwVrKyZYOqI59X0rG7ynAl8DH2NEH5KYBSTxXV2NRn
         r/9qYsllMDKLtXfqWY7ripXDPjNT8MxHwr7OTSRVt37S51zRFJOnnnbt1i2eHw7rxa
         GsbWfCI9lq99kWGzP9ZxL7eo3ogghCj6/FjZ8JzVvg59Y72iJkUiL58QhA5eSRpfq0
         l7G0FzrSDZVpTGMEbR5eDHUwy82iZUSqC9aztHLHp5nXkEqgCnOL1v/XHLpm2SOb8X
         OWhmbi/WMbkhh8aqTjcnWppTYorL0i5slDZdPPnaDI0KYmKyegCjBzHtqkcUOLbz69
         FsXmjyQQBhnWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gabriele Paoloni <gabriele.paoloni@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 078/130] x86/mce: Move the mce_panic() call and 'kill_it' assignments to the right places
Date:   Tue, 22 Dec 2020 21:17:21 -0500
Message-Id: <20201223021813.2791612-78-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriele Paoloni <gabriele.paoloni@intel.com>

[ Upstream commit e273e6e12ab1db3eb57712bd60655744d0091fa3 ]

Right now, for local MCEs the machine calls panic(), if needed, right
after lmce is set. For MCE broadcasting, mce_reign() takes care of
calling mce_panic().

Hence:
- improve readability by moving the conditional evaluation of
tolerant up to when kill_it is set first;
- move the mce_panic() call up into the statement where mce_end()
fails.

 [ bp: Massage, remove comment in the mce_end() failure case because it
   is superfluous; use local ptr 'cfg' in both tests. ]

Signed-off-by: Gabriele Paoloni <gabriele.paoloni@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/20201127161819.3106432-3-gabriele.paoloni@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/core.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index c2a9762d278dd..10f69e045d3ea 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1328,8 +1328,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * severity is MCE_AR_SEVERITY we have other options.
 	 */
 	if (!(m.mcgstatus & MCG_STATUS_RIPV))
-		kill_it = 1;
-
+		kill_it = (cfg->tolerant == 3) ? 0 : 1;
 	/*
 	 * Check if this MCE is signaled to only this logical processor,
 	 * on Intel only.
@@ -1364,6 +1363,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (mce_end(order) < 0) {
 			if (!no_way_out)
 				no_way_out = worst >= MCE_PANIC_SEVERITY;
+
+			if (no_way_out && cfg->tolerant < 3)
+				mce_panic("Fatal machine check on current CPU", &m, msg);
 		}
 	} else {
 		/*
@@ -1380,15 +1382,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		}
 	}
 
-	/*
-	 * If tolerant is at an insane level we drop requests to kill
-	 * processes and continue even when there is no way out.
-	 */
-	if (cfg->tolerant == 3)
-		kill_it = 0;
-	else if (no_way_out)
-		mce_panic("Fatal machine check on current CPU", &m, msg);
-
 	if (worst > 0)
 		irq_work_queue(&mce_irq_work);
 
-- 
2.27.0

