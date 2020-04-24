Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3219F1B74C7
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgDXM2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:28:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbgDXMYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:24:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B20D621835;
        Fri, 24 Apr 2020 12:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731055;
        bh=21jnwet0trPW2Kv3E6ihRnckW6TR5od8KkJAPHwPeqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7W/2T83CUnd5AGRNZR9YaKAv87omwC9MfZ0t+RxJSHbBE4uoqNHvZrREM1Y3Z+Jd
         OXbPVg3S+37kF6Yy6+hpfEXlBpfKAxezBV23jJ8qrHRqqjINVrefxQBLlltg+4SQ9S
         geXIIjMiBq8aQq9M540rGheejGhYp8+srUIHrj8E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/18] ext4: increase wait time needed before reuse of deleted inode numbers
Date:   Fri, 24 Apr 2020 08:23:53 -0400
Message-Id: <20200424122355.10453-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122355.10453-1-sashal@kernel.org>
References: <20200424122355.10453-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index dafa7e4aaecb9..8876eaad10f68 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -665,7 +665,7 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
  * block has been written back to disk.  (Yes, these values are
  * somewhat arbitrary...)
  */
-#define RECENTCY_MIN	5
+#define RECENTCY_MIN	60
 #define RECENTCY_DIRTY	300
 
 static int recently_deleted(struct super_block *sb, ext4_group_t group, int ino)
-- 
2.20.1

