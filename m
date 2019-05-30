Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA022F19D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbfE3EOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730611AbfE3DQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:11 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16F472458C;
        Thu, 30 May 2019 03:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186171;
        bh=XCn1ELRMA+ToIVfC3c3fQspKTX4PZzGqmlCyR9tStvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ak7QNxT60uxrTEKxqKOthoAIwuQ5cBdp+XnxB3I7TLp4Vrkfp4rZ4SZehAM30kIUB
         nKI7Tr0PNlFOZuTFvwZYqlfAI6YXJ+8NcPgnEVyQmUBKT8qEqIXqbNPRUwNzKdRXjW
         SSnGYnVBeDGdvEOAeX7V4mOtT3tFb0H3KI36ot98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Yu Xu <xuyu@linux.alibaba.com>
Subject: [PATCH 4.19 026/276] NFSv4.1 fix incorrect return value in copy_file_range
Date:   Wed, 29 May 2019 20:03:04 -0700
Message-Id: <20190530030525.828612417@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

commit 0769663b4f580566ef6cdf366f3073dbe8022c39 upstream.

According to the NFSv4.2 spec if the input and output file is the
same file, operation should fail with EINVAL. However, linux
copy_file_range() system call has no such restrictions. Therefore,
in such case let's return EOPNOTSUPP and allow VFS to fallback
to doing do_splice_direct(). Also when copy_file_range is called
on an NFSv4.0 or 4.1 mount (ie., a server that doesn't support
COPY functionality), we also need to return EOPNOTSUPP and
fallback to a regular copy.

Fixes xfstest generic/075, generic/091, generic/112, generic/263
for all NFSv4.x versions.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Yu Xu <xuyu@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs42proc.c |    3 ---
 fs/nfs/nfs4file.c  |    4 +++-
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -329,9 +329,6 @@ ssize_t nfs42_proc_copy(struct file *src
 	};
 	ssize_t err, err2;
 
-	if (!nfs_server_capable(file_inode(dst), NFS_CAP_COPY))
-		return -EOPNOTSUPP;
-
 	src_lock = nfs_get_lock_context(nfs_file_open_context(src));
 	if (IS_ERR(src_lock))
 		return PTR_ERR(src_lock);
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -133,8 +133,10 @@ static ssize_t nfs4_copy_file_range(stru
 				    struct file *file_out, loff_t pos_out,
 				    size_t count, unsigned int flags)
 {
+	if (!nfs_server_capable(file_inode(file_out), NFS_CAP_COPY))
+		return -EOPNOTSUPP;
 	if (file_inode(file_in) == file_inode(file_out))
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	return nfs42_proc_copy(file_in, pos_in, file_out, pos_out, count);
 }
 


