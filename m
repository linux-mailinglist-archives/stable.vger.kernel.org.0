Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC3E5F7F03
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfKKTHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 14:07:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbfKKSiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:38:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0845F214E0;
        Mon, 11 Nov 2019 18:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497480;
        bh=ZK/ZBjuL36PlHFysUhKmPHj4iSBscDJgj7PWaoy0ufo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D49QMJeoipL2EJdhrE4SVxCij8++3Dd2PYOswjJFjer+T53qKqJXbmICH6f45befI
         znIIH1Q317XAhTlFK4SOx+hW0edMsjoru7IWR65YuEKFc6a2+xqWYBwh4rop1RBzPD
         seCxZlxLpro5ttKiW9C4sdO1sKs7GY/XoqzzqB1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.14 042/105] configfs_register_group() shouldnt be (and isnt) called in rmdirable parts
Date:   Mon, 11 Nov 2019 19:28:12 +0100
Message-Id: <20191111181440.718616654@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit f19e4ed1e1edbfa3c9ccb9fed17759b7d6db24c6 upstream.

revert cc57c07343bd "configfs: fix registered group removal"
It was an attempt to handle something that fundamentally doesn't
work - configfs_register_group() should never be done in a part
of tree that can be rmdir'ed.  And in mainline it never had been,
so let's not borrow trouble; the fix was racy anyway, it would take
a lot more to make that work and desired semantics is not clear.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/configfs/dir.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1782,16 +1782,6 @@ void configfs_unregister_group(struct co
 	struct dentry *dentry = group->cg_item.ci_dentry;
 	struct dentry *parent = group->cg_item.ci_parent->ci_dentry;
 
-	mutex_lock(&subsys->su_mutex);
-	if (!group->cg_item.ci_parent->ci_group) {
-		/*
-		 * The parent has already been unlinked and detached
-		 * due to a rmdir.
-		 */
-		goto unlink_group;
-	}
-	mutex_unlock(&subsys->su_mutex);
-
 	inode_lock_nested(d_inode(parent), I_MUTEX_PARENT);
 	spin_lock(&configfs_dirent_lock);
 	configfs_detach_prep(dentry, NULL);
@@ -1806,7 +1796,6 @@ void configfs_unregister_group(struct co
 	dput(dentry);
 
 	mutex_lock(&subsys->su_mutex);
-unlink_group:
 	unlink_group(group);
 	mutex_unlock(&subsys->su_mutex);
 }


