Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6038E2C9B74
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389277AbgLAJIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:08:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389266AbgLAJIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:08:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDE2D22245;
        Tue,  1 Dec 2020 09:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813675;
        bh=OIl2PaLR6m+mUydIo7T59Uy4mlHqDn+kQDtyLPEktvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGpOLu8VQqTynyZLFGZkUaUiJHkgcZo8T8r2iJUqVsyMGsfeXRCSmzLBmjmLJ9WCw
         Yvwz7XY73iQhAwgQUiSrdZJfoLUbLooaNY6QuhfKILZrqw1kXfpsU8BSlHsmq/Ugfy
         LJizv9BpRIZ+KF8XRzNPewUiT9+xLgGQPyKcKHe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.9 021/152] powerpc/64s/exception: KVM Fix for host DSI being taken in HPT guest MMU context
Date:   Tue,  1 Dec 2020 09:52:16 +0100
Message-Id: <20201201084714.627633394@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit cd81acc600a9684ea4b4d25a47900d38a3890eab upstream.

Commit 2284ffea8f0c ("powerpc/64s/exception: Only test KVM in SRR
interrupts when PR KVM is supported") removed KVM guest tests from
interrupts that do not set HV=1, when PR-KVM is not configured.

This is wrong for HV-KVM HPT guest MMIO emulation case which attempts
to load the faulting instruction word with MSR[DR]=1 and MSR[HV]=1 with
the guest MMU context loaded. This can cause host DSI, DSLB interrupts
which must test for KVM guest. Restore this and add a comment.

Fixes: 2284ffea8f0c ("powerpc/64s/exception: Only test KVM in SRR interrupts when PR KVM is supported")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201117135617.3521127-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/exceptions-64s.S |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1410,6 +1410,11 @@ END_FTR_SECTION_IFSET(CPU_FTR_HVMODE)
  *   If none is found, do a Linux page fault. Linux page faults can happen in
  *   kernel mode due to user copy operations of course.
  *
+ *   KVM: The KVM HDSI handler may perform a load with MSR[DR]=1 in guest
+ *   MMU context, which may cause a DSI in the host, which must go to the
+ *   KVM handler. MSR[IR] is not enabled, so the real-mode handler will
+ *   always be used regardless of AIL setting.
+ *
  * - Radix MMU
  *   The hardware loads from the Linux page table directly, so a fault goes
  *   immediately to Linux page fault.
@@ -1420,10 +1425,8 @@ INT_DEFINE_BEGIN(data_access)
 	IVEC=0x300
 	IDAR=1
 	IDSISR=1
-#ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
 	IKVM_SKIP=1
 	IKVM_REAL=1
-#endif
 INT_DEFINE_END(data_access)
 
 EXC_REAL_BEGIN(data_access, 0x300, 0x80)
@@ -1462,6 +1465,8 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TY
  *   ppc64_bolted_size (first segment). The kernel handler must avoid stomping
  *   on user-handler data structures.
  *
+ *   KVM: Same as 0x300, DSLB must test for KVM guest.
+ *
  * A dedicated save area EXSLB is used (XXX: but it actually need not be
  * these days, we could use EXGEN).
  */
@@ -1470,10 +1475,8 @@ INT_DEFINE_BEGIN(data_access_slb)
 	IAREA=PACA_EXSLB
 	IRECONCILE=0
 	IDAR=1
-#ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
 	IKVM_SKIP=1
 	IKVM_REAL=1
-#endif
 INT_DEFINE_END(data_access_slb)
 
 EXC_REAL_BEGIN(data_access_slb, 0x380, 0x80)


