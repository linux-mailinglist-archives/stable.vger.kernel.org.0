Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720A757EE72
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238769AbiGWKLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238772AbiGWKJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:09:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB5B3F337;
        Sat, 23 Jul 2022 03:03:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BBDD60C81;
        Sat, 23 Jul 2022 10:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9986DC341CA;
        Sat, 23 Jul 2022 10:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570588;
        bh=nuzqddq499/Cz35y7gS4UjYy2QLCf/Ts4K7ar6xCcXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pclEJzr+od9lDiT/HmO5VstbxRxzPYS66nc3ekFMJeNRDfvtJNVwOfYlWKA3XrJig
         Z1zRS1LpSxrZQdnTRLwnOPznxMGltiKi9/d9Y8ynQzMI7eXwgrF4yoxaFpvLMU4J21
         eDUNSxGLe/DSGiOpvyaoBK+4Y9LbE6Awir4P0ZtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 139/148] KVM: emulate: do not adjust size of fastop and setcc subroutines
Date:   Sat, 23 Jul 2022 11:55:51 +0200
Message-Id: <20220723095303.318087524@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 79629181607e801c0b41b8790ac4ee2eb5d7bc3e upstream.

Instead of doing complicated calculations to find the size of the subroutines
(which are even more complicated because they need to be stringified into
an asm statement), just hardcode to 16.

It is less dense for a few combinations of IBT/SLS/retbleed, but it has
the advantage of being really simple.

Cc: stable@vger.kernel.org # 5.15.x: 84e7051c0bc1: x86/kvm: fix FASTOP_SIZE when return thunks are enabled
Cc: stable@vger.kernel.org
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -188,13 +188,6 @@
 #define X8(x...) X4(x), X4(x)
 #define X16(x...) X8(x), X8(x)
 
-#define NR_FASTOP	(ilog2(sizeof(ulong)) + 1)
-#define RET_LENGTH	(1 + (4 * IS_ENABLED(CONFIG_RETHUNK)) + \
-			 IS_ENABLED(CONFIG_SLS))
-#define FASTOP_LENGTH	(ENDBR_INSN_SIZE + 7 + RET_LENGTH)
-#define FASTOP_SIZE	(8 << ((FASTOP_LENGTH > 8) & 1) << ((FASTOP_LENGTH > 16) & 1))
-static_assert(FASTOP_LENGTH <= FASTOP_SIZE);
-
 struct opcode {
 	u64 flags : 56;
 	u64 intercept : 8;
@@ -308,9 +301,15 @@ static void invalidate_registers(struct
  * Moreover, they are all exactly FASTOP_SIZE bytes long, so functions for
  * different operand sizes can be reached by calculation, rather than a jump
  * table (which would be bigger than the code).
+ *
+ * The 16 byte alignment, considering 5 bytes for the RET thunk, 3 for ENDBR
+ * and 1 for the straight line speculation INT3, leaves 7 bytes for the
+ * body of the function.  Currently none is larger than 4.
  */
 static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 
+#define FASTOP_SIZE	16
+
 #define __FOP_FUNC(name) \
 	".align " __stringify(FASTOP_SIZE) " \n\t" \
 	".type " name ", @function \n\t" \
@@ -442,9 +441,7 @@ static int fastop(struct x86_emulate_ctx
  * RET | JMP __x86_return_thunk	[1,5 bytes; CONFIG_RETHUNK]
  * INT3				[1 byte; CONFIG_SLS]
  */
-#define SETCC_LENGTH	(3 + RET_LENGTH)
-#define SETCC_ALIGN	(4 << ((SETCC_LENGTH > 4) & 1) << ((SETCC_LENGTH > 8) & 1))
-static_assert(SETCC_LENGTH <= SETCC_ALIGN);
+#define SETCC_ALIGN	16
 
 #define FOP_SETCC(op) \
 	".align " __stringify(SETCC_ALIGN) " \n\t" \


