Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00311C44DA
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbgEDSKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731207AbgEDSFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:05:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6F022073E;
        Mon,  4 May 2020 18:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615503;
        bh=NlVxoTjNVIj7k425iDGce3uuUKxG2Mo4IPPMlgN5liw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNSXXKklWzKUgIWXXw3F4/3hgrP7QaL2KhUUhnHKT26f3MRchQ21PPY4ir6Ea7hng
         Bh3Hhwm9LwuZamCmknRrA/SC56Eq3nFMZCBdKO8WvahK3Nrvpw+EunFPE4+h9AoHzL
         qR0Oypm1T/iwuJXN/rK4niGWMCUbcHWmuYAUZHMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.4 26/57] dlmfs_file_write(): fix the bogosity in handling non-zero *ppos
Date:   Mon,  4 May 2020 19:57:30 +0200
Message-Id: <20200504165458.613322756@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 3815f1be546e752327b5868af103ccdddcc4db77 upstream.

'count' is how much you want written, not the final position.
Moreover, it can legitimately be less than the current position...

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/dlmfs/dlmfs.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -275,7 +275,6 @@ static ssize_t dlmfs_file_write(struct f
 				loff_t *ppos)
 {
 	int bytes_left;
-	ssize_t writelen;
 	char *lvb_buf;
 	struct inode *inode = file_inode(filp);
 
@@ -285,32 +284,30 @@ static ssize_t dlmfs_file_write(struct f
 	if (*ppos >= i_size_read(inode))
 		return -ENOSPC;
 
+	/* don't write past the lvb */
+	if (count > i_size_read(inode) - *ppos)
+		count = i_size_read(inode) - *ppos;
+
 	if (!count)
 		return 0;
 
 	if (!access_ok(buf, count))
 		return -EFAULT;
 
-	/* don't write past the lvb */
-	if ((count + *ppos) > i_size_read(inode))
-		writelen = i_size_read(inode) - *ppos;
-	else
-		writelen = count - *ppos;
-
-	lvb_buf = kmalloc(writelen, GFP_NOFS);
+	lvb_buf = kmalloc(count, GFP_NOFS);
 	if (!lvb_buf)
 		return -ENOMEM;
 
-	bytes_left = copy_from_user(lvb_buf, buf, writelen);
-	writelen -= bytes_left;
-	if (writelen)
-		user_dlm_write_lvb(inode, lvb_buf, writelen);
+	bytes_left = copy_from_user(lvb_buf, buf, count);
+	count -= bytes_left;
+	if (count)
+		user_dlm_write_lvb(inode, lvb_buf, count);
 
 	kfree(lvb_buf);
 
-	*ppos = *ppos + writelen;
-	mlog(0, "wrote %zd bytes\n", writelen);
-	return writelen;
+	*ppos = *ppos + count;
+	mlog(0, "wrote %zu bytes\n", count);
+	return count;
 }
 
 static void dlmfs_init_once(void *foo)


