Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA72041253F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382886AbhITSmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382502AbhITSkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:40:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 854146333C;
        Mon, 20 Sep 2021 17:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159090;
        bh=oCcN4ZY5S+aUwN0NRWHzeKfycl/SB8RjIQ71p8yVtug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06cAdFQqZr5bf6IRDjbuIbr+yUWW5M/1zRPQvBqGXPPOjdh0Z7P2DzXA7VyQFI4+m
         R+8v0wpl3wEY9+Ja3BHIeOI9ADaFwIychTX2zNSoPvIdmQZCdnVKTnhxGnuvC2nKBn
         NMsjSUkwvNQI+QcQZnPoLqv+06Nh13mBG4QtzazM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ganesh Goudar <ganeshgr@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.14 072/168] powerpc/mce: Fix access error in mce handler
Date:   Mon, 20 Sep 2021 18:43:30 +0200
Message-Id: <20210920163924.010676718@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ganesh Goudar <ganeshgr@linux.ibm.com>

commit 3a1e92d0896e928ac2a5b58962d05a39afef2e23 upstream.

We queue an irq work for deferred processing of mce event in realmode
mce handler, where translation is disabled. Queuing of the work may
result in accessing memory outside RMO region, such access needs the
translation to be enabled for an LPAR running with hash mmu else the
kernel crashes.

After enabling translation in mce_handle_error() we used to leave it
enabled to avoid crashing here, but now with the commit
74c3354bc1d89 ("powerpc/pseries/mce: restore msr before returning from
handler") we are restoring the MSR to disable translation.

Hence to fix this enable the translation before queuing the work.

Without this change following trace is seen on injecting SLB multihit in
an LPAR running with hash mmu.

  Oops: Kernel access of bad area, sig: 11 [#1]
  LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
  CPU: 5 PID: 1883 Comm: insmod Tainted: G        OE     5.14.0-mce+ #137
  NIP:  c000000000735d60 LR: c000000000318640 CTR: 0000000000000000
  REGS: c00000001ebff9a0 TRAP: 0300   Tainted: G       OE      (5.14.0-mce+)
  MSR:  8000000000001003 <SF,ME,RI,LE>  CR: 28008228  XER: 00000001
  CFAR: c00000000031863c DAR: c00000027fa8fe08 DSISR: 40000000 IRQMASK: 0
  ...
  NIP llist_add_batch+0x0/0x40
  LR  __irq_work_queue_local+0x70/0xc0
  Call Trace:
    0xc00000001ebffc0c (unreliable)
    irq_work_queue+0x40/0x70
    machine_check_queue_event+0xbc/0xd0
    machine_check_early_common+0x16c/0x1f4

Fixes: 74c3354bc1d89 ("powerpc/pseries/mce: restore msr before returning from handler")
Signed-off-by: Ganesh Goudar <ganeshgr@linux.ibm.com>
[mpe: Fix comment formatting, trim oops in change log for readability]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210909064330.312432-1-ganeshgr@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/mce.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/mce.c
+++ b/arch/powerpc/kernel/mce.c
@@ -249,6 +249,7 @@ void machine_check_queue_event(void)
 {
 	int index;
 	struct machine_check_event evt;
+	unsigned long msr;
 
 	if (!get_mce_event(&evt, MCE_EVENT_RELEASE))
 		return;
@@ -262,8 +263,20 @@ void machine_check_queue_event(void)
 	memcpy(&local_paca->mce_info->mce_event_queue[index],
 	       &evt, sizeof(evt));
 
-	/* Queue irq work to process this event later. */
-	irq_work_queue(&mce_event_process_work);
+	/*
+	 * Queue irq work to process this event later. Before
+	 * queuing the work enable translation for non radix LPAR,
+	 * as irq_work_queue may try to access memory outside RMO
+	 * region.
+	 */
+	if (!radix_enabled() && firmware_has_feature(FW_FEATURE_LPAR)) {
+		msr = mfmsr();
+		mtmsr(msr | MSR_IR | MSR_DR);
+		irq_work_queue(&mce_event_process_work);
+		mtmsr(msr);
+	} else {
+		irq_work_queue(&mce_event_process_work);
+	}
 }
 
 void mce_common_process_ue(struct pt_regs *regs,


