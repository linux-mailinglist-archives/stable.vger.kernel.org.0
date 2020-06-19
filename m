Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB01200E59
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391482AbgFSPGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390684AbgFSPGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:06:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93B8821BE5;
        Fri, 19 Jun 2020 15:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579201;
        bh=MkhQdYmlwhdXAwRMV4INdW/RGVcDVH26f6kH/J+KPUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=miXsB+G1nN0Q6RZ+uSZwDA8VOQ8T9NFeQDVLyqdfCV9MNpCwJ/yEp4utrceDMrqJ0
         eky0bfRGQfqU3tOF5HXTy22pFMqDWZGc3iMepkBwBmVi4cEUE0bu7YDoRISKUufSjH
         nmHnjoJ983UMVorO41OOpNTnwHdz/pwSqOL+zHGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/261] btrfs: account for trans_block_rsv in may_commit_transaction
Date:   Fri, 19 Jun 2020 16:30:56 +0200
Message-Id: <20200619141652.087010489@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit bb4f58a747f0421b10645fbf75a6acc88da0de50 ]

On ppc64le with 64k page size (respectively 64k block size) generic/320
was failing and debug output showed we were getting a premature ENOSPC
with a bunch of space in btrfs_fs_info::trans_block_rsv.

This meant there were still open transaction handles holding space, yet
the flusher didn't commit the transaction because it deemed the freed
space won't be enough to satisfy the current reserve ticket. Fix this
by accounting for space in trans_block_rsv when deciding whether the
current transaction should be committed or not.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Tested-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/space-info.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index e8a4b0ebe97f..5b47e3c44c8f 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -462,6 +462,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	struct reserve_ticket *ticket = NULL;
 	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_block_rsv;
 	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
+	struct btrfs_block_rsv *trans_rsv = &fs_info->trans_block_rsv;
 	struct btrfs_trans_handle *trans;
 	u64 bytes_needed;
 	u64 reclaim_bytes = 0;
@@ -524,6 +525,11 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	spin_lock(&delayed_refs_rsv->lock);
 	reclaim_bytes += delayed_refs_rsv->reserved;
 	spin_unlock(&delayed_refs_rsv->lock);
+
+	spin_lock(&trans_rsv->lock);
+	reclaim_bytes += trans_rsv->reserved;
+	spin_unlock(&trans_rsv->lock);
+
 	if (reclaim_bytes >= bytes_needed)
 		goto commit;
 	bytes_needed -= reclaim_bytes;
-- 
2.25.1



