Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B925D20E803
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgF2WCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgF2SfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26A7724196;
        Mon, 29 Jun 2020 15:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443953;
        bh=S4oSBEKFtn41itg9mzsbFJpEvLbzU9TYSrz+ppPP6Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssc6vpKKd+8FBR9j3F2t5sweklbGR81LepenAVhpRiffII7zbpFz5HxaCHKsZos09
         pRVixcehWhENq0UwaAr0JPqug+WW1mz+67LpZh/a8FWShiQp6inc2eoMyjyMU/wjef
         lai1yg13qi8GKYro7IY8JOoZWSsuCRiW9fgGOOvo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 055/265] fix a braino in "sparc32: fix register window handling in genregs32_[gs]et()"
Date:   Mon, 29 Jun 2020 11:14:48 -0400
Message-Id: <20200629151818.2493727-56-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 9d964e1b82d8182184153b70174f445ea616f053 ]

lost npc in PTRACE_SETREGSET, breaking PTRACE_SETREGS as well

Fixes: cf51e129b968 "sparc32: fix register window handling in genregs32_[gs]et()"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/ptrace_32.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/ptrace_32.c b/arch/sparc/kernel/ptrace_32.c
index 60f7205ebe40d..646dd58169ecb 100644
--- a/arch/sparc/kernel/ptrace_32.c
+++ b/arch/sparc/kernel/ptrace_32.c
@@ -168,12 +168,17 @@ static int genregs32_set(struct task_struct *target,
 	if (ret || !count)
 		return ret;
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &regs->y,
+				 &regs->npc,
 				 34 * sizeof(u32), 35 * sizeof(u32));
 	if (ret || !count)
 		return ret;
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &regs->y,
+				 35 * sizeof(u32), 36 * sizeof(u32));
+	if (ret || !count)
+		return ret;
 	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-					 35 * sizeof(u32), 38 * sizeof(u32));
+					 36 * sizeof(u32), 38 * sizeof(u32));
 }
 
 static int fpregs32_get(struct task_struct *target,
-- 
2.25.1

