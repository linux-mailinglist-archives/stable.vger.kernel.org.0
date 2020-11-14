Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F7D2B2BD1
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 07:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgKNGvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 01:51:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgKNGvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Nov 2020 01:51:44 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E744120678;
        Sat, 14 Nov 2020 06:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605336704;
        bh=7A8xRWjoWPWC9KyJ6x3rmRUQXiSqxG75ANllE40gtLo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xJ/bJfViHVB1I9bXIA4pxqZUlnb8SqqJNl1dmDc+0iHh8SxpA+KWzPufRmOaO88Gw
         yzSjQJAiA7dPpFhDnFpiXuho2A44Oh1rs9X66w1b64OjxIfbeRuP39TQz6SDZKDzKE
         Gk0ShjhRP6crlzgDn/0AvG0EwXkjtiGGEkJkgsBY=
Date:   Fri, 13 Nov 2020 22:51:43 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, riel@surriel.com, shy828301@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, ziy@nvidia.com
Subject:  [patch 02/14] mm/compaction: stop isolation if too many
 pages are isolated and we have pages to migrate
Message-ID: <20201114065143.mF1DRNoun%akpm@linux-foundation.org>
In-Reply-To: <20201113225115.b24faebc85f710d5aff55aa7@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
