Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B98923E731
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 08:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgHGGWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 02:22:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 02:22:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33CC122C9F;
        Fri,  7 Aug 2020 06:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781339;
        bh=oSdNly9aIeyibSd9/S4eMSMD5jPf3sak6mS/2Aqks1A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XX7RS8XNlUeUGQWfrxFpo/0uT/lGY26j6IKgkZFLpueXaBLdAiIAABur7zi8FVCzf
         X+Ll7btLzEg5Vtp8Je/89OT1Mo6vwK+wKDRRfAnjetFf6NoKI+axYh8c4husXYnb8N
         i7rENz9gdA3cZhTqQnGazowo0YSklM5Shbt6IGhw=
Date:   Thu, 06 Aug 2020 23:22:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 093/163] mm/page_counter.c: fix protection usage
 propagation
Message-ID: <20200807062218.U7OzBph9t%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=46rom: Michal Koutn=C3=BD <mkoutny@suse.com>
Subject: mm/page_counter.c: fix protection usage propagation

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

Link: http://lkml.kernel.org/r/20200803153231.15477-1-mhocko@kernel.org
Fixes: 230671533d64 ("mm: memory.low hierarchical behavior")
Signed-off-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>	[4.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_counter.c~mm-fix-protection-usage-propagation
+++ a/mm/page_counter.c
@@ -72,7 +72,7 @@ void page_counter_charge(struct page_cou
 		long new;
=20
 		new =3D atomic_long_add_return(nr_pages, &c->usage);
-		propagate_protected_usage(counter, new);
+		propagate_protected_usage(c, new);
 		/*
 		 * This is indeed racy, but we can live with some
 		 * inaccuracy in the watermark.
@@ -116,7 +116,7 @@ bool page_counter_try_charge(struct page
 		new =3D atomic_long_add_return(nr_pages, &c->usage);
 		if (new > c->max) {
 			atomic_long_sub(nr_pages, &c->usage);
-			propagate_protected_usage(counter, new);
+			propagate_protected_usage(c, new);
 			/*
 			 * This is racy, but we can live with some
 			 * inaccuracy in the failcnt.
@@ -125,7 +125,7 @@ bool page_counter_try_charge(struct page
 			*fail =3D c;
 			goto failed;
 		}
-		propagate_protected_usage(counter, new);
+		propagate_protected_usage(c, new);
 		/*
 		 * Just like with failcnt, we can live with some
 		 * inaccuracy in the watermark.
_
