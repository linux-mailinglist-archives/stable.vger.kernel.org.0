Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEB7769E7
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387998AbfGZNmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387991AbfGZNmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:42:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E22EE22CBD;
        Fri, 26 Jul 2019 13:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148558;
        bh=7xIcJ6Fzifi4By4D8Vj/IisMVr9pp74nLitXIpQmDTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2q6C315hTGmFgIH8/uczmTLnJ5r1mJEYsgwov0MUBY3vUzpFpMqxEF4Dn3Wx6J7S/
         Qm+F1wgC0G8zrWBoKokwk7b0JjHYDDwYZ7jxPZ07w11C511XWw09/x3qSt6wUOvFCi
         xDgArn3RNez8rjM6g9D2rSrsEGFWvJ8d+h1odL2s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/47] btrfs: fix minimum number of chunk errors for DUP
Date:   Fri, 26 Jul 2019 09:41:38 -0400
Message-Id: <20190726134210.12156-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134210.12156-1-sashal@kernel.org>
References: <20190726134210.12156-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit 0ee5f8ae082e1f675a2fb6db601c31ac9958a134 ]

The list of profiles in btrfs_chunk_max_errors lists DUP as a profile
DUP able to tolerate 1 device missing. Though this profile is special
with 2 copies, it still needs the device, unlike the others.

Looking at the history of changes, thre's no clear reason why DUP is
there, functions were refactored and blocks of code merged to one
helper.

d20983b40e828 Btrfs: fix writing data into the seed filesystem
  - factor code to a helper

de11cc12df173 Btrfs: don't pre-allocate btrfs bio
  - unrelated change, DUP still in the list with max errors 1

a236aed14ccb0 Btrfs: Deal with failed writes in mirrored configurations
  - introduced the max errors, leaves DUP and RAID1 in the same group

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2fd000308be7..6e008bd5c8cd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5040,8 +5040,7 @@ static inline int btrfs_chunk_max_errors(struct map_lookup *map)
 
 	if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
 			 BTRFS_BLOCK_GROUP_RAID10 |
-			 BTRFS_BLOCK_GROUP_RAID5 |
-			 BTRFS_BLOCK_GROUP_DUP)) {
+			 BTRFS_BLOCK_GROUP_RAID5)) {
 		max_errors = 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID6) {
 		max_errors = 2;
-- 
2.20.1

