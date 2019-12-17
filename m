Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1A87122048
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfLQAxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:53:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35392 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727096AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003Mv-T5; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0005Zw-Sd; Tue, 17 Dec 2019 00:51:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Miklos Szeredi" <mszeredi@redhat.com>
Date:   Tue, 17 Dec 2019 00:47:00 +0000
Message-ID: <lsq.1576543535.705370919@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 086/136] fuse: truncate pending writes on O_TRUNC
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit e4648309b85a78f8c787457832269a8712a8673e upstream.

Make sure cached writes are not reordered around open(..., O_TRUNC), with
the obvious wrong results.

Fixes: 4d99ff8f12eb ("fuse: Turn writeback cache on")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fuse/file.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -237,7 +237,7 @@ int fuse_open_common(struct inode *inode
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	int err;
-	bool lock_inode = (file->f_flags & O_TRUNC) &&
+	bool is_wb_truncate = (file->f_flags & O_TRUNC) &&
 			  fc->atomic_o_trunc &&
 			  fc->writeback_cache;
 
@@ -245,16 +245,20 @@ int fuse_open_common(struct inode *inode
 	if (err)
 		return err;
 
-	if (lock_inode)
+	if (is_wb_truncate) {
 		mutex_lock(&inode->i_mutex);
+		fuse_set_nowrite(inode);
+	}
 
 	err = fuse_do_open(fc, get_node_id(inode), file, isdir);
 
 	if (!err)
 		fuse_finish_open(inode, file);
 
-	if (lock_inode)
+	if (is_wb_truncate) {
+		fuse_release_nowrite(inode);
 		mutex_unlock(&inode->i_mutex);
+	}
 
 	return err;
 }

