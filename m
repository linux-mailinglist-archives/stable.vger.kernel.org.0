Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68AF9145071
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387919AbgAVJnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387752AbgAVJnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:43:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC4F82468A;
        Wed, 22 Jan 2020 09:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686221;
        bh=e5CRW54dsq2bYqXNwFy3jRK3OjNNRYCjwFha6ZoH1FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8+9C4zTOzgZoAT7AFC22zLtjrvgdSm2hy2gtFDFiAoWWlN9horfJ3aUMqzbNSWc1
         veLgYHAkm/7/KtUJH/D/b2k9r3ec6mWYWctcdmVdxgeUYtNuXRh7A+tWKVqweAQ4+8
         kfpVOeJktFncVJZLXmCeF+CpzyBuysTGrFy99VTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Brunnbauer <brunni@netestate.de>,
        Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.19 092/103] reiserfs: fix handling of -EOPNOTSUPP in reiserfs_for_each_xattr
Date:   Wed, 22 Jan 2020 10:29:48 +0100
Message-Id: <20200122092815.893804063@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

commit 394440d469413fa9b74f88a11f144d76017221f2 upstream.

Commit 60e4cf67a58 (reiserfs: fix extended attributes on the root
directory) introduced a regression open_xa_root started returning
-EOPNOTSUPP but it was not handled properly in reiserfs_for_each_xattr.

When the reiserfs module is built without CONFIG_REISERFS_FS_XATTR,
deleting an inode would result in a warning and chowning an inode
would also result in a warning and then fail to complete.

With CONFIG_REISERFS_FS_XATTR enabled, the xattr root would always be
present for read-write operations.

This commit handles -EOPNOSUPP in the same way -ENODATA is handled.

Fixes: 60e4cf67a582 ("reiserfs: fix extended attributes on the root directory")
CC: stable@vger.kernel.org	# Commit 60e4cf67a58 was picked up by stable
Link: https://lore.kernel.org/r/20200115180059.6935-1-jeffm@suse.com
Reported-by: Michael Brunnbauer <brunni@netestate.de>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/reiserfs/xattr.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -319,8 +319,12 @@ static int reiserfs_for_each_xattr(struc
 out_dir:
 	dput(dir);
 out:
-	/* -ENODATA isn't an error */
-	if (err == -ENODATA)
+	/*
+	 * -ENODATA: this object doesn't have any xattrs
+	 * -EOPNOTSUPP: this file system doesn't have xattrs enabled on disk.
+	 * Neither are errors
+	 */
+	if (err == -ENODATA || err == -EOPNOTSUPP)
 		err = 0;
 	return err;
 }


