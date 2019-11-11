Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6ED0F7CD6
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbfKKSuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:50:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728461AbfKKSuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:50:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2EBC20818;
        Mon, 11 Nov 2019 18:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498216;
        bh=cOcAE6qqwB7bGykBj2+xfk0pwpLQQFmZczApTOhfZ4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/L1UEq/e4rVh4iIU7zCzYXWpf6uvNtzRJ0d9yXV9+Jx1AweBsNpoSOSKpn63a+83
         ekMKFtpFH8G8Nlg5nZ4I7foTop0XjEr+iAPN/3U0/7MnS6das0hOqpdT3DpZA6NnLc
         IgjAz5zRt4bfiAnkaarX/hRtiToJpasg6jDIkthE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.3 055/193] ceph: dont allow copy_file_range when stripe_count != 1
Date:   Mon, 11 Nov 2019 19:27:17 +0100
Message-Id: <20191111181505.054376085@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Henriques <lhenriques@suse.com>

commit a3a0819388b2bf15e7eafe38ff6aacfc27b12df0 upstream.

copy_file_range tries to use the OSD 'copy-from' operation, which simply
performs a full object copy.  Unfortunately, the implementation of this
system call assumes that stripe_count is always set to 1 and doesn't take
into account that the data may be striped across an object set.  If the
file layout has stripe_count different from 1, then the destination file
data will be corrupted.

For example:

Consider a 8 MiB file with 4 MiB object size, stripe_count of 2 and
stripe_size of 2 MiB; the first half of the file will be filled with 'A's
and the second half will be filled with 'B's:

               0      4M     8M       Obj1     Obj2
               +------+------+       +----+   +----+
        file:  | AAAA | BBBB |       | AA |   | AA |
               +------+------+       |----|   |----|
                                     | BB |   | BB |
                                     +----+   +----+

If we copy_file_range this file into a new file (which needs to have the
same file layout!), then it will start by copying the object starting at
file offset 0 (Obj1).  And then it will copy the object starting at file
offset 4M -- which is Obj1 again.

Unfortunately, the solution for this is to not allow remote object copies
to be performed when the file layout stripe_count is not 1 and simply
fallback to the default (VFS) copy_file_range implementation.

Cc: stable@vger.kernel.org
Signed-off-by: Luis Henriques <lhenriques@suse.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/file.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1934,10 +1934,18 @@ static ssize_t __ceph_copy_file_range(st
 	if (ceph_test_mount_opt(ceph_inode_to_client(src_inode), NOCOPYFROM))
 		return -EOPNOTSUPP;
 
+	/*
+	 * Striped file layouts require that we copy partial objects, but the
+	 * OSD copy-from operation only supports full-object copies.  Limit
+	 * this to non-striped file layouts for now.
+	 */
 	if ((src_ci->i_layout.stripe_unit != dst_ci->i_layout.stripe_unit) ||
-	    (src_ci->i_layout.stripe_count != dst_ci->i_layout.stripe_count) ||
-	    (src_ci->i_layout.object_size != dst_ci->i_layout.object_size))
+	    (src_ci->i_layout.stripe_count != 1) ||
+	    (dst_ci->i_layout.stripe_count != 1) ||
+	    (src_ci->i_layout.object_size != dst_ci->i_layout.object_size)) {
+		dout("Invalid src/dst files layout\n");
 		return -EOPNOTSUPP;
+	}
 
 	if (len < src_ci->i_layout.object_size)
 		return -EOPNOTSUPP; /* no remote copy will be done */


