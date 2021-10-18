Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CF6431DCA
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhJRNzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232847AbhJRNxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 957BD61409;
        Mon, 18 Oct 2021 13:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564335;
        bh=NKMJmg+oIgJNSDtkTSgCog3BrBMeBjAqxcMvP8EuDW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArqxQulOm8maFBOz0RDVL8qyzB/J+j3sS2EiZBJir/404H2v/ncJyw6+vwp5JAmos
         Gw/Zc2BuXub5/d54tN0x+1u9vhLiLi2nSFySFkcjnJoq6aOlk4dsO8DTyqYRj1LydP
         SJZloSOpCimCX+3JeSVVOswaUE2I1hHLo/drMgDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.14 033/151] btrfs: check for error when looking up inode during dir entry replay
Date:   Mon, 18 Oct 2021 15:23:32 +0200
Message-Id: <20211018132341.764155246@linuxfoundation.org>
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

commit cfd312695b71df04c3a2597859ff12c470d1e2e4 upstream.

At replay_one_name(), we are treating any error from btrfs_lookup_inode()
as if the inode does not exists. Fix this by checking for an error and
returning it to the caller.

CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1941,8 +1941,8 @@ static noinline int replay_one_name(stru
 	struct btrfs_key log_key;
 	struct inode *dir;
 	u8 log_type;
-	int exists;
-	int ret = 0;
+	bool exists;
+	int ret;
 	bool update_size = (key->type == BTRFS_DIR_INDEX_KEY);
 	bool name_added = false;
 
@@ -1962,12 +1962,12 @@ static noinline int replay_one_name(stru
 		   name_len);
 
 	btrfs_dir_item_key_to_cpu(eb, di, &log_key);
-	exists = btrfs_lookup_inode(trans, root, path, &log_key, 0);
-	if (exists == 0)
-		exists = 1;
-	else
-		exists = 0;
+	ret = btrfs_lookup_inode(trans, root, path, &log_key, 0);
 	btrfs_release_path(path);
+	if (ret < 0)
+		goto out;
+	exists = (ret == 0);
+	ret = 0;
 
 	if (key->type == BTRFS_DIR_ITEM_KEY) {
 		dst_di = btrfs_lookup_dir_item(trans, root, path, key->objectid,


