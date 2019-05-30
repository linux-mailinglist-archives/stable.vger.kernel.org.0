Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F332EC70
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732378AbfE3DUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731196AbfE3DUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:54 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31C082497C;
        Thu, 30 May 2019 03:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186454;
        bh=x7O6KTT0FirLGwU3C2fSs6asJYzlStlvS11JObgv65M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDT8rs/ewb3erzbF+YTTKUJTAMpXl719dEp4qSgd7jkdAoSUAhnLRStF2TUfJQmXM
         pMo3TLyDPr/xqEhujhPKcNiv8z/qdoXW/1jZJ761xSGhIzioAqQJmzaN4crOBbXMDv
         i/iWH0aCd800NNVZK1/1RKdLnYUqSDEI4ludo0vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 066/128] sched/core: Handle overflow in cpu_shares_write_u64
Date:   Wed, 29 May 2019 20:06:38 -0700
Message-Id: <20190530030446.697768355@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5b61d50ab4ef590f5e1d4df15cd2cea5f5715308 ]

Bit shift in scale_load() could overflow shares. This patch saturates
it to MAX_SHARES like following sched_group_set_shares().

Example:

 # echo 9223372036854776832 > cpu.shares
 # cat cpu.shares

Before patch: 1024
After pattch: 262144

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/155125501891.293431.3345233332801109696.stgit@buzz
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4617ede80f020..3861dd6da91e7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8512,6 +8512,8 @@ static void cpu_cgroup_attach(struct cgroup_taskset *tset)
 static int cpu_shares_write_u64(struct cgroup_subsys_state *css,
 				struct cftype *cftype, u64 shareval)
 {
+	if (shareval > scale_load_down(ULONG_MAX))
+		shareval = MAX_SHARES;
 	return sched_group_set_shares(css_tg(css), scale_load(shareval));
 }
 
-- 
2.20.1



