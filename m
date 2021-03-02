Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A369B32B2BE
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343967AbhCCAx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350534AbhCBUGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 15:06:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FFA160201;
        Tue,  2 Mar 2021 20:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614715504;
        bh=dZn0iUMFHRoA3vCrFDFvUd/mf0EEgaR4RnetwWeEbvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPE5cKlZK29+1nuN2yukCiV809pPnGzoFaEbQbsk0bqP7WZIUtziy0UyVBXLCdegZ
         TEscfw7lcOW7zeEGHQjkHd+mSalW5sq8F6vj0akIqBrU+GvveITHyroCZoV7y/+ZuV
         mV4THCKB1yK+igUKVMo7ljAhbjuVh1HGE8fcDDUpMfjB/QUuTItVjV8RXwSyTa4Z6Z
         eiAB2EkNBHFRPz1+N86yB9xKK9F3g+5hV843D24qgZnibjK+Gkm0WrzwRaSecQd8dH
         Jzvvvd9ifzmltHKeiyXmWpVHhinPDs3VJFP7ZNY5HCzQZ7oEopeLOmj5eiNgxPcCDK
         TjmogQy0XyGcA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-fscrypt@vger.kernel.org, Yunlei He <heyunlei@hihonor.com>,
        bintian.wang@hihonor.com, stable@vger.kernel.org
Subject: [PATCH 2/2] f2fs: fix error handling in f2fs_end_enable_verity()
Date:   Tue,  2 Mar 2021 12:04:20 -0800
Message-Id: <20210302200420.137977-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302200420.137977-1-ebiggers@kernel.org>
References: <20210302200420.137977-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

f2fs didn't properly clean up if verity failed to be enabled on a file:

- It left verity metadata (pages past EOF) in the page cache, which
  would be exposed to userspace if the file was later extended.

- It didn't truncate the verity metadata at all (either from cache or
  from disk) if an error occurred while setting the verity bit.

Fix these bugs by adding a call to truncate_inode_pages() and ensuring
that we truncate the verity metadata (both from cache and from disk) in
all error paths.  Also rework the code to cleanly separate the success
path from the error paths, which makes it much easier to understand.

Reported-by: Yunlei He <heyunlei@hihonor.com>
Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/verity.c | 61 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 41 insertions(+), 20 deletions(-)

diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index 054ec852b5ea4..2db89967fde37 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -160,31 +160,52 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
 	};
 	int err = 0;
 
-	if (desc != NULL) {
-		/* Succeeded; write the verity descriptor. */
-		err = pagecache_write(inode, desc, desc_size, desc_pos);
+	/*
+	 * If an error already occurred (which fs/verity/ signals by passing
+	 * desc == NULL), then only clean-up is needed.
+	 */
+	if (desc == NULL)
+		goto cleanup;
 
-		/* Write all pages before clearing FI_VERITY_IN_PROGRESS. */
-		if (!err)
-			err = filemap_write_and_wait(inode->i_mapping);
-	}
+	/* Append the verity descriptor. */
+	err = pagecache_write(inode, desc, desc_size, desc_pos);
+	if (err)
+		goto cleanup;
 
-	/* If we failed, truncate anything we wrote past i_size. */
-	if (desc == NULL || err)
-		f2fs_truncate(inode);
+	/*
+	 * Write all pages (both data and verity metadata).  Note that this must
+	 * happen before clearing FI_VERITY_IN_PROGRESS; otherwise pages beyond
+	 * i_size won't be written properly.  For crash consistency, this also
+	 * must happen before the verity inode flag gets persisted.
+	 */
+	err = filemap_write_and_wait(inode->i_mapping);
+	if (err)
+		goto cleanup;
+
+	/* Set the verity xattr. */
+	err = f2fs_setxattr(inode, F2FS_XATTR_INDEX_VERITY,
+			    F2FS_XATTR_NAME_VERITY, &dloc, sizeof(dloc),
+			    NULL, XATTR_CREATE);
+	if (err)
+		goto cleanup;
+
+	/* Finally, set the verity inode flag. */
+	file_set_verity(inode);
+	f2fs_set_inode_flags(inode);
+	f2fs_mark_inode_dirty_sync(inode, true);
 
 	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
+	return 0;
 
-	if (desc != NULL && !err) {
-		err = f2fs_setxattr(inode, F2FS_XATTR_INDEX_VERITY,
-				    F2FS_XATTR_NAME_VERITY, &dloc, sizeof(dloc),
-				    NULL, XATTR_CREATE);
-		if (!err) {
-			file_set_verity(inode);
-			f2fs_set_inode_flags(inode);
-			f2fs_mark_inode_dirty_sync(inode, true);
-		}
-	}
+cleanup:
+	/*
+	 * Verity failed to be enabled, so clean up by truncating any verity
+	 * metadata that was written beyond i_size (both from cache and from
+	 * disk) and clearing FI_VERITY_IN_PROGRESS.
+	 */
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	f2fs_truncate(inode);
+	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
 	return err;
 }
 
-- 
2.30.1

