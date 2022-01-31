Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C140E4A44A4
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241590AbiAaLbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377988AbiAaL1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:27:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6138CC094265;
        Mon, 31 Jan 2022 03:17:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FCD9B82A5D;
        Mon, 31 Jan 2022 11:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56491C340EF;
        Mon, 31 Jan 2022 11:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627829;
        bh=3tSqRNYVVEdgFU/5z8VN14xz614uvr0H+s+4uqrS/JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xB+uNL073H5EQO4xgL7RjvRg24Bhdb2klWM3HiXeLPLKjWk5aNAniFXl1Iz4IA1+4
         lxikQtgiq+3JO0gRRA7B91buBaFzZeO8MbVK7ak/hTdIdsLgyvKBRx9GNkT7yyfMBA
         T6n3iwGkmG4idAJ7FJmDC3+1Ihq2SF59Su18J8Bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.16 039/200] powerpc/audit: Fix syscall_get_arch()
Date:   Mon, 31 Jan 2022 11:55:02 +0100
Message-Id: <20220131105234.870772429@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 252745240ba0ae774d2f80c5e185ed59fbc4fb41 upstream.

Commit 770cec16cdc9 ("powerpc/audit: Simplify syscall_get_arch()")
and commit 898a1ef06ad4 ("powerpc/audit: Avoid unneccessary #ifdef
in syscall_get_arguments()")
replaced test_tsk_thread_flag(task, TIF_32BIT)) by is_32bit_task().

But is_32bit_task() applies on current task while be want the test
done on task 'task'

So add a new macro is_tsk_32bit_task() to check any task.

Fixes: 770cec16cdc9 ("powerpc/audit: Simplify syscall_get_arch()")
Fixes: 898a1ef06ad4 ("powerpc/audit: Avoid unneccessary #ifdef in syscall_get_arguments()")
Cc: stable@vger.kernel.org
Reported-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/c55cddb8f65713bf5859ed675d75a50cb37d5995.1642159570.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/syscall.h     |    4 ++--
 arch/powerpc/include/asm/thread_info.h |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/syscall.h
+++ b/arch/powerpc/include/asm/syscall.h
@@ -90,7 +90,7 @@ static inline void syscall_get_arguments
 	unsigned long val, mask = -1UL;
 	unsigned int n = 6;
 
-	if (is_32bit_task())
+	if (is_tsk_32bit_task(task))
 		mask = 0xffffffff;
 
 	while (n--) {
@@ -105,7 +105,7 @@ static inline void syscall_get_arguments
 
 static inline int syscall_get_arch(struct task_struct *task)
 {
-	if (is_32bit_task())
+	if (is_tsk_32bit_task(task))
 		return AUDIT_ARCH_PPC;
 	else if (IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))
 		return AUDIT_ARCH_PPC64LE;
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -168,8 +168,10 @@ static inline bool test_thread_local_fla
 
 #ifdef CONFIG_COMPAT
 #define is_32bit_task()	(test_thread_flag(TIF_32BIT))
+#define is_tsk_32bit_task(tsk)	(test_tsk_thread_flag(tsk, TIF_32BIT))
 #else
 #define is_32bit_task()	(IS_ENABLED(CONFIG_PPC32))
+#define is_tsk_32bit_task(tsk)	(IS_ENABLED(CONFIG_PPC32))
 #endif
 
 #if defined(CONFIG_PPC64)


