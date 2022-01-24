Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B11499B5A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575169AbiAXVvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572900AbiAXVmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD133C0419DE;
        Mon, 24 Jan 2022 12:31:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CA8B61382;
        Mon, 24 Jan 2022 20:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4BAC340E5;
        Mon, 24 Jan 2022 20:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056282;
        bh=8Yt00TSqkUG5zmPCAKbAEstzXYANjL5hTNzJAqPXA70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6RDx0NuYT+Bs4UDoMak/YyMZaSj4vsFNkg3U7OmjeisSsKZI29x90sE+IIHSAiiN
         DHJZB1M2gj9c+Q0jT+aXLLKYTgUMfqoFl6/OTf63Iz9C28zLMYLJWo7K26WAaU1BEK
         n4yH6M4oEPhrEIe8STZXXpn1PDKNmUe0CfoYRvfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Stafford Horne <shorne@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 400/846] openrisc: Add clone3 ABI wrapper
Date:   Mon, 24 Jan 2022 19:38:37 +0100
Message-Id: <20220124184114.751113365@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index edaa775a648e6..c68f3349c1741 100644
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



