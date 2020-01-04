Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 667C9130472
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 21:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgADU7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 15:59:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbgADU7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 Jan 2020 15:59:37 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3636824654;
        Sat,  4 Jan 2020 20:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578171577;
        bh=HuPWhhHrqeSWiUh121GEnd8YYpBsCHJV6q9ZOlF5gqI=;
        h=Date:From:To:Subject:From;
        b=I0Hh+tJhU3x3XdeoiQDMD4PF6NJzu/VzscqM5bvQTtml7ryeAGycUcc6l2LFUYCGW
         MmdI2r6wip6dQ1DAvz91ely/3TPQ7KkiNzf0KyNfK28rleZfNFDrz5iSu/AK/AfDN8
         Fg7I2zSRyCDwecmTHgsVvsXClx0L5SAupxomena4=
Date:   Sat, 04 Jan 2020 12:59:36 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, chanho.min@lge.com,
        jjinsuk.choi@lge.com, linux-mm@kvack.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 02/17] mm/zsmalloc.c: fix the migrated zspage
 statistics.
Message-ID: <20200104205936.KQJRwCAg-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
