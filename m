Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 545B37A40B
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 11:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731132AbfG3JZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 05:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731046AbfG3JZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 05:25:54 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 906A22089E;
        Tue, 30 Jul 2019 09:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564478753;
        bh=nqU4k4X/e7lYeTAPiZAW8mdKZR5UN/bj9V8U1bHWGn8=;
        h=From:To:Cc:Subject:Date:From;
        b=2F0v4akXyoiqT9/IdB6Ohu4GIcsn8FKvMOtHoG+WiVduFmfrv/2DFnEhZcTFRMI38
         djITFzPR+wZabZ+x6kLMIDxM8IeHsUqlAD02hW1ZOJmf8bPYufh5CJ1EzwQEM2Abru
         Yd+T5QoVt9ASTYqx5qMTWhukv0Vsan1typDxX4/Q=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        "# 4 . 9+" <stable@vger.kernel.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH] arm64: compat: Provide definition for COMPAT_SIGMINSTKSZ
Date:   Tue, 30 Jul 2019 10:25:47 +0100
Message-Id: <20190730092547.1284-1-will@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit 24951465cbd279f60b1fdc2421b3694405bcff42 ]

arch/arm/ defines a SIGMINSTKSZ of 2k, so we should use the same value
for compat tasks.

Cc: <stable@vger.kernel.org> # 4.9+
Cc: Aurelien Jarno <aurelien@aurel32.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Reported-by: Steve McIntyre <steve.mcintyre@arm.com>
Tested-by: Steve McIntyre <93sam@debian.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---

Aurelien points out that this didn't get selected for -stable despite its
counterpart (22839869f21a ("signal: Introduce COMPAT_SIGMINSTKSZ for use
in compat_sys_sigaltstack")) being backported to 4.9. Oops.

 arch/arm64/include/asm/compat.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index 1a037b94eba1..cee28a05ee98 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -159,6 +159,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 }
 
 #define compat_user_stack_pointer() (user_stack_pointer(task_pt_regs(current)))
+#define COMPAT_MINSIGSTKSZ	2048
 
 static inline void __user *arch_compat_alloc_user_space(long len)
 {
-- 
2.11.0

