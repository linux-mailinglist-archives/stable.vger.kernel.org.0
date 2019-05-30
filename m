Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084C62F109
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfE3EJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730951AbfE3DRM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:12 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE08D2466D;
        Thu, 30 May 2019 03:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186232;
        bh=yx0iJw45NNvcDXF2idGcnvs+znekSWFaMfqbWO0lQO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQX4APzxWb+ja9CiDI3lROLGZyjIHPN2P4p0ACzmSlUfoLQB1TBn0zean0DD0xrVG
         ART6+pfm5TwDJzfckKInz4ut6e1/U5A7A/aKpvjSfMiWVwc3tTRixLAXjWGo2W5eGi
         JrhXSAEjivmhXT+ZHmn4i15RbJMWpVCGPgBKMSLQ=
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
Subject: [PATCH 4.19 137/276] sched/rt: Check integer overflow at usec to nsec conversion
Date:   Wed, 29 May 2019 20:04:55 -0700
Message-Id: <20190530030534.285509068@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1a010e29cfa00fee2888fd2fd4983f848cbafb58 ]

Example of unhandled overflows:

 # echo 18446744073709651 > cpu.rt_runtime_us
 # cat cpu.rt_runtime_us
 99

 # echo 18446744073709900 > cpu.rt_period_us
 # cat cpu.rt_period_us
 348

After this patch they will fail with -EINVAL.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/155125501739.293431.5252197504404771496.stgit@buzz
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/rt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 2e2955a8cf8fe..b980cc96604fa 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2559,6 +2559,8 @@ int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 	rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
 	if (rt_runtime_us < 0)
 		rt_runtime = RUNTIME_INF;
+	else if ((u64)rt_runtime_us > U64_MAX / NSEC_PER_USEC)
+		return -EINVAL;
 
 	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
@@ -2579,6 +2581,9 @@ int sched_group_set_rt_period(struct task_group *tg, u64 rt_period_us)
 {
 	u64 rt_runtime, rt_period;
 
+	if (rt_period_us > U64_MAX / NSEC_PER_USEC)
+		return -EINVAL;
+
 	rt_period = rt_period_us * NSEC_PER_USEC;
 	rt_runtime = tg->rt_bandwidth.rt_runtime;
 
-- 
2.20.1



