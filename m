Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB55212FBE
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 01:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgGBXCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 19:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgGBXCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 19:02:06 -0400
X-Greylist: delayed 482 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Jul 2020 16:02:06 PDT
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537CFC08C5C1;
        Thu,  2 Jul 2020 16:02:06 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 49yYLH2Jg0zQlH5;
        Fri,  3 Jul 2020 00:53:59 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id j0GeXSc04_hr; Fri,  3 Jul 2020 00:53:56 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     tsbogend@alpha.franken.de, linux-mips@vger.kernel.org
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, stable@vger.kernel.org
Subject: [PATCH] MIPS: Add missing EHB in mtc0 -> mfc0 sequence for DSPen
Date:   Fri,  3 Jul 2020 00:53:34 +0200
Message-Id: <20200702225334.32414-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 0
X-Rspamd-Score: -0.75 / 15.00 / 15.00
X-Rspamd-Queue-Id: 422C1174A
X-Rspamd-UID: 6831da
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This resolves the hazard between the mtc0 in the change_c0_status() and
the mfc0 in configure_exception_vector(). Without resolving this hazard
configure_exception_vector() could read an old value and would restore
this old value again. This would revert the changes change_c0_status()
did. I checked this by printing out the read_c0_status() at the end of
per_cpu_trap_init() and the ST0_MX is not set without this patch.

The hazard is documented in the MIPS Architecture Reference Manual Vol.
III: MIPS32/microMIPS32 Privileged Resource Architecture (MD00088), rev
6.03 table 8.1 which includes:

   Producer | Consumer | Hazard
  ----------|----------|----------------------------
   mtc0     | mfc0     | any coprocessor 0 register

I saw this hazard on an Atheros AR9344 rev 2 SoC with a MIPS 74Kc CPU.
There the change_c0_status() function would activate the DSPen by
setting ST0_MX in the c0_status register. This was reverted and then the
system got a DSP exception when the DSP registers were saved in
save_dsp() in the first process switch. The crash looks like this:

[    0.089999] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
[    0.097796] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
[    0.107070] Kernel panic - not syncing: Unexpected DSP exception
[    0.113470] Rebooting in 1 seconds..

We saw this problem in OpenWrt only on the MIPS 74Kc based Atheros SoCs,
not on the 24Kc based SoCs. We only saw it with kernel 5.4 not with
kernel 4.19, in addition we had to use GCC 8.4 or 9.X, with GCC 8.3 it
did not happen.

In the kernel I bisected this problem to commit 9012d011660e ("compiler:
allow all arches to enable CONFIG_OPTIMIZE_INLINING"), but when this was
reverted it also happened after commit 172dcd935c34b ("MIPS: Always
allocate exception vector for MIPSr2+").

Commit 0b24cae4d535 ("MIPS: Add missing EHB in mtc0 -> mfc0 sequence.")
does similar changes to a different file. I am not sure if there are
more places affected by this problem.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Cc: <stable@vger.kernel.org>
---
 arch/mips/kernel/traps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 7c32c956156a..1234ea21dd8f 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -2169,6 +2169,7 @@ static void configure_status(void)
 
 	change_c0_status(ST0_CU|ST0_MX|ST0_RE|ST0_FR|ST0_BEV|ST0_TS|ST0_KX|ST0_SX|ST0_UX,
 			 status_set);
+	back_to_back_c0_hazard();
 }
 
 unsigned int hwrena;
-- 
2.20.1

