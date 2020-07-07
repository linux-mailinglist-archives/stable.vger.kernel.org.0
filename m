Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D21216FD2
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgGGPKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728492AbgGGPKu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:10:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6892420674;
        Tue,  7 Jul 2020 15:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134649;
        bh=dxPAnu+QUeb8GHs9JmFoF4WsmUsrXtWVFlxVUxpCAQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEQm/LxbBJly5B8PrIVI3a2qePorzQ81usXYvowLs4ZEzmyJ2IFDni/dMw7sMZX5D
         41PRwBgChZ5cpXd3l3Iwewc+itYTkERKAOEDvPP7SVtLbxMHGWa6nsBK+p3I5lGtQH
         Lxz7st/5PVgNskrdGJASdZJEOipfcmrcibu2jyuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.4 18/19] MIPS: Add missing EHB in mtc0 -> mfc0 sequence for DSPen
Date:   Tue,  7 Jul 2020 17:10:21 +0200
Message-Id: <20200707145748.411814202@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145747.493710555@linuxfoundation.org>
References: <20200707145747.493710555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>

commit fcec538ef8cca0ad0b84432235dccd9059c8e6f8 upstream.

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
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/traps.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -2080,6 +2080,7 @@ static void configure_status(void)
 
 	change_c0_status(ST0_CU|ST0_MX|ST0_RE|ST0_FR|ST0_BEV|ST0_TS|ST0_KX|ST0_SX|ST0_UX,
 			 status_set);
+	back_to_back_c0_hazard();
 }
 
 /* configure HWRENA register */


