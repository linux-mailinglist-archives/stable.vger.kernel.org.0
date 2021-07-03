Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C27A3BAA91
	for <lists+stable@lfdr.de>; Sun,  4 Jul 2021 01:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhGCXIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Jul 2021 19:08:40 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:19398 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhGCXIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Jul 2021 19:08:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1625353565; x=1656889565;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=M/HivuLwkUMgNqSMkbbUrOINkboc88MgrXG2cW24onM=;
  b=p78qdgcxQyE00+MtZcPzUatG6AMqI8vfJIfwVsV2l5Ou4HH7oo3yAxxw
   GTMMODQcdPrC7GQnjiJAeZfVPwAMqNlOzh9ojpXioLvwrTRv8Vql9sYQg
   WyRo7rCjDR+p+wxLStoDzz5sXFC2mIDkSCvE492oMELwc2NUAxLrdLrez
   Y=;
X-IronPort-AV: E=Sophos;i="5.83,322,1616457600"; 
   d="scan'208";a="941630460"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 03 Jul 2021 23:06:04 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 6134F14021C;
        Sat,  3 Jul 2021 23:06:03 +0000 (UTC)
Received: from EX13D19UWA004.ant.amazon.com (10.43.160.102) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 3 Jul 2021 23:06:03 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D19UWA004.ant.amazon.com (10.43.160.102) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 3 Jul 2021 23:06:03 +0000
Received: from u7187ce7291cc57.ant.amazon.com (10.187.170.17) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Sat, 3 Jul 2021 23:06:01 +0000
From:   Tahsin Erdogan <trdgn@amazon.com>
To:     Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Tahsin Erdogan <trdgn@amazon.com>, <stable@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext4: eliminate bogus error in ext4_data_block_valid_rcu()
Date:   Sat, 3 Jul 2021 16:05:55 -0700
Message-ID: <20210703230555.4093-1-trdgn@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mainline commit ce9f24cccdc0 ("ext4: check journal inode extents more carefully")
enabled validity checks for journal inode's data blocks. This change got
ported to stable branches, but the backport for 4.19 has a bug where it will
flag an error even when system block entry's inode number matches journal
inode.

The way error is reported is also problematic because it updates the superblock
without following journaling rules. This may result in superblock checksum
errors if the superblock is in the process of being committed but has a
previously calculated checksum that doesn't include the bogus error update.

This patch eliminates the bogus error by trying to match how other backports
were implemented, which is to flag an error only when inode numbers mismatch.

Fixes: commit a75a5d163857 ("ext4: check journal inode extents more carefully")
Signed-off-by: Tahsin Erdogan <trdgn@amazon.com>
Cc: stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/block_validity.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 1ea8fc9ff048..1bc65ecd4bd6 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -171,8 +171,10 @@ static int ext4_data_block_valid_rcu(struct ext4_sb_info *sbi,
 		else if (start_blk >= (entry->start_blk + entry->count))
 			n = n->rb_right;
 		else {
+			if (entry->ino == ino)
+				return 1;
 			sbi->s_es->s_last_error_block = cpu_to_le64(start_blk);
-			return entry->ino == ino;
+			return 0;
 		}
 	}
 	return 1;
-- 
2.17.1

