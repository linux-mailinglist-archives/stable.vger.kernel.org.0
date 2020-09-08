Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783C4261885
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731548AbgIHRxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731586AbgIHQNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:13:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8720C248A5;
        Tue,  8 Sep 2020 15:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580348;
        bh=Wmb9tXluiT6qEG93jAG038HMJ32OR4eUqlf3c58sI2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PD12uB1e1B/1XICsJtggQomPHn9SprIYZsCm9inHx3lOgBPNh3FYUPlcNQ6yZVLLm
         3Z8c0637FyrtOestZTXxgqSHLkrwzO58WanRJyx293oTD633FIiQE7oxOlJoa4l6m2
         OFo9cN09+W1ANU1UifxUH52AjgJDJMFS9+egkOu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/65] btrfs: Remove redundant extent_buffer_get in get_old_root
Date:   Tue,  8 Sep 2020 17:26:24 +0200
Message-Id: <20200908152219.039795888@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit 6c122e2a0c515cfb3f3a9cefb5dad4cb62109c78 ]

get_old_root used used only by btrfs_search_old_slot to initialise the
path structure. The old root is always a cloned buffer (either via alloc
dummy or via btrfs_clone_extent_buffer) and its reference count is 2: 1
from allocation, 1 from extent_buffer_get call in get_old_root.

This latter explicit ref count acquire operation is in fact unnecessary
since the semantic is such that the newly allocated buffer is handed
over to the btrfs_path for lifetime management. Considering this just
remove the extra extent_buffer_get in get_old_root.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index f5a8c0d26cf36..492a781c27cd4 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1438,7 +1438,6 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 
 	if (!eb)
 		return NULL;
-	extent_buffer_get(eb);
 	btrfs_tree_read_lock(eb);
 	if (old_root) {
 		btrfs_set_header_bytenr(eb, eb->start);
-- 
2.25.1



