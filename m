Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B4722F2B7
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgG0Olt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729320AbgG0OHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:07:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9F312083B;
        Mon, 27 Jul 2020 14:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858872;
        bh=EiHdFGuyv6SSDSspwXrfE+iEnDphCE/McZEQwqx02eM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgvoTfs9q87qixSJzxEMzSR8GdpGYFE4qOXpnaROQECwJF9ZthaLv0JFvuSoP+Nyn
         tiNZpuwr0k8eGLiE7LlDAdgZX6plJRPcoiuYytb+gRrUTqGAWKVEkA2uFqE0Cnex0G
         t97oVzmmox8pktzC4giQ9ZAbQk/9soxSWdj1cywo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 44/64] arm64: Use test_tsk_thread_flag() for checking TIF_SINGLESTEP
Date:   Mon, 27 Jul 2020 16:04:23 +0200
Message-Id: <20200727134913.364673097@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134911.020675249@linuxfoundation.org>
References: <20200727134911.020675249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit 5afc78551bf5d53279036e0bf63314e35631d79f ]

Rather than open-code test_tsk_thread_flag() at each callsite, simply
replace the couple of offenders with calls to test_tsk_thread_flag()
directly.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/debug-monitors.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index db7ed460a5476..2ccd0a99d8b35 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -389,14 +389,14 @@ void user_rewind_single_step(struct task_struct *task)
 	 * If single step is active for this thread, then set SPSR.SS
 	 * to 1 to avoid returning to the active-pending state.
 	 */
-	if (test_ti_thread_flag(task_thread_info(task), TIF_SINGLESTEP))
+	if (test_tsk_thread_flag(task, TIF_SINGLESTEP))
 		set_regs_spsr_ss(task_pt_regs(task));
 }
 NOKPROBE_SYMBOL(user_rewind_single_step);
 
 void user_fastforward_single_step(struct task_struct *task)
 {
-	if (test_ti_thread_flag(task_thread_info(task), TIF_SINGLESTEP))
+	if (test_tsk_thread_flag(task, TIF_SINGLESTEP))
 		clear_regs_spsr_ss(task_pt_regs(task));
 }
 
-- 
2.25.1



