Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B7B1137E4
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 23:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfLDW67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 17:58:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:48840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbfLDW67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 17:58:59 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9D40206DB;
        Wed,  4 Dec 2019 22:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575500338;
        bh=kxXKPcJcPKEfGfVmrB0I55DYFu+cQ1nd1VHyHrwmOUA=;
        h=Date:From:To:Subject:From;
        b=N5QuT68G+LlmPit8/LRM6Iqk3RgH2lIGvA4dBFxaGzedxVQd45SiM4PIcbAguP9sa
         EG2OCU9TbUoRRpIWr9En3hnyIwBfkEBE4uam4nYF/xTNOViBzXnhe+Mz/xciQ+4L7H
         f4rM5Ol/gEjb0G+cqyiHf3jSTIQ0gmlx+Aa78NMo=
Date:   Wed, 04 Dec 2019 14:58:58 -0800
From:   akpm@linux-foundation.org
To:     chanho.min@lge.com, jjinsuk.choi@lge.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com,
        stable@vger.kernel.org
Subject:  + mm-zsmallocc-fix-the-migrated-zspage-statistics.patch
 added to -mm tree
Message-ID: <20191204225858.BGHJTiBbn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: fix the migrated zspage statistics.
has been added to the -mm tree.  Its filename is
     mm-zsmallocc-fix-the-migrated-zspage-statistics.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmallocc-fix-the-migrated-zspage-statistics.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmallocc-fix-the-migrated-zspage-statistics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chanho Min <chanho.min@lge.com>
Subject: mm/zsmalloc.c: fix the migrated zspage statistics.

When zspage is migrated to the other zone, the zone page state should be
updated as well, otherwise the NR_ZSPAGE for each zone shows wrong counts
including proc/zoneinfo in practice.

Link: http://lkml.kernel.org/r/1575434841-48009-1-git-send-email-chanho.min@lge.com
Fixes: 91537fee0013 ("mm: add NR_ZSMALLOC to vmstat")
Signed-off-by: Chanho Min <chanho.min@lge.com>
Signed-off-by: Jinsuk Choi <jjinsuk.choi@lge.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>        [4.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/zsmalloc.c~mm-zsmallocc-fix-the-migrated-zspage-statistics
+++ a/mm/zsmalloc.c
@@ -2069,6 +2069,11 @@ static int zs_page_migrate(struct addres
 		zs_pool_dec_isolated(pool);
 	}
 
+	if (page_zone(newpage) != page_zone(page)) {
+		dec_zone_page_state(page, NR_ZSPAGES);
+		inc_zone_page_state(newpage, NR_ZSPAGES);
+	}
+
 	reset_page(page);
 	put_page(page);
 	page = newpage;
_

Patches currently in -mm which might be from chanho.min@lge.com are

mm-zsmallocc-fix-the-migrated-zspage-statistics.patch

