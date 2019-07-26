Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E312876A2C
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfGZN4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387753AbfGZNlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:41:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9003A22CD4;
        Fri, 26 Jul 2019 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148506;
        bh=nzndwPSgzd3yxlgIMwo/8KxyQSBYjo653wm/221bf28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVpAbMX1NYUg2q5lNUPHRnun6wGDm5q+dxLO+PpdPmv4v7ZgxS+bU7DogomzbFJAb
         t3Grcezc7Tzo75QnyAUPeZoyHlzlqelDHrHDEVbphMeTELS1pYfu7AzX/vwuaMrXnf
         wzdo5JHw1ZKB2IAOtQYYz6ITmkbLVsEQsNb42380=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Eiichi Tsukata <devel@etsukata.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joel Fernandes <joel@joelfernandes.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 72/85] stacktrace: Force USER_DS for stack_trace_save_user()
Date:   Fri, 26 Jul 2019 09:39:22 -0400
Message-Id: <20190726133936.11177-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit cac9b9a4b08304f11daace03b8b48659355e44c1 ]

When walking userspace stacks, USER_DS needs to be set, otherwise
access_ok() will not function as expected.

Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Reported-by: Eiichi Tsukata <devel@etsukata.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Vegard Nossum <vegard.nossum@oracle.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Link: https://lkml.kernel.org/r/20190718085754.GM3402@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/stacktrace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index 36139de0a3c4..899b726c9e98 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -226,12 +226,17 @@ unsigned int stack_trace_save_user(unsigned long *store, unsigned int size)
 		.store	= store,
 		.size	= size,
 	};
+	mm_segment_t fs;
 
 	/* Trace user stack if not a kernel thread */
 	if (!current->mm)
 		return 0;
 
+	fs = get_fs();
+	set_fs(USER_DS);
 	arch_stack_walk_user(consume_entry, &c, task_pt_regs(current));
+	set_fs(fs);
+
 	return c.len;
 }
 #endif
-- 
2.20.1

