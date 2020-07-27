Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A73E22F22E
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgG0OLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730000AbgG0OLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:11:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6683320838;
        Mon, 27 Jul 2020 14:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859079;
        bh=LQsZh6B58xYbN7fyPaEnUzMa5mwNfHfmclnKpLJfYHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FuAnH93yNM9DktwidoUmLfyOqWb1WKVGUlsaAvnYxN2ZuCm6uyF6QUzBWkz/AuFGT
         ywYFdOYKtk4ci4sXEZY+rXx1TaloP2G1+iRHLcXtW6pa4uT8RqSHyGceU0Ev4kzOwd
         uiP0yvL8ZnRdD8tvHk6wueBv4VZhAxRmGaLcoA+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 58/86] arm64: Use test_tsk_thread_flag() for checking TIF_SINGLESTEP
Date:   Mon, 27 Jul 2020 16:04:32 +0200
Message-Id: <20200727134917.345507336@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
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
index 93ee34dee9f22..501e835c65007 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -392,14 +392,14 @@ void user_rewind_single_step(struct task_struct *task)
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



