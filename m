Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5822759DD22
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355685AbiHWLCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357201AbiHWLBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:01:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6150BAF483;
        Tue, 23 Aug 2022 02:14:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47600B81C94;
        Tue, 23 Aug 2022 09:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E892C433D6;
        Tue, 23 Aug 2022 09:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246057;
        bh=FiKJFq3p3hNMNAz/G+j1Jr63XmO/Uxj1ECLA2jSv+YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1TEIBBjukxFzehGnV+ep5dE6UbzxhhB8cyvktweSzGXTGfHfrHjZJjOXWMAlSU/8
         XljGV2r38bFUWnlrJCaTm4dE55AHyCSJuyaEXf1HFrngqfrNenBmteIYkiV19EWbWd
         ob60WF9TH7GoG9MMQgmiBut8ETyEC9dZN5tneMHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 4.19 244/287] nios2: page fault et.al. are *not* restartable syscalls...
Date:   Tue, 23 Aug 2022 10:26:53 +0200
Message-Id: <20220823080109.339451222@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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


