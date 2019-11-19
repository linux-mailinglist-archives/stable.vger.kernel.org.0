Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75439101868
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729319AbfKSFb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:31:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729315AbfKSFbx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:31:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69A8A222A2;
        Tue, 19 Nov 2019 05:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141512;
        bh=brsGMJbB8Y/X6b87XrfPuGi9CYA42fx94LcAjJEr0TY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMw79pKO5REx/sZtaLVltzPIbl+jKzugfAJOmfT5EQf7Tc7ouoHAytBjvxlGusloh
         SpU7oo3MEtP738cYlcuqmU3NHsAEGT8CgLgNRaMYTg8RoLot9ASPmBvoTy1zdzL/qI
         7W2YzSVHw/5MQdwvZj7FYPQIHT1c+/Cmp7eMPqc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Klocke <philipp97kl@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/422] sched/debug: Explicitly cast sched_feat() to bool
Date:   Tue, 19 Nov 2019 06:15:43 +0100
Message-Id: <20191119051408.155153867@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 62058fd6dcf63..94bec97bd5e28 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1389,7 +1389,7 @@ static const_debug __maybe_unused unsigned int sysctl_sched_features =
 	0;
 #undef SCHED_FEAT
 
-#define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
+#define sched_feat(x) !!(sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
 
 #endif /* SCHED_DEBUG && CONFIG_JUMP_LABEL */
 
-- 
2.20.1



