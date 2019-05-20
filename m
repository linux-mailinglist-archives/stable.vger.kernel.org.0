Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB7BD23446
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389038AbfETMZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389035AbfETMZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:25:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD37D20645;
        Mon, 20 May 2019 12:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355117;
        bh=JcTSlTzNIy7BdVgAaXqyAePNCWF4zBgxROpHibd0uZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zf1pR0DJBGf4dTQVb+2G8jj6dMrFSIT4s1lIeN9+W4d1TD6AlTM8DUReVDMNfeELl
         f1+Ju4mdQShORXIqnrERY/q7rBB7/7mbTbo6SrNdvdnWVX2E7zt3CYyzd2JF1dNg7V
         8ofQQsBtUlpu0VdVTA+nI8Xbb02FPnna32x4capU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.19 104/105] ext4: fix compile error when using BUFFER_TRACE
Date:   Mon, 20 May 2019 14:14:50 +0200
Message-Id: <20190520115254.410000000@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

commit ddccb6dbe780d68133191477571cb7c69e17bb8c upstream.

Fix compile error below when using BUFFER_TRACE.

fs/ext4/inode.c: In function ‘ext4_expand_extra_isize’:
fs/ext4/inode.c:5979:19: error: request for member ‘bh’ in something not a structure or union
  BUFFER_TRACE(iloc.bh, "get_write_access");

Fixes: c03b45b853f58 ("ext4, project: expand inode extra size if possible")
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5975,7 +5975,7 @@ int ext4_expand_extra_isize(struct inode
 
 	ext4_write_lock_xattr(inode, &no_expand);
 
-	BUFFER_TRACE(iloc.bh, "get_write_access");
+	BUFFER_TRACE(iloc->bh, "get_write_access");
 	error = ext4_journal_get_write_access(handle, iloc->bh);
 	if (error) {
 		brelse(iloc->bh);


