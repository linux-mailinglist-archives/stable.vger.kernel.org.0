Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA6E81C57
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbfHENWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730748AbfHENWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:22:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33B2B20657;
        Mon,  5 Aug 2019 13:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011364;
        bh=iqHwHrhpIETGLfGzdmgKsSWSRbnrsCeUGwFDY/Lb73g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ra3jWoW9Y1D/CK4YrpLujSsCpkwbblYd2n3zPjZeAjdb4wJ6AZ9Sy3FQ6YVsj+pRw
         xNH45rmOY5Ibtek6xhfrioIL0ypHmY0fu2JF1yNMlI0fLcmGgC3FJvUD7oAobt8dOv
         1H65qRo0bmadIuwJEdFo2grjG3DK/yiLdvwTtUn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Eiichi Tsukata <devel@etsukata.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 065/131] stacktrace: Force USER_DS for stack_trace_save_user()
Date:   Mon,  5 Aug 2019 15:02:32 +0200
Message-Id: <20190805124955.820469238@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 36139de0a3c4b..899b726c9e98f 100644
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



