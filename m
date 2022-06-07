Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5AB541797
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378304AbiFGVDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379387AbiFGVCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:02:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B3F1D0C3;
        Tue,  7 Jun 2022 11:47:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD4086157E;
        Tue,  7 Jun 2022 18:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11C1C385A5;
        Tue,  7 Jun 2022 18:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627677;
        bh=EInUvTyG0QKxuaOKiE7JO3QEO7XmepPOp9648sfZpiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qcq1uQJV2Jfw8v0+StfnXC7Ym3D4tJHkjvia5VchRWjCqQYWT87ZMx8txtaoxJZG3
         pTB1rdQpnGZTg2cS61Zt9vY629+qfiCZuHJWop3kUgT6ODrhrD8+6Nd+MpzPc6yp//
         Vif8/mMUpgCfF4HmFGTIxStO9ctrff9n0IOuiFAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.18 052/879] btrfs: zoned: finish block group when there are no more allocatable bytes left
Date:   Tue,  7 Jun 2022 18:52:50 +0200
Message-Id: <20220607165004.197224164@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 8b8a53998caefebfe5c8da7a74c2b601caf5dd48 upstream.

Currently, btrfs_zone_finish_endio() finishes a block group only when the
written region reaches the end of the block group. We can also finish the
block group when no more allocation is possible.

Fixes: be1a1d7a5d24 ("btrfs: zoned: finish fully written block group")
CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2000,6 +2000,7 @@ void btrfs_zone_finish_endio(struct btrf
 	struct btrfs_block_group *block_group;
 	struct map_lookup *map;
 	struct btrfs_device *device;
+	u64 min_alloc_bytes;
 	u64 physical;
 
 	if (!btrfs_is_zoned(fs_info))
@@ -2008,7 +2009,15 @@ void btrfs_zone_finish_endio(struct btrf
 	block_group = btrfs_lookup_block_group(fs_info, logical);
 	ASSERT(block_group);
 
-	if (logical + length < block_group->start + block_group->zone_capacity)
+	/* No MIXED_BG on zoned btrfs. */
+	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
+		min_alloc_bytes = fs_info->sectorsize;
+	else
+		min_alloc_bytes = fs_info->nodesize;
+
+	/* Bail out if we can allocate more data from this block group. */
+	if (logical + length + min_alloc_bytes <=
+	    block_group->start + block_group->zone_capacity)
 		goto out;
 
 	spin_lock(&block_group->lock);


