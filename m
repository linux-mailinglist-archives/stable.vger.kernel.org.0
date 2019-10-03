Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3A1CAA7E
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732353AbfJCRHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392014AbfJCQhT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:37:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FF18215EA;
        Thu,  3 Oct 2019 16:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120637;
        bh=Q126/Y718SLM2Gs8W+0rOnGGB4+ONF5nJAAIU1E5uqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qjy2kX25WtZICPS2t6mdu2v0AM/pjlSu6IrcgLa/9x/Nj3n6D4rolpxu4idT6m3N0
         NPZFjj9tqvFaPjw2y++co1EsJcQyaXY4N2GGkC0bqYZT4HX5pilqPAbBXy3ezPyFqn
         mklsB7YUBacYSVnKnKCm84v63ert8ac+/K6N/mqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.2 297/313] fs: Export generic_fadvise()
Date:   Thu,  3 Oct 2019 17:54:35 +0200
Message-Id: <20191003154602.423159820@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit cf1ea0592dbf109e7e7935b7d5b1a47a1ba04174 upstream.

Filesystems will need to call this function from their fadvise handlers.

CC: stable@vger.kernel.org
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/fs.h |    2 ++
 mm/fadvise.c       |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3544,6 +3544,8 @@ extern void inode_nohighmem(struct inode
 /* mm/fadvise.c */
 extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
 		       int advice);
+extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
+			   int advice);
 
 #if defined(CONFIG_IO_URING)
 extern struct sock *io_uring_get_socket(struct file *file);
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -27,8 +27,7 @@
  * deactivate the pages and clear PG_Referenced.
  */
 
-static int generic_fadvise(struct file *file, loff_t offset, loff_t len,
-			   int advice)
+int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 {
 	struct inode *inode;
 	struct address_space *mapping;
@@ -178,6 +177,7 @@ static int generic_fadvise(struct file *
 	}
 	return 0;
 }
+EXPORT_SYMBOL(generic_fadvise);
 
 int vfs_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 {


