Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C326B59D612
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243604AbiHWI2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344524AbiHWI1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:27:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF696C746;
        Tue, 23 Aug 2022 01:14:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD2CF6132D;
        Tue, 23 Aug 2022 08:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0055C433D6;
        Tue, 23 Aug 2022 08:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242484;
        bh=FiKJFq3p3hNMNAz/G+j1Jr63XmO/Uxj1ECLA2jSv+YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xxiniz4ePqBgMc027Zpa5HNBif8u7o48pWXcOCC558+hiV2u4QNCVsl2jSficxu5B
         VMmNNsf79bfFEpGrEoaDfNvmYMn/J/0z0J9/Ec5RyYdrqqoEEEnUqq3c66IKTRmo0b
         keAkFB/vzLIkHFVu2ZMwSqwCApyjpM6dfRU58bYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 4.9 078/101] nios2: page fault et.al. are *not* restartable syscalls...
Date:   Tue, 23 Aug 2022 10:03:51 +0200
Message-Id: <20220823080037.557315562@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_ABUSE_SURBL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 8535c239ac674f7ead0f2652932d35c52c4123b2 upstream.

make sure that ->orig_r2 is negative for everything except
the syscalls.

Fixes: 82ed08dd1b0e ("nios2: Exception handling")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nios2/include/asm/entry.h |    3 ++-
 arch/nios2/kernel/entry.S      |    4 +---
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/arch/nios2/include/asm/entry.h
+++ b/arch/nios2/include/asm/entry.h
@@ -50,7 +50,8 @@
 	stw	r13, PT_R13(sp)
 	stw	r14, PT_R14(sp)
 	stw	r15, PT_R15(sp)
-	stw	r2, PT_ORIG_R2(sp)
+	movi	r24, -1
+	stw	r24, PT_ORIG_R2(sp)
 	stw	r7, PT_ORIG_R7(sp)
 
 	stw	ra, PT_RA(sp)
--- a/arch/nios2/kernel/entry.S
+++ b/arch/nios2/kernel/entry.S
@@ -185,6 +185,7 @@ ENTRY(handle_system_call)
 	ldw	r5, PT_R5(sp)
 
 local_restart:
+	stw	r2, PT_ORIG_R2(sp)
 	/* Check that the requested system call is within limits */
 	movui	r1, __NR_syscalls
 	bgeu	r2, r1, ret_invsyscall
@@ -336,9 +337,6 @@ external_interrupt:
 	/* skip if no interrupt is pending */
 	beq	r12, r0, ret_from_interrupt
 
-	movi	r24, -1
-	stw	r24, PT_ORIG_R2(sp)
-
 	/*
 	 * Process an external hardware interrupt.
 	 */


