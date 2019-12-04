Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57363112233
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 05:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfLDErl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 23:47:41 -0500
Received: from lgeamrelo11.lge.com ([156.147.23.51]:60499 "EHLO
        lgeamrelo11.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbfLDErl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 23:47:41 -0500
Received: from unknown (HELO lgeamrelo02.lge.com) (156.147.1.126)
        by 156.147.23.51 with ESMTP; 4 Dec 2019 13:47:39 +0900
X-Original-SENDERIP: 156.147.1.126
X-Original-MAILFROM: chanho.min@lge.com
Received: from unknown (HELO localhost.localdomain) (10.178.31.96)
        by 156.147.1.126 with ESMTP; 4 Dec 2019 13:47:38 +0900
X-Original-SENDERIP: 10.178.31.96
X-Original-MAILFROM: chanho.min@lge.com
From:   Chanho Min <chanho.min@lge.com>
To:     Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        seungho1.park@lge.com, Inkyu Hwang <inkyu.hwang@lge.com>,
        Jinsuk Choi <jjinsuk.choi@lge.com>, stable@vger.kernel.org,
        Chanho Min <chanho.min@lge.com>
Subject: [PATCH RESEND] mm/zsmalloc.c: fix the migrated zspage statistics.
Date:   Wed,  4 Dec 2019 13:47:21 +0900
Message-Id: <1575434841-48009-1-git-send-email-chanho.min@lge.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When zspage is migrated to the other zone, the zone page state should
be updated as well, otherwise the NR_ZSPAGE for each zone shows wrong
counts including proc/zoneinfo in practice.

Cc: <stable@vger.kernel.org>        [4.9+]
Fixes: 91537fee0013 ("mm: add NR_ZSMALLOC to vmstat")
Signed-off-by: Chanho Min <chanho.min@lge.com>
Signed-off-by: Jinsuk Choi <jjinsuk.choi@lge.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
---
 mm/zsmalloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 2b2b9aa..22d17ec 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -2069,6 +2069,11 @@ static int zs_page_migrate(struct address_space *mapping, struct page *newpage,
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
-- 
2.7.4

