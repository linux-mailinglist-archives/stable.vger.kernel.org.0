Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D94992F60B
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbfE3Ewa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727929AbfE3DKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:49 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7775A24482;
        Thu, 30 May 2019 03:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185848;
        bh=E7+mlZqKHOBfvv+QiQrUGEat89sfQaVVTYn77dRIOYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCWLKv7en7OVY/AQQfO0dRAwithXPTwuRkAxzpC4s+gfjVHQidcq3Epg5c+rWhStb
         x6/RpHYmPPaoYo8pFLI1OaWkX2B1lb7xQss3wJJACdMzqDx3gbb9RywmORgJ6fGko7
         XHAvCAeewAhz3jRn0dfCFGIZ5q7TNCLHnlOi1Wqw=
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
Subject: [PATCH 5.1 170/405] sched/core: Handle overflow in cpu_shares_write_u64
Date:   Wed, 29 May 2019 20:02:48 -0700
Message-Id: <20190530030549.729642107@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
index 89c9c1d7d22c5..a75ad50b5e2ff 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6559,6 +6559,8 @@ static void cpu_cgroup_attach(struct cgroup_taskset *tset)
 static int cpu_shares_write_u64(struct cgroup_subsys_state *css,
 				struct cftype *cftype, u64 shareval)
 {
+	if (shareval > scale_load_down(ULONG_MAX))
+		shareval = MAX_SHARES;
 	return sched_group_set_shares(css_tg(css), scale_load(shareval));
 }
 
-- 
2.20.1



