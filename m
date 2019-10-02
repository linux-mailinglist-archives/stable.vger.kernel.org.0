Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED10C91B9
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbfJBTIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:08:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35624 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729231AbfJBTIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:12 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyr-00035x-Bv; Wed, 02 Oct 2019 20:08:09 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyo-0003dY-Bv; Wed, 02 Oct 2019 20:08:06 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Helge Deller" <deller@gmx.de>,
        "John David Anglin" <dave.anglin@bell.net>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.864935705@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 46/87] parisc: Use implicit space register selection
 for loading the coherence index of I/O pdirs
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit 63923d2c3800919774f5c651d503d1dd2adaddd5 upstream.

We only support I/O to kernel space. Using %sr1 to load the coherence
index may be racy unless interrupts are disabled. This patch changes the
code used to load the coherence index to use implicit space register
selection. This saves one instruction and eliminates the race.

Tested on rp3440, c8000 and c3750.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/parisc/ccio-dma.c  | 4 +---
 drivers/parisc/sba_iommu.c | 3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -563,8 +563,6 @@ ccio_io_pdir_entry(u64 *pdir_ptr, space_
 	/* We currently only support kernel addresses */
 	BUG_ON(sid != KERNEL_SPACE);
 
-	mtsp(sid,1);
-
 	/*
 	** WORD 1 - low order word
 	** "hints" parm includes the VALID bit!
@@ -595,7 +593,7 @@ ccio_io_pdir_entry(u64 *pdir_ptr, space_
 	** Grab virtual index [0:11]
 	** Deposit virt_idx bits into I/O PDIR word
 	*/
-	asm volatile ("lci %%r0(%%sr1, %1), %0" : "=r" (ci) : "r" (vba));
+	asm volatile ("lci %%r0(%1), %0" : "=r" (ci) : "r" (vba));
 	asm volatile ("extru %1,19,12,%0" : "+r" (ci) : "r" (ci));
 	asm volatile ("depw  %1,15,12,%0" : "+r" (pa) : "r" (ci));
 
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -573,8 +573,7 @@ sba_io_pdir_entry(u64 *pdir_ptr, space_t
 	pa = virt_to_phys(vba);
 	pa &= IOVP_MASK;
 
-	mtsp(sid,1);
-	asm("lci 0(%%sr1, %1), %0" : "=r" (ci) : "r" (vba));
+	asm("lci 0(%1), %0" : "=r" (ci) : "r" (vba));
 	pa |= (ci >> PAGE_SHIFT) & 0xff;  /* move CI (8 bits) into lowest byte */
 
 	pa |= SBA_PDIR_VALID_BIT;	/* set "valid" bit */

