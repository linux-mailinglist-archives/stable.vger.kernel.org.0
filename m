Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDB14A3841
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 19:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245313AbiA3StI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 13:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiA3StI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 13:49:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46430C061714
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 10:49:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E487DB8290B
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 18:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825DCC340E4;
        Sun, 30 Jan 2022 18:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643568545;
        bh=0LdGXD4o0dYFFki5R828S+G2IpxpEr01eRZJEtUE2Gs=;
        h=Subject:To:Cc:From:Date:From;
        b=1Krkb7JkfJCYdapUXB7GsiPksEFFqNyiVbIA/sGZErWNW1gpvA1la1ucTgGWD2/PY
         1lYDg5jfzkXlF4ifVWKgfi7BW+odtgZ91qwzWtbbe9r5D8xIwjZ2FLk9QXTk15kPlQ
         yztMQUeHNSV94bG7/yIhaF+Rlv4zPyL00QdiHrMo=
Subject: FAILED: patch "[PATCH] NFSv4: Handle case where the lookup of a directory fails" failed to apply to 4.4-stable tree
To:     trond.myklebust@hammerspace.com, Anna.Schumaker@Netapp.com,
        tao.lyu@epfl.ch
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 Jan 2022 19:49:02 +0100
Message-ID: <1643568542248209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ac795161c93699d600db16c1a8cc23a65a1eceaf Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Thu, 6 Jan 2022 18:24:02 -0500
Subject: [PATCH] NFSv4: Handle case where the lookup of a directory fails

If the application sets the O_DIRECTORY flag, and tries to open a
regular file, nfs_atomic_open() will punt to doing a regular lookup.
If the server then returns a regular file, we will happily return a
file descriptor with uninitialised open state.

The fix is to return the expected ENOTDIR error in these cases.

Reported-by: Lyu Tao <tao.lyu@epfl.ch>
Fixes: 0dd2b474d0b6 ("nfs: implement i_op->atomic_open()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 2884138848f4..408c3bb549b1 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1994,6 +1994,19 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 
 no_open:
 	res = nfs_lookup(dir, dentry, lookup_flags);
+	if (!res) {
+		inode = d_inode(dentry);
+		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
+		    !S_ISDIR(inode->i_mode))
+			res = ERR_PTR(-ENOTDIR);
+	} else if (!IS_ERR(res)) {
+		inode = d_inode(res);
+		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
+		    !S_ISDIR(inode->i_mode)) {
+			dput(res);
+			res = ERR_PTR(-ENOTDIR);
+		}
+	}
 	if (switched) {
 		d_lookup_done(dentry);
 		if (!res)

