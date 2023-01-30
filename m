Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7D9681070
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbjA3ODf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbjA3ODY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:03:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CFB3B3C2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:03:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 99DF4CE16B6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4A5C433EF;
        Mon, 30 Jan 2023 14:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087391;
        bh=93GWhiji0lyZxjJI6UGQKdFH6KAyLaOvKtCojPxaUi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmmqWrpE0etEr6nVXtSdp1BITtQKkkec0NJHePgrg27p7/NMmvqfWvUd20EPH2WDr
         BjVcnRXljjuRzqRgLN8SGRzkg7owpi8TlJ9+MENGmWXcuM8kFxzKI9/KuhyAZx+xo8
         bj6rXVJUAMUqsNV88sBKzYUv2BpacHBOrhB7Os1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/313] btrfs: zoned: enable metadata over-commit for non-ZNS setup
Date:   Mon, 30 Jan 2023 14:50:27 +0100
Message-Id: <20230130134345.633143606@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 85e79ec7b78f863178ca488fd8cb5b3de6347756 ]

The commit 79417d040f4f ("btrfs: zoned: disable metadata overcommit for
zoned") disabled the metadata over-commit to track active zones properly.

However, it also introduced a heavy overhead by allocating new metadata
block groups and/or flushing dirty buffers to release the space
reservations. Specifically, a workload (write only without any sync
operations) worsen its performance from 343.77 MB/sec (v5.19) to 182.89
MB/sec (v6.0).

The performance is still bad on current misc-next which is 187.95 MB/sec.
And, with this patch applied, it improves back to 326.70 MB/sec (+73.82%).

This patch introduces a new fs_info->flag BTRFS_FS_NO_OVERCOMMIT to
indicate it needs to disable the metadata over-commit. The flag is enabled
when a device with max active zones limit is loaded into a file-system.

Fixes: 79417d040f4f ("btrfs: zoned: disable metadata overcommit for zoned")
CC: stable@vger.kernel.org # 6.0+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h      | 6 ++++++
 fs/btrfs/space-info.c | 3 ++-
 fs/btrfs/zoned.c      | 2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9e6d48ff4597..a3febabacec0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -590,6 +590,12 @@ enum {
 	/* Indicate we have to finish a zone to do next allocation. */
 	BTRFS_FS_NEED_ZONE_FINISH,
 
+	/*
+	 * Indicate metadata over-commit is disabled. This is set when active
+	 * zone tracking is needed.
+	 */
+	BTRFS_FS_NO_OVERCOMMIT,
+
 #if BITS_PER_LONG == 32
 	/* Indicate if we have error/warn message printed on 32bit systems */
 	BTRFS_FS_32BIT_ERROR,
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index f171bf875633..65c010159fb5 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -404,7 +404,8 @@ int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
 		return 0;
 
 	used = btrfs_space_info_used(space_info, true);
-	if (btrfs_is_zoned(fs_info) && (space_info->flags & BTRFS_BLOCK_GROUP_METADATA))
+	if (test_bit(BTRFS_FS_NO_OVERCOMMIT, &fs_info->flags) &&
+	    (space_info->flags & BTRFS_BLOCK_GROUP_METADATA))
 		avail = 0;
 	else
 		avail = calc_available_free_space(fs_info, space_info, flush);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index c9e2b0c85309..056f002263db 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -538,6 +538,8 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		}
 		atomic_set(&zone_info->active_zones_left,
 			   max_active_zones - nactive);
+		/* Overcommit does not work well with active zone tacking. */
+		set_bit(BTRFS_FS_NO_OVERCOMMIT, &fs_info->flags);
 	}
 
 	/* Validate superblock log */
-- 
2.39.0



