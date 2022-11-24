Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A3D6380D2
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 23:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiKXWLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 17:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiKXWLm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 17:11:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70720898C7;
        Thu, 24 Nov 2022 14:11:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23998B82904;
        Thu, 24 Nov 2022 22:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08E6C433C1;
        Thu, 24 Nov 2022 22:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669327898;
        bh=P4Nkni80swF4c00hCzUN3eDIZhvT+PaoaRZA8UFyfDA=;
        h=Date:To:From:Subject:From;
        b=fFE2Xtq1h3ZJU6uO+Nw18wfQNcJOs/USFKMtShwxdUGKPIYcntiQr88CJhpWyvbew
         bAZeGgkZ3Z0CzOzmo3A9RjmAZ01Zu1O2g0xRxfruAQxi3LVOty6HpCdbyDGTgM8TrW
         k/3NwTB6fDgOswyO+l1PugYfUfk9I2n/j9YNZHKk=
Date:   Thu, 24 Nov 2022 14:11:37 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, zhenyzha@redhat.com,
        william.kucharski@oracle.com, stable@vger.kernel.org,
        kirill.shutemov@linux.intel.com, david@redhat.com,
        gshan@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-migrate-fix-thps-mapcount-on-isolation.patch removed from -mm tree
Message-Id: <20221124221138.C08E6C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: migrate: Fix THP's mapcount on isolation
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-thps-mapcount-on-isolation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm: migrate: Fix THP's mapcount on isolation
Date: Wed, 23 Nov 2022 08:57:52 +0800

The issue is reported when removing memory through virtio_mem device.  The
transparent huge page, experienced copy-on-write fault, is wrongly
regarded as pinned.  The transparent huge page is escaped from being
isolated in isolate_migratepages_block().  The transparent huge page can't
be migrated and the corresponding memory block can't be put into offline
state.

Fix it by replacing page_mapcount() with total_mapcount().  With this, the
transparent huge page can be isolated and migrated, and the memory block
can be put into offline state.

Link: https://lkml.kernel.org/r/20221123005752.161003-1-gshan@redhat.com
Fixes: 3917c80280c9 ("thp: change CoW semantics for anon-THP")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>	[v5.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-migrate-fix-thps-mapcount-on-isolation
+++ a/mm/compaction.c
@@ -990,7 +990,7 @@ isolate_migratepages_block(struct compac
 		 * admittedly racy check.
 		 */
 		mapping = page_mapping(page);
-		if (!mapping && page_count(page) > page_mapcount(page))
+		if (!mapping && page_count(page) > total_mapcount(page))
 			goto isolate_fail;
 
 		/*
_

Patches currently in -mm which might be from gshan@redhat.com are


