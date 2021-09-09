Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4989140541C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355192AbhIIM5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355013AbhIIMtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:49:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44ADD63224;
        Thu,  9 Sep 2021 11:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188613;
        bh=LhVQYxSijWb2ticR9mMoZ1pEGPEgC7Plw8vjUmGB1sQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nx0xJTJZnGMbyTyG4SJ143BTNH+VVxEZNOMpHUS8/ndTcOOMZCbzZFlkIVsgER9JN
         5xGYMPJLaZbHfJZVD5qI4NullfKiNpe1Tthbto6KSYzLX+/4qGxhBOI8iV5br1bat3
         5+WZ7ITVCFr3skE2QkRvDrUhP63hsBXnIT9/7KvD09Q+yVHxZT0ab8du2iN+a7slUF
         Xsv5Mr8Pj66Vly1kYkri2omAs+3dzM8jwPgwTClbh0HbskeMr5RTj/g0ZW5eQZDIti
         yz0dUPA5EmhsHHNA2HydS9lwLHuP1c/bGGE8GhoDTtPGAO+6KYz8y7t3BuPVplm43h
         xcdpder0VLY9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 083/109] btrfs: tree-log: check btrfs_lookup_data_extent return value
Date:   Thu,  9 Sep 2021 07:54:40 -0400
Message-Id: <20210909115507.147917-83-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

[ Upstream commit 3736127a3aa805602b7a2ad60ec9cfce68065fbb ]

Function btrfs_lookup_data_extent calls btrfs_search_slot to verify if
the EXTENT_ITEM exists in the extent tree. btrfs_search_slot can return
values bellow zero if an error happened.

Function replay_one_extent currently checks if the search found
something (0 returned) and increments the reference, and if not, it
seems to evaluate as 'not found'.

Fix the condition by checking if the value was bellow zero and return
early.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 5412361d0c27..8ea4b3da85d1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -719,7 +719,9 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 			 */
 			ret = btrfs_lookup_data_extent(fs_info, ins.objectid,
 						ins.offset);
-			if (ret == 0) {
+			if (ret < 0) {
+				goto out;
+			} else if (ret == 0) {
 				btrfs_init_generic_ref(&ref,
 						BTRFS_ADD_DELAYED_REF,
 						ins.objectid, ins.offset, 0);
-- 
2.30.2

