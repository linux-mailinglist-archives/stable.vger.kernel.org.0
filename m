Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF1F4915DF
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238701AbiARCcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244767AbiARC2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:28:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B0EC0612F3;
        Mon, 17 Jan 2022 18:25:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7546260DEB;
        Tue, 18 Jan 2022 02:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B6CC36AF5;
        Tue, 18 Jan 2022 02:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472750;
        bh=DcWAn2JPOmd7HM4LptMNGkIDWokyu5A3HOzLpIINlwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eiNtNxwzUnu8PofBn/yk4HZCme65DZQslVWdbfQDW0C+vc8yVnTaGrqOa+7LYSdVj
         Lgl+bHDVFEFHN/Samw78bxXHbgj40MTWsRfSvhdjksVccfcrb/H+7s10m6VHgC1XJJ
         DugBYuqSmWtD8IHiAOhexWZ+czUKmJurQOjMx7pmwQZfrVXh5rpUm0BYMaHDzdvV5Z
         4gjPJl6plZDDMMA9adMNKTwp1CfW/ARXA4tgcv9mGz4Dx5IsLRykrFnfui91EWNz4c
         gs7VZbf6TLr0DCCSLLsbHI6ud8Jd2yhzaq7+RZ/F3sqXF6Oqb/8jHu/aSjA+RCu/59
         dVlFWxYlzm9Wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 122/217] x86/mce: Allow instrumentation during task work queueing
Date:   Mon, 17 Jan 2022 21:18:05 -0500
Message-Id: <20220118021940.1942199-122-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

