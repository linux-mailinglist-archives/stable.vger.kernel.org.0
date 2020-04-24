Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241751B7537
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgDXMbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727839AbgDXMXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF31F2087E;
        Fri, 24 Apr 2020 12:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587730988;
        bh=WMY2KhaknJ6qcA8omuj0vvPzI9GIiw3E9kxGJCALNEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZrtCxDOpOUzh6OPDnHVlLTPAk1srVA1xk3hOpLbZ02NvaHIwviMqJ5q9HfeTW4PDV
         ghrtstQX0Bgx/mSdRTLgYUyblupk49mVWD+7LgpgeZNCKMIDM2hFGsrkszE31otDRU
         XGY8/mi1kaVFRNixhJTifo3nEwpyneIWQHMzcenw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 27/38] sched/vtime: Work around an unitialized variable warning
Date:   Fri, 24 Apr 2020 08:22:25 -0400
Message-Id: <20200424122237.9831-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122237.9831-1-sashal@kernel.org>
References: <20200424122237.9831-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit e0d648f9d883ec1efab261af158d73aa30e9dd12 ]

Work around this warning:

  kernel/sched/cputime.c: In function ‘kcpustat_field’:
  kernel/sched/cputime.c:1007:6: warning: ‘val’ may be used uninitialized in this function [-Wmaybe-uninitialized]

because GCC can't see that val is used only when err is 0.

Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20200327214334.GF8015@zn.tnic
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cputime.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index dac9104d126f7..ff9435dee1df2 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -1003,12 +1003,12 @@ u64 kcpustat_field(struct kernel_cpustat *kcpustat,
 		   enum cpu_usage_stat usage, int cpu)
 {
 	u64 *cpustat = kcpustat->cpustat;
+	u64 val = cpustat[usage];
 	struct rq *rq;
-	u64 val;
 	int err;
 
 	if (!vtime_accounting_enabled_cpu(cpu))
-		return cpustat[usage];
+		return val;
 
 	rq = cpu_rq(cpu);
 
-- 
2.20.1

