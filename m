Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FAF24BF96
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgHTNuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727977AbgHTJ1Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:27:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F14BE22B4B;
        Thu, 20 Aug 2020 09:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915644;
        bh=EqcsjBxJ0kSJGRNSqRm07UoiqBAOeV5Df6CJ64YjXug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFhdPhAo5r/hNJLAIIp859lVEhZKOdOJK6aaclwkK827PhjRpOov6OTgwNhJkgsEN
         JLabNVJxD5rC7jny6atP507y1bbiEeArKOCuq0ryylvkXwEVpOWgIWxLer91DTL3I2
         LbFrk3IBeM+V9AmltToce07Gxu2dqpP9y6Am0jUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 085/232] mm/page_counter.c: fix protection usage propagation
Date:   Thu, 20 Aug 2020 11:18:56 +0200
Message-Id: <20200820091616.934865239@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Koutný <mkoutny@suse.com>

commit a6f23d14ec7d7d02220ad8bb2774be3322b9aeec upstream.

When workload runs in cgroups that aren't directly below root cgroup and
their parent specifies reclaim protection, it may end up ineffective.

The reason is that propagate_protected_usage() is not called in all
hierarchy up.  All the protected usage is incorrectly accumulated in the
workload's parent.  This means that siblings_low_usage is overestimated
and effective protection underestimated.  Even though it is transitional
phenomenon (uncharge path does correct propagation and fixes the wrong
children_low_usage), it can undermine the intended protection
unexpectedly.

We have noticed this problem while seeing a swap out in a descendant of a
protected memcg (intermediate node) while the parent was conveniently
under its protection limit and the memory pressure was external to that
hierarchy.  Michal has pinpointed this down to the wrong
siblings_low_usage which led to the unwanted reclaim.

The fix is simply updating children_low_usage in respective ancestors also
in the charging path.

Fixes: 230671533d64 ("mm: memory.low hierarchical behavior")
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>	[4.18+]
Link: http://lkml.kernel.org/r/20200803153231.15477-1-mhocko@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_counter.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -72,7 +72,7 @@ void page_counter_charge(struct page_cou
 		long new;
 
 		new = atomic_long_add_return(nr_pages, &c->usage);
-		propagate_protected_usage(counter, new);
+		propagate_protected_usage(c, new);
 		/*
 		 * This is indeed racy, but we can live with some
 		 * inaccuracy in the watermark.
@@ -116,7 +116,7 @@ bool page_counter_try_charge(struct page
 		new = atomic_long_add_return(nr_pages, &c->usage);
 		if (new > c->max) {
 			atomic_long_sub(nr_pages, &c->usage);
-			propagate_protected_usage(counter, new);
+			propagate_protected_usage(c, new);
 			/*
 			 * This is racy, but we can live with some
 			 * inaccuracy in the failcnt.
@@ -125,7 +125,7 @@ bool page_counter_try_charge(struct page
 			*fail = c;
 			goto failed;
 		}
-		propagate_protected_usage(counter, new);
+		propagate_protected_usage(c, new);
 		/*
 		 * Just like with failcnt, we can live with some
 		 * inaccuracy in the watermark.


