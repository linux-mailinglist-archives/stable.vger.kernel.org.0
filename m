Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3B541671A4
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgBUHz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:55:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:55140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730396AbgBUHz6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:55:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 009C02073A;
        Fri, 21 Feb 2020 07:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271758;
        bh=TCXdBVO4W8YwWs/6p2/vh06762IYUcp4B7L9N0S3sUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fr7wkMk6nXxi2MBwIsKEr49PObDw8/Tg9dEYlkg3xd9+NJJxgg0Ur8+cX08pASxE3
         KbDi7lprPtFoS9SVgKhea4jBWM5LseBgi60hJn+LOaNEFf6TBrBMminCgfOnKZjKa4
         D01pj/jSWUF0RNyRmtQp+Vk3SAvQhofDhmtTzEm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Guanglei <guanglei.li@unisoc.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 288/399] sched/core: Fix size of rq::uclamp initialization
Date:   Fri, 21 Feb 2020 08:40:13 +0100
Message-Id: <20200221072429.831301480@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 894fb81313fd1..b2564d62a0f74 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1253,7 +1253,8 @@ static void __init init_uclamp(void)
 	mutex_init(&uclamp_mutex);
 
 	for_each_possible_cpu(cpu) {
-		memset(&cpu_rq(cpu)->uclamp, 0, sizeof(struct uclamp_rq));
+		memset(&cpu_rq(cpu)->uclamp, 0,
+				sizeof(struct uclamp_rq)*UCLAMP_CNT);
 		cpu_rq(cpu)->uclamp_flags = 0;
 	}
 
-- 
2.20.1



