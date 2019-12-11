Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF8211AFFC
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731966AbfLKPSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:18:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731859AbfLKPS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A7E422527;
        Wed, 11 Dec 2019 15:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077508;
        bh=oi0NwHz/0+UXCaZM5CXMYdplOMcRs9ZrS4m8zdYsDv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YG8pZxX478TdQet0bxu6/vhNQeQjJd7J2einetm+YtO68+/tKut9A0WqVOKZ1DLGa
         dip1NQ1JPYj5JzAMA0FpLcYdu7FxVxoJDxsxRhdM+l7INhgMGA7HkzGTJxSSVDpBWK
         YrLtCCaVzBjYJ6SUPZ9NU7rLX5a/N4Rq4QEIvBws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janne Huttunen <janne.huttunen@nokia.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 064/243] mm/vmstat.c: fix NUMA statistics updates
Date:   Wed, 11 Dec 2019 16:03:46 +0100
Message-Id: <20191211150343.419011891@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janne Huttunen <janne.huttunen@nokia.com>

[ Upstream commit 13c9aaf7fa01cc7600c61981609feadeef3354ec ]

Scan through the whole array to see if an update is needed.  While we're
at it, use sizeof() to be safe against any possible type changes in the
future.

The bug here is that we wouldn't sync per-cpu counters into global ones
if there was an update of numa_stats for higher cpus.  Highly
theoretical one though because it is much more probable that zone_stats
are updated so we would refresh anyway.  So I wouldn't bother to mark
this for stable, yet something nice to fix.

[mhocko@suse.com: changelog enhancement]
Link: http://lkml.kernel.org/r/1541601517-17282-1-git-send-email-janne.huttunen@nokia.com
Fixes: 1d90ca897cb0 ("mm: update NUMA counter threshold size")
Signed-off-by: Janne Huttunen <janne.huttunen@nokia.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmstat.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index a2b2ea786c9b2..ce81b0a7d0186 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1826,12 +1826,13 @@ static bool need_update(int cpu)
 
 		/*
 		 * The fast way of checking if there are any vmstat diffs.
-		 * This works because the diffs are byte sized items.
 		 */
-		if (memchr_inv(p->vm_stat_diff, 0, NR_VM_ZONE_STAT_ITEMS))
+		if (memchr_inv(p->vm_stat_diff, 0, NR_VM_ZONE_STAT_ITEMS *
+			       sizeof(p->vm_stat_diff[0])))
 			return true;
 #ifdef CONFIG_NUMA
-		if (memchr_inv(p->vm_numa_stat_diff, 0, NR_VM_NUMA_STAT_ITEMS))
+		if (memchr_inv(p->vm_numa_stat_diff, 0, NR_VM_NUMA_STAT_ITEMS *
+			       sizeof(p->vm_numa_stat_diff[0])))
 			return true;
 #endif
 	}
-- 
2.20.1



