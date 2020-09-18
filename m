Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3915826F2FF
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgIRCFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbgIRCFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:05:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2923D2344C;
        Fri, 18 Sep 2020 02:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394700;
        bh=cy6Vb+w8dw3c/JpKeFygjW4q0sjZBzO0mk4wcmcKE64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xhwoS+HDOLJPbDKBAjEarxv5rMLa3kdoYCIUEvOwqRn1VE9fxPHfirFMNAZOuSh/J
         Guv7cMSNTBDJ/DRKjYXs2qo+8HdhuHWZVyGAI6RiCYLjXmOinx2cUg4mEwbVbLtn8D
         +/eXwO7W2BxKT7b8dhPRVi7HdlNMuAkkUmWwRdVs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 187/330] btrfs: do not init a reloc root if we aren't relocating
Date:   Thu, 17 Sep 2020 21:58:47 -0400
Message-Id: <20200918020110.2063155-187-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 2abc726ab4b83db774e315c660ab8da21477092f ]

We previously were checking if the root had a dead root before accessing
root->reloc_root in order to avoid a use-after-free type bug.  However
this scenario happens after we've unset the reloc control, so we would
have been saved if we'd simply checked for fs_info->reloc_control.  At
this point during relocation we no longer need to be creating new reloc
roots, so simply move this check above the reloc_root checks to avoid
any future races and confusion.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index af3605a0bf2e0..1313506a7ecb5 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1468,6 +1468,10 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
 	int clear_rsv = 0;
 	int ret;
 
+	if (!rc || !rc->create_reloc_tree ||
+	    root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID)
+		return 0;
+
 	/*
 	 * The subvolume has reloc tree but the swap is finished, no need to
 	 * create/update the dead reloc tree
@@ -1481,10 +1485,6 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
-	if (!rc || !rc->create_reloc_tree ||
-	    root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID)
-		return 0;
-
 	if (!trans->reloc_reserved) {
 		rsv = trans->block_rsv;
 		trans->block_rsv = rc->block_rsv;
@@ -2336,6 +2336,18 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 			trans = NULL;
 			goto out;
 		}
+
+		/*
+		 * At this point we no longer have a reloc_control, so we can't
+		 * depend on btrfs_init_reloc_root to update our last_trans.
+		 *
+		 * But that's ok, we started the trans handle on our
+		 * corresponding fs_root, which means it's been added to the
+		 * dirty list.  At commit time we'll still call
+		 * btrfs_update_reloc_root() and update our root item
+		 * appropriately.
+		 */
+		reloc_root->last_trans = trans->transid;
 		trans->block_rsv = rc->block_rsv;
 
 		replaced = 0;
-- 
2.25.1

