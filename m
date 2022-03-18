Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71544DE012
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 18:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239699AbiCRRio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 13:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239693AbiCRRii (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 13:38:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 756903076F8;
        Fri, 18 Mar 2022 10:37:19 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1CE191515;
        Fri, 18 Mar 2022 10:37:19 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 203123F7B4;
        Fri, 18 Mar 2022 10:37:18 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     James Morse <james.morse@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: fixup for [PATCH 5.4 18/43] arm64 entry: Add macro for reading symbol address from the trampoline
Date:   Fri, 18 Mar 2022 17:37:13 +0000
Message-Id: <20220318173713.2320567-1-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YjSxfK6bmH4P9IQl@kroah.com>
References: <YjSxfK6bmH4P9IQl@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

__sdei_asm_trampoline_next_handler shouldn't have its own name as the
tramp_data_read_var takes the symbol name, and generates the name for
the value in the data page if CONFIG_RANDOMIZE_BASE is clear.

This means when CONFIG_RANDOMIZE_BASE is clear, this code won't compile
as __sdei_asm_trampoline_next_handler doesn't exist.

Use the proper name, and let the macro do its thing.

Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kernel/entry.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e4b5a15c2e2e..cfc0bb6c49f7 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -1190,7 +1190,7 @@ __entry_tramp_data_start:
 __entry_tramp_data_vectors:
 	.quad	vectors
 #ifdef CONFIG_ARM_SDE_INTERFACE
-__entry_tramp_data___sdei_asm_trampoline_next_handler:
+__entry_tramp_data___sdei_asm_handler:
 	.quad	__sdei_asm_handler
 #endif /* CONFIG_ARM_SDE_INTERFACE */
 	.popsection				// .rodata
@@ -1319,7 +1319,7 @@ ENTRY(__sdei_asm_entry_trampoline)
 	 */
 1:	str	x4, [x1, #(SDEI_EVENT_INTREGS + S_ORIG_ADDR_LIMIT)]
 
-	tramp_data_read_var     x4, __sdei_asm_trampoline_next_handler
+	tramp_data_read_var     x4, __sdei_asm_handler
 	br	x4
 ENDPROC(__sdei_asm_entry_trampoline)
 NOKPROBE(__sdei_asm_entry_trampoline)
-- 
2.30.2

