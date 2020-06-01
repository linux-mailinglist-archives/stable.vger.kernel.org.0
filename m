Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD891EAD3C
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731101AbgFASL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:11:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731097AbgFASL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:11:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7BE52065C;
        Mon,  1 Jun 2020 18:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035087;
        bh=b/EUArRdVQdkWs2IhRIZmaWX7WUowYSahHk7SFy+5q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSckfL0POvKlA/JAIJTwtebov8XxnEBCaptzGkOO33vPQ1ciTHlnzzu8AE+zMYzAb
         NIyOa8cGl0DrigniN+bbuuseXM4Z37RKFHHO05GHSH7wP0B7SMTycxXSBMLLldUkBq
         eNw8P0N7nGc5o3q6ew0RyK83QNag2drKN6zA0b4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thorsten Glaser <t.glaser@tarent.de>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>, stable@kernel.org
Subject: [PATCH 5.4 108/142] x86/syscalls: Revert "x86/syscalls: Make __X32_SYSCALL_BIT be unsigned long"
Date:   Mon,  1 Jun 2020 19:54:26 +0200
Message-Id: <20200601174049.134783758@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 700d3a5a664df267f01ec8887fd2d8ff98f67e7f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/uapi/asm/unistd.h       |   11 +++++++++--
 tools/arch/x86/include/uapi/asm/unistd.h |    2 +-
 2 files changed, 10 insertions(+), 3 deletions(-)

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
--- a/tools/arch/x86/include/uapi/asm/unistd.h
+++ b/tools/arch/x86/include/uapi/asm/unistd.h
@@ -3,7 +3,7 @@
 #define _UAPI_ASM_X86_UNISTD_H
 
 /* x32 syscall flag bit */
-#define __X32_SYSCALL_BIT	0x40000000UL
+#define __X32_SYSCALL_BIT	0x40000000
 
 #ifndef __KERNEL__
 # ifdef __i386__


