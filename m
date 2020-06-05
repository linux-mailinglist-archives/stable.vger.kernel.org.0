Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C23C1EFB4C
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgFEOQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbgFEOQT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:16:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF8FB208A9;
        Fri,  5 Jun 2020 14:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366578;
        bh=G61HIjVZvMgRo7LlxxL+AVvu+MxFpRf/gwQh5Wz4BXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVCLnCrUuJKAt2cQ4Hpyn34E4nQgqPNYQBqFDLHTIf47hS/2LlC42oifsA1qUbQ5f
         6EHhtOUbjf7cmI8kOuPkIa1ZwQGyit4KYAI/bIzSpNqhwh3PexX3OvbH1bSiNkmSPH
         hLKRkWUyY5tZb/t/0CIenWMw18MaF3dAzfCl+A6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thorsten Glaser <t.glaser@tarent.de>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>, stable@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 01/43] x86/syscalls: Revert "x86/syscalls: Make __X32_SYSCALL_BIT be unsigned long"
Date:   Fri,  5 Jun 2020 16:14:31 +0200
Message-Id: <20200605140152.573595118@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

[ Upstream commit 700d3a5a664df267f01ec8887fd2d8ff98f67e7f ]

Revert

  45e29d119e99 ("x86/syscalls: Make __X32_SYSCALL_BIT be unsigned long")

and add a comment to discourage someone else from making the same
mistake again.

It turns out that some user code fails to compile if __X32_SYSCALL_BIT
is unsigned long. See, for example [1] below.

 [ bp: Massage and do the same thing in the respective tools/ header. ]

Fixes: 45e29d119e99 ("x86/syscalls: Make __X32_SYSCALL_BIT be unsigned long")
Reported-by: Thorsten Glaser <t.glaser@tarent.de>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@kernel.org
Link: [1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=954294
Link: https://lkml.kernel.org/r/92e55442b744a5951fdc9cfee10badd0a5f7f828.1588983892.git.luto@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/uapi/asm/unistd.h       | 11 +++++++++--
 tools/arch/x86/include/uapi/asm/unistd.h |  2 +-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/uapi/asm/unistd.h b/arch/x86/include/uapi/asm/unistd.h
index 196fdd02b8b1..be5e2e747f50 100644
--- a/arch/x86/include/uapi/asm/unistd.h
+++ b/arch/x86/include/uapi/asm/unistd.h
@@ -2,8 +2,15 @@
 #ifndef _UAPI_ASM_X86_UNISTD_H
 #define _UAPI_ASM_X86_UNISTD_H
 
-/* x32 syscall flag bit */
-#define __X32_SYSCALL_BIT	0x40000000UL
+/*
+ * x32 syscall flag bit.  Some user programs expect syscall NR macros
+ * and __X32_SYSCALL_BIT to have type int, even though syscall numbers
+ * are, for practical purposes, unsigned long.
+ *
+ * Fortunately, expressions like (nr & ~__X32_SYSCALL_BIT) do the right
+ * thing regardless.
+ */
+#define __X32_SYSCALL_BIT	0x40000000
 
 #ifndef __KERNEL__
 # ifdef __i386__
diff --git a/tools/arch/x86/include/uapi/asm/unistd.h b/tools/arch/x86/include/uapi/asm/unistd.h
index 196fdd02b8b1..30d7d04d72d6 100644
--- a/tools/arch/x86/include/uapi/asm/unistd.h
+++ b/tools/arch/x86/include/uapi/asm/unistd.h
@@ -3,7 +3,7 @@
 #define _UAPI_ASM_X86_UNISTD_H
 
 /* x32 syscall flag bit */
-#define __X32_SYSCALL_BIT	0x40000000UL
+#define __X32_SYSCALL_BIT	0x40000000
 
 #ifndef __KERNEL__
 # ifdef __i386__
-- 
2.25.1



