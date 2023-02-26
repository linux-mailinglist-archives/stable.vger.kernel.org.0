Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7786A318D
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 16:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjBZPAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 10:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbjBZO6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:58:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66B01C7EA;
        Sun, 26 Feb 2023 06:52:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58D11B80C83;
        Sun, 26 Feb 2023 14:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB83C433D2;
        Sun, 26 Feb 2023 14:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423119;
        bh=LyJJ4wVn9AuHhKbPdsf7LLzV4TZz8LkznaCsf2AXnNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQ1Jt/s70ReEQ6Jvdy2Cfh1gtwBBbpaqqfIHE9aeWeNqcRdp3uTtO2uiiLiQ4v3hf
         eDctjmiifwQcx29KeoKxDIZu4TO9g60bWNOq6bZyjJe8BM0I83WdgfxhDp8dS8PhLY
         PaCgvEU+uyYPpjp6TSpM8wf2+hZ+Z4K88a3exZIDe97Zn0I5TrliPpvo5+W9aCRPiq
         p+TOxiWkhAJm/uNnhE8WtntBroRvLyubcyi6rrmqNaiFiiCL5/LV67FR/cq55a0qbn
         gPiKRw73+ukXraV37dJr9VoMNtPQD6OWiNU595a/f/xq8+zUjv6uaLy3RYr7aorxPl
         LMqtwjEaZWh2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Schmitz <schmitzmic@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>, gerg@linux-m68k.org,
        ebiederm@xmission.com, linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 5.4 13/19] m68k: Check syscall_trace_enter() return code
Date:   Sun, 26 Feb 2023 09:51:15 -0500
Message-Id: <20230226145123.829229-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226145123.829229-1-sashal@kernel.org>
References: <20230226145123.829229-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 259b3661b6141..94abf3d8afc52 100644
--- a/arch/m68k/68000/entry.S
+++ b/arch/m68k/68000/entry.S
@@ -47,6 +47,8 @@ do_trace:
 	jbsr	syscall_trace_enter
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
+	addql	#1,%d0
+	jeq	ret_from_exception
 	movel	%sp@(PT_OFF_ORIG_D0),%d1
 	movel	#-ENOSYS,%d0
 	cmpl	#NR_syscalls,%d1
diff --git a/arch/m68k/coldfire/entry.S b/arch/m68k/coldfire/entry.S
index 52d312d5b4d4f..fb3b065677459 100644
--- a/arch/m68k/coldfire/entry.S
+++ b/arch/m68k/coldfire/entry.S
@@ -92,6 +92,8 @@ ENTRY(system_call)
 	jbsr	syscall_trace_enter
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
+	addql	#1,%d0
+	jeq	ret_from_exception
 	movel	%d3,%a0
 	jbsr	%a0@
 	movel	%d0,%sp@(PT_OFF_D0)		/* save the return value */
diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index 97cd3ea5f10b8..9a66657773beb 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -160,9 +160,12 @@ do_trace_entry:
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
2.39.0

