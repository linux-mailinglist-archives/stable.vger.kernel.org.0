Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0413A981
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388049AbfFIRBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388044AbfFIRBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:01:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B13B9206DF;
        Sun,  9 Jun 2019 17:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099683;
        bh=hFSwgNcy1FE4XaePHXQfp2EUCe80CS3i8M4vN20piSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRrBHwWGPbAy5b58xl4jK3kvLMiQLQ6rcgnoFmcVCGnLzaFGZdNdDQ382g5Wn6Xkz
         t5kVJ6Qkt+hpjZctPLdNZ1UIsSzFBSGVNUJhH0rniH+zMR3VD35UZSHk5lvaqz+WRD
         c8LKmb7+MLdTyqc7AhHcLEZuZcmigr7Q9lwpp0T0=
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
Subject: [PATCH 4.4 127/241] sched/core: Handle overflow in cpu_shares_write_u64
Date:   Sun,  9 Jun 2019 18:41:09 +0200
Message-Id: <20190609164151.467929067@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
index 1ef2fb4bbd6bd..0e70bfeded7fd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8361,6 +8361,8 @@ static void cpu_cgroup_attach(struct cgroup_taskset *tset)
 static int cpu_shares_write_u64(struct cgroup_subsys_state *css,
 				struct cftype *cftype, u64 shareval)
 {
+	if (shareval > scale_load_down(ULONG_MAX))
+		shareval = MAX_SHARES;
 	return sched_group_set_shares(css_tg(css), scale_load(shareval));
 }
 
-- 
2.20.1



