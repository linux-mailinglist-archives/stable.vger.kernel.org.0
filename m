Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11BF594735
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbiHOX3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343985AbiHOX0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:26:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685947FE5C;
        Mon, 15 Aug 2022 13:06:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04AA86069E;
        Mon, 15 Aug 2022 20:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8C9C433D6;
        Mon, 15 Aug 2022 20:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593990;
        bh=OoFLweGMGU3hs6aXiOhf2CsOVzv7McoV0UwXcZHxGHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+sDy9HvSIhcil2q8gyBgRI7qul0gwlFoJ7Y5vS/yd3dFHSeaMcJLGuYybdKzCXhK
         6DYuTGFxhk+MsVVAela91Wr0CA8JTvUMI7yeTKS40gXpCN4bW1t/K1mlXsOEBNaIB0
         wso/UoUNt5gNeF8q315N+XHWKz98ZpKiCp1SSLT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1021/1095] btrfs: let can_allocate_chunk return error
Date:   Mon, 15 Aug 2022 20:07:00 +0200
Message-Id: <20220815180511.327770468@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit bb9950d3df7169a673c594d38fb74e241ed4fb2a ]

For the later patch, convert the return type from bool to int and return
errors. No functional changes.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f45ecd939a2c..8bdcbc0c6d60 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3985,12 +3985,12 @@ static void found_extent(struct find_free_extent_ctl *ffe_ctl,
 	}
 }
 
-static bool can_allocate_chunk(struct btrfs_fs_info *fs_info,
-			       struct find_free_extent_ctl *ffe_ctl)
+static int can_allocate_chunk(struct btrfs_fs_info *fs_info,
+			      struct find_free_extent_ctl *ffe_ctl)
 {
 	switch (ffe_ctl->policy) {
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
-		return true;
+		return 0;
 	case BTRFS_EXTENT_ALLOC_ZONED:
 		/*
 		 * If we have enough free space left in an already
@@ -4000,8 +4000,8 @@ static bool can_allocate_chunk(struct btrfs_fs_info *fs_info,
 		 */
 		if (ffe_ctl->max_extent_size >= ffe_ctl->min_alloc_size &&
 		    !btrfs_can_activate_zone(fs_info->fs_devices, ffe_ctl->flags))
-			return false;
-		return true;
+			return -ENOSPC;
+		return 0;
 	default:
 		BUG();
 	}
@@ -4083,8 +4083,9 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
 			int exist = 0;
 
 			/*Check if allocation policy allows to create a new chunk */
-			if (!can_allocate_chunk(fs_info, ffe_ctl))
-				return -ENOSPC;
+			ret = can_allocate_chunk(fs_info, ffe_ctl);
+			if (ret)
+				return ret;
 
 			trans = current->journal_info;
 			if (trans)
-- 
2.35.1



