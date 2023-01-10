Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A22664ACF
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239402AbjAJSgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239256AbjAJSet (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:34:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C45F9B282
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62857CE18E4
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CEEC433D2;
        Tue, 10 Jan 2023 18:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375408;
        bh=A6zpt9CN7L4K+ht6X3RAssYIHTZ4R8k4Df6o2n6Ilfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1WIsivuThsHxu4C1RUOMzskX//L57EbKC+eg7I7/i0DLXbKtoqZPAkGOscF8sQFJr
         e6m//ivWY3xfUfQ0i1SZdh/APV8IOUSGaA+AhwxPkjMwf0m+uri+F/yQCEB//bwCmv
         6Hv2sIE5qsTtj7qQQRjxx393nNdnYFKBucyHC3jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Su Yue <l@damenly.su>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/290] btrfs: move missing device handling in a dedicate function
Date:   Tue, 10 Jan 2023 19:04:32 +0100
Message-Id: <20230110180038.147020765@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit ff37c89f94be14b0e22a532d1e6d57187bfd5bb8 ]

This simplifies the code flow in read_one_chunk and makes error handling
when handling missing devices a bit simpler by reducing it to a single
check if something went wrong. No functional changes.

Reviewed-by: Su Yue <l@damenly.su>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 1742e1c90c3d ("btrfs: fix extent map use-after-free when handling missing device in read_one_chunk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c886ec81c5d0..c773ecba7c2d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7043,6 +7043,27 @@ static void warn_32bit_meta_chunk(struct btrfs_fs_info *fs_info,
 }
 #endif
 
+static struct btrfs_device *handle_missing_device(struct btrfs_fs_info *fs_info,
+						  u64 devid, u8 *uuid)
+{
+	struct btrfs_device *dev;
+
+	if (!btrfs_test_opt(fs_info, DEGRADED)) {
+		btrfs_report_missing_device(fs_info, devid, uuid, true);
+		return ERR_PTR(-ENOENT);
+	}
+
+	dev = add_missing_dev(fs_info->fs_devices, devid, uuid);
+	if (IS_ERR(dev)) {
+		btrfs_err(fs_info, "failed to init missing device %llu: %ld",
+			  devid, PTR_ERR(dev));
+		return dev;
+	}
+	btrfs_report_missing_device(fs_info, devid, uuid, false);
+
+	return dev;
+}
+
 static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 			  struct btrfs_chunk *chunk)
 {
@@ -7130,28 +7151,17 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 				   BTRFS_UUID_SIZE);
 		args.uuid = uuid;
 		map->stripes[i].dev = btrfs_find_device(fs_info->fs_devices, &args);
-		if (!map->stripes[i].dev &&
-		    !btrfs_test_opt(fs_info, DEGRADED)) {
-			free_extent_map(em);
-			btrfs_report_missing_device(fs_info, devid, uuid, true);
-			return -ENOENT;
-		}
 		if (!map->stripes[i].dev) {
-			map->stripes[i].dev =
-				add_missing_dev(fs_info->fs_devices, devid,
-						uuid);
+			map->stripes[i].dev = handle_missing_device(fs_info,
+								    devid, uuid);
 			if (IS_ERR(map->stripes[i].dev)) {
 				free_extent_map(em);
-				btrfs_err(fs_info,
-					"failed to init missing dev %llu: %ld",
-					devid, PTR_ERR(map->stripes[i].dev));
 				return PTR_ERR(map->stripes[i].dev);
 			}
-			btrfs_report_missing_device(fs_info, devid, uuid, false);
 		}
+
 		set_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
 				&(map->stripes[i].dev->dev_state));
-
 	}
 
 	write_lock(&map_tree->lock);
-- 
2.35.1



