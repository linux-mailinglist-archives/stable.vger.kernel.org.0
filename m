Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 476811070B8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfKVKiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:38:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728628AbfKVKiP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:38:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B5592073F;
        Fri, 22 Nov 2019 10:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419094;
        bh=kZ3eFbfzpF8RN+2f4cfw+2bjwJ52lRnc7ozYNT8kUPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uujFmvcpMYhMmjXh7AcDESITdTdypnuBI0Ae4GJMXmFKYCj+O1XqcPH5OOkOZjrQ3
         KFY1IbY8kg8/k19qQ9IHtxTj7+KR+VTMH+Zkwo08yF2RT8kBLRXGQeCXmKbwnVwKaz
         K10uwklL7i0dGwcBuBziSKgzPwwjcHKg8zOAQCAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>,
        Eugene Syromyatnikov <evgsyr@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 154/159] ARM: 8802/1: Call syscall_trace_exit even when system call skipped
Date:   Fri, 22 Nov 2019 11:29:05 +0100
Message-Id: <20191122100847.872357164@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>

[ Upstream commit f18aef742c8fbd68e280dff0a63ba0ca6ee8ad85 ]

On at least x86 and ARM64, and as documented in the ptrace man page
a skipped system call will still cause a syscall exit ptrace stop.

Previous to this commit 32-bit ARM did not, resulting in strace
being confused when seccomp skips system calls.

This change also impacts programs that use ptrace to skip system calls.

Fixes: ad75b51459ae ("ARM: 7579/1: arch/allow a scno of -1 to not cause a SIGILL")
Signed-off-by: Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>
Signed-off-by: Eugene Syromyatnikov <evgsyr@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>
Tested-by: Eugene Syromyatnikov <evgsyr@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/entry-common.S | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index e969b18d9ff93..d31f0300d2c98 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -261,16 +261,15 @@ __sys_trace:
 	cmp	scno, #-1			@ skip the syscall?
 	bne	2b
 	add	sp, sp, #S_OFF			@ restore stack
-	b	ret_slow_syscall
 
-__sys_trace_return:
-	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
+__sys_trace_return_nosave:
+	enable_irq_notrace
 	mov	r0, sp
 	bl	syscall_trace_exit
 	b	ret_slow_syscall
 
-__sys_trace_return_nosave:
-	enable_irq_notrace
+__sys_trace_return:
+	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
 	mov	r0, sp
 	bl	syscall_trace_exit
 	b	ret_slow_syscall
-- 
2.20.1



