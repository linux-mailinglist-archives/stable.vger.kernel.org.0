Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE13915DF8F
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390147AbgBNQJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:09:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391223AbgBNQJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:09:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE96D2468C;
        Fri, 14 Feb 2020 16:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696550;
        bh=4TMk3oPXzDqusW1Vw1/tbsbx3c4Xl54P2d6RaQrX17s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1TH7yPdhZdL2dgt9AVFya0MTwiq/ctnmrdym3MwlVr9oy/KVZyrElnvxJ/O5A19eC
         v8z76M0NHpfBGlfsf+P6R2rMcLCtxf1UTGrjBTB3nF8kONxPnUgD7GzL2uP34n+vHB
         hKJol7vmFvYJ8kPfBaiemtSgMdjVouP0EXqhWNMU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Guanglei <guanglei.li@unisoc.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 343/459] sched/core: Fix size of rq::uclamp initialization
Date:   Fri, 14 Feb 2020 10:59:53 -0500
Message-Id: <20200214160149.11681-343-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Guanglei <guanglei.li@unisoc.com>

[ Upstream commit dcd6dffb0a75741471297724640733fa4e958d72 ]

rq::uclamp is an array of struct uclamp_rq, make sure we clear the
whole thing.

Fixes: 69842cba9ace ("sched/uclamp: Add CPU's clamp buckets refcountinga")
Signed-off-by: Li Guanglei <guanglei.li@unisoc.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Qais Yousef <qais.yousef@arm.com>
Link: https://lkml.kernel.org/r/1577259844-12677-1-git-send-email-guangleix.li@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 00743684a549a..9540b7e076e64 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1252,7 +1252,8 @@ static void __init init_uclamp(void)
 	mutex_init(&uclamp_mutex);
 
 	for_each_possible_cpu(cpu) {
-		memset(&cpu_rq(cpu)->uclamp, 0, sizeof(struct uclamp_rq));
+		memset(&cpu_rq(cpu)->uclamp, 0,
+				sizeof(struct uclamp_rq)*UCLAMP_CNT);
 		cpu_rq(cpu)->uclamp_flags = 0;
 	}
 
-- 
2.20.1

