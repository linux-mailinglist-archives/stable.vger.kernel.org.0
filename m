Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F2F3786B6
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbhEJLKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234365AbhEJLDT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:03:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7DD36162B;
        Mon, 10 May 2021 10:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644058;
        bh=vc4YkXsp9LYCBLtu1We7x1zKPK4f0rGvM9IOT7u5xfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T3cHDcWQ3STjWWLFBhR5fP93NgQnp8OAON0YQ6uLqI5YM0qOjFr7m/cJ1MSPWjhJq
         b4fMm2WEZnsbZgwxdFfB5U96KHDVPcTI2/iTQiXEk5VpXrIxP3QcHdSBVdJe49mMLk
         vDnct3CsBYigsfq3zIoUum/Sx+Axx4S45sonVZdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Christoph Hellwig <hch@lst.de>,
        Lei YU <yulei.sh@bytedance.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.11 270/342] jffs2: Hook up splice_write callback
Date:   Mon, 10 May 2021 12:21:00 +0200
Message-Id: <20210510102019.020801528@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

commit 42984af09afc414d540fcc8247f42894b0378a91 upstream.

overlayfs using jffs2 as the upper filesystem would fail in some cases
since moving to v5.10. The test case used was to run 'touch' on a file
that exists in the lower fs, causing the modification time to be
updated. It returns EINVAL when the bug is triggered.

A bisection showed this was introduced in v5.9-rc1, with commit
36e2c7421f02 ("fs: don't allow splice read/write without explicit ops").
Reverting that commit restores the expected behaviour.

Some digging showed that this was due to jffs2 lacking an implementation
of splice_write. (For unknown reasons the warn_unsupported that should
trigger was not displaying any output).

Adding this patch resolved the issue and the test now passes.

Cc: stable@vger.kernel.org
Fixes: 36e2c7421f02 ("fs: don't allow splice read/write without explicit ops")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Lei YU <yulei.sh@bytedance.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jffs2/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -57,6 +57,7 @@ const struct file_operations jffs2_file_
 	.mmap =		generic_file_readonly_mmap,
 	.fsync =	jffs2_fsync,
 	.splice_read =	generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
 };
 
 /* jffs2_file_inode_operations */


