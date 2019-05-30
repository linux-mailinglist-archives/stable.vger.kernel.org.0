Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8CC2EB71
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbfE3DNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727563AbfE3DNI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:08 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B83E4244EA;
        Thu, 30 May 2019 03:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185987;
        bh=nGAUJRbLvnG4RZXmH6VU4fSaW9467h2MfLvkpldJnBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3KPifvDIPdZCSgoBOL8zuUqBHtHhmz5w4fP53T7XAZw7KH/YqVLHEBB8OiNVEG0+
         onnF0u2UIDYDH5hWyqM2jQm4F7whcfszu9YhQFo8sx0gpQgQko2Xui9DGCll1gcG8V
         ntXgk7tJnY0LcDLVHhuuBWVZBf3O/XBDzkA61AuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.0 029/346] ovl: relax WARN_ON() for overlapping layers use case
Date:   Wed, 29 May 2019 20:01:42 -0700
Message-Id: <20190530030542.244955863@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit acf3062a7e1ccf67c6f7e7c28671a6708fde63b0 upstream.

This nasty little syzbot repro:
https://syzkaller.appspot.com/x/repro.syz?x=12c7a94f400000

Creates overlay mounts where the same directory is both in upper and lower
layers. Simplified example:

  mkdir foo work
  mount -t overlay none foo -o"lowerdir=.,upperdir=foo,workdir=work"

The repro runs several threads in parallel that attempt to chdir into foo
and attempt to symlink/rename/exec/mkdir the file bar.

The repro hits a WARN_ON() I placed in ovl_instantiate(), which suggests
that an overlay inode already exists in cache and is hashed by the pointer
of the real upper dentry that ovl_create_real() has just created. At the
point of the WARN_ON(), for overlay dir inode lock is held and upper dir
inode lock, so at first, I did not see how this was possible.

On a closer look, I see that after ovl_create_real(), because of the
overlapping upper and lower layers, a lookup by another thread can find the
file foo/bar that was just created in upper layer, at overlay path
foo/foo/bar and hash the an overlay inode with the new real dentry as lower
dentry. This is possible because the overlay directory foo/foo is not
locked and the upper dentry foo/bar is in dcache, so ovl_lookup() can find
it without taking upper dir inode shared lock.

Overlapping layers is considered a wrong setup which would result in
unexpected behavior, but it shouldn't crash the kernel and it shouldn't
trigger WARN_ON() either, so relax this WARN_ON() and leave a pr_warn()
instead to cover all cases of failure to get an overlay inode.

The error returned from failure to insert new inode to cache with
inode_insert5() was changed to -EEXIST, to distinguish from the error
-ENOMEM returned on failure to get/allocate inode with iget5_locked().

Reported-by: syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com
Fixes: 01b39dcc9568 ("ovl: use inode_insert5() to hash a newly...")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/dir.c   |    2 +-
 fs/overlayfs/inode.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -260,7 +260,7 @@ static int ovl_instantiate(struct dentry
 		 * hashed directory inode aliases.
 		 */
 		inode = ovl_get_inode(dentry->d_sb, &oip);
-		if (WARN_ON(IS_ERR(inode)))
+		if (IS_ERR(inode))
 			return PTR_ERR(inode);
 	} else {
 		WARN_ON(ovl_inode_real(inode) != d_inode(newdentry));
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -832,7 +832,7 @@ struct inode *ovl_get_inode(struct super
 	int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
 	bool is_dir, metacopy = false;
 	unsigned long ino = 0;
-	int err = -ENOMEM;
+	int err = oip->newinode ? -EEXIST : -ENOMEM;
 
 	if (!realinode)
 		realinode = d_inode(lowerdentry);
@@ -917,6 +917,7 @@ out:
 	return inode;
 
 out_err:
+	pr_warn_ratelimited("overlayfs: failed to get inode (%i)\n", err);
 	inode = ERR_PTR(err);
 	goto out;
 }


