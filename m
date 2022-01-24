Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4728649A58F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370995AbiAYAGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2360320AbiAXXga (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:36:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0E5C0604F1;
        Mon, 24 Jan 2022 13:37:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ACFCB812A7;
        Mon, 24 Jan 2022 21:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622A7C340E7;
        Mon, 24 Jan 2022 21:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060247;
        bh=J08//W2RZ6z3pUMPIZc0DxIQ0L/ndbEORfINNcq+txY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uur736XDGFjDSWG5RIhR5334nuT1ECAIctsUb8wRnPLh3UKwnxr6BHBN9uhKHVpa2
         WyXUlgGVFgVAoBPnBHnSFxD46uQ7EApuo3/xuW36bAZ2S8NIm2huPKkWwm9kyzudbU
         uzfzhNR2TKZRufD28jiwt5MipUgbf5Bxy9jdLkfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 0886/1039] btrfs: zoned: unset dedicated block group on allocation failure
Date:   Mon, 24 Jan 2022 19:44:35 +0100
Message-Id: <20220124184155.069409458@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 1ada69f61c88abb75a1038ee457633325658a183 upstream.

Allocating an extent from a block group can fail for various reasons.
When an allocation from a dedicated block group (for tree-log or
relocation data) fails, we need to unregister it as a dedicated one so
that we can allocate a new block group for the dedicated one.

However, we are returning early when the block group in case it is
read-only, fully used, or not be able to activate the zone. As a result,
we keep the non-usable block group as a dedicated one, leading to
further allocation failure. With many block groups, the allocator will
iterate hopeless loop to find a free extent, results in a hung task.

Fix the issue by delaying the return and doing the proper cleanups.

CC: stable@vger.kernel.org # 5.16
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3790,23 +3790,35 @@ static int do_allocation_zoned(struct bt
 	spin_unlock(&fs_info->relocation_bg_lock);
 	if (skip)
 		return 1;
+
 	/* Check RO and no space case before trying to activate it */
 	spin_lock(&block_group->lock);
 	if (block_group->ro ||
 	    block_group->alloc_offset == block_group->zone_capacity) {
-		spin_unlock(&block_group->lock);
-		return 1;
+		ret = 1;
+		/*
+		 * May need to clear fs_info->{treelog,data_reloc}_bg.
+		 * Return the error after taking the locks.
+		 */
 	}
 	spin_unlock(&block_group->lock);
 
-	if (!btrfs_zone_activate(block_group))
-		return 1;
+	if (!ret && !btrfs_zone_activate(block_group)) {
+		ret = 1;
+		/*
+		 * May need to clear fs_info->{treelog,data_reloc}_bg.
+		 * Return the error after taking the locks.
+		 */
+	}
 
 	spin_lock(&space_info->lock);
 	spin_lock(&block_group->lock);
 	spin_lock(&fs_info->treelog_bg_lock);
 	spin_lock(&fs_info->relocation_bg_lock);
 
+	if (ret)
+		goto out;
+
 	ASSERT(!ffe_ctl->for_treelog ||
 	       block_group->start == fs_info->treelog_bg ||
 	       fs_info->treelog_bg == 0);


