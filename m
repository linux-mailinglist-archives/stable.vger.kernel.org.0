Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACB91A9E6F
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409613AbgDOL4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409405AbgDOLr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:47:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F47320732;
        Wed, 15 Apr 2020 11:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951278;
        bh=2WU1KnZmrA8AQIpCo6xlMyXDOrFQw7bJMjD+x8xgYXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jr4reM7z9ZlnbEs/DA5HTctS3BNO1gdcg+ptJj72W5Utjx8Sh5/rhlkS0GcrVlgWa
         5ye2byGDGeFlFNPDtTmyQBjnFjK9L9sUaUnO0M3/30PntPgq5psd+w/raqvwAAGg1M
         n0P4qqeeFogsxR8XhonIf2fHkzKsQidCjpVLCwts=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Triplett <josh@joshtriplett.org>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 08/21] ext4: fix incorrect group count in ext4_fill_super error message
Date:   Wed, 15 Apr 2020 07:47:35 -0400
Message-Id: <20200415114748.15713-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114748.15713-1-sashal@kernel.org>
References: <20200415114748.15713-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

[ Upstream commit df41460a21b06a76437af040d90ccee03888e8e5 ]

ext4_fill_super doublechecks the number of groups before mounting; if
that check fails, the resulting error message prints the group count
from the ext4_sb_info sbi, which hasn't been set yet. Print the freshly
computed group count instead (which at that point has just been computed
in "blocks_count").

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Fixes: 4ec1102813798 ("ext4: Add sanity checks for the superblock before mounting the filesystem")
Link: https://lore.kernel.org/r/8b957cd1513fcc4550fe675c10bcce2175c33a49.1585431964.git.josh@joshtriplett.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 508995e7e31d8..cbea8ff6e6c7b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3952,9 +3952,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			EXT4_BLOCKS_PER_GROUP(sb) - 1);
 	do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
 	if (blocks_count > ((uint64_t)1<<32) - EXT4_DESC_PER_BLOCK(sb)) {
-		ext4_msg(sb, KERN_WARNING, "groups count too large: %u "
+		ext4_msg(sb, KERN_WARNING, "groups count too large: %llu "
 		       "(block count %llu, first data block %u, "
-		       "blocks per group %lu)", sbi->s_groups_count,
+		       "blocks per group %lu)", blocks_count,
 		       ext4_blocks_count(es),
 		       le32_to_cpu(es->s_first_data_block),
 		       EXT4_BLOCKS_PER_GROUP(sb));
-- 
2.20.1

