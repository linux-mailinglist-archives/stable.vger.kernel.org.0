Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A07F4A1F
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388998AbfKHLkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388974AbfKHLkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75469222C4;
        Fri,  8 Nov 2019 11:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213245;
        bh=RoJ98/3J4bGpFbXoIaQYhTZs4qSivjw8NPTnwltpGGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QoLYf2fqb/kF+6vYnEYmWWgUaavB4uwycXjRaurabMpwm3wgPeGHGkiinAtiQuciI
         v6bSIBc8Gor2WNkvktGfKO6GSTAezlCx0xmuk/lRP+IPFt/XjXssZQ5xB5Vrq/Dncg
         iVFE3/64zQ3TDruEnSdPQV126WufVVtkuaVeRXYI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Philipp Klocke <philipp97kl@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 114/205] sched/debug: Explicitly cast sched_feat() to bool
Date:   Fri,  8 Nov 2019 06:36:21 -0500
Message-Id: <20191108113752.12502-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 7e6f4c5d600c1c8e2a1d900e65cab319d9b6782e ]

LLVM has a warning that tags expressions like:

	if (foo && non-bool-const)

This pattern triggers for CONFIG_SCHED_DEBUG=n where sched_feat() ends
up being whatever bit we select. Avoid the warning with an explicit
cast to bool.

Reported-by: Philipp Klocke <philipp97kl@gmail.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9a7c3d08b39f8..c32322c73e22a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1393,7 +1393,7 @@ static const_debug __maybe_unused unsigned int sysctl_sched_features =
 	0;
 #undef SCHED_FEAT
 
-#define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
+#define sched_feat(x) !!(sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
 
 #endif /* SCHED_DEBUG && CONFIG_JUMP_LABEL */
 
-- 
2.20.1

