Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C971E290191
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406197AbgJPJPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394569AbgJPJJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:09:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CF152158C;
        Fri, 16 Oct 2020 09:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839325;
        bh=+FJ2l1V6533c8aUcWwIXfsnqlWMY00l2N89F7O9fV4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acB0JzWLVPwbtTUy9Cf9xQRlPdMENSOTFKVXmMXqIeqNgmhgyteN7KYJKfLLOkjbF
         TlxlFz5OaDBTdEZu76NtO5AOk54rQDIYf7liucWciBG4KMfN4TCrWk0XzPhVXxmXzp
         xIp9kn4FReyXcoSWjTewNhINtK21n1ZI5+HLpHfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d94d02749498bb7bab4b@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 4.14 14/18] reiserfs: Initialize inode keys properly
Date:   Fri, 16 Oct 2020 11:07:24 +0200
Message-Id: <20201016090437.988041715@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.265805669@linuxfoundation.org>
References: <20201016090437.265805669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 4443390e08d34d5771ab444f601cf71b3c9634a4 upstream.

reiserfs_read_locked_inode() didn't initialize key length properly. Use
_make_cpu_key() macro for key initialization so that all key member are
properly initialized.

CC: stable@vger.kernel.org
Reported-by: syzbot+d94d02749498bb7bab4b@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/reiserfs/inode.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1552,11 +1552,7 @@ void reiserfs_read_locked_inode(struct i
 	 * set version 1, version 2 could be used too, because stat data
 	 * key is the same in both versions
 	 */
-	key.version = KEY_FORMAT_3_5;
-	key.on_disk_key.k_dir_id = dirino;
-	key.on_disk_key.k_objectid = inode->i_ino;
-	key.on_disk_key.k_offset = 0;
-	key.on_disk_key.k_type = 0;
+	_make_cpu_key(&key, KEY_FORMAT_3_5, dirino, inode->i_ino, 0, 0, 3);
 
 	/* look for the object's stat data */
 	retval = search_item(inode->i_sb, &key, &path_to_sd);


