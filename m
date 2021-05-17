Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2CF383061
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbhEQO0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239618AbhEQOYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:24:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0D17613D2;
        Mon, 17 May 2021 14:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260778;
        bh=JtbkjOVcdOzg7fuOsD2FsRSo5xPf7YLGyq6iAL+LiME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4hUzRqGsxI7HF37HeeaXtoZzOa85+USJxBhZflVA+Qz413ZdyZs/qvWUznUJjlXb
         mXRy7AEEQJSJpFca/pR8aczo/lNyaC4uznyJSF5j4CMf2uw+/ySLMCYGw0A1r3QSan
         XOi5vgEGiPAUUOW06rvuaTsa+Eduyonk5KkD4PoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>,
        Quentin Perret <qperret@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 234/363] sched: Fix out-of-bound access in uclamp
Date:   Mon, 17 May 2021 16:01:40 +0200
Message-Id: <20210517140310.494339158@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

[ Upstream commit 6d2f8909a5fabb73fe2a63918117943986c39b6c ]

Util-clamp places tasks in different buckets based on their clamp values
for performance reasons. However, the size of buckets is currently
computed using a rounding division, which can lead to an off-by-one
error in some configurations.

For instance, with 20 buckets, the bucket size will be 1024/20=51. A
task with a clamp of 1024 will be mapped to bucket id 1024/51=20. Sadly,
correct indexes are in range [0,19], hence leading to an out of bound
memory access.

Clamp the bucket id to fix the issue.

Fixes: 69842cba9ace ("sched/uclamp: Add CPU's clamp buckets refcounting")
Suggested-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lkml.kernel.org/r/20210430151412.160913-1-qperret@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 17ad829a114c..814200541f8f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -928,7 +928,7 @@ DEFINE_STATIC_KEY_FALSE(sched_uclamp_used);
 
 static inline unsigned int uclamp_bucket_id(unsigned int clamp_value)
 {
-	return clamp_value / UCLAMP_BUCKET_DELTA;
+	return min_t(unsigned int, clamp_value / UCLAMP_BUCKET_DELTA, UCLAMP_BUCKETS - 1);
 }
 
 static inline unsigned int uclamp_none(enum uclamp_id clamp_id)
-- 
2.30.2



