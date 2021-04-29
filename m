Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5B036EEBE
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 19:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbhD2RUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 13:20:13 -0400
Received: from mgw-01.mpynet.fi ([82.197.21.90]:58430 "EHLO mgw-01.mpynet.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233329AbhD2RUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Apr 2021 13:20:12 -0400
X-Greylist: delayed 1595 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Apr 2021 13:20:11 EDT
Received: from pps.filterd (mgw-01.mpynet.fi [127.0.0.1])
        by mgw-01.mpynet.fi (8.16.0.43/8.16.0.43) with SMTP id 13TGpR4P073769;
        Thu, 29 Apr 2021 19:52:46 +0300
Received: from ex13.tuxera.com (ex13.tuxera.com [178.16.184.72])
        by mgw-01.mpynet.fi with ESMTP id 387nwygmk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 29 Apr 2021 19:52:46 +0300
Received: from localhost (84.253.226.89) by tuxera-exch.ad.tuxera.com
 (10.20.48.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Apr
 2021 19:52:46 +0300
From:   Jouni Roivas <jouni.roivas@tuxera.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        <stable@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Anton Altaparmakov <anton@tuxera.com>
Subject: [PATCH] hfsplus: Prevent corruption in shrinking truncate
Date:   Thu, 29 Apr 2021 19:51:39 +0300
Message-ID: <20210429165139.3082828-1-jouni.roivas@tuxera.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [84.253.226.89]
X-ClientProxiedBy: tuxera-exch.ad.tuxera.com (10.20.48.11) To
 tuxera-exch.ad.tuxera.com (10.20.48.11)
X-Proofpoint-GUID: 3BXjuyDZVuC5qxI6x6dF34kaALyxk-nq
X-Proofpoint-ORIG-GUID: 3BXjuyDZVuC5qxI6x6dF34kaALyxk-nq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-29_08:2021-04-28,2021-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=mpy_notspam policy=mpy score=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290105
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I believe there are some issues introduced by
commit 31651c607151 ("hfsplus: avoid deadlock on file truncation")

HFS+ has extent records which always contains 8 extents. In case the
first extent record in catalog file gets full, new ones are allocated
from extents overflow file.

In case shrinking truncate happens to middle of an extent record which
locates in extents overflow file, the logic in hfsplus_file_truncate()
was changed so that call to hfs_brec_remove() is not guarded any more.

Right action would be just freeing the extents that exceed the new
size inside extent record by calling hfsplus_free_extents(), and then
check if the whole extent record should be removed. However since the
guard (blk_cnt > start) is now after the call to hfs_brec_remove(),
this has unfortunate effect that the last matching extent record is
removed unconditionally.

To reproduce this issue, create a file which has at least 10 extents,
and then perform shrinking truncate into middle of the last extent
record, so that the number of remaining extents is not under or
divisible by 8. This causes the last extent record (8 extents) to be
removed totally instead of truncating into middle of it. Thus this
causes corruption, and lost data.

Fix for this is simply checking if the new truncated end is below the
start of this extent record, making it safe to remove the full extent
record. However call to hfs_brec_remove() can't be moved to it's
previous place since we're dropping ->tree_lock and it can cause a race
condition and the cached info being invalidated possibly corrupting the
node data.

Another issue is related to this one. When entering into the block
(blk_cnt > start) we are not holding the ->tree_lock. We break out from
the loop not holding the lock, but hfs_find_exit() does unlock it. Not
sure if it's possible for someone else to take the lock under our feet,
but it can cause hard to debug errors and premature unlocking. Even if
there's no real risk of it, the locking should still always be kept in
balance. Thus taking the lock now just before the check.

Cc: <stable@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>
Reviewed-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Jouni Roivas <jouni.roivas@tuxera.com>
---
 fs/hfsplus/extents.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index a930ddd15681..7054a542689f 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -598,13 +598,15 @@ void hfsplus_file_truncate(struct inode *inode)
 		res = __hfsplus_ext_cache_extent(&fd, inode, alloc_cnt);
 		if (res)
 			break;
-		hfs_brec_remove(&fd);
 
-		mutex_unlock(&fd.tree->tree_lock);
 		start = hip->cached_start;
+		if (blk_cnt <= start)
+			hfs_brec_remove(&fd);
+		mutex_unlock(&fd.tree->tree_lock);
 		hfsplus_free_extents(sb, hip->cached_extents,
 				     alloc_cnt - start, alloc_cnt - blk_cnt);
 		hfsplus_dump_extent(hip->cached_extents);
+		mutex_lock(&fd.tree->tree_lock);
 		if (blk_cnt > start) {
 			hip->extent_state |= HFSPLUS_EXT_DIRTY;
 			break;
@@ -612,7 +614,6 @@ void hfsplus_file_truncate(struct inode *inode)
 		alloc_cnt = start;
 		hip->cached_start = hip->cached_blocks = 0;
 		hip->extent_state &= ~(HFSPLUS_EXT_DIRTY | HFSPLUS_EXT_NEW);
-		mutex_lock(&fd.tree->tree_lock);
 	}
 	hfs_find_exit(&fd);
 
-- 
2.25.1

