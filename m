Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C14C5A47E0
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiH2LCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiH2LCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:02:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A9812629;
        Mon, 29 Aug 2022 04:02:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 414B9B80EF3;
        Mon, 29 Aug 2022 11:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3BAC433D6;
        Mon, 29 Aug 2022 11:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770925;
        bh=Xbum2y2w9I//FEatEVKCLlgTgDxwECszg8Je8VtlIRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBmppjzBZhBPYDQERxotmmxr0E+mZvMNE+G0UXjFBn4ASH8Up6pqHSgDgA5cDujtx
         SYuMcWuQC97dtBMtTuPhqs/SQFd1726FQLRPW5c6rPG2YkWwgtFYjnSdLtHsm8aSLh
         MsiUdaurJSY+jkLWR6nhPG/6ZjjJA2fG6kjGx7bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/136] riscv: lib: uaccess: fold fixups into body
Date:   Mon, 29 Aug 2022 12:58:11 +0200
Message-Id: <20220829105805.566116022@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 9d504f9aa5c1b76673018da9503e76b351a24b8c ]

uaccess functions such __asm_copy_to_user(),  __arch_copy_from_user()
and __clear_user() place their exception fixups in the `.fixup` section
without any clear association with themselves. If we backtrace the
fixup code, it will be symbolized as an offset from the nearest prior
symbol.

Similar as arm64 does, we must move fixups into the body of the
functions themselves, after the usual fast-path returns.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/lib/uaccess.S | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
index 63bc691cff91b..ac34f0026adcd 100644
--- a/arch/riscv/lib/uaccess.S
+++ b/arch/riscv/lib/uaccess.S
@@ -173,6 +173,13 @@ ENTRY(__asm_copy_from_user)
 	csrc CSR_STATUS, t6
 	li	a0, 0
 	ret
+
+	/* Exception fixup code */
+10:
+	/* Disable access to user memory */
+	csrs CSR_STATUS, t6
+	mv a0, t5
+	ret
 ENDPROC(__asm_copy_to_user)
 ENDPROC(__asm_copy_from_user)
 EXPORT_SYMBOL(__asm_copy_to_user)
@@ -218,19 +225,12 @@ ENTRY(__clear_user)
 	addi a0, a0, 1
 	bltu a0, a3, 5b
 	j 3b
-ENDPROC(__clear_user)
-EXPORT_SYMBOL(__clear_user)
 
-	.section .fixup,"ax"
-	.balign 4
-	/* Fixup code for __copy_user(10) and __clear_user(11) */
-10:
-	/* Disable access to user memory */
-	csrs CSR_STATUS, t6
-	mv a0, t5
-	ret
+	/* Exception fixup code */
 11:
+	/* Disable access to user memory */
 	csrs CSR_STATUS, t6
 	mv a0, a1
 	ret
-	.previous
+ENDPROC(__clear_user)
+EXPORT_SYMBOL(__clear_user)
-- 
2.35.1



