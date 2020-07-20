Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD732270C4
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgGTVjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:39:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbgGTVjK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:39:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09CF022C9D;
        Mon, 20 Jul 2020 21:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281150;
        bh=wRgAKJCJkV7Q4az1cAhz2iFJt5bHLBdVWRTvN1inipk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImjiAMoONHUm+dctYuVrhYVxck6xBt/omRZ3lPKwBl4PQiwfEV4+3eX2aNtBb3Twf
         f3EgTfC3Iq/uUlOnGoF/wjJ7U65ls45uTinWc7oSubjcBUC3kc83qsyitkLE53aaMC
         XW23igRTT7+VC+RR98VaGBxBDxcp7skU7WoS1ijo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 16/19] arm64: Use test_tsk_thread_flag() for checking TIF_SINGLESTEP
Date:   Mon, 20 Jul 2020 17:38:47 -0400
Message-Id: <20200720213851.407715-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213851.407715-1-sashal@kernel.org>
References: <20200720213851.407715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 262925b98f421..85bf560f363bd 100644
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

