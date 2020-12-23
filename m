Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DA22E1384
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbgLWCai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:30:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730530AbgLWCZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89DA422A83;
        Wed, 23 Dec 2020 02:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690292;
        bh=ZyApZxQZVk6sKMiHL/zzmD4bkGQiWvE7rBwr+GXas2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=siy6Ki7eM8zFoKooFvJbxW7q2qzR8eASz63TsySEIF682qPKCovV6FZml1fnHv8zM
         6GAZV4/AEXgDVg0von/AMukc2hHm5CIY0pg9luw1z8N7CEon7sKGgUfKvwMlsUzaur
         uAGx8yCRuoBgr9Zh2gW0cLFFMsyFijU2+9Fm8eJNsKMg7d7c/iaT93lytXewIPVCzW
         Y5Sphx26Mnm8eEyrZfm3NVEcf/Tb2PLN3bzz5SkmNeWuTnFeWx8tXN7/x/8KNNHPw+
         bW2vEErrTXoVwPO/ejy/CQQFLK3d3NZvJeRGjToau+1PErfVHRrE3FA5LvPcjV6YmO
         4H70rM0yaSzOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 29/48] selftests/x86/fsgsbase: Fix GS == 1, 2, and 3 tests
Date:   Tue, 22 Dec 2020 21:23:57 -0500
Message-Id: <20201223022417.2794032-29-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

[ Upstream commit 716572b0003ef67a4889bd7d85baf5099c5a0248 ]

Setting GS to 1, 2, or 3 causes a nonsensical part of the IRET microcode
to change GS back to zero on a return from kernel mode to user mode. The
result is that these tests fail randomly depending on when interrupts
happen. Detect when this happens and let the test pass.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/7567fd44a1d60a9424f25b19a998f12149993b0d.1604346596.git.luto@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/x86/fsgsbase.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/x86/fsgsbase.c b/tools/testing/selftests/x86/fsgsbase.c
index f249e042b3b51..026cd644360f6 100644
--- a/tools/testing/selftests/x86/fsgsbase.c
+++ b/tools/testing/selftests/x86/fsgsbase.c
@@ -318,8 +318,8 @@ static void set_gs_and_switch_to(unsigned long local,
 		local = read_base(GS);
 
 		/*
-		 * Signal delivery seems to mess up weird selectors.  Put it
-		 * back.
+		 * Signal delivery is quite likely to change a selector
+		 * of 1, 2, or 3 back to 0 due to IRET being defective.
 		 */
 		asm volatile ("mov %0, %%gs" : : "rm" (force_sel));
 	} else {
@@ -337,6 +337,14 @@ static void set_gs_and_switch_to(unsigned long local,
 	if (base == local && sel_pre_sched == sel_post_sched) {
 		printf("[OK]\tGS/BASE remained 0x%hx/0x%lx\n",
 		       sel_pre_sched, local);
+	} else if (base == local && sel_pre_sched >= 1 && sel_pre_sched <= 3 &&
+		   sel_post_sched == 0) {
+		/*
+		 * IRET is misdesigned and will squash selectors 1, 2, or 3
+		 * to zero.  Don't fail the test just because this happened.
+		 */
+		printf("[OK]\tGS/BASE changed from 0x%hx/0x%lx to 0x%hx/0x%lx because IRET is defective\n",
+		       sel_pre_sched, local, sel_post_sched, base);
 	} else {
 		nerrs++;
 		printf("[FAIL]\tGS/BASE changed from 0x%hx/0x%lx to 0x%hx/0x%lx\n",
-- 
2.27.0

