Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E28B28B05
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388286AbfEWTvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731853AbfEWTIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:08:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57367217D7;
        Thu, 23 May 2019 19:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638522;
        bh=oLnhJo1VanbKdZHccG/M2AWX6tCSmV4ezVCwsTOPdPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMggWRII9eJk/xnqwAnAOac5FrHXrYbN2tKU3ZTISEfqUDc6h3xrPrOBpdmV7KShF
         1do5FTcT5UytZfBEOvCmhgOvrkIHa6ExImERd593k0Dhkumvj7WLFS/c+If6QPfCUF
         TxJjW35X5HSXoEIP6/qbnZI2+DIwrrhsspFbH5xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antonio SJ Musumeci <trapexit@spawn.link>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.9 20/53] fuse: fix writepages on 32bit
Date:   Thu, 23 May 2019 21:05:44 +0200
Message-Id: <20190523181714.052642775@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181710.981455400@linuxfoundation.org>
References: <20190523181710.981455400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 9de5be06d0a89ca97b5ab902694d42dfd2bb77d2 upstream.

Writepage requests were cropped to i_size & 0xffffffff, which meant that
mmaped writes to any file larger than 4G might be silently discarded.

Fix by storing the file size in a properly sized variable (loff_t instead
of size_t).

Reported-by: Antonio SJ Musumeci <trapexit@spawn.link>
Fixes: 6eaf4782eb09 ("fuse: writepages: crop secondary requests")
Cc: <stable@vger.kernel.org> # v3.13
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1521,7 +1521,7 @@ __acquires(fc->lock)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
-	size_t crop = i_size_read(inode);
+	loff_t crop = i_size_read(inode);
 	struct fuse_req *req;
 
 	while (fi->writectr >= 0 && !list_empty(&fi->queued_writes)) {


