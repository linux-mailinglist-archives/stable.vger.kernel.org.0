Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4574301995
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 06:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbhAXFCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 00:02:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbhAXFCF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Jan 2021 00:02:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F7E422581;
        Sun, 24 Jan 2021 05:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611464482;
        bh=WIzIzn9J3HEweHSPZO07FXCJBKhAfp8duZ1IMwbU0dA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BTZ3GkSQ/l7aIpN+UsV1arwdMpxsOn2KXVMDLeXyczecPkoZWWDWS2+wf6A3qJk+7
         LAuYI0Es+Nri4TAUDjQ+J6b6mBc5zNWfppGLvJjvPhjbpW0oSiaf9jsuU9dtUUKomz
         uPi7oDeMJ9p1GHQ2f1Gkruvp4MsWZYBa20WNFC5o=
Date:   Sat, 23 Jan 2021 21:01:19 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 06/19] mm: memcontrol: prevent starvation when
 writing memory.high
Message-ID: <20210124050119.34lm1Gw1Q%akpm@linux-foundation.org>
In-Reply-To: <20210123210029.a7c704d0cab204683e41ad10@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: prevent starvation when writing memory.high

When a value is written to a cgroup's memory.high control file, the
write() context first tries to reclaim the cgroup to size before putting
the limit in place for the workload.  Concurrent charges from the workload
can keep such a write() looping in reclaim indefinitely.

In the past, a write to memory.high would first put the limit in place for
the workload, then do targeted reclaim until the new limit has been met -
similar to how we do it for memory.max.  This wasn't prone to the
described starvation issue.  However, this sequence could cause excessive
latencies in the workload, when allocating threads could be put into long
penalty sleeps on the sudden memory.high overage created by the write(),
before that had a chance to work it off.

Now that memory_high_write() performs reclaim before enforcing the new
limit, reflect that the cgroup may well fail to converge due to concurrent
workload activity.  Bail out of the loop after a few tries.

Link: https://lkml.kernel.org/r/20210112163011.127833-1-hannes@cmpxchg.org
Fixes: 536d3bf261a2 ("mm: memcontrol: avoid workload stalls when lowering m=
emory.high")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Tejun Heo <tj@kernel.org>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>	[5.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-prevent-starvation-when-writing-memoryh=
igh
+++ a/mm/memcontrol.c
@@ -6273,7 +6273,6 @@ static ssize_t memory_high_write(struct
=20
 	for (;;) {
 		unsigned long nr_pages =3D page_counter_read(&memcg->memory);
-		unsigned long reclaimed;
=20
 		if (nr_pages <=3D high)
 			break;
@@ -6287,10 +6286,10 @@ static ssize_t memory_high_write(struct
 			continue;
 		}
=20
-		reclaimed =3D try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-							 GFP_KERNEL, true);
+		try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
+					     GFP_KERNEL, true);
=20
-		if (!reclaimed && !nr_retries--)
+		if (!nr_retries--)
 			break;
 	}
=20
_
