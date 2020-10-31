Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9DD2A1A48
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 20:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgJaTnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 15:43:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgJaTnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 15:43:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCF01206E9;
        Sat, 31 Oct 2020 19:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604173403;
        bh=VTjl14a0nFILUsN1lDN1BGJHsg2WhHw3Bx1dpz6akv4=;
        h=Date:From:To:Subject:From;
        b=FtcCdGbHUGQhNDuZWh02XgqZYodTFq9L2U7QwICGS7zUYbYvJqmxCI0ErsoaEO5It
         iX2JZW6XKf94ihgPHX3MjjVFDwf0HGX38NMHhHfCH4m/YOLqJwg3RP62OLfc/82+lI
         ljbKez1ZBCKbm9tKUgf0PJ2QC0qJvC6AOA1I8aZo=
Date:   Sat, 31 Oct 2020 12:43:22 -0700
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, riel@surriel.com, shy828301@gmail.com,
        stable@vger.kernel.org, vbabka@suse.cz, ziy@nvidia.com
Subject:  +
 =?US-ASCII?Q?mm-compaction-stop-isolation-if-too-many-pages-are-isolate?=
 =?US-ASCII?Q?d-and-we-have-pages-to-migrate.patch?= added to -mm tree
Message-ID: <20201031194322.G8zdI8Fpy%akpm@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     mm-compaction-stop-isolation-if-too-many-pages-are-isolated-and-we-hav=
e-pages-to-migrate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-stop-isolation-=
if-too-many-pages-are-isolated-and-we-have-pages-to-migrate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-stop-isolation-=
if-too-many-pages-are-isolated-and-we-have-pages-to-migrate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Zi Yan <ziy@nvidia.com>
Subject: mm/compaction: stop isolation if too many pages are isolated and w=
e have pages to migrate

In isolate_migratepages_block, if we have too many isolated pages and
nr_migratepages is not zero, we should try to migrate what we have without
wasting time on isolating.

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

mm-compaction-count-pages-and-stop-correctly-during-page-isolation.patch
mm-compaction-count-pages-and-stop-correctly-during-page-isolation-v3.patch
mm-compaction-stop-isolation-if-too-many-pages-are-isolated-and-we-have-pag=
es-to-migrate.patch

