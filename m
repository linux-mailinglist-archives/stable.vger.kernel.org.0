Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10D6593E88
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345819AbiHOUot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347788AbiHOUnM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:43:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D14BB5E53;
        Mon, 15 Aug 2022 12:08:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2276CCE10E7;
        Mon, 15 Aug 2022 19:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E905AC433D6;
        Mon, 15 Aug 2022 19:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590488;
        bh=KdT6OdPtJ0WC0bsnZs/Ssa740D193ke143bebXcN3r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHzSWUXhn3QvA/HoPmseQO0N0ZZxuM4iQNR955aIBjBly9eanxg8Qr49MzqDr2mGu
         phBaEumIfnzO3+GWvMs6c2VqVIDQbMYJtyiHXTh3zfnBXPJoLej9m7IvG9CFyjX4Jt
         0hofN3+Rfo9ru8z3WK5XxeXVqcpLnoCuLv7jZ2sY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai1@huaweicloud.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0276/1095] dm writecache: count number of blocks read, not number of read bios
Date:   Mon, 15 Aug 2022 19:54:35 +0200
Message-Id: <20220815180441.187748615@linuxfoundation.org>
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
index 688b6b3bcd7b..3bec493cccb2 100644
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



