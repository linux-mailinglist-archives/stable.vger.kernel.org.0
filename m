Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0CB1B36AB
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 07:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgDVFF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 01:05:26 -0400
Received: from mo-csw1114.securemx.jp ([210.130.202.156]:33430 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgDVFF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 01:05:26 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 03M54lDi014206; Wed, 22 Apr 2020 14:04:47 +0900
X-Iguazu-Qid: 2wHHD3mIzV4SsgL3yt
X-Iguazu-QSIG: v=2; s=0; t=1587531886; q=2wHHD3mIzV4SsgL3yt; m=EehSSJHdxcxkrgypKG6sKnjKS7l7/XclzvaqBI3r4nA=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1112) id 03M54fxB006531;
        Wed, 22 Apr 2020 14:04:45 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 03M54fl1020687;
        Wed, 22 Apr 2020 14:04:41 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 03M54fTh027946;
        Wed, 22 Apr 2020 14:04:41 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Samuel Neves <sneves@dei.uc.pt>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH  for 4.4 and 4.9] x86/vdso: Fix lsl operand order
Date:   Wed, 22 Apr 2020 14:04:28 +0900
X-TSB-HOP: ON
Message-Id: <20200422050428.1110192-1-nobuhiro1.iwamatsu@toshiba.co.jp>
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

