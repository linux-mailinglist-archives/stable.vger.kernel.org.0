Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EC16AF4D5
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbjCGTUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbjCGTTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:19:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C41C5ACB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:03:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6E7661532
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC7DC433D2;
        Tue,  7 Mar 2023 19:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215831;
        bh=PwRfxWnd81gQ97pfEJN4tcjcJqRWKUYJWubMkulxQ2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlMQCnHMWs8IXs7y9p63t70SbXECSSRrXRxZfXrGJmEDKh676ULJNORN2sycAxpWM
         GGux2MR1wOfAZ4wXK9U0Omf0iOInQi+Wl10L5TTXPpRo/M9zyrBMeH5ZomfjcYseFA
         BBXZ3/0/TopjZhHzDr6Ew98r3UTXhCEtLCbAewQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Schmitz <schmitzmic@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 388/567] m68k: Check syscall_trace_enter() return code
Date:   Tue,  7 Mar 2023 18:02:04 +0100
Message-Id: <20230307165922.644987812@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Schmitz <schmitzmic@gmail.com>

[ Upstream commit 2ca8a1de4437f21562e57f9ac123914747a8e7a1 ]

Check return code of syscall_trace_enter(), and skip syscall
if -1. Return code will be left at what had been set by
ptrace or seccomp (in regs->d0).

No regression seen in testing with strace on ARAnyM.

Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20230112035529.13521-2-schmitzmic@gmail.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/68000/entry.S    | 2 ++
 arch/m68k/coldfire/entry.S | 2 ++
 arch/m68k/kernel/entry.S   | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/arch/m68k/68000/entry.S b/arch/m68k/68000/entry.S
index 997b549330156..7d63e2f1555a0 100644
--- a/arch/m68k/68000/entry.S
+++ b/arch/m68k/68000/entry.S
@@ -45,6 +45,8 @@ do_trace:
 	jbsr	syscall_trace_enter
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
+	addql	#1,%d0
+	jeq	ret_from_exception
 	movel	%sp@(PT_OFF_ORIG_D0),%d1
 	movel	#-ENOSYS,%d0
 	cmpl	#NR_syscalls,%d1
diff --git a/arch/m68k/coldfire/entry.S b/arch/m68k/coldfire/entry.S
index 9f337c70243a3..35104c5417ff4 100644
--- a/arch/m68k/coldfire/entry.S
+++ b/arch/m68k/coldfire/entry.S
@@ -90,6 +90,8 @@ ENTRY(system_call)
 	jbsr	syscall_trace_enter
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
+	addql	#1,%d0
+	jeq	ret_from_exception
 	movel	%d3,%a0
 	jbsr	%a0@
 	movel	%d0,%sp@(PT_OFF_D0)		/* save the return value */
diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index 9434fca68de5d..9f3663facaa0e 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -184,9 +184,12 @@ do_trace_entry:
 	jbsr	syscall_trace
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
+	addql	#1,%d0			| optimization for cmpil #-1,%d0
+	jeq	ret_from_syscall
 	movel	%sp@(PT_OFF_ORIG_D0),%d0
 	cmpl	#NR_syscalls,%d0
 	jcs	syscall
+	jra	ret_from_syscall
 badsys:
 	movel	#-ENOSYS,%sp@(PT_OFF_D0)
 	jra	ret_from_syscall
-- 
2.39.2



