Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0093290086
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405323AbgJPJGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405320AbgJPJGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:06:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BCBE20848;
        Fri, 16 Oct 2020 09:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839211;
        bh=nJQ3OJhP3nQvj0m1UlC0a5K7IIXWDVG71TTpX6f38ZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRo+5i4mrQXY5kMQuXpekFpV2+IB2ibGpLtpg7Vgkl8uEI0tfCGmcwvUKe9hCqKGq
         eIPlAwf0OSoIj5VX5wsPJrkcH2dhCIIKXL9X9RXOtLVVJeS/OWbXkh+8vCVpwLJrX6
         8fLCENZAN39pvpXNpW1p69T+E7pujC6mOzXTf7Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d94d02749498bb7bab4b@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 4.4 13/16] reiserfs: Initialize inode keys properly
Date:   Fri, 16 Oct 2020 11:07:06 +0200
Message-Id: <20201016090436.070115145@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090435.423923738@linuxfoundation.org>
References: <20201016090435.423923738@linuxfoundation.org>
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
@@ -1553,11 +1553,7 @@ void reiserfs_read_locked_inode(struct i
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


