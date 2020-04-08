Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBC41A1D59
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 10:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgDHIYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 04:24:37 -0400
Received: from mo-csw1114.securemx.jp ([210.130.202.156]:33024 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgDHIYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 04:24:37 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 0388OZ0V014131; Wed, 8 Apr 2020 17:24:35 +0900
X-Iguazu-Qid: 2wHHbNmoFLwY5L1B2o
X-Iguazu-QSIG: v=2; s=0; t=1586334274; q=2wHHbNmoFLwY5L1B2o; m=xiDJl1g6+R84KiuIFTxihTIlTSkBPcUwRlOJaNyd/DE=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1110) id 0388OYQ6039024;
        Wed, 8 Apr 2020 17:24:34 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 0388OYFO018793
        for <stable@vger.kernel.org>; Wed, 8 Apr 2020 17:24:34 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 0388OYuI022627
        for <stable@vger.kernel.org>; Wed, 8 Apr 2020 17:24:34 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Subject: [PATCH for 4.4.y] x86/vdso: Fix lsl operand order
Date:   Wed,  8 Apr 2020 17:24:30 +0900
X-TSB-HOP: ON
Message-Id: <20200408082430.4132299-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Neves <sneves@dei.uc.pt>

commit e78e5a91456fcecaa2efbb3706572fe043766f4d upstream.

In the __getcpu function, lsl is using the wrong target and destination
registers. Luckily, the compiler tends to choose %eax for both variables,
so it has been working so far.

Fixes: a582c540ac1b ("x86/vdso: Use RDPID in preference to LSL when available")
Signed-off-by: Samuel Neves <sneves@dei.uc.pt>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Andy Lutomirski <luto@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20180901201452.27828-1-sneves@dei.uc.pt
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 arch/x86/include/asm/vgtod.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 51e7533bbf79e..ef342818fcf11 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -86,7 +86,7 @@ static inline unsigned int __getcpu(void)
 	 *
 	 * If RDPID is available, use it.
 	 */
-	alternative_io ("lsl %[p],%[seg]",
+	alternative_io ("lsl %[seg],%[p]",
 			".byte 0xf3,0x0f,0xc7,0xf8", /* RDPID %eax/rax */
 			X86_FEATURE_RDPID,
 			[p] "=a" (p), [seg] "r" (__PER_CPU_SEG));
-- 
2.26.0

