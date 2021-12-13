Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71704729AB
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240616AbhLMKXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244351AbhLMKQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:16:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F15C0497DD;
        Mon, 13 Dec 2021 01:56:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8BD5B80E20;
        Mon, 13 Dec 2021 09:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF121C34600;
        Mon, 13 Dec 2021 09:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389361;
        bh=60mtdTU7mtPxx8yxDboP61RQQgSrcbwYFeRsFFREP6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mu0cOKhqD4z3RYDm2pitBoqRS5BQ4qn2gCgm8hb3vahMXKs9aZnkb9cYaJ//lArjh
         JDQsOiNyuZqVRc/dZWN0FIxagjRsQOfwOMDOUaP8pz2vyILf9Dq7rEIp700wj1Om/p
         yPuEVJ5QxeXDteA9XKMUC0O6I8e24I9b10UTgHTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 074/171] btrfs: replace the BUG_ON in btrfs_del_root_ref with proper error handling
Date:   Mon, 13 Dec 2021 10:29:49 +0100
Message-Id: <20211213092947.566564052@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 8289ed9f93bef2762f9184e136d994734b16d997 upstream.

I hit the BUG_ON() with generic/475 test case, and to my surprise, all
callers of btrfs_del_root_ref() are already aborting transaction, thus
there is not need for such BUG_ON(), just go to @out label and caller
will properly handle the error.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/root-tree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -336,7 +336,8 @@ int btrfs_del_root_ref(struct btrfs_tran
 	key.offset = ref_id;
 again:
 	ret = btrfs_search_slot(trans, tree_root, &key, path, -1, 1);
-	BUG_ON(ret < 0);
+	if (ret < 0)
+		goto out;
 	if (ret == 0) {
 		leaf = path->nodes[0];
 		ref = btrfs_item_ptr(leaf, path->slots[0],


