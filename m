Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7715A47DD
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiH2LCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiH2LB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:01:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4176F1C915;
        Mon, 29 Aug 2022 04:01:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F34AAB80EC8;
        Mon, 29 Aug 2022 11:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044E3C433B5;
        Mon, 29 Aug 2022 11:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770913;
        bh=zsP5m/HM7B3yPTjrS0qFApOqZLNggpW8XOAOb0CmZP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXZbAoe7g7GTPT+2qSKGTODGB+wTjnS6OpdIqAhPtLZHJ7yBKdmnEdbABWIlXBZ6d
         imdjRdCpLnXZI5sS0ibcrsGOD1BN6eywj4+BhV2nKTkBqGY6AbylTpNPUaEOLpiPNM
         SeJZZyuyOCloHDujzzPk5j7SUfX1I+z9MbVnS0oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/136] btrfs: put initial index value of a directory in a constant
Date:   Mon, 29 Aug 2022 12:58:08 +0200
Message-Id: <20220829105805.464243592@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 528ee697126fddaff448897c2d649bd756153c79 ]

At btrfs_set_inode_index_count() we refer twice to the number 2 as the
initial index value for a directory (when it's empty), with a proper
comment explaining the reason for that value. In the next patch I'll
have to use that magic value in the directory logging code, so put
the value in a #define at btrfs_inode.h, to avoid hardcoding the
magic value again at tree-log.c.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/btrfs_inode.h | 12 ++++++++++--
 fs/btrfs/inode.c       | 10 ++--------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 76ee1452c57ba..37ceea85b871c 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -13,6 +13,13 @@
 #include "ordered-data.h"
 #include "delayed-inode.h"
 
+/*
+ * Since we search a directory based on f_pos (struct dir_context::pos) we have
+ * to start at 2 since '.' and '..' have f_pos of 0 and 1 respectively, so
+ * everybody else has to start at 2 (see btrfs_real_readdir() and dir_emit_dots()).
+ */
+#define BTRFS_DIR_START_INDEX 2
+
 /*
  * ordered_data_close is set by truncate when a file that used
  * to have good data has been truncated to zero.  When it is set
@@ -164,8 +171,9 @@ struct btrfs_inode {
 	u64 disk_i_size;
 
 	/*
-	 * if this is a directory then index_cnt is the counter for the index
-	 * number for new files that are created
+	 * If this is a directory then index_cnt is the counter for the index
+	 * number for new files that are created. For an empty directory, this
+	 * must be initialized to BTRFS_DIR_START_INDEX.
 	 */
 	u64 index_cnt;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ac6ba984973c0..26a4acb856a38 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6396,14 +6396,8 @@ static int btrfs_set_inode_index_count(struct btrfs_inode *inode)
 		goto out;
 	ret = 0;
 
-	/*
-	 * MAGIC NUMBER EXPLANATION:
-	 * since we search a directory based on f_pos we have to start at 2
-	 * since '.' and '..' have f_pos of 0 and 1 respectively, so everybody
-	 * else has to start at 2
-	 */
 	if (path->slots[0] == 0) {
-		inode->index_cnt = 2;
+		inode->index_cnt = BTRFS_DIR_START_INDEX;
 		goto out;
 	}
 
@@ -6414,7 +6408,7 @@ static int btrfs_set_inode_index_count(struct btrfs_inode *inode)
 
 	if (found_key.objectid != btrfs_ino(inode) ||
 	    found_key.type != BTRFS_DIR_INDEX_KEY) {
-		inode->index_cnt = 2;
+		inode->index_cnt = BTRFS_DIR_START_INDEX;
 		goto out;
 	}
 
-- 
2.35.1



