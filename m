Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 263D32F1AC
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730570AbfE3DQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:16:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729566AbfE3DQC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:02 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84F39245C4;
        Thu, 30 May 2019 03:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186161;
        bh=oi8lKQ5r/i49dFb9dykc0Y0t9E2sFOuG489GbRWGmc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qtTn2FDPtUpo/7YMD8wo2asV0DTGtZlBJjOv2hyjkbXSae7mdhvywpP//4iJh0KiT
         VfFWupNX2HrPtOy6kT+V1uiLKI8epcyU8Zt+1/fuUt2ANZXhhzQbODeinX06+jVp4J
         AXD030tct8tI2LbIZcY1Gnazm0OJ57UZzg+SgU9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 001/276] x86: Hide the int3_emulate_call/jmp functions from UML
Date:   Wed, 29 May 2019 20:02:39 -0700
Message-Id: <20190530030523.290639899@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 693713cbdb3a4bda5a8a678c31f06560bbb14657 upstream.

User Mode Linux does not have access to the ip or sp fields of the pt_regs,
and accessing them causes UML to fail to build. Hide the int3_emulate_jmp()
and int3_emulate_call() instructions from UML, as it doesn't need them
anyway.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/text-patching.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -39,6 +39,7 @@ extern int poke_int3_handler(struct pt_r
 extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
 extern int after_bootmem;
 
+#ifndef CONFIG_UML_X86
 static inline void int3_emulate_jmp(struct pt_regs *regs, unsigned long ip)
 {
 	regs->ip = ip;
@@ -65,6 +66,7 @@ static inline void int3_emulate_call(str
 	int3_emulate_push(regs, regs->ip - INT3_INSN_SIZE + CALL_INSN_SIZE);
 	int3_emulate_jmp(regs, func);
 }
-#endif
+#endif /* CONFIG_X86_64 */
+#endif /* !CONFIG_UML_X86 */
 
 #endif /* _ASM_X86_TEXT_PATCHING_H */


