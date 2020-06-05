Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B371EFAA5
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgFEOT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727973AbgFEOT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:19:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7188208A9;
        Fri,  5 Jun 2020 14:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366767;
        bh=hdTdm917EtRampf7Yvwgw4mSbIBi5+48PdnjaXNUQTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T46Z5o/Gz7tqUk2Y0qVLYw83nL20O+JsCIQlB3M6l/8V/MAaGMcUEnlVoj7w3CYBt
         ySOnrgAkJgLhoB/rTv8N9mRypmtSKhYaD8qPm7UJ2KZ2GjcLKU5FDtJbm0Fwk62DEH
         Tj5H6fGqyCBdGFtTByWk8335T1ZvscNBzOsRgV/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/28] Revert "cgroup: Add memory barriers to plug cgroup_rstat_updated() race window"
Date:   Fri,  5 Jun 2020 16:15:03 +0200
Message-Id: <20200605140252.421219691@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.338635395@linuxfoundation.org>
References: <20200605140252.338635395@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

[ Upstream commit d8ef4b38cb69d907f9b0e889c44d05fc0f890977 ]

This reverts commit 9a9e97b2f1f2 ("cgroup: Add memory barriers to plug
cgroup_rstat_updated() race window").

The commit was added in anticipation of memcg rstat conversion which needed
synchronous accounting for the event counters (e.g. oom kill count). However,
the conversion didn't get merged due to percpu memory overhead concern which
couldn't be addressed at the time.

Unfortunately, the patch's addition of smp_mb() to cgroup_rstat_updated()
meant that every scheduling event now had to go through an additional full
barrier and Mel Gorman noticed it as 1% regression in netperf UDP_STREAM test.

There's no need to have this barrier in tree now and even if we need
synchronous accounting in the future, the right thing to do is separating that
out to a separate function so that hot paths which don't care about
synchronous behavior don't have to pay the overhead of the full barrier. Let's
revert.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Mel Gorman <mgorman@techsingularity.net>
Link: http://lkml.kernel.org/r/20200409154413.GK3818@techsingularity.net
Cc: v4.18+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/rstat.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index bb95a35e8c2d..d0ed410b4127 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -32,12 +32,9 @@ void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 		return;
 
 	/*
-	 * Paired with the one in cgroup_rstat_cpu_pop_upated().  Either we
-	 * see NULL updated_next or they see our updated stat.
-	 */
-	smp_mb();
-
-	/*
+	 * Speculative already-on-list test. This may race leading to
+	 * temporary inaccuracies, which is fine.
+	 *
 	 * Because @parent's updated_children is terminated with @parent
 	 * instead of NULL, we can tell whether @cgrp is on the list by
 	 * testing the next pointer for NULL.
@@ -133,13 +130,6 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 		*nextp = rstatc->updated_next;
 		rstatc->updated_next = NULL;
 
-		/*
-		 * Paired with the one in cgroup_rstat_cpu_updated().
-		 * Either they see NULL updated_next or we see their
-		 * updated stat.
-		 */
-		smp_mb();
-
 		return pos;
 	}
 
-- 
2.25.1



