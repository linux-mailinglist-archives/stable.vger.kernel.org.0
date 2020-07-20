Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F8F226595
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731626AbgGTPzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:55:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731404AbgGTPzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:55:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 475CC2065E;
        Mon, 20 Jul 2020 15:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260504;
        bh=73OfyVQhcIxZMzuwA5a7Od8723BMHesLMf45Xpthq9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=meHayuuyAKG90IElWwBDPzn2RbK+hx1/2nYV+Ob9/PI646xzKrSXEAA5Pkk1GZt7l
         FDDv0hWNwuYc+9/tEtTA9xS0Fpr431k0tYbJWR0YhEwUY0UDwwvgBxwhwW17IQoXBF
         uVCi9CsvMbyGmRKmvh3o65sazw+dGIuqhq2jhNqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Keno Fischer <keno@juliacomputing.com>,
        Luis Machado <luis.machado@linaro.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 126/133] arm64: compat: Ensure upper 32 bits of x0 are zero on syscall return
Date:   Mon, 20 Jul 2020 17:37:53 +0200
Message-Id: <20200720152809.812865589@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 15956689a0e60aa0c795174f3c310b60d8794235 upstream.

Although we zero the upper bits of x0 on entry to the kernel from an
AArch32 task, we do not clear them on the exception return path and can
therefore expose 64-bit sign extended syscall return values to userspace
via interfaces such as the 'perf_regs' ABI, which deal exclusively with
64-bit registers.

Explicitly clear the upper 32 bits of x0 on return from a compat system
call.

Cc: <stable@vger.kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Keno Fischer <keno@juliacomputing.com>
Cc: Luis Machado <luis.machado@linaro.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/syscall.h |   12 +++++++++++-
 arch/arm64/kernel/syscall.c      |    3 +++
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -45,6 +45,10 @@ static inline long syscall_get_error(str
 				     struct pt_regs *regs)
 {
 	unsigned long error = regs->regs[0];
+
+	if (is_compat_thread(task_thread_info(task)))
+		error = sign_extend64(error, 31);
+
 	return IS_ERR_VALUE(error) ? error : 0;
 }
 
@@ -58,7 +62,13 @@ static inline void syscall_set_return_va
 					    struct pt_regs *regs,
 					    int error, long val)
 {
-	regs->regs[0] = (long) error ? error : val;
+	if (error)
+		val = error;
+
+	if (is_compat_thread(task_thread_info(task)))
+		val = lower_32_bits(val);
+
+	regs->regs[0] = val;
 }
 
 #define SYSCALL_MAX_ARGS 6
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -50,6 +50,9 @@ static void invoke_syscall(struct pt_reg
 		ret = do_ni_syscall(regs, scno);
 	}
 
+	if (is_compat_task())
+		ret = lower_32_bits(ret);
+
 	regs->regs[0] = ret;
 }
 


