Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA9F2DEF8A
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbgLSNFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:05:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728847AbgLSNEZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 08:04:25 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.4 01/34] ptrace: Prevent kernel-infoleak in ptrace_get_syscall_info()
Date:   Sat, 19 Dec 2020 14:02:58 +0100
Message-Id: <20201219125341.454853868@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125341.384025953@linuxfoundation.org>
References: <20201219125341.384025953@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

commit 0032ce0f85a269a006e91277be5fdbc05fad8426 upstream.

ptrace_get_syscall_info() is potentially copying uninitialized stack
memory to userspace, since the compiler may leave a 3-byte hole near the
beginning of `info`. Fix it by adding a padding field to `struct
ptrace_syscall_info`.

Fixes: 201766a20e30 ("ptrace: add PTRACE_GET_SYSCALL_INFO request")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Reviewed-by: Dmitry V. Levin <ldv@altlinux.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200801152044.230416-1-yepeilin.cs@gmail.com
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/ptrace.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -81,7 +81,8 @@ struct seccomp_metadata {
 
 struct ptrace_syscall_info {
 	__u8 op;	/* PTRACE_SYSCALL_INFO_* */
-	__u32 arch __attribute__((__aligned__(sizeof(__u32))));
+	__u8 pad[3];
+	__u32 arch;
 	__u64 instruction_pointer;
 	__u64 stack_pointer;
 	union {


