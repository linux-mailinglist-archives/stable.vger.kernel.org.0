Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C69B170E00
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 02:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731681AbfGWARP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 20:17:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfGWARP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jul 2019 20:17:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9DC82199C;
        Tue, 23 Jul 2019 00:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563841034;
        bh=oF+ER6D8bcyy3qtsvVfLvukjLH9//a/rG4RVEa5B5es=;
        h=Date:From:To:Subject:From;
        b=Y6/UIGvdYBCqj6Ok9Dr+fAPMRQD6Jo/DiOlrSzQdARiRpK/JUJnNv1ytyZLpz6dLt
         3Ks9+XWLbxQr9TrUhHQ54E9ppdzkW8Mwc4Q98oFHa1hPzoHVwgpTnxHHVI+q657hBR
         bLIf0v25TAVHvnc336ofnv8GnnxkRLx/y312X13I=
Date:   Mon, 22 Jul 2019 17:17:14 -0700
From:   akpm@linux-foundation.org
To:     laoar.shao@gmail.com, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shaoyafang@didiglobal.com, stable@vger.kernel.org, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-compaction-clear-total=5Fmigratefree=5Fscanned-before-s?=
 =?US-ASCII?Q?canning-a-new-zone.patch?= added to -mm tree
Message-ID: <20190723001714.9PNveKHG8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: clear total_{migrate,free}_scanned before scanning a new zone
has been added to the -mm tree.  Its filename is
     mm-compaction-clear-total_migratefree_scanned-before-scanning-a-new-zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-clear-total_migratefree_scanned-before-scanning-a-new-zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-clear-total_migratefree_scanned-before-scanning-a-new-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm/compaction.c: clear total_{migrate,free}_scanned before scanning a new zone

total_{migrate,free}_scanned will be added to COMPACTMIGRATE_SCANNED and
COMPACTFREE_SCANNED in compact_zone().  We should clear them before
scanning a new zone.  In the proc triggered compaction, we forgot clearing
them.

Link: http://lkml.kernel.org/r/1563789275-9639-1-git-send-email-laoar.shao@gmail.com
Fixes: 7f354a548d1c ("mm, compaction: add vmstats for kcompactd work")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang Shao <shaoyafang@didiglobal.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-clear-total_migratefree_scanned-before-scanning-a-new-zone
+++ a/mm/compaction.c
@@ -2408,8 +2408,6 @@ static void compact_node(int nid)
 	struct zone *zone;
 	struct compact_control cc = {
 		.order = -1,
-		.total_migrate_scanned = 0,
-		.total_free_scanned = 0,
 		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
 		.whole_zone = true,
@@ -2425,6 +2423,8 @@ static void compact_node(int nid)
 
 		cc.nr_freepages = 0;
 		cc.nr_migratepages = 0;
+		cc.total_migrate_scanned = 0;
+		cc.total_free_scanned = 0;
 		cc.zone = zone;
 		INIT_LIST_HEAD(&cc.freepages);
 		INIT_LIST_HEAD(&cc.migratepages);
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-vmscan-expose-cgroup_ino-for-memcg-reclaim-tracepoints.patch
mm-compaction-clear-total_migratefree_scanned-before-scanning-a-new-zone.patch

