Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED02C593818
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240703AbiHOSmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242019AbiHOSkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBCA2E6AE;
        Mon, 15 Aug 2022 11:24:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EC0560FA3;
        Mon, 15 Aug 2022 18:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B90EC433D6;
        Mon, 15 Aug 2022 18:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587853;
        bh=fMnFgYb+bYaDSGvOdBhrx5oW0FvbsyErxXYJwlmU99o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PlTSO8p3LRwkLmHdXmtMmEMmRvmSqkEhTOVXlRAFjVivP6Tsc9lCyc39JhuQ96BDF
         TJf0mml10ydhCXgGCkWDdpbkJTJGTR4vZn2gtXMR5XHs6L9FDwh+87SRgT6y44WrXq
         DFe+K/m2eItCKUwAWTipzdAS5DRnrINARzhF/Zrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai1@huaweicloud.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 215/779] dm writecache: count number of blocks read, not number of read bios
Date:   Mon, 15 Aug 2022 19:57:39 +0200
Message-Id: <20220815180346.465007955@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 2c6e755b49d273243431f5f1184654e71221fc78 ]

Change dm-writecache, so that it counts the number of blocks read
instead of the number of read bios. Bios can be split and requeued
using the dm_accept_partial_bio function, so counting bios caused
inaccurate results.

Fixes: e3a35d03407c ("dm writecache: add event counters")
Reported-by: Yu Kuai <yukuai1@huaweicloud.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/device-mapper/writecache.rst | 4 ++--
 drivers/md/dm-writecache.c                             | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/writecache.rst b/Documentation/admin-guide/device-mapper/writecache.rst
index 10429779a91a..7bead3b52690 100644
--- a/Documentation/admin-guide/device-mapper/writecache.rst
+++ b/Documentation/admin-guide/device-mapper/writecache.rst
@@ -78,8 +78,8 @@ Status:
 2. the number of blocks
 3. the number of free blocks
 4. the number of blocks under writeback
-5. the number of read requests
-6. the number of read requests that hit the cache
+5. the number of read blocks
+6. the number of read blocks that hit the cache
 7. the number of write requests
 8. the number of write requests that hit uncommitted block
 9. the number of write requests that hit committed block
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index e3d0a9bb27b5..9d6b7b706a65 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1364,6 +1364,7 @@ static enum wc_map_op writecache_map_read(struct dm_writecache *wc, struct bio *
 		}
 	} else {
 		writecache_map_remap_origin(wc, bio, e);
+		wc->stats.reads += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
 		map_op = WC_MAP_REMAP_ORIGIN;
 	}
 
-- 
2.35.1



