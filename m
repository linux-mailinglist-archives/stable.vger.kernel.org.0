Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF20E3785E4
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbhEJLCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234715AbhEJK4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFF7B61483;
        Mon, 10 May 2021 10:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643712;
        bh=wB6VxavS+YG8qCAhE1UQak6s2RxqDvU72Ap2YvfT46E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqUpYKim6cBT3zcHI/z2iliJZcv8OGpjw+cpPOkNCpBO+0dhOQcdV3vRrNNC/rYqx
         RGaCF8SmZk4wjh3k7gMW42pd8u1pi1OH4aIjnbKHym/ROUOUMqy5AwP8+qWtfkxER+
         24kVFgsnxh5/HbotQI9sBSWwHLT5/9e0F2vifWGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 126/342] btrfs: do proper error handling in btrfs_update_reloc_root
Date:   Mon, 10 May 2021 12:18:36 +0200
Message-Id: <20210510102014.240812812@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 592fbcd50c99b8adf999a2a54f9245caff333139 ]

We call btrfs_update_root in btrfs_update_reloc_root, which can fail for
all sorts of reasons, including IO errors.  Instead of panicing the box
lets return the error, now that all callers properly handle those
errors.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a257a7d8d453..73dcfe6e18f2 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -896,7 +896,7 @@ int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
 	int ret;
 
 	if (!have_reloc_root(root))
-		goto out;
+		return 0;
 
 	reloc_root = root->reloc_root;
 	root_item = &reloc_root->root_item;
@@ -929,10 +929,8 @@ int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_update_root(trans, fs_info->tree_root,
 				&reloc_root->root_key, root_item);
-	BUG_ON(ret);
 	btrfs_put_root(reloc_root);
-out:
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.30.2



