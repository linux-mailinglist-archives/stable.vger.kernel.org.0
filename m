Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15B41A9F08
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368382AbgDOMFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:05:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897641AbgDOLrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:47:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ED0721569;
        Wed, 15 Apr 2020 11:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951245;
        bh=3LC5W3ksQs8BAiEla9JyXaEan26FdDIhFIUrqtJlvHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3JcR4MI/4cTGDiEqfVrucT9MgWdAPFm9q9elQ5yPegoTPUPJcUEvq24t95N39/3H
         MxmJoP/uxKZ+GeW0QS7zC58upyi5mESqIuVPnTvRxvZGeEyr0U2JLtzeAdpbUfkM7E
         RxDRA+JJO53MV4ZgMqH3FjLhLOWRP4LAeMI9zH/Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Triplett <josh@joshtriplett.org>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/30] ext4: fix incorrect group count in ext4_fill_super error message
Date:   Wed, 15 Apr 2020 07:46:53 -0400
Message-Id: <20200415114711.15381-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114711.15381-1-sashal@kernel.org>
References: <20200415114711.15381-1-sashal@kernel.org>
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
index af55757bad699..47cbd51111739 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4101,9 +4101,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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

