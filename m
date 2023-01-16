Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024BE66D09D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 22:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjAPVA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 16:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjAPVA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 16:00:58 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6507035A7;
        Mon, 16 Jan 2023 13:00:56 -0800 (PST)
Received: from fedcomp.intra.ispras.ru (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 2890F40D403D;
        Mon, 16 Jan 2023 21:00:52 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 2890F40D403D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1673902852;
        bh=aPV6pXyHE8sCh3Ryx3ARXM6RJp4EZ+mnoTRRwaCNjdo=;
        h=From:To:Cc:Subject:Date:From;
        b=FXCbw/QYuC8QnIz1VNr3ed5sUSwXO+2jdNi2CUXmtNds4aa/CS3hT4oasox2nhI9z
         jElg7zq6MjptUH5BBY/pSMziVwEJFJWyttGtjKoqkIDocsvibya9FyGhuaIKitkC+k
         KDFGNPPA51SsCRpn0sViNH0BKo5iiste8F5iYMXw=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH 5.15] block: fix and cleanup bio_check_ro
Date:   Tue, 17 Jan 2023 00:00:40 +0300
Message-Id: <20230116210040.804629-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 57e95e4670d1126c103305bcf34a9442f49f6d6a upstream.

Don't use a WARN_ON when printing a potentially user triggered
condition. Also don't print the partno when the block device name
already includes it, and use the %pg specifier to simplify printing
the block device name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20220304180105.409765-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 block/blk-core.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 13e1fca1e923..ed6271dcc1b1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -698,14 +698,10 @@ static inline bool should_fail_request(struct block_device *part,
 static inline bool bio_check_ro(struct bio *bio)
 {
 	if (op_is_write(bio_op(bio)) && bdev_read_only(bio->bi_bdev)) {
-		char b[BDEVNAME_SIZE];
-
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
 			return false;
-
-		WARN_ONCE(1,
-		       "Trying to write to read-only block-device %s (partno %d)\n",
-			bio_devname(bio, b), bio->bi_bdev->bd_partno);
+		pr_warn("Trying to write to read-only block-device %pg\n",
+			bio->bi_bdev);
 		/* Older lvm-tools actually trigger this */
 		return false;
 	}
-- 
2.34.1

