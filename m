Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEC449989F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449359AbiAXV2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:28:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36490 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449749AbiAXVQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:16:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F56EB8123A;
        Mon, 24 Jan 2022 21:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0B8C340E9;
        Mon, 24 Jan 2022 21:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059008;
        bh=8RebVPnGQbTuBjYXPFFVIGJcwMDv/Hu35mDAL/+P9Cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k51OYnIdj5i2lWndyBO/y/RNaWkzTXD+5fPhyV2mgsJsRcN6AXjou+hXemXhy8/6g
         HWbsMCFF7clz/75szAZ/xvXJTNgF3uyGxb+v5VtPxdS5L4WRdu8qA4tUZ3faUlhcwG
         wktQRjkqNHFpEmONhxDxuI5stuqV+2jNzjARIItY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Stafford Horne <shorne@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0473/1039] openrisc: Add clone3 ABI wrapper
Date:   Mon, 24 Jan 2022 19:37:42 +0100
Message-Id: <20220124184141.172946221@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stafford Horne <shorne@gmail.com>

[ Upstream commit 433fe39f674d58bc7a3e8254a5d2ffc290b7e04e ]

Like fork and clone the clone3 syscall needs a wrapper to save callee
saved registers, which is required by the OpenRISC ABI.  This came up
after auditing code following a discussion with Rob Landley and Arnd
Bergmann [0].

Tested with the clone3 kselftests and there were no issues.

[0] https://lore.kernel.org/all/41206fc7-f8ce-98aa-3718-ba3e1431e320@landley.net/T/#m9c0cdb2703813b9df4da04cf6b30de1f1aa89944

Fixes: 07e83dfbe16c ("openrisc: Enable the clone3 syscall")
Cc: Rob Landley <rob@landley.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/include/asm/syscalls.h | 2 ++
 arch/openrisc/kernel/entry.S         | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/arch/openrisc/include/asm/syscalls.h b/arch/openrisc/include/asm/syscalls.h
index 3a7eeae6f56a8..aa1c7e98722e3 100644
--- a/arch/openrisc/include/asm/syscalls.h
+++ b/arch/openrisc/include/asm/syscalls.h
@@ -22,9 +22,11 @@ asmlinkage long sys_or1k_atomic(unsigned long type, unsigned long *v1,
 
 asmlinkage long __sys_clone(unsigned long clone_flags, unsigned long newsp,
 			void __user *parent_tid, void __user *child_tid, int tls);
+asmlinkage long __sys_clone3(struct clone_args __user *uargs, size_t size);
 asmlinkage long __sys_fork(void);
 
 #define sys_clone __sys_clone
+#define sys_clone3 __sys_clone3
 #define sys_fork __sys_fork
 
 #endif /* __ASM_OPENRISC_SYSCALLS_H */
diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
index 59c6d3aa7081e..dc5b45e9e72b5 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -1170,6 +1170,11 @@ ENTRY(__sys_clone)
 	l.j	_fork_save_extra_regs_and_call
 	 l.nop
 
+ENTRY(__sys_clone3)
+	l.movhi	r29,hi(sys_clone3)
+	l.j	_fork_save_extra_regs_and_call
+	 l.ori	r29,r29,lo(sys_clone3)
+
 ENTRY(__sys_fork)
 	l.movhi	r29,hi(sys_fork)
 	l.ori	r29,r29,lo(sys_fork)
-- 
2.34.1



