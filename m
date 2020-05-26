Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75CA1CAB73
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgEHMnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729095AbgEHMni (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E71B206B8;
        Fri,  8 May 2020 12:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941817;
        bh=JxDTP/jEDm4nDFAV9NBWKwOiM24wbS+ZzoghH7uSflk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2uLzG+ur9Vlb0hOdxDspXbzKzHBZoh3AOmKhiVq55S9CWuOxk1TpHKAykP0q+93Gk
         lGPcgUMFS03ea5CyA7s9HFL0K8soC5wxe/T/IMHGzu1/MMg2prBoEWqLCVhCno5JSM
         0nRw+nZVpJpysGr33IUJF7drBBGjvKEkVNNhGfiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Neuling <mikey@neuling.org>,
        Cyril Bur <cyrilbur@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 147/312] powerpc/tm: Fix stack pointer corruption in __tm_recheckpoint()
Date:   Fri,  8 May 2020 14:32:18 +0200
Message-Id: <20200508123134.800376765@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Neuling <mikey@neuling.org>

commit 6bcb80143e792becfd2b9cc6a339ce523e4e2219 upstream.

At the start of __tm_recheckpoint() we save the kernel stack pointer
(r1) in SPRG SCRATCH0 (SPRG2) so that we can restore it after the
trecheckpoint.

Unfortunately, the same SPRG is used in the SLB miss handler.  If an
SLB miss is taken between the save and restore of r1 to the SPRG, the
SPRG is changed and hence r1 is also corrupted.  We can end up with
the following crash when we start using r1 again after the restore
from the SPRG:

  Oops: Bad kernel stack pointer, sig: 6 [#1]
  SMP NR_CPUS=2048 NUMA pSeries
  CPU: 658 PID: 143777 Comm: htm_demo Tainted: G            EL   X 4.4.13-0-default #1
  task: c0000b56993a7810 ti: c00000000cfec000 task.ti: c0000b56993bc000
  NIP: c00000000004f188 LR: 00000000100040b8 CTR: 0000000010002570
  REGS: c00000000cfefd40 TRAP: 0300   Tainted: G            EL   X  (4.4.13-0-default)
  MSR: 8000000300001033 <SF,ME,IR,DR,RI,LE>  CR: 02000424  XER: 20000000
  CFAR: c000000000008468 DAR: 00003ffd84e66880 DSISR: 40000000 SOFTE: 0
  PACATMSCRATCH: 00003ffbc865e680
  GPR00: fffffffcfabc4268 00003ffd84e667a0 00000000100d8c38 000000030544bb80
  GPR04: 0000000000000002 00000000100cf200 0000000000000449 00000000100cf100
  GPR08: 000000000000c350 0000000000002569 0000000000002569 00000000100d6c30
  GPR12: 00000000100d6c28 c00000000e6a6b00 00003ffd84660000 0000000000000000
  GPR16: 0000000000000003 0000000000000449 0000000010002570 0000010009684f20
  GPR20: 0000000000800000 00003ffd84e5f110 00003ffd84e5f7a0 00000000100d0f40
  GPR24: 0000000000000000 0000000000000000 0000000000000000 00003ffff0673f50
  GPR28: 00003ffd84e5e960 00000000003d0f00 00003ffd84e667a0 00003ffd84e5e680
  NIP [c00000000004f188] restore_gprs+0x110/0x17c
  LR [00000000100040b8] 0x100040b8
  Call Trace:
  Instruction dump:
  f8a1fff0 e8e700a8 38a00000 7ca10164 e8a1fff8 e821fff0 7c0007dd 7c421378
  7db142a6 7c3242a6 38800002 7c810164 <e9c100e0> e9e100e8 ea0100f0 ea2100f8

We hit this on large memory machines (> 2TB) but it can also be hit on
smaller machines when 1TB segments are disabled.

To hit this, you also need to be virtualised to ensure SLBs are
periodically removed by the hypervisor.

This patches moves the saving of r1 to the SPRG to the region where we
are guaranteed not to take any further SLB misses.

Fixes: 98ae22e15b43 ("powerpc: Add helper functions for transactional memory context switching")
Cc: stable@vger.kernel.org # v3.9+
Signed-off-by: Michael Neuling <mikey@neuling.org>
Acked-by: Cyril Bur <cyrilbur@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/tm.S |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/powerpc/kernel/tm.S
+++ b/arch/powerpc/kernel/tm.S
@@ -352,8 +352,6 @@ _GLOBAL(__tm_recheckpoint)
 	 */
 	subi	r7, r7, STACK_FRAME_OVERHEAD
 
-	SET_SCRATCH0(r1)
-
 	mfmsr	r6
 	/* R4 = original MSR to indicate whether thread used FP/Vector etc. */
 
@@ -482,6 +480,7 @@ restore_gprs:
 	 * until we turn MSR RI back on.
 	 */
 
+	SET_SCRATCH0(r1)
 	ld	r5, -8(r1)
 	ld	r1, -16(r1)
 


