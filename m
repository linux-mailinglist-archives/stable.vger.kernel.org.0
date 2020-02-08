Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D499B156644
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbgBHSdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:33:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34350 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727915AbgBHS3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:46 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-0003fw-RU; Sat, 08 Feb 2020 18:29:37 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrI-000CPi-Fi; Sat, 08 Feb 2020 18:29:36 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Alastair D'Silva" <alastair@d-silva.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>
Date:   Sat, 08 Feb 2020 18:20:17 +0000
Message-ID: <lsq.1581185940.696641548@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 078/148] powerpc: Allow 64bit VDSO __kernel_sync_dicache
 to work across ranges >4GB
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alastair D'Silva <alastair@d-silva.org>

commit f9ec11165301982585e5e5f606739b5bae5331f3 upstream.

When calling __kernel_sync_dicache with a size >4GB, we were masking
off the upper 32 bits, so we would incorrectly flush a range smaller
than intended.

This patch replaces the 32 bit shifts with 64 bit ones, so that
the full size is accounted for.

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191104023305.9581-3-alastair@au1.ibm.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/vdso64/cacheflush.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/vdso64/cacheflush.S
+++ b/arch/powerpc/kernel/vdso64/cacheflush.S
@@ -39,7 +39,7 @@ V_FUNCTION_BEGIN(__kernel_sync_dicache)
 	subf	r8,r6,r4		/* compute length */
 	add	r8,r8,r5		/* ensure we get enough */
 	lwz	r9,CFG_DCACHE_LOGBLOCKSZ(r10)
-	srw.	r8,r8,r9		/* compute line count */
+	srd.	r8,r8,r9		/* compute line count */
 	crclr	cr0*4+so
 	beqlr				/* nothing to do? */
 	mtctr	r8
@@ -56,7 +56,7 @@ V_FUNCTION_BEGIN(__kernel_sync_dicache)
 	subf	r8,r6,r4		/* compute length */
 	add	r8,r8,r5
 	lwz	r9,CFG_ICACHE_LOGBLOCKSZ(r10)
-	srw.	r8,r8,r9		/* compute line count */
+	srd.	r8,r8,r9		/* compute line count */
 	crclr	cr0*4+so
 	beqlr				/* nothing to do? */
 	mtctr	r8

