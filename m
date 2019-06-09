Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43DE93AACD
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbfFIQpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:45:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729667AbfFIQpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:45:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 297A92084A;
        Sun,  9 Jun 2019 16:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098711;
        bh=PNNRAQtybQcafoxDwBfgfl8iuKndtpVW8pix/Q4wujM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xbDTNCmQoHSuP6TPDpRdi3blryQqG6TgF/tUvOnn8jCqA4828IwvWGnO2xOgfk89j
         O1C0acxpAN6vpjNOZ2PUQatROozvVnDPkVVllCycqovdamMiXwIIyq4unIvgBaWT5H
         zo2JqrLf4Hu6BfDoVNhPoDO4B4fv9KeojcBx6VJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.1 32/70] fuse: fix copy_file_range() in the writeback case
Date:   Sun,  9 Jun 2019 18:41:43 +0200
Message-Id: <20190609164129.780863006@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit a2bc92362941006830afa3dfad6caec1f99acbf5 upstream.

Prior to sending COPY_FILE_RANGE to userspace filesystem, we must flush all
dirty pages in both the source and destination files.

This patch adds the missing flush of the source file.

Tested on libfuse-3.5.0 with:

  libfuse/example/passthrough_ll /mnt/fuse/ -o writeback
  libfuse/test/test_syscalls /mnt/fuse/tmp/test

Fixes: 88bc7d5097a1 ("fuse: add support for copy_file_range()")
Cc: <stable@vger.kernel.org> # v4.20
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/file.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3098,6 +3098,7 @@ static ssize_t fuse_copy_file_range(stru
 {
 	struct fuse_file *ff_in = file_in->private_data;
 	struct fuse_file *ff_out = file_out->private_data;
+	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
 	struct fuse_inode *fi_out = get_fuse_inode(inode_out);
 	struct fuse_conn *fc = ff_in->fc;
@@ -3121,6 +3122,17 @@ static ssize_t fuse_copy_file_range(stru
 	if (fc->no_copy_file_range)
 		return -EOPNOTSUPP;
 
+	if (fc->writeback_cache) {
+		inode_lock(inode_in);
+		err = filemap_write_and_wait_range(inode_in->i_mapping,
+						   pos_in, pos_in + len);
+		if (!err)
+			fuse_sync_writes(inode_in);
+		inode_unlock(inode_in);
+		if (err)
+			return err;
+	}
+
 	inode_lock(inode_out);
 
 	if (fc->writeback_cache) {


