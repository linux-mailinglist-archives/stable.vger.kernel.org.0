Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A601C1501
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731827AbgEANpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:45:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730317AbgEANpE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:45:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6925220757;
        Fri,  1 May 2020 13:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340703;
        bh=edshClquLjQLAskTiibmYotWxRfjfhE2CQvBtrwoN0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBltICPhV3BlNGB3rsOz0L88gg9Lq5IhZel+8HvJL5yDlW3rQffdZfNIiZPvBi3XQ
         jWOWBFajH3FxBr4WcgBB7ujunDpUNS0jCQ8+pr9TqnQlZ2Kpn3LqC5MoUQNnLy0gvi
         0in8KxiZsVmsAv7nztbq0ZLrbBzZ9jZJylNhuO8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 090/106] ext4: increase wait time needed before reuse of deleted inode numbers
Date:   Fri,  1 May 2020 15:24:03 +0200
Message-Id: <20200501131554.300377276@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit a17a9d935dc4a50acefaf319d58030f1da7f115a ]

Current wait times have proven to be too short to protect against inode
reuses that lead to metadata inconsistencies.

Now that we will retry the inode allocation if we can't find any
recently deleted inodes, it's a lot safer to increase the recently
deleted time from 5 seconds to a minute.

Link: https://lore.kernel.org/r/20200414023925.273867-1-tytso@mit.edu
Google-Bug-Id: 36602237
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ialloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f95ee99091e4c..eab18b7b56e77 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -663,7 +663,7 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
  * block has been written back to disk.  (Yes, these values are
  * somewhat arbitrary...)
  */
-#define RECENTCY_MIN	5
+#define RECENTCY_MIN	60
 #define RECENTCY_DIRTY	300
 
 static int recently_deleted(struct super_block *sb, ext4_group_t group, int ino)
-- 
2.20.1



