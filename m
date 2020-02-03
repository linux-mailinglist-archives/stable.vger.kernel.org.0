Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8C8150C90
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730955AbgBCQhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:37:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731357AbgBCQhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:37:36 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 090A42082E;
        Mon,  3 Feb 2020 16:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747856;
        bh=bMgZZy1qqrTGcobRB/v6mBwqSQpFkgMhc+FHm3UYgUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIOCAStzuc1FOPDc8LDWqwPFXo3zJ73UQ8gr2syWdrMH7+k7mMDdvaR30p8aM7GrL
         D/XgqQET6bP5TRIUz/1u0qBwyvUhSNXOCr5uaOs+dX5bMFTau2l6wZfT2hwF7rUImM
         yw5IKReGc5NvDq5IJIgAv12wMueUv3lnyj1YTloo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>,
        syzbot+190005201ced78a74ad6@syzkaller.appspotmail.com,
        stable@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 01/23] vfs: fix do_last() regression
Date:   Mon,  3 Feb 2020 16:20:21 +0000
Message-Id: <20200203161903.315802929@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161902.288335885@linuxfoundation.org>
References: <20200203161902.288335885@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 6404674acd596de41fd3ad5f267b4525494a891a upstream.

Brown paperbag time: fetching ->i_uid/->i_mode really should've been
done from nd->inode.  I even suggested that, but the reason for that has
slipped through the cracks and I went for dir->d_inode instead - made
for more "obvious" patch.

Analysis:

 - at the entry into do_last() and all the way to step_into(): dir (aka
   nd->path.dentry) is known not to have been freed; so's nd->inode and
   it's equal to dir->d_inode unless we are already doomed to -ECHILD.
   inode of the file to get opened is not known.

 - after step_into(): inode of the file to get opened is known; dir
   might be pointing to freed memory/be negative/etc.

 - at the call of may_create_in_sticky(): guaranteed to be out of RCU
   mode; inode of the file to get opened is known and pinned; dir might
   be garbage.

The last was the reason for the original patch.  Except that at the
do_last() entry we can be in RCU mode and it is possible that
nd->path.dentry->d_inode has already changed under us.

In that case we are going to fail with -ECHILD, but we need to be
careful; nd->inode is pointing to valid struct inode and it's the same
as nd->path.dentry->d_inode in "won't fail with -ECHILD" case, so we
should use that.

Reported-by: "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Reported-by: syzbot+190005201ced78a74ad6@syzkaller.appspotmail.com
Wearing-brown-paperbag: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@kernel.org
Fixes: d0cb50185ae9 ("do_last(): fetch directory ->i_mode and ->i_uid before it's too late")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3202,8 +3202,8 @@ static int do_last(struct nameidata *nd,
 		   struct file *file, const struct open_flags *op)
 {
 	struct dentry *dir = nd->path.dentry;
-	kuid_t dir_uid = dir->d_inode->i_uid;
-	umode_t dir_mode = dir->d_inode->i_mode;
+	kuid_t dir_uid = nd->inode->i_uid;
+	umode_t dir_mode = nd->inode->i_mode;
 	int open_flag = op->open_flag;
 	bool will_truncate = (open_flag & O_TRUNC) != 0;
 	bool got_write = false;


