Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FCA4727DE
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238277AbhLMKFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:05:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48134 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240728AbhLMKCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:02:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87EFBB80E9F;
        Mon, 13 Dec 2021 10:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80365C34601;
        Mon, 13 Dec 2021 10:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389755;
        bh=2tI4L4ZC1VexFTjJvfJSKNyBjbxhEofLYOX0mGLy6nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JbLDYz2UHIgPVzpZ5vJ3sqq5p7kZmqE0vTYL2bxkLzlq6PbJ8HLzyrYCuTZq0TDr
         rO4/X27X8MiONFykzgrJBLEEFkbP/PRdmcUevtm5jDS3TkGBJCDjoPFVaD68KfH7aT
         8dxNeO1m+oNC9M1j11tURWeyzLq3fuSGf/w6pXvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kelly Devilliv <kelly.devilliv@gmail.com>,
        Guo Ren <guoren@linux.alibaba.com>
Subject: [PATCH 5.15 162/171] csky: fix typo of fpu config macro
Date:   Mon, 13 Dec 2021 10:31:17 +0100
Message-Id: <20211213092950.466467638@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -209,7 +209,7 @@ asmlinkage void do_trap_illinsn(struct p
 
 asmlinkage void do_trap_fpe(struct pt_regs *regs)
 {
-#ifdef CONFIG_CPU_HAS_FP
+#ifdef CONFIG_CPU_HAS_FPU
 	return fpu_fpe(regs);
 #else
 	do_trap_error(regs, SIGILL, ILL_ILLOPC, regs->pc,
@@ -219,7 +219,7 @@ asmlinkage void do_trap_fpe(struct pt_re
 
 asmlinkage void do_trap_priv(struct pt_regs *regs)
 {
-#ifdef CONFIG_CPU_HAS_FP
+#ifdef CONFIG_CPU_HAS_FPU
 	if (user_mode(regs) && fpu_libc_helper(regs))
 		return;
 #endif


