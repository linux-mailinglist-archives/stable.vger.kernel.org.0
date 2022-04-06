Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1EA44F6ADA
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbiDFUJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbiDFUIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:08:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B3F29C97E;
        Wed,  6 Apr 2022 11:28:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D56661BCB;
        Wed,  6 Apr 2022 18:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297C8C385A3;
        Wed,  6 Apr 2022 18:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269734;
        bh=zTA/gwxscYLWt3/KQ7o9xr51+1aDngsucM7Pk5mFjtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQAOaSZlA0NiexhkvHJZajLSLZSblqsyYFqzE+rw1bCKJsIRv64GO9DLJTo5UZi2z
         z6bMD9zM/ThQAPXzK606sDQVDC2dIYiQgrlXsJIHmqL24bBqrN1EcAcXmVlf/H958S
         x0JYQtXvCSrPw3s105g9ov+qhxosJM+ZLZckknhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 37/43] arm64: entry: Add macro for reading symbol addresses from the trampoline
Date:   Wed,  6 Apr 2022 20:26:46 +0200
Message-Id: <20220406182437.757706906@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: James Morse <james.morse@arm.com>

commit b28a8eebe81c186fdb1a0078263b30576c8e1f42 upstream.

The trampoline code needs to use the address of symbols in the wider
kernel, e.g. vectors. PC-relative addressing wouldn't work as the
trampoline code doesn't run at the address the linker expected.

tramp_ventry uses a literal pool, unless CONFIG_RANDOMIZE_BASE is
set, in which case it uses the data page as a literal pool because
the data page can be unmapped when running in user-space, which is
required for CPUs vulnerable to meltdown.

Pull this logic out as a macro, instead of adding a third copy
of it.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
[ Removed SDEI for stable backport ]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -921,6 +921,15 @@ __ni_sys_trace:
 	sub	\dst, \dst, PAGE_SIZE
 	.endm
 
+	.macro tramp_data_read_var	dst, var
+#ifdef CONFIG_RANDOMIZE_BASE
+	tramp_data_page		\dst
+	add	\dst, \dst, #:lo12:__entry_tramp_data_\var
+	ldr	\dst, [\dst]
+#else
+	ldr	\dst, =\var
+#endif
+	.endm
 
 #define BHB_MITIGATION_NONE	0
 #define BHB_MITIGATION_LOOP	1
@@ -951,13 +960,7 @@ __ni_sys_trace:
 	b	.
 2:
 	tramp_map_kernel	x30
-#ifdef CONFIG_RANDOMIZE_BASE
-	tramp_data_page		x30
-	isb
-	ldr	x30, [x30]
-#else
-	ldr	x30, =vectors
-#endif
+	tramp_data_read_var	x30, vectors
 	prfm	plil1strm, [x30, #(1b - \vector_start)]
 	msr	vbar_el1, x30
 	isb
@@ -1037,7 +1040,12 @@ END(tramp_exit_compat)
 	.align PAGE_SHIFT
 	.globl	__entry_tramp_data_start
 __entry_tramp_data_start:
+__entry_tramp_data_vectors:
 	.quad	vectors
+#ifdef CONFIG_ARM_SDE_INTERFACE
+__entry_tramp_data___sdei_asm_trampoline_next_handler:
+	.quad	__sdei_asm_handler
+#endif /* CONFIG_ARM_SDE_INTERFACE */
 	.popsection				// .rodata
 #endif /* CONFIG_RANDOMIZE_BASE */
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */


