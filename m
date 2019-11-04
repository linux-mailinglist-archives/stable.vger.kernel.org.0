Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21535EECF1
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388277AbfKDWBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:01:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389161AbfKDWBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:01:41 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27BFA20650;
        Mon,  4 Nov 2019 22:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904900;
        bh=6AvvrlPXSuBoPMjBsq1vSdqTw7HJ6pi4GC+M7L2rNXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qio3BPt6I/rAdV5tXdzE0JVXE+0AzfiT7RruVIFVwQ/o/Ef3uNQI/deaYQeFYf0Ws
         KIRZklutLWt6om6wRNoWzvi3Ky43eSambI3arRH6BPSeH5CbFkAjtUykmXEeXb0/O1
         Pe/xdhSn3ziDXnXlph6e55I5i6aci9jrjKwaU6iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 110/149] fuse: truncate pending writes on O_TRUNC
Date:   Mon,  4 Nov 2019 22:45:03 +0100
Message-Id: <20191104212144.114811627@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit e4648309b85a78f8c787457832269a8712a8673e upstream.

Make sure cached writes are not reordered around open(..., O_TRUNC), with
the obvious wrong results.

Fixes: 4d99ff8f12eb ("fuse: Turn writeback cache on")
Cc: <stable@vger.kernel.org> # v3.15+
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/file.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -202,7 +202,7 @@ int fuse_open_common(struct inode *inode
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	int err;
-	bool lock_inode = (file->f_flags & O_TRUNC) &&
+	bool is_wb_truncate = (file->f_flags & O_TRUNC) &&
 			  fc->atomic_o_trunc &&
 			  fc->writeback_cache;
 
@@ -210,16 +210,20 @@ int fuse_open_common(struct inode *inode
 	if (err)
 		return err;
 
-	if (lock_inode)
+	if (is_wb_truncate) {
 		inode_lock(inode);
+		fuse_set_nowrite(inode);
+	}
 
 	err = fuse_do_open(fc, get_node_id(inode), file, isdir);
 
 	if (!err)
 		fuse_finish_open(inode, file);
 
-	if (lock_inode)
+	if (is_wb_truncate) {
+		fuse_release_nowrite(inode);
 		inode_unlock(inode);
+	}
 
 	return err;
 }


