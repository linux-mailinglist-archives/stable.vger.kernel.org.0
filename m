Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176D9472858
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240316AbhLMKK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242792AbhLMKIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:08:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E52C08EA6F;
        Mon, 13 Dec 2021 01:52:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8257BCE0AE2;
        Mon, 13 Dec 2021 09:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31933C00446;
        Mon, 13 Dec 2021 09:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389153;
        bh=spf84bjZNDkyUYaa+GuMENnzGKDa9wTIqctAHHJzIEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Im52aOUCZ6CINyQe4xC8J9DspGstQNC9wYl7KEFCce1zQs7y8NQbAFEhyeVHx6BLB
         a08nX0pae/bn7YVQXIQaqgK24Nb56P/h0K/iO7S5/dPtWd7vRYb98TzwEMXJaT7xFM
         w+oFOeQ0pHaSmjaCyB6qMYMWYo+BH+a7tu2JZux8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kelly Devilliv <kelly.devilliv@gmail.com>,
        Guo Ren <guoren@linux.alibaba.com>
Subject: [PATCH 5.10 121/132] csky: fix typo of fpu config macro
Date:   Mon, 13 Dec 2021 10:31:02 +0100
Message-Id: <20211213092943.251520760@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kelly Devilliv <kelly.devilliv@gmail.com>

commit a0793fdad9a11a32bc6d21317c93c83f4aa82ebc upstream.

Fix typo which will cause fpe and privilege exception error.

Signed-off-by: Kelly Devilliv <kelly.devilliv@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/csky/kernel/traps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/csky/kernel/traps.c
+++ b/arch/csky/kernel/traps.c
@@ -211,7 +211,7 @@ asmlinkage void do_trap_illinsn(struct p
 
 asmlinkage void do_trap_fpe(struct pt_regs *regs)
 {
-#ifdef CONFIG_CPU_HAS_FP
+#ifdef CONFIG_CPU_HAS_FPU
 	return fpu_fpe(regs);
 #else
 	do_trap_error(regs, SIGILL, ILL_ILLOPC, regs->pc,
@@ -221,7 +221,7 @@ asmlinkage void do_trap_fpe(struct pt_re
 
 asmlinkage void do_trap_priv(struct pt_regs *regs)
 {
-#ifdef CONFIG_CPU_HAS_FP
+#ifdef CONFIG_CPU_HAS_FPU
 	if (user_mode(regs) && fpu_libc_helper(regs))
 		return;
 #endif


