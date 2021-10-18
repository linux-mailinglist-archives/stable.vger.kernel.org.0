Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E00431DAC
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbhJRNyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233711AbhJRNvu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:51:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BEAA613A3;
        Mon, 18 Oct 2021 13:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564306;
        bh=odU9IoUQ8L8GzWY05+boDSQRU03jV0olz6+rWM9JSGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GR0Kw/XW3kkfRBFd4a56yBibrzYqCMqRVQNz3Jo9ACerxz7dLWq0i63iQHPcihVjq
         MrgTJdhc2aZMy8Uge/4W+eSgnjq+v2ujotLRpziEFm7ubWqnopeF/Kabvu2DdU5/tk
         oZdp5keTGfQmksdlzzjfceonBAZ7JYqtJ4xqZhHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.14 032/151] btrfs: deal with errors when adding inode reference during log replay
Date:   Mon, 18 Oct 2021 15:23:31 +0200
Message-Id: <20211018132341.729111698@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 52db77791fe24538c8aa2a183248399715f6b380 upstream.

At __inode_add_ref(), we treating any error returned from
btrfs_lookup_dir_item() or from btrfs_lookup_dir_index_item() as meaning
that there is no existing directory entry in the fs/subvolume tree.
This is not correct since we can get errors such as, for example, -EIO
when reading extent buffers while searching the fs/subvolume's btree.

So fix that and return the error to the caller when it is not -ENOENT.

CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1182,7 +1182,10 @@ next:
 	/* look for a conflicting sequence number */
 	di = btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(dir),
 					 ref_index, name, namelen, 0);
-	if (di && !IS_ERR(di)) {
+	if (IS_ERR(di)) {
+		if (PTR_ERR(di) != -ENOENT)
+			return PTR_ERR(di);
+	} else if (di) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
 		if (ret)
 			return ret;
@@ -1192,7 +1195,9 @@ next:
 	/* look for a conflicting name */
 	di = btrfs_lookup_dir_item(trans, root, path, btrfs_ino(dir),
 				   name, namelen, 0);
-	if (di && !IS_ERR(di)) {
+	if (IS_ERR(di)) {
+		return PTR_ERR(di);
+	} else if (di) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
 		if (ret)
 			return ret;


