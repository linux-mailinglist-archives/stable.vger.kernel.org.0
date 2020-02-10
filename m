Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D94F15773C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgBJM6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:58:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729957AbgBJMlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:18 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7D8B21739;
        Mon, 10 Feb 2020 12:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338478;
        bh=u4ilCjELg5OtwY1xaVFUG0Hdgjxy9XdEEzxrekWujKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aL8BP5RJwxUxqjaRjHZY6WMuuSZ4HSvYC5gbCjCNScdKAbg29oHD3thqTH7g7x2FK
         GORwnU2QMTtu7bRh+CV8HBpG4FZh8COBgKLPWUiCFAYSU5yzuNjGgVXWsnCtf5SWlE
         08IcJDU/5TmBbaLEFAbxx0hhyT07T/GG5aM0FcUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.5 210/367] gfs2: move setting current->backing_dev_info
Date:   Mon, 10 Feb 2020 04:32:03 -0800
Message-Id: <20200210122443.741061602@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 4c0e8dda608a51855225c611b5c6b442f95fbc56 upstream.

Set current->backing_dev_info just around the buffered write calls to
prepare for the next fix.

Fixes: 967bcc91b044 ("gfs2: iomap direct I/O support")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/file.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -867,18 +867,15 @@ static ssize_t gfs2_file_write_iter(stru
 	inode_lock(inode);
 	ret = generic_write_checks(iocb, from);
 	if (ret <= 0)
-		goto out;
-
-	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = inode_to_bdi(inode);
+		goto out_unlock;
 
 	ret = file_remove_privs(file);
 	if (ret)
-		goto out2;
+		goto out_unlock;
 
 	ret = file_update_time(file);
 	if (ret)
-		goto out2;
+		goto out_unlock;
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		struct address_space *mapping = file->f_mapping;
@@ -887,11 +884,13 @@ static ssize_t gfs2_file_write_iter(stru
 
 		written = gfs2_file_direct_write(iocb, from);
 		if (written < 0 || !iov_iter_count(from))
-			goto out2;
+			goto out_unlock;
 
+		current->backing_dev_info = inode_to_bdi(inode);
 		ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
+		current->backing_dev_info = NULL;
 		if (unlikely(ret < 0))
-			goto out2;
+			goto out_unlock;
 		buffered = ret;
 
 		/*
@@ -915,14 +914,14 @@ static ssize_t gfs2_file_write_iter(stru
 			 */
 		}
 	} else {
+		current->backing_dev_info = inode_to_bdi(inode);
 		ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
+		current->backing_dev_info = NULL;
 		if (likely(ret > 0))
 			iocb->ki_pos += ret;
 	}
 
-out2:
-	current->backing_dev_info = NULL;
-out:
+out_unlock:
 	inode_unlock(inode);
 	if (likely(ret > 0)) {
 		/* Handle various SYNC-type writes */


