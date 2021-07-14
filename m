Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81293C942E
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 01:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhGNXH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 19:07:26 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:42838 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229928AbhGNXH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 19:07:26 -0400
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B01EEC0BBE;
        Wed, 14 Jul 2021 23:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1626303873; bh=sN8/PJ4qyNt5quiwEKpJiNDyd7Pwo/pNX7RtiBN1ayQ=;
        h=From:To:Cc:Subject:Date:From;
        b=P+EQDqMNdfa+wzmDaylrHVgmpE00ScY4o0n6uY2QXLPp7HREIE2Bv9UBxCSyuePRa
         XIEA/hhGFh4/xzPp/QgWAySY8u+lgjN1RcNfIp6QXCxDUFz/y5CDd/7j4PraYhmGJ2
         2xzvy25oq8BCJyr3lMayIQM2TdJQsr9ySfKucKvDO09+VNPvtwiyplfjasZ4N+AVr+
         pyzPBNqQ7lCtHw5a9Tge74yOb0HjA9npMygIJSAHerS0+PSYUhmfXdeld71ESfNJhn
         ZJAB6tn3T/qzDvJc3am9ocGzdUMpgdeVWoFJAwgsNyx/eaw/vsl+t57uPITdidqo18
         tqJBT1gmSAeOw==
Received: from vineetg-Latitude-7400.internal.synopsys.com (snps-fugpbdpduq.internal.synopsys.com [10.202.17.37])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 42A88A0251;
        Wed, 14 Jul 2021 23:04:30 +0000 (UTC)
X-SNPS-Relay: synopsys.com
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-snps-arc@lists.infradead.org, libc-alpha@sourceware.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        stable@vger.kernel.org
Subject: [PATCH] ARC: fp: set FPU_STATUS.FWE to enable FPU_STATUS update on context switch
Date:   Wed, 14 Jul 2021 16:04:26 -0700
Message-Id: <20210714230426.7141-1-vgupta@synopsys.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

FPU_STATUS register contains FP exception flags bits which are updated
as side-effect of FP instructions but can also be manually wiggled such
as by glibc C99 functions fe{raise,clear,test}except() etc.
To effect the update, the programming model requires OR'ing FWE
bit(231). This bit is write-only and RAZ, meaning it is effectively
auto-cleared after a write and thus needs to be set everytime which
is how glibc implements this.

However there's another usecase of FPU_STATUS update, at the time of
Linux task switch when incoming task value needs to be programmed into
the register. This was added as part of f45ba2bd6da0dc ("ARCv2:
fpu: preserve userspace fpu state") which however missing the OR'ing
with FWE bit, meaning the new value is not effectively being written at
all, which is what this patch fixes. This was not caught in interm glibc
testing as the race window which relies on a specific exception bit to be
set/clear is really small and will end up causing extremely hard to
reproduce/debug issues.

Fortunately this was caught by glibc's math/test-fenv-tls test which
repeatedly set/clear exception flags in a big loop, concurrently in main
program and also in a thread.

Fixes: https://github.com/foss-for-synopsys-dwc-arc-processors/linux/issues/54
Fixes: f45ba2bd6da0dc ("ARCv2: fpu: preserve userspace fpu state")
Cc: stable@vger.kernel.org	#5.6+
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/fpu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arc/kernel/fpu.c b/arch/arc/kernel/fpu.c
index c67c0f0f5f77..ec640219d989 100644
--- a/arch/arc/kernel/fpu.c
+++ b/arch/arc/kernel/fpu.c
@@ -57,23 +57,26 @@ void fpu_save_restore(struct task_struct *prev, struct task_struct *next)
 
 void fpu_init_task(struct pt_regs *regs)
 {
+	const unsigned int fwe = 0x80000000;
+
 	/* default rounding mode */
 	write_aux_reg(ARC_REG_FPU_CTRL, 0x100);
 
-	/* set "Write enable" to allow explicit write to exception flags */
-	write_aux_reg(ARC_REG_FPU_STATUS, 0x80000000);
+	/* Initialize to zero: setting requires FWE be set */
+	write_aux_reg(ARC_REG_FPU_STATUS, fwe);
 }
 
 void fpu_save_restore(struct task_struct *prev, struct task_struct *next)
 {
 	struct arc_fpu *save = &prev->thread.fpu;
 	struct arc_fpu *restore = &next->thread.fpu;
+	const unsigned int fwe = 0x80000000;
 
 	save->ctrl = read_aux_reg(ARC_REG_FPU_CTRL);
 	save->status = read_aux_reg(ARC_REG_FPU_STATUS);
 
 	write_aux_reg(ARC_REG_FPU_CTRL, restore->ctrl);
-	write_aux_reg(ARC_REG_FPU_STATUS, restore->status);
+	write_aux_reg(ARC_REG_FPU_STATUS, (fwe | restore->status));
 }
 
 #endif
-- 
2.25.1

