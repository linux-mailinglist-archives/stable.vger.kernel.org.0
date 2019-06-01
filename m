Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB2631F65
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfFANRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:17:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727551AbfFANRq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:17:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E3E22569E;
        Sat,  1 Jun 2019 13:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395066;
        bh=SKeFZxLlJJEe28gVBbpYOeHuIKrn5SXSvLw4bDj5xSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PIAJLMrqXO9fV6XF4DxT8NsqjxvNxdDm4szh7RUueQN2p+OUWJOay3OaEdcZA9X4N
         0aNZcqx7Crw5EtqBRYtGOYIRok0QAcC9DnyaKU2ZufxW3oz3t7DiN2RV5NL8R9CQ2A
         /LqzE2boG0UYW2tfsyfkVzYMI5q6+2Wxo5bJISfo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.1 017/186] mm/compaction.c: fix an undefined behaviour
Date:   Sat,  1 Jun 2019 09:13:53 -0400
Message-Id: <20190601131653.24205-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

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
index 444029da4e9d8..7b48ac9164a89 100644
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

