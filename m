Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7342B4FFF
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 19:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgKPSlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 13:41:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727750AbgKPSlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Nov 2020 13:41:10 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9166B20855;
        Mon, 16 Nov 2020 18:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605552069;
        bh=dVYXw/s/6TBo64jBpJPqbPDYjAhFP2uvWaQdLZlAKNs=;
        h=Date:From:To:Subject:From;
        b=ENN8Dp/13Yn9zEdgrKFqXhE+znzE45cAUmt3gQw5NMy2ccakLck9FPh70DG9HjfhT
         E2TqUcmezC9m+5wXBGsf8D5tSyc/EPc/L2U38FkD2YqnQw62/g1OWjZuYM/llDFfoq
         f2IXgnLBa4fgchG2ib9Hw6CcOF7u3QFAJ+1k5lfE=
Date:   Mon, 16 Nov 2020 10:41:09 -0800
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, riel@surriel.com, shy828301@gmail.com,
        stable@vger.kernel.org, vbabka@suse.cz, ziy@nvidia.com
Subject:  [merged]
 =?US-ASCII?Q?mm-compaction-stop-isolation-if-too-many-pages-are-isolate?=
 =?US-ASCII?Q?d-and-we-have-pages-to-migrate.patch?= removed from -mm tree
Message-ID: <20201116184109.BbJrDAIH5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/compaction: stop isolation if too many pages are isolated =
and we have pages to migrate
has been removed from the -mm tree.  Its filename was
     mm-compaction-stop-isolation-if-too-many-pages-are-isolated-and-we-hav=
e-pages-to-migrate.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Zi Yan <ziy@nvidia.com>
Subject: mm/compaction: stop isolation if too many pages are isolated and w=
e have pages to migrate

In isolate_migratepages_block, if we have too many isolated pages and
nr_migratepages is not zero, we should try to migrate what we have without
wasting time on isolating.

In theory it's possible that multiple parallel compactions will cause
too_many_isolated() to become true even if each has isolated less than
COMPACT_CLUSTER_MAX, and loop forever in the while loop.  Bailing
immediately prevents that.

[vbabka@suse.cz: changelog addition]
Link: https://lkml.kernel.org/r/20201030183809.3616803-2-zi.yan@sent.com
Fixes: 1da2f328fa64 (=E2=80=9Cmm,thp,compaction,cma: allow THP migration fo=
r CMA allocations=E2=80=9D)
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/compaction.c~mm-compaction-stop-isolation-if-too-many-pages-are-is=
olated-and-we-have-pages-to-migrate
+++ a/mm/compaction.c
@@ -817,6 +817,10 @@ isolate_migratepages_block(struct compac
 	 * delay for some time until fewer pages are isolated
 	 */
 	while (unlikely(too_many_isolated(pgdat))) {
+		/* stop isolation if there are still pages not migrated */
+		if (cc->nr_migratepages)
+			return 0;
+
 		/* async migration should just abort */
 		if (cc->mode =3D=3D MIGRATE_ASYNC)
 			return 0;
_

Patches currently in -mm which might be from ziy@nvidia.com are


