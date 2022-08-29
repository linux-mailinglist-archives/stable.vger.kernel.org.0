Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3806F5A47E2
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiH2LCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiH2LCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:02:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E194DF21;
        Mon, 29 Aug 2022 04:02:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68D2161132;
        Mon, 29 Aug 2022 11:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC4DC433B5;
        Mon, 29 Aug 2022 11:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770928;
        bh=WRUsUFdOc9sND/MlPr5Ul0+JGH0AnPLPlTw7USxmtqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdTLexzFPgaACaOjVDJ0VlYFP+ByI6pbNZOYN8wBqQqg3b81kQksmfCoBjSlxv1XQ
         MnGvjeNvas8/CuS8JXo7fjtitKCgZAKHrqnddZhcEB83hGBD94EdP555jx4s6jqyve
         CbBvgW4rFLTzn2dVYm4Od2AyIbb72gFTwJPN8GFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Lifu <chenlifu@huawei.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/136] riscv: lib: uaccess: fix CSR_STATUS SR_SUM bit
Date:   Mon, 29 Aug 2022 12:58:12 +0200
Message-Id: <20220829105805.603762071@linuxfoundation.org>
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

From: Chen Lifu <chenlifu@huawei.com>

[ Upstream commit c08b4848f596fd95543197463b5162bd7bab2442 ]

Since commit 5d8544e2d007 ("RISC-V: Generic library routines and assembly")
and commit ebcbd75e3962 ("riscv: Fix the bug in memory access fixup code"),
if __clear_user and __copy_user return from an fixup branch,
CSR_STATUS SR_SUM bit will be set, it is a vulnerability, so that
S-mode memory accesses to pages that are accessible by U-mode will success.
Disable S-mode access to U-mode memory should clear SR_SUM bit.

Fixes: 5d8544e2d007 ("RISC-V: Generic library routines and assembly")
Fixes: ebcbd75e3962 ("riscv: Fix the bug in memory access fixup code")
Signed-off-by: Chen Lifu <chenlifu@huawei.com>
Reviewed-by: Ben Dooks <ben.dooks@codethink.co.uk>
Link: https://lore.kernel.org/r/20220615014714.1650349-1-chenlifu@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/lib/uaccess.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
index ac34f0026adcd..2c7c1c5026af3 100644
--- a/arch/riscv/lib/uaccess.S
+++ b/arch/riscv/lib/uaccess.S
@@ -177,7 +177,7 @@ ENTRY(__asm_copy_from_user)
 	/* Exception fixup code */
 10:
 	/* Disable access to user memory */
-	csrs CSR_STATUS, t6
+	csrc CSR_STATUS, t6
 	mv a0, t5
 	ret
 ENDPROC(__asm_copy_to_user)
@@ -229,7 +229,7 @@ ENTRY(__clear_user)
 	/* Exception fixup code */
 11:
 	/* Disable access to user memory */
-	csrs CSR_STATUS, t6
+	csrc CSR_STATUS, t6
 	mv a0, a1
 	ret
 ENDPROC(__clear_user)
-- 
2.35.1



