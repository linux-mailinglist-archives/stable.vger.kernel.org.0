Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830A624BB30
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgHTMYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730045AbgHTJxm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:53:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F16A208DB;
        Thu, 20 Aug 2020 09:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917221;
        bh=X5Vbw7v3JN2jIdF4Via6kEXf7Sgw1y6/1nSofmAy63Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oO19pvT6Mp0ObBGyMqgd23V4u0flbEfQz7PgErDePBVzPhhjuF+sOuGbazOWnkATK
         lAQvzDe05tGCRUDJxGUi7LRrX6mHgMtxWEAnnzZ1hxAC79K65LcWLe0cBefYwA8fwe
         qTZzhHH38/Y50xEKK8SQLbWqPsgS6VKuR9c2Pu/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 16/92] btrfs: fix memory leaks after failure to lookup checksums during inode logging
Date:   Thu, 20 Aug 2020 11:21:01 +0200
Message-Id: <20200820091538.397895621@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 4f26433e9b3eb7a55ed70d8f882ae9cd48ba448b upstream.

While logging an inode, at copy_items(), if we fail to lookup the checksums
for an extent we release the destination path, free the ins_data array and
then return immediately. However a previous iteration of the for loop may
have added checksums to the ordered_sums list, in which case we leak the
memory used by them.

So fix this by making sure we iterate the ordered_sums list and free all
its checksums before returning.

Fixes: 3650860b90cc2a ("Btrfs: remove almost all of the BUG()'s from tree-log.c")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-log.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3988,11 +3988,8 @@ static noinline int copy_items(struct bt
 						fs_info->csum_root,
 						ds + cs, ds + cs + cl - 1,
 						&ordered_sums, 0);
-				if (ret) {
-					btrfs_release_path(dst_path);
-					kfree(ins_data);
-					return ret;
-				}
+				if (ret)
+					break;
 			}
 		}
 	}
@@ -4005,7 +4002,6 @@ static noinline int copy_items(struct bt
 	 * we have to do this after the loop above to avoid changing the
 	 * log tree while trying to change the log tree.
 	 */
-	ret = 0;
 	while (!list_empty(&ordered_sums)) {
 		struct btrfs_ordered_sum *sums = list_entry(ordered_sums.next,
 						   struct btrfs_ordered_sum,


