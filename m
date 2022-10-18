Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3A5602DE6
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 16:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiJROGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 10:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiJROGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 10:06:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7404AD38D9;
        Tue, 18 Oct 2022 07:06:30 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5995333985;
        Tue, 18 Oct 2022 14:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666101964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=XTUoLbaIxNZRTNB0cLoZ8ZhWB6ge7EAJaS+BezrKBR0=;
        b=TZVwT+QG/fICiilrITbzriZizOtWvwEB7GLVQJgGa9eVbWUj47mSNAmch5waij2ebSTe0L
        QkGesECY2Jegd+hdWj0sC4Gze9PtBpjPFUE3E4S9LDduuJAokqyI/3ioRUw+T+CxdPvpfe
        ljli4lQmVLU8eYNV0XB8OUt2L17xJlc=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 4B6632C141;
        Tue, 18 Oct 2022 14:06:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C90F3DA79B; Tue, 18 Oct 2022 16:05:55 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: fix type of parameter generation in btrfs_get_dentry
Date:   Tue, 18 Oct 2022 16:05:52 +0200
Message-Id: <20221018140552.3768-1-dsterba@suse.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The type of parameter generation has been u32 since the beginning,
however all callers pass a u64 generation, so unify the types to prevent
potential loss.

CC: stable@vger.kernel.org # 4.9+
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/export.c | 2 +-
 fs/btrfs/export.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 1d4c2397d0d6..fab7eb76e53b 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -58,7 +58,7 @@ static int btrfs_encode_fh(struct inode *inode, u32 *fh, int *max_len,
 }
 
 struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
-				u64 root_objectid, u32 generation,
+				u64 root_objectid, u64 generation,
 				int check_generation)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
diff --git a/fs/btrfs/export.h b/fs/btrfs/export.h
index f32f4113c976..5afb7ca42828 100644
--- a/fs/btrfs/export.h
+++ b/fs/btrfs/export.h
@@ -19,7 +19,7 @@ struct btrfs_fid {
 } __attribute__ ((packed));
 
 struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
-				u64 root_objectid, u32 generation,
+				u64 root_objectid, u64 generation,
 				int check_generation);
 struct dentry *btrfs_get_parent(struct dentry *child);
 
-- 
2.37.3

