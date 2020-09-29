Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C66E27C8BA
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgI2MEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:04:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728532AbgI2Lh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4AA22083B;
        Tue, 29 Sep 2020 11:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379479;
        bh=cy6Vb+w8dw3c/JpKeFygjW4q0sjZBzO0mk4wcmcKE64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0bp5RICly/E5YneteI0ndZZg0or2psRShz9SF4sPihN6HTpVmnLyVD7eQkA9mMEC
         GDObBBaZb/WfU1h7FgY5kcg9U1bLOXjBF1d/cVHFQ34/DAQNX1fNk4SYWtsu4pQw8K
         hqhQJs83KDMx/WKYxaBoPPW5GIT6p0kuvUCeUOoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 181/388] btrfs: do not init a reloc root if we arent relocating
Date:   Tue, 29 Sep 2020 12:58:32 +0200
Message-Id: <20200929110019.241640212@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



