Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D4C2EE26
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731380AbfE3DUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732373AbfE3DUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:54 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0F662496D;
        Thu, 30 May 2019 03:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186453;
        bh=LeDPiyFnxwiZOP4NSwMJs2cfD37WSrq+sC4BCzOfoYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzKN0bHE7O+x8VmcsFuQxj6aD6BdnMFsx76vPt7aGu67mCqpU1GIF51GsMyyD4kdr
         rVomBIY9eVmGiZGQ6Qe3sRa/0ftKRK9YwEqeAYXZZJ3u05YBuOCJliDRLLPb16cMbE
         pg1kj1ZzMCgH7knWBKwVapBatvsC7Hzk8Pc1vUzY=
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
Subject: [PATCH 4.9 065/128] sched/core: Check quota and period overflow at usec to nsec conversion
Date:   Wed, 29 May 2019 20:06:37 -0700
Message-Id: <20190530030446.474976146@linuxfoundation.org>
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

[ Upstream commit 1a8b4540db732ca16c9e43ac7c08b1b8f0b252d8 ]

Large values could overflow u64 and pass following sanity checks.

 # echo 18446744073750000 > cpu.cfs_period_us
 # cat cpu.cfs_period_us
 40448

 # echo 18446744073750000 > cpu.cfs_quota_us
 # cat cpu.cfs_quota_us
 40448

After this patch they will fail with -EINVAL.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/155125502079.293431.3947497929372138600.stgit@buzz
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 50e80b1be2c8f..4617ede80f020 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8611,8 +8611,10 @@ int tg_set_cfs_quota(struct task_group *tg, long cfs_quota_us)
 	period = ktime_to_ns(tg->cfs_bandwidth.period);
 	if (cfs_quota_us < 0)
 		quota = RUNTIME_INF;
-	else
+	else if ((u64)cfs_quota_us <= U64_MAX / NSEC_PER_USEC)
 		quota = (u64)cfs_quota_us * NSEC_PER_USEC;
+	else
+		return -EINVAL;
 
 	return tg_set_cfs_bandwidth(tg, period, quota);
 }
@@ -8634,6 +8636,9 @@ int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
 {
 	u64 quota, period;
 
+	if ((u64)cfs_period_us > U64_MAX / NSEC_PER_USEC)
+		return -EINVAL;
+
 	period = (u64)cfs_period_us * NSEC_PER_USEC;
 	quota = tg->cfs_bandwidth.quota;
 
-- 
2.20.1



