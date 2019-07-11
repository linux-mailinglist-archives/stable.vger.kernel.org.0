Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7E765865
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 16:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbfGKOAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 10:00:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:51084 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728415AbfGKOAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 10:00:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F330AAF1B;
        Thu, 11 Jul 2019 14:00:16 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 291371E43CC; Thu, 11 Jul 2019 16:00:16 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] fs: Export generic_fadvise()
Date:   Thu, 11 Jul 2019 16:00:11 +0200
Message-Id: <20190711140012.1671-3-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190711140012.1671-1-jack@suse.cz>
References: <20190711140012.1671-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Filesystems will need to call this function from their fadvise handlers.

CC: stable@vger.kernel.org # Needed by "xfs: Fix stale data exposure when
					readahead races with hole punch"
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h | 2 ++
 mm/fadvise.c       | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index f7fdfe93e25d..2666862ff00d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3536,6 +3536,8 @@ extern void inode_nohighmem(struct inode *inode);
 /* mm/fadvise.c */
 extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
 		       int advice);
+extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
+			   int advice);
 
 #if defined(CONFIG_IO_URING)
 extern struct sock *io_uring_get_socket(struct file *file);
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 467bcd032037..4f17c83db575 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -27,8 +27,7 @@
  * deactivate the pages and clear PG_Referenced.
  */
 
-static int generic_fadvise(struct file *file, loff_t offset, loff_t len,
-			   int advice)
+int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 {
 	struct inode *inode;
 	struct address_space *mapping;
@@ -178,6 +177,7 @@ static int generic_fadvise(struct file *file, loff_t offset, loff_t len,
 	}
 	return 0;
 }
+EXPORT_SYMBOL(generic_fadvise);
 
 int vfs_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 {
-- 
2.16.4

