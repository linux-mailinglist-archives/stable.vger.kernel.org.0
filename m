Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03D8409374
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343570AbhIMOVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:21:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344141AbhIMOQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:16:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3851E61AFE;
        Mon, 13 Sep 2021 13:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540683;
        bh=CL5Y3CisgtGWXW+uw3x7L2vaHHHyTBOnODkCDoZu7xI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Nt/38M9e5mDtmXFXXVtz+R3JGD4f9wJ5IIHfkXT5rg4+og1pFxHWv9qrKYP7dRRx
         RrMhtgfzbg+84yZ6oSy/3rLopQma8MHVtgv/aP7MFgszkoduEtB2/B14KW8rpE5P5E
         c2QUGP/4/RCZoMcylHJIdHygMG83dU4fxyY3UaCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.13 293/300] fuse: flush extending writes
Date:   Mon, 13 Sep 2021 15:15:54 +0200
Message-Id: <20210913131119.244976614@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 59bda8ecee2ffc6a602b7bf2b9e43ca669cdbdcd upstream.

Callers of fuse_writeback_range() assume that the file is ready for
modification by the server in the supplied byte range after the call
returns.

If there's a write that extends the file beyond the end of the supplied
range, then the file needs to be extended to at least the end of the range,
but currently that's not done.

There are at least two cases where this can cause problems:

 - copy_file_range() will return short count if the file is not extended
   up to end of the source range.

 - FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE will not extend the file,
   hence the region may not be fully allocated.

Fix by flushing writes from the start of the range up to the end of the
file.  This could be optimized if the writes are non-extending, etc, but
it's probably not worth the trouble.

Fixes: a2bc92362941 ("fuse: fix copy_file_range() in the writeback case")
Fixes: 6b1bdb56b17c ("fuse: allow fallocate(FALLOC_FL_ZERO_RANGE)")
Cc: <stable@vger.kernel.org>  # v5.2
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2886,7 +2886,7 @@ fuse_direct_IO(struct kiocb *iocb, struc
 
 static int fuse_writeback_range(struct inode *inode, loff_t start, loff_t end)
 {
-	int err = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	int err = filemap_write_and_wait_range(inode->i_mapping, start, -1);
 
 	if (!err)
 		fuse_sync_writes(inode);


