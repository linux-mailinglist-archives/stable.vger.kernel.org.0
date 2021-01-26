Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138C7304A5E
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731530AbhAZFFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:33424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730808AbhAZBpL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 20:45:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D07B5229C4;
        Tue, 26 Jan 2021 01:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611622857;
        bh=2fhVeA9L0qxjYu7pa1o0emVCKJX9T5S21Dol+AZsFlo=;
        h=Date:From:To:Subject:From;
        b=ZNO+gbgeQopziTbX0E2yFu6WDOnA6t2Z5HMZseexytpcdz2DT5MuizW6XYic3YkJ7
         JvFbRy0j8LDcL5M8fLnpZe8qXx8xiUzqwuzu6FOTc1Pa11UrbfY4b8dhDKvDtI8IgJ
         VBfjlDJtaub5A8711dGmDovNcOqkqqWplckawsko=
Date:   Mon, 25 Jan 2021 17:00:56 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, tj@kernel.org
Subject:  [alternative-merged]
 mm-memcontrol-prevent-starvation-when-writing-memoryhigh.patch removed from
 -mm tree
Message-ID: <20210126010056.MshuMuzDK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: prevent starvation when writing memory.high
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-prevent-starvation-when-writing-memoryhigh.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
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

Patches currently in -mm which might be from hannes@cmpxchg.org are

revert-mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh.patch

