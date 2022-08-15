Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A64A59413D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344801AbiHOUqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344933AbiHOUpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:45:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C9BB5E7E;
        Mon, 15 Aug 2022 12:08:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB3BDB81106;
        Mon, 15 Aug 2022 19:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19853C433C1;
        Mon, 15 Aug 2022 19:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590494;
        bh=VgMoTdeM27KVRPXO4E7YPhY2Lw8hSEWmBEss6I8f9bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zkuzDjsflpkzmchny+a8FdG8ff9zXnCAQzepkIsmDl8w16QQPWiD+h5QdTK5h9cjB
         kByDvqVGOIGvRksUoFCbkcZJdZZL7kMAVd7UKlRihtb4cI7wEohig3ZLNH3y1RbBPP
         Z+MPBraf3h+HcKfHrVIBizPyFXR7tAk1CUAmc+YY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0278/1095] dm writecache: count number of blocks discarded, not number of discard bios
Date:   Mon, 15 Aug 2022 19:54:37 +0200
Message-Id: <20220815180441.281543770@linuxfoundation.org>
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

[ Upstream commit 2ee73ef60db4d79b9f9b8cd501e8188b5179449f ]

Change dm-writecache, so that it counts the number of blocks discarded
instead of the number of discard bios. Make it consistent with the
read and write statistics counters that were changed to count the
number of blocks instead of bios.

Fixes: e3a35d03407c ("dm writecache: add event counters")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/device-mapper/writecache.rst | 2 +-
 drivers/md/dm-writecache.c                             | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/writecache.rst b/Documentation/admin-guide/device-mapper/writecache.rst
index 6c9a2c74df8a..724e028d1858 100644
--- a/Documentation/admin-guide/device-mapper/writecache.rst
+++ b/Documentation/admin-guide/device-mapper/writecache.rst
@@ -87,7 +87,7 @@ Status:
 11. the number of write blocks that are allocated in the cache
 12. the number of write requests that are blocked on the freelist
 13. the number of flush requests
-14. the number of discard requests
+14. the number of discarded blocks
 
 Messages:
 	flush
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 98df6327990a..e5acb393f70b 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1513,7 +1513,7 @@ static enum wc_map_op writecache_map_flush(struct dm_writecache *wc, struct bio
 
 static enum wc_map_op writecache_map_discard(struct dm_writecache *wc, struct bio *bio)
 {
-	wc->stats.discards++;
+	wc->stats.discards += bio->bi_iter.bi_size >> wc->block_size_bits;
 
 	if (writecache_has_error(wc))
 		return WC_MAP_ERROR;
-- 
2.35.1



