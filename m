Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED182F9E88
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390642AbhARLmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390738AbhARLla (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2778D2245C;
        Mon, 18 Jan 2021 11:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970074;
        bh=BFaPnYyu5T73jgDFiII32cdNoIyOIr54eHTfXGs0O3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqHDqwC6JNA4qucC+kaaJPSvjL+7aWart6P26kF0NdFcls3UxtCjIsHnTyT0PSlBN
         joYqIQtsMeVR3Tii/5OJNNmD5wcfE3s46N3Nl7t37W4Zx3qg2B3do4wxHZMPua9aYQ
         nmn6xiD3dInXM4S6XwjIuJ8lq7GICeTTd6QRhk1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Schwab <schwab@suse.de>,
        Tycho Andersen <tycho@tycho.pizza>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10 026/152] riscv: return -ENOSYS for syscall -1
Date:   Mon, 18 Jan 2021 12:33:21 +0100
Message-Id: <20210118113354.034638065@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Schwab <schwab@suse.de>

commit cf7b2ae4d70432fa94ebba3fbaab825481ae7189 upstream.

Properly return -ENOSYS for syscall -1 instead of leaving the return value
uninitialized.  This fixes the strace teststuite.

Fixes: 5340627e3fe0 ("riscv: add support for SECCOMP and SECCOMP_FILTER")
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Schwab <schwab@suse.de>
Reviewed-by: Tycho Andersen <tycho@tycho.pizza>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/riscv/kernel/entry.S |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -186,14 +186,7 @@ check_syscall_nr:
 	 * Syscall number held in a7.
 	 * If syscall number is above allowed value, redirect to ni_syscall.
 	 */
-	bge a7, t0, 1f
-	/*
-	 * Check if syscall is rejected by tracer, i.e., a7 == -1.
-	 * If yes, we pretend it was executed.
-	 */
-	li t1, -1
-	beq a7, t1, ret_from_syscall_rejected
-	blt a7, t1, 1f
+	bgeu a7, t0, 1f
 	/* Call syscall */
 	la s0, sys_call_table
 	slli t0, a7, RISCV_LGPTR


