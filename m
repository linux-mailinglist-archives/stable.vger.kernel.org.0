Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0D001A40FD
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgDJDrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:47:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726659AbgDJDrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:47:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99A4B20BED;
        Fri, 10 Apr 2020 03:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490440;
        bh=GjPeH6JpRUsDpjzBE8PwMZtO+xG1P4rvrLtffBmCaqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zzmrkv+voMUvVzSO2njOYEC0S+rT1IZjM/wvvt2aseDX4O5Z287CFboe0F3WCOyQi
         /fQIftpy3anwmcjoZs4dgpSbd0FRmL8g16yvo2H9Duvcfb6D0bOGvFmZq3BlTM88Du
         WYWa0xZTAz0qM0NjHDtebqdBV9dyLFsPyTGNrmT8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tao Zhou <ouwen210@hotmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mel Gorman <mgorman@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 37/68] sched/fair: Fix condition of avg_load calculation
Date:   Thu,  9 Apr 2020 23:46:02 -0400
Message-Id: <20200410034634.7731-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034634.7731-1-sashal@kernel.org>
References: <20200410034634.7731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Zhou <ouwen210@hotmail.com>

[ Upstream commit 6c8116c914b65be5e4d6f66d69c8142eb0648c22 ]

In update_sg_wakeup_stats(), the comment says:

Computing avg_load makes sense only when group is fully
busy or overloaded.

But, the code below this comment does not check like this.

From reading the code about avg_load in other functions, I
confirm that avg_load should be calculated in fully busy or
overloaded case. The comment is correct and the checking
condition is wrong. So, change that condition.

Fixes: 57abff067a08 ("sched/fair: Rework find_idlest_group()")
Signed-off-by: Tao Zhou <ouwen210@hotmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Link: https://lkml.kernel.org/r/Message-ID:
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c1217bfe5e819..7f895d5139948 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8345,7 +8345,8 @@ static inline void update_sg_wakeup_stats(struct sched_domain *sd,
 	 * Computing avg_load makes sense only when group is fully busy or
 	 * overloaded
 	 */
-	if (sgs->group_type < group_fully_busy)
+	if (sgs->group_type == group_fully_busy ||
+		sgs->group_type == group_overloaded)
 		sgs->avg_load = (sgs->group_load * SCHED_CAPACITY_SCALE) /
 				sgs->group_capacity;
 }
-- 
2.20.1

