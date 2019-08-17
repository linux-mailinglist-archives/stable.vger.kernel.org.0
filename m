Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8686A9101A
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 12:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfHQKhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 06:37:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51586 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbfHQKhT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Aug 2019 06:37:19 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hyw5E-0008PL-Hu; Sat, 17 Aug 2019 11:37:16 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1hyw5E-0005oo-CH; Sat, 17 Aug 2019 11:37:16 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Theodore Ts'o" <tytso@mit.edu>, "Hulk Robot" <hulkci@huawei.com>,
        "zhangyi (F)" <yi.zhang@huawei.com>, "Jan Kara" <jack@suse.cz>
Date:   Sat, 17 Aug 2019 11:35:11 +0100
Message-ID: <lsq.1566038111.854541932@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 2/4] ext4: brelse all indirect buffer in
 ext4_ind_remove_space()
In-Reply-To: <lsq.1566038111.397675943@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.73-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "zhangyi (F)" <yi.zhang@huawei.com>

commit 674a2b27234d1b7afcb0a9162e81b2e53aeef217 upstream.

All indirect buffers get by ext4_find_shared() should be released no
mater the branch should be freed or not. But now, we forget to release
the lower depth indirect buffers when removing space from the same
higher depth indirect block. It will lead to buffer leak and futher
more, it may lead to quota information corruption when using old quota,
consider the following case.

 - Create and mount an empty ext4 filesystem without extent and quota
   features,
 - quotacheck and enable the user & group quota,
 - Create some files and write some data to them, and then punch hole
   to some files of them, it may trigger the buffer leak problem
   mentioned above.
 - Disable quota and run quotacheck again, it will create two new
   aquota files and write the checked quota information to them, which
   probably may reuse the freed indirect block(the buffer and page
   cache was not freed) as data block.
 - Enable quota again, it will invoke
   vfs_load_quota_inode()->invalidate_bdev() to try to clean unused
   buffers and pagecache. Unfortunately, because of the buffer of quota
   data block is still referenced, quota code cannot read the up to date
   quota info from the device and lead to quota information corruption.

This problem can be reproduced by xfstests generic/231 on ext3 file
system or ext4 file system without extent and quota features.

This patch fix this problem by releasing the missing indirect buffers,
in ext4_ind_remove_space().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/indirect.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1481,10 +1481,14 @@ end_range:
 					   partial->p + 1,
 					   partial2->p,
 					   (chain+n-1) - partial);
-			BUFFER_TRACE(partial->bh, "call brelse");
-			brelse(partial->bh);
-			BUFFER_TRACE(partial2->bh, "call brelse");
-			brelse(partial2->bh);
+			while (partial > chain) {
+				BUFFER_TRACE(partial->bh, "call brelse");
+				brelse(partial->bh);
+			}
+			while (partial2 > chain2) {
+				BUFFER_TRACE(partial2->bh, "call brelse");
+				brelse(partial2->bh);
+			}
 			return 0;
 		}
 

