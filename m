Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C3D24B413
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbgHTJ5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729684AbgHTJ5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:57:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FF39207FB;
        Thu, 20 Aug 2020 09:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917424;
        bh=p6TsHCvvkp3SLABaDg9z5pQt9RWPKGLg3o7T1fgNJ4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWBxhVCm5/oz3ZK7spiqxA2/9zD5tAcCOx7H1fyDrSQpSVSq0CY0ZtSHEgnfeJSd+
         IHbhcnWAC69r+nLKAn9OUbo0f4Gw7s05UlNOrcjNg3nsmbWyj6dAQoVk9hnSQLC7z9
         ue60B/8mMpWOTJnWSw5B3PeF7bJCEBRf331OpXds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 026/212] sh: Fix validation of system call number
Date:   Thu, 20 Aug 2020 11:19:59 +0200
Message-Id: <20200820091603.663937357@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

[ Upstream commit 04a8a3d0a73f51c7c2da84f494db7ec1df230e69 ]

The slow path for traced system call entries accessed a wrong memory
location to get the number of the maximum allowed system call number.
Renumber the numbered "local" label for the correct location to avoid
collisions with actual local labels.

Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Fixes: f3a8308864f920d2 ("sh: Add a few missing irqflags tracing markers.")
Signed-off-by: Rich Felker <dalias@libc.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/kernel/entry-common.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sh/kernel/entry-common.S b/arch/sh/kernel/entry-common.S
index 28cc61216b649..ed5b758c650d7 100644
--- a/arch/sh/kernel/entry-common.S
+++ b/arch/sh/kernel/entry-common.S
@@ -203,7 +203,7 @@ syscall_trace_entry:
 	mov.l	@(OFF_R7,r15), r7   ! arg3
 	mov.l	@(OFF_R3,r15), r3   ! syscall_nr
 	!
-	mov.l	2f, r10			! Number of syscalls
+	mov.l	6f, r10			! Number of syscalls
 	cmp/hs	r10, r3
 	bf	syscall_call
 	mov	#-ENOSYS, r0
@@ -357,7 +357,7 @@ ENTRY(system_call)
 	tst	r9, r8
 	bf	syscall_trace_entry
 	!
-	mov.l	2f, r8			! Number of syscalls
+	mov.l	6f, r8			! Number of syscalls
 	cmp/hs	r8, r3
 	bt	syscall_badsys
 	!
@@ -396,7 +396,7 @@ syscall_exit:
 #if !defined(CONFIG_CPU_SH2)
 1:	.long	TRA
 #endif
-2:	.long	NR_syscalls
+6:	.long	NR_syscalls
 3:	.long	sys_call_table
 7:	.long	do_syscall_trace_enter
 8:	.long	do_syscall_trace_leave
-- 
2.25.1



