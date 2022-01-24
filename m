Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525FC499964
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455179AbiAXVey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:34:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41240 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452346AbiAXVZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:25:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 459ABB811FB;
        Mon, 24 Jan 2022 21:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7276BC340E4;
        Mon, 24 Jan 2022 21:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059513;
        bh=DcWAn2JPOmd7HM4LptMNGkIDWokyu5A3HOzLpIINlwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igMRjpDy0dDrG7eYEl2vIOL4kqSnB0PL7LsnLpwUuL6Y4c68Ji2OXuO4toShG2ATN
         kMyJnbauFhhVkHDWF6Entks63tpoxhWMYAlGNhSG5PNEhjza8mpSvl2gORz3yyf0zI
         4Jy9XfgHTiU/Q01wMV/HQI0DYXAx1gcMuWner80c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0640/1039] x86/mce: Allow instrumentation during task work queueing
Date:   Mon, 24 Jan 2022 19:40:29 +0100
Message-Id: <20220124184146.865221335@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 4fbce464db81a42f9a57ee242d6150ec7f996415 ]

Fixes

  vmlinux.o: warning: objtool: do_machine_check()+0xdb1: call to queue_task_work() leaves .noinstr.text section

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211208111343.8130-6-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 6ed365337a3b1..70ec5685906b2 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1454,6 +1454,14 @@ noinstr void do_machine_check(struct pt_regs *regs)
 	if (worst != MCE_AR_SEVERITY && !kill_current_task)
 		goto out;
 
+	/*
+	 * Enable instrumentation around the external facilities like
+	 * task_work_add() (via queue_task_work()), fixup_exception() etc.
+	 * For now, that is. Fixing this properly would need a lot more involved
+	 * reorganization.
+	 */
+	instrumentation_begin();
+
 	/* Fault was in user mode and we need to take some action */
 	if ((m.cs & 3) == 3) {
 		/* If this triggers there is no way to recover. Die hard. */
@@ -1482,6 +1490,9 @@ noinstr void do_machine_check(struct pt_regs *regs)
 		if (m.kflags & MCE_IN_KERNEL_COPYIN)
 			queue_task_work(&m, msg, kill_me_never);
 	}
+
+	instrumentation_end();
+
 out:
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
 }
-- 
2.34.1



