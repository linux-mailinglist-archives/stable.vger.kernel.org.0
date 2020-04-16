Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112E01AC823
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbgDPPEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408983AbgDPNxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:53:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE4B82076D;
        Thu, 16 Apr 2020 13:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045200;
        bh=4PpD070jqdkedZt8ThZiTCX383+wNv8MLoZ3mDIv1Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5mbzYANFoihGrbsvOwtmQ4dLKrj048dDVSZLVsrUmILsRM67dhL5qf90nyYdnOIS
         dle7g3XQgsC8Mid6QOXHs7QC3Ywxt+14koYxJ/V3LvjcKsrF/Fsrx8cs2L/GTLXFOT
         9+/YUiW0ytOyfPLtRdksII6Dq6NaXRvCWqEzrBFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Zhou <ouwen210@hotmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mel Gorman <mgorman@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 037/254] sched/fair: Fix condition of avg_load calculation
Date:   Thu, 16 Apr 2020 15:22:06 +0200
Message-Id: <20200416131330.497922858@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

>From reading the code about avg_load in other functions, I
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



