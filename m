Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F9F3ED656
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238301AbhHPNUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240388AbhHPNQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:16:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63583632EF;
        Mon, 16 Aug 2021 13:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119604;
        bh=an0t3BZUULDzdfiwNObU/fSO9ebQNPCwThTsWk57IEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QM79jUUDPVIhtDpGSEhyDdCs33Yz+P3eT3ydQa7KIIpReLK/Kn3UUGUa30FmwYckB
         6e0yVbG+rwhW8JIb29imG9bMIAbGdAkrTeKW3htOgsrO17eBeOKh0iNLEPhXfFNIhs
         T9UFLsoNa/a5659Fnbax7iSOYyogbM9WvgjSibzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+579885d1a9a833336209@syzkaller.appspotmail.com
Subject: [PATCH 5.13 089/151] ovl: fix deadlock in splice write
Date:   Mon, 16 Aug 2021 15:01:59 +0200
Message-Id: <20210816125447.013365592@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 9b91b6b019fda817eb52f728eb9c79b3579760bc ]

There's possibility of an ABBA deadlock in case of a splice write to an
overlayfs file and a concurrent splice write to a corresponding real file.

The call chain for splice to an overlay file:

 -> do_splice                     [takes sb_writers on overlay file]
   -> do_splice_from
     -> iter_file_splice_write    [takes pipe->mutex]
       -> vfs_iter_write
         ...
         -> ovl_write_iter        [takes sb_writers on real file]

And the call chain for splice to a real file:

 -> do_splice                     [takes sb_writers on real file]
   -> do_splice_from
     -> iter_file_splice_write    [takes pipe->mutex]

Syzbot successfully bisected this to commit 82a763e61e2b ("ovl: simplify
file splice").

Fix by reverting the write part of the above commit and by adding missing
bits from ovl_write_iter() into ovl_splice_write().

Fixes: 82a763e61e2b ("ovl: simplify file splice")
Reported-and-tested-by: syzbot+579885d1a9a833336209@syzkaller.appspotmail.com
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/file.c | 47 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 4d53d3b7e5fe..d081faa55e83 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -392,6 +392,51 @@ out_unlock:
 	return ret;
 }
 
+/*
+ * Calling iter_file_splice_write() directly from overlay's f_op may deadlock
+ * due to lock order inversion between pipe->mutex in iter_file_splice_write()
+ * and file_start_write(real.file) in ovl_write_iter().
+ *
+ * So do everything ovl_write_iter() does and call iter_file_splice_write() on
+ * the real file.
+ */
+static ssize_t ovl_splice_write(struct pipe_inode_info *pipe, struct file *out,
+				loff_t *ppos, size_t len, unsigned int flags)
+{
+	struct fd real;
+	const struct cred *old_cred;
+	struct inode *inode = file_inode(out);
+	struct inode *realinode = ovl_inode_real(inode);
+	ssize_t ret;
+
+	inode_lock(inode);
+	/* Update mode */
+	ovl_copyattr(realinode, inode);
+	ret = file_remove_privs(out);
+	if (ret)
+		goto out_unlock;
+
+	ret = ovl_real_fdget(out, &real);
+	if (ret)
+		goto out_unlock;
+
+	old_cred = ovl_override_creds(inode->i_sb);
+	file_start_write(real.file);
+
+	ret = iter_file_splice_write(pipe, real.file, ppos, len, flags);
+
+	file_end_write(real.file);
+	/* Update size */
+	ovl_copyattr(realinode, inode);
+	revert_creds(old_cred);
+	fdput(real);
+
+out_unlock:
+	inode_unlock(inode);
+
+	return ret;
+}
+
 static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct fd real;
@@ -603,7 +648,7 @@ const struct file_operations ovl_file_operations = {
 	.fadvise	= ovl_fadvise,
 	.flush		= ovl_flush,
 	.splice_read    = generic_file_splice_read,
-	.splice_write   = iter_file_splice_write,
+	.splice_write   = ovl_splice_write,
 
 	.copy_file_range	= ovl_copy_file_range,
 	.remap_file_range	= ovl_remap_file_range,
-- 
2.30.2



