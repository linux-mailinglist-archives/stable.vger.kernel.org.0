Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49A7044071
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390408AbfFMQG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731312AbfFMIpw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:45:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8E4D21743;
        Thu, 13 Jun 2019 08:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415552;
        bh=+EOijRYzI9FkbnvTNEtmNJ+L0BCsXTD1RgtsBpxrh8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4fwdlTRx/vk8tbdjtMllTHqZx4JD5suFp9Wxo2/orq2NlvzmqUZOCOFUhWPD5B86
         zfqFpgkzsf01W/gdhaKTeuLxF+FiZV9+0xvtQS+ZDQA7b5SDEwlAezq/irCJzsDDoQ
         173c8bq7Yh/yYujXhjixhEKLQfN1pcRlscB4rw60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 018/155] mm/compaction.c: fix an undefined behaviour
Date:   Thu, 13 Jun 2019 10:32:10 +0200
Message-Id: <20190613075653.778873177@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dd7ef7bd14640f11763b54f55131000165f48321 ]

In a low-memory situation, cc->fast_search_fail can keep increasing as it
is unable to find an available page to isolate in
fast_isolate_freepages().  As the result, it could trigger an error below,
so just compare with the maximum bits can be shifted first.

UBSAN: Undefined behaviour in mm/compaction.c:1160:30
shift exponent 64 is too large for 64-bit type 'unsigned long'
CPU: 131 PID: 1308 Comm: kcompactd1 Kdump: loaded Tainted: G
W    L    5.0.0+ #17
Call trace:
 dump_backtrace+0x0/0x450
 show_stack+0x20/0x2c
 dump_stack+0xc8/0x14c
 __ubsan_handle_shift_out_of_bounds+0x7e8/0x8c4
 compaction_alloc+0x2344/0x2484
 unmap_and_move+0xdc/0x1dbc
 migrate_pages+0x274/0x1310
 compact_zone+0x26ec/0x43bc
 kcompactd+0x15b8/0x1a24
 kthread+0x374/0x390
 ret_from_fork+0x10/0x18

[akpm@linux-foundation.org: code cleanup]
Link: http://lkml.kernel.org/r/20190320203338.53367-1-cai@lca.pw
Fixes: 70b44595eafe ("mm, compaction: use free lists to quickly locate a migration source")
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/compaction.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 368445cc71cf..2d7bb9eb07cd 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1164,7 +1164,9 @@ static bool suitable_migration_target(struct compact_control *cc,
 static inline unsigned int
 freelist_scan_limit(struct compact_control *cc)
 {
-	return (COMPACT_CLUSTER_MAX >> cc->fast_search_fail) + 1;
+	unsigned short shift = BITS_PER_LONG - 1;
+
+	return (COMPACT_CLUSTER_MAX >> min(shift, cc->fast_search_fail)) + 1;
 }
 
 /*
-- 
2.20.1



