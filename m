Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB8224F9DE
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgHXJuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:50:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728601AbgHXIjI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:39:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F137E20FC3;
        Mon, 24 Aug 2020 08:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258348;
        bh=23ucjoFeJ1M8m1lUFCqnbYUhv+4g9L4TflRGrF9xXrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WzibhZpazSEOB7eIS1aiNeuSllsA0kA5mlB9aTsb5NW7l17sDFq5vk9fGOyi/8qKZ
         ZLHhQKkAqMVDYnoZkZdjAhupRr6XBQIVmpyM34RvlKEbb8sK4efhFxt7g/V2p7JaOV
         u5UXG16ZFKgxx4fQ2ZDFFsltbv2m7UE9b8vw6Tqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Filipe Manana <fdmanana@gmail.com>, Jan Kara <jack@suse.cz>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.7 017/124] ext4: do not block RWF_NOWAIT dio write on unallocated space
Date:   Mon, 24 Aug 2020 10:29:11 +0200
Message-Id: <20200824082410.264793677@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 0b3171b6d195637f84ddf8b59bae818ea20bc8ac upstream.

Since commit 378f32bab371 ("ext4: introduce direct I/O write using iomap
infrastructure") we don't properly bail out of RWF_NOWAIT direct IO
write if underlying blocks are not allocated. Also
ext4_dio_write_checks() does not honor RWF_NOWAIT when re-acquiring
i_rwsem. Fix both issues.

Fixes: 378f32bab371 ("ext4: introduce direct I/O write using iomap infrastructure")
Cc: stable@kernel.org
Reported-by: Filipe Manana <fdmanana@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/20200708153516.9507-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/file.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -428,6 +428,10 @@ restart:
 	 */
 	if (*ilock_shared && (!IS_NOSEC(inode) || *extend ||
 	     !ext4_overwrite_io(inode, offset, count))) {
+		if (iocb->ki_flags & IOCB_NOWAIT) {
+			ret = -EAGAIN;
+			goto out;
+		}
 		inode_unlock_shared(inode);
 		*ilock_shared = false;
 		inode_lock(inode);


