Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FE420DC5C
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgF2UOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732841AbgF2TaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFB0C252CE;
        Mon, 29 Jun 2020 15:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445095;
        bh=S4oSBEKFtn41itg9mzsbFJpEvLbzU9TYSrz+ppPP6Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrNecuVb7GnfOhdml6QZ+ndFFBry3mYtgzeM/D0gHoQmzRsky9kAb5S+oPH+Zk470
         gry56PHwK80baeZ+YgopCW3G1bqcE0vQNm+AyE5Sv/pLd1d3jWIcKKzK0TmkmIJTxA
         LnP2RcrB4dQHUvAV+LCIAJKhG8OItA+qUUKABXdQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/78] fix a braino in "sparc32: fix register window handling in genregs32_[gs]et()"
Date:   Mon, 29 Jun 2020 11:36:53 -0400
Message-Id: <20200629153806.2494953-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
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

