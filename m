Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9D515E8EA
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389344AbgBNRD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:03:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404169AbgBNQPy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:15:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0839246AA;
        Fri, 14 Feb 2020 16:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696953;
        bh=JJMmc5g1eGCmHENbQ2PMQGmXelm8gaob9rFnxvQpAFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOjAkz5ZD7tgV7LFmdS8MsC30lQoc9o5vJdbRUN5G6niZtisOqW3uAo1g95YW9KhT
         gRBb285lObjY8Bn53rOjcUym61UsqHqLfv/lWXw1K6RXSg5E79FVyCFbA+UKj0c3RD
         esYnyMPO4PkhCjsGkfWTl1/vRl9iTZOYoIaXnKr8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Thumshirn <jth@kernel.org>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 194/252] btrfs: fix possible NULL-pointer dereference in integrity checks
Date:   Fri, 14 Feb 2020 11:10:49 -0500
Message-Id: <20200214161147.15842-194-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <jth@kernel.org>

[ Upstream commit 3dbd351df42109902fbcebf27104149226a4fcd9 ]

A user reports a possible NULL-pointer dereference in
btrfsic_process_superblock(). We are assigning state->fs_info to a local
fs_info variable and afterwards checking for the presence of state.

While we would BUG_ON() a NULL state anyways, we can also just remove
the local fs_info copy, as fs_info is only used once as the first
argument for btrfs_num_copies(). There we can just pass in
state->fs_info as well.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=205003
Signed-off-by: Johannes Thumshirn <jth@kernel.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/check-integrity.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 833cf3c35b4df..3b77c8ab5357e 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -629,7 +629,6 @@ static struct btrfsic_dev_state *btrfsic_dev_state_hashtable_lookup(dev_t dev,
 static int btrfsic_process_superblock(struct btrfsic_state *state,
 				      struct btrfs_fs_devices *fs_devices)
 {
-	struct btrfs_fs_info *fs_info = state->fs_info;
 	struct btrfs_super_block *selected_super;
 	struct list_head *dev_head = &fs_devices->devices;
 	struct btrfs_device *device;
@@ -700,7 +699,7 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 			break;
 		}
 
-		num_copies = btrfs_num_copies(fs_info, next_bytenr,
+		num_copies = btrfs_num_copies(state->fs_info, next_bytenr,
 					      state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			pr_info("num_copies(log_bytenr=%llu) = %d\n",
-- 
2.20.1

