Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C90A2145673
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgAVN06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:26:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgAVN06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:26:58 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB8EC2467B;
        Wed, 22 Jan 2020 13:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699617;
        bh=e5CRW54dsq2bYqXNwFy3jRK3OjNNRYCjwFha6ZoH1FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYJpM0aKCU7ng5ZDjM2ZixiQIul/vROePLxI11qQ9fi2lq88LoaKC1DMQrzRa5YNz
         lio2RTfc5F4EyUiFNOe9Wc2KTzEviCt/sZBjXrqwrtDEVyT+rbYvb+d9iGLSggTtE3
         /EsaXBCaHSiZZa4yrpEo+m4FcN0bQ7r44anGYc6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Brunnbauer <brunni@netestate.de>,
        Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.4 198/222] reiserfs: fix handling of -EOPNOTSUPP in reiserfs_for_each_xattr
Date:   Wed, 22 Jan 2020 10:29:44 +0100
Message-Id: <20200122092847.885279414@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
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


