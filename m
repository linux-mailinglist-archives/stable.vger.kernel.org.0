Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DC4521597
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 14:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbiEJMlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 08:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241324AbiEJMlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 08:41:50 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DAD24D617;
        Tue, 10 May 2022 05:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1652186272; x=1683722272;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bE2GOy6zlpqOoRX6zYpnJAL0E/MfIkSIFEmV3eldp8g=;
  b=eZbJJjnPf6mf8cQPPkSwCsrsHttF36WPxATA9Rgy4PKtFqz4DvZNjcrj
   ZcF9W/w8xmnRx7JUbBopLe4/drCddYwdFFivNf1kM9h+2BhYlRhOf/MwZ
   ycMfRQ7db25xPCphERUda9wL7i472SsiTXZjGtZNyVGuTe8uiIRg3JsoS
   A=;
X-IronPort-AV: E=Sophos;i="5.91,214,1647302400"; 
   d="scan'208";a="1014326555"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 10 May 2022 12:37:27 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com (Postfix) with ESMTPS id 0A4E441CEE;
        Tue, 10 May 2022 12:37:27 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 10 May 2022 12:37:26 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.162.96) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 10 May 2022 12:37:24 +0000
From:   Alexander Graf <graf@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Matt Evans <matt@ozlabs.org>, <stable@vger.kernel.org>
Subject: [PATCH v3] KVM: PPC: Book3S PR: Enable MSR_DR for switch_mmu_context()
Date:   Tue, 10 May 2022 14:37:17 +0200
Message-ID: <20220510123717.24508-1-graf@amazon.com>
X-Mailer: git-send-email 2.28.0.394.ge197136389
MIME-Version: 1.0
X-Originating-IP: [10.43.162.96]
X-ClientProxiedBy: EX13D03UWC002.ant.amazon.com (10.43.162.160) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 863771a28e27 ("powerpc/32s: Convert switch_mmu_context() to C")
moved the switch_mmu_context() to C. While in principle a good idea, it
meant that the function now uses the stack. The stack is not accessible
from real mode though.

So to keep calling the function, let's turn on MSR_DR while we call it.
That way, all pointer references to the stack are handled virtually.

In addition, make sure to save/restore r12 on the stack, as it may get
clobbered by the C function.

Reported-by: Matt Evans <matt@ozlabs.org>
Fixes: 863771a28e27 ("powerpc/32s: Convert switch_mmu_context() to C")
Signed-off-by: Alexander Graf <graf@amazon.com>
Cc: stable@vger.kernel.org # v5.14+

---

v1 -> v2:

  - Save and restore R12, so that we don't touch volatile registers
    while calling into C.

v2 -> v3:

  - Save and restore R12 on the stack. SPRGs may be clobbered by
    page faults.
---
 arch/powerpc/kvm/book3s_32_sr.S | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_32_sr.S b/arch/powerpc/kvm/book3s_32_sr.S
index e3ab9df6cf19..6cfcd20d4668 100644
--- a/arch/powerpc/kvm/book3s_32_sr.S
+++ b/arch/powerpc/kvm/book3s_32_sr.S
@@ -122,11 +122,27 @@
 
 	/* 0x0 - 0xb */
 
-	/* 'current->mm' needs to be in r4 */
-	tophys(r4, r2)
-	lwz	r4, MM(r4)
-	tophys(r4, r4)
-	/* This only clobbers r0, r3, r4 and r5 */
+	/* switch_mmu_context() needs paging, let's enable it */
+	mfmsr   r9
+	ori     r11, r9, MSR_DR
+	mtmsr   r11
+	sync
+
+	/* switch_mmu_context() clobbers r12, rescue it */
+	SAVE_GPR(12, r1)
+
+	/* Calling switch_mmu_context(<inv>, current->mm, <inv>); */
+	lwz	r4, MM(r2)
 	bl	switch_mmu_context
 
+	/* restore r12 */
+	REST_GPR(12, r1)
+
+	/* Disable paging again */
+	mfmsr   r9
+	li      r6, MSR_DR
+	andc    r9, r9, r6
+	mtmsr	r9
+	sync
+
 .endm
-- 
2.28.0.394.ge197136389




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



