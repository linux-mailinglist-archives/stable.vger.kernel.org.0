Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DAF69771F
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 08:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbjBOHHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 02:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbjBOHG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 02:06:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7B43525E;
        Tue, 14 Feb 2023 23:06:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83AB861A6A;
        Wed, 15 Feb 2023 07:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF68BC433D2;
        Wed, 15 Feb 2023 07:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676444782;
        bh=ius7o69/YiCg0p/ta5M1yrgwHh91Pn97V+bDp9qvGXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ce7+QWNqncV84N3TnRLgl7lBWIlrftRzO3fL6GaVhMeg0VRZbXRSwR+OKrpmKOt+d
         F1WNpAgto5X5pvFhQQBgcMneL7MvgNc58sWdmN/z7jsNK/3YVprU6KJqhe3mmSr1Bp
         GW80hhEMn9dJf3mL7iD5fZNlD/4P44zEtpnqKTizKmPUyyjVdioij/MmhEhVTAPCdn
         duKLYsG6JkQmGSBZUOga73kl/osAO38mhUqQ4S3YYiUNx5tYh0i+bUmf/DpSBsw9tk
         t1XIeXjHhlcuDoFdyI7AZ6+HwmMjalV33y4rjpuJIueC98Q7DgKbXxQwSueq/8fZNc
         8Ar+QZgkqIeIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 02/93] btrfs: limit device extents to the device size
Date:   Wed, 15 Feb 2023 02:04:49 -0500
Message-Id: <20230215070620.2718851-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215070620.2718851-1-sashal@kernel.org>
References: <20230215070620.2718851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 3c538de0f2a74d50aff7278c092f88ae59cee688 upstream.

There was a recent regression in btrfs/177 that started happening with
the size class patches ("btrfs: introduce size class to block group
allocator").  This however isn't a regression introduced by those
patches, but rather the bug was uncovered by a change in behavior in
these patches.  The patches triggered more chunk allocations in the
^free-space-tree case, which uncovered a race with device shrink.

The problem is we will set the device total size to the new size, and
use this to find a hole for a device extent.  However during shrink we
may have device extents allocated past this range, so we could
potentially find a hole in a range past our new shrink size.  We don't
actually limit our found extent to the device size anywhere, we assume
that we will not find a hole past our device size.  This isn't true with
shrink as we're relocating block groups and thus creating holes past the
device size.

Fix this by making sure we do not search past the new device size, and
if we wander into any device extents that start after our device size
simply break from the loop and use whatever hole we've already found.

CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 65e4e887605f9..f66bf1a88edfc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1612,7 +1612,7 @@ static int find_free_dev_extent_start(struct btrfs_device *device,
 	if (ret < 0)
 		goto out;
 
-	while (1) {
+	while (search_start < search_end) {
 		l = path->nodes[0];
 		slot = path->slots[0];
 		if (slot >= btrfs_header_nritems(l)) {
@@ -1635,6 +1635,9 @@ static int find_free_dev_extent_start(struct btrfs_device *device,
 		if (key.type != BTRFS_DEV_EXTENT_KEY)
 			goto next;
 
+		if (key.offset > search_end)
+			break;
+
 		if (key.offset > search_start) {
 			hole_size = key.offset - search_start;
 			dev_extent_hole_check(device, &search_start, &hole_size,
@@ -1695,6 +1698,7 @@ static int find_free_dev_extent_start(struct btrfs_device *device,
 	else
 		ret = 0;
 
+	ASSERT(max_hole_start + max_hole_size <= search_end);
 out:
 	btrfs_free_path(path);
 	*start = max_hole_start;
-- 
2.39.0

