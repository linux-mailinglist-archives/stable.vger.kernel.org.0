Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88BD0171FA8
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732116AbgB0OhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732349AbgB0N5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:57:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB3C92084E;
        Thu, 27 Feb 2020 13:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811868;
        bh=JrqyDo3x/1o+v5c62+1zKO0XnJlzXMNnrtph6kSO1Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPqF235rwKp8fDNj0fJWeXyJWSBvzhDaS7wkoge+bZdrqMUI4+y2C+byPVLmyOns3
         OSgI0YsPsoZZXoL5MtxWnzwk13tJ07pKr2lXVfL+XFXEJrPUV0bVAfSoEDl4MrwV/W
         rYjSuS+G61ijUo6WBRt02RqrIT9VdwUiWUZvSifY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 132/237] btrfs: fix possible NULL-pointer dereference in integrity checks
Date:   Thu, 27 Feb 2020 14:35:46 +0100
Message-Id: <20200227132306.434413161@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7d5a9b51f0d7a..4be07cf31d74c 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -642,7 +642,6 @@ static struct btrfsic_dev_state *btrfsic_dev_state_hashtable_lookup(dev_t dev,
 static int btrfsic_process_superblock(struct btrfsic_state *state,
 				      struct btrfs_fs_devices *fs_devices)
 {
-	struct btrfs_fs_info *fs_info = state->fs_info;
 	struct btrfs_super_block *selected_super;
 	struct list_head *dev_head = &fs_devices->devices;
 	struct btrfs_device *device;
@@ -713,7 +712,7 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 			break;
 		}
 
-		num_copies = btrfs_num_copies(fs_info, next_bytenr,
+		num_copies = btrfs_num_copies(state->fs_info, next_bytenr,
 					      state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			pr_info("num_copies(log_bytenr=%llu) = %d\n",
-- 
2.20.1



