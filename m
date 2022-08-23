Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6808859DA5C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352343AbiHWKH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352809AbiHWKGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:06:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E387027166;
        Tue, 23 Aug 2022 01:53:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76FE461377;
        Tue, 23 Aug 2022 08:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AC6C433D6;
        Tue, 23 Aug 2022 08:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244786;
        bh=UlzcKidXqLG4HmGSEd5gPKAWOKksFX8ym+DBmzhofjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGY3A5P+4Z+2xhE9/2R04DPXjp+R0wuoSJfGe6hEO2GQsBlX9iBFaQYbL3518zUPJ
         JK8Z47fVyvcGM3EBGaxrcJU9eA36kiHgED3HyzYZgxF+tkGn+BcvFJMgBXxMjHSuvf
         /sjj9mA3m5pFmVYTiS8qBJyp8+aAKZVY47Fxeomk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.15 114/244] nios2: add force_successful_syscall_return()
Date:   Tue, 23 Aug 2022 10:24:33 +0200
Message-Id: <20220823080102.823419744@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit fd0c153daad135d0ec1a53c5dbe6936a724d6ae1 upstream.

If we use the ancient SysV syscall ABI, we'd better have tell the
kernel how to claim that a negative return value is a success.
Use ->orig_r2 for that - it's inaccessible via ptrace, so it's
a fair game for changes and it's normally[*] non-negative on return
from syscall.  Set to -1; syscall is not going to be restart-worthy
by definition, so we won't interfere with that use either.

[*] the only exception is rt_sigreturn(), where we skip the entire
messing with r1/r2 anyway.

Fixes: 82ed08dd1b0e ("nios2: Exception handling")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nios2/include/asm/ptrace.h |    2 ++
 arch/nios2/kernel/entry.S       |    6 ++++++
 2 files changed, 8 insertions(+)

--- a/arch/nios2/include/asm/ptrace.h
+++ b/arch/nios2/include/asm/ptrace.h
@@ -74,6 +74,8 @@ extern void show_regs(struct pt_regs *);
 	((struct pt_regs *)((unsigned long)current_thread_info() + THREAD_SIZE)\
 		- 1)
 
+#define force_successful_syscall_return() (current_pt_regs()->orig_r2 = -1)
+
 int do_syscall_trace_enter(void);
 void do_syscall_trace_exit(void);
 #endif /* __ASSEMBLY__ */
--- a/arch/nios2/kernel/entry.S
+++ b/arch/nios2/kernel/entry.S
@@ -213,6 +213,9 @@ local_restart:
 translate_rc_and_ret:
 	movi	r1, 0
 	bge	r2, zero, 3f
+	ldw	r1, PT_ORIG_R2(sp)
+	addi	r1, r1, 1
+	beq	r1, zero, 3f
 	sub	r2, zero, r2
 	movi	r1, 1
 3:
@@ -276,6 +279,9 @@ traced_system_call:
 translate_rc_and_ret2:
 	movi	r1, 0
 	bge	r2, zero, 4f
+	ldw	r1, PT_ORIG_R2(sp)
+	addi	r1, r1, 1
+	beq	r1, zero, 4f
 	sub	r2, zero, r2
 	movi	r1, 1
 4:


