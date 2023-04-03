Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB706D4929
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233626AbjDCOfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbjDCOfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:35:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5820D16F19
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:35:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EED5DB81C99
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5164DC433D2;
        Mon,  3 Apr 2023 14:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532515;
        bh=yRgIFKuJ04v02ElTFYmhoub7Af/FQQrOiHDnSxjunq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQeMgc+/4BRLsn6v5OdbC/XfVHRtaryActRn7ivGeDHOMUdMxXhW5krXo7B+hMTfq
         YGb5Vv93N2fsS5g8T9zfo8iJX56yIsYx9GrYcsE0gcoXTLrcuqn6g/x8JeniuLyeDR
         at0TgCpeLvB6EMDa2fZZfFCUoyeEjIAdMYp/DKV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/181] btrfs: rename BTRFS_FS_NO_OVERCOMMIT to BTRFS_FS_ACTIVE_ZONE_TRACKING
Date:   Mon,  3 Apr 2023 16:07:28 +0200
Message-Id: <20230403140415.542808396@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit bf1f1fec2724a33b67ec12032402ea75f2a83622 ]

This flag only gets set when we're doing active zone tracking, and we're
going to need to use this flag for things related to this behavior.
Rename the flag to represent what it actually means for the file system
so it can be used in other ways and still make sense.

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h      | 7 ++-----
 fs/btrfs/space-info.c | 2 +-
 fs/btrfs/zoned.c      | 3 +--
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a3febabacec04..3bcef0c4d6fc4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -590,11 +590,8 @@ enum {
 	/* Indicate we have to finish a zone to do next allocation. */
 	BTRFS_FS_NEED_ZONE_FINISH,
 
-	/*
-	 * Indicate metadata over-commit is disabled. This is set when active
-	 * zone tracking is needed.
-	 */
-	BTRFS_FS_NO_OVERCOMMIT,
+	/* This is set when active zone tracking is needed. */
+	BTRFS_FS_ACTIVE_ZONE_TRACKING,
 
 #if BITS_PER_LONG == 32
 	/* Indicate if we have error/warn message printed on 32bit systems */
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 65c010159fb5f..c7642c00a65d0 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -404,7 +404,7 @@ int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
 		return 0;
 
 	used = btrfs_space_info_used(space_info, true);
-	if (test_bit(BTRFS_FS_NO_OVERCOMMIT, &fs_info->flags) &&
+	if (test_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags) &&
 	    (space_info->flags & BTRFS_BLOCK_GROUP_METADATA))
 		avail = 0;
 	else
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 1b72004136ef8..0d88cc46ac5db 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -538,8 +538,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		}
 		atomic_set(&zone_info->active_zones_left,
 			   max_active_zones - nactive);
-		/* Overcommit does not work well with active zone tacking. */
-		set_bit(BTRFS_FS_NO_OVERCOMMIT, &fs_info->flags);
+		set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
 	}
 
 	/* Validate superblock log */
-- 
2.39.2



