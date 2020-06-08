Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F561F251E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731795AbgFHXZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731141AbgFHXZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:25:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF88D2078D;
        Mon,  8 Jun 2020 23:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658723;
        bh=Gww3TbrH3eF0jQEmWRGZutj5P7IuAJBkE8VkTY5CPag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFTf///JbFpJhd8T+0dgnQyIjj1WIGzRWB0JyaK2u5XV3kTgp9HlR+/20W46uFVWk
         LkHylQdqJOC58Cw3/8v8hcpeXITIl4nUDsC9LwCSC9iE9D/EJKDNIH0+ka+rTC580h
         6u+6rbRyYtMv/WwrAz9YxeM6XN7NJ22ciwyYGQsk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 17/72] btrfs: do not ignore error from btrfs_next_leaf() when inserting checksums
Date:   Mon,  8 Jun 2020 19:24:05 -0400
Message-Id: <20200608232500.3369581-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232500.3369581-1-sashal@kernel.org>
References: <20200608232500.3369581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 7e4a3f7ed5d54926ec671bbb13e171cfe179cc50 ]

We are currently treating any non-zero return value from btrfs_next_leaf()
the same way, by going to the code that inserts a new checksum item in the
tree. However if btrfs_next_leaf() returns an error (a value < 0), we
should just stop and return the error, and not behave as if nothing has
happened, since in that case we do not have a way to know if there is a
next leaf or we are currently at the last leaf already.

So fix that by returning the error from btrfs_next_leaf().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file-item.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 717d82d51bb1..edd5f152e448 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -795,10 +795,12 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 		nritems = btrfs_header_nritems(path->nodes[0]);
 		if (!nritems || (path->slots[0] >= nritems - 1)) {
 			ret = btrfs_next_leaf(root, path);
-			if (ret == 1)
+			if (ret < 0) {
+				goto out;
+			} else if (ret > 0) {
 				found_next = 1;
-			if (ret != 0)
 				goto insert;
+			}
 			slot = path->slots[0];
 		}
 		btrfs_item_key_to_cpu(path->nodes[0], &found_key, slot);
-- 
2.25.1

