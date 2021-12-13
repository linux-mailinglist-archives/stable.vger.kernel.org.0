Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04E9472697
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236478AbhLMJxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:53:40 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41512 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237503AbhLMJuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:50:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A3C80CE0DDE;
        Mon, 13 Dec 2021 09:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6E3C341C5;
        Mon, 13 Dec 2021 09:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389009;
        bh=60mtdTU7mtPxx8yxDboP61RQQgSrcbwYFeRsFFREP6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcI23k5vU1FDwOSgmhgBgypCjgqTva4Po/M6JG7XdfO1NUpXwkfEoaBG1ebIOAazb
         ZVWAaOqdW1O7HTLFrM6rbDbDmIQ6TwKkxodg0rKXZ5b5H4o2HrYL2wB1FooW7SiJz8
         jc38mM22zvykl79kUzo3gbysJwaqMJ9nRjVDPYug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 053/132] btrfs: replace the BUG_ON in btrfs_del_root_ref with proper error handling
Date:   Mon, 13 Dec 2021 10:29:54 +0100
Message-Id: <20211213092940.946824185@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
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


