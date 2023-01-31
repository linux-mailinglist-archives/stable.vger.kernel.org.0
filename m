Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB142682DD2
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 14:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjAaN0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 08:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbjAaN0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 08:26:14 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3AD4FC33;
        Tue, 31 Jan 2023 05:25:51 -0800 (PST)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.11])
        by mail.ispras.ru (Postfix) with ESMTPSA id D00C240D403D;
        Tue, 31 Jan 2023 13:25:45 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru D00C240D403D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1675171545;
        bh=/8MGER4H7YRMsY2CKllGrZ4gQgnYn/yZ1tjAboskZ58=;
        h=From:To:Cc:Subject:Date:From;
        b=H1aR72f3LtaVZ5MTM1pQ9G4UbFxCk2SXpaF8PND6Y7YPCqIYdI41Kv/vOLd5Ab9w8
         Z7Ulbi+2mp8wMpOxzM1uPMPx3thB3t6h7sRYgFKsP9oLtTYccBGr4Cz5D20K2jd2Z6
         kJCp7e2Nxb3HfaIOKG5S1WJzYXA67GD4Mfxe+x64=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH v2 5.10] block: fix and cleanup bio_check_ro
Date:   Tue, 31 Jan 2023 16:25:38 +0300
Message-Id: <20230131132538.860037-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.30.2
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
condition.  Also don't print the partno when the block device name
already includes it, and use the %pg specifier to simplify printing
the block device name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20220304180105.409765-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[the formatted string layout is not changed because struct bio hasn't
got bi_bdev field in stable branches older than 5.15]
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
v1->v2: added backport comment

 block/blk-core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 26664f2a139e..9afb79b322fb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -700,9 +700,7 @@ static inline bool bio_check_ro(struct bio *bio, struct hd_struct *part)
 
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
 			return false;
-
-		WARN_ONCE(1,
-		       "Trying to write to read-only block-device %s (partno %d)\n",
+		pr_warn("Trying to write to read-only block-device %s (partno %d)\n",
 			bio_devname(bio, b), part->partno);
 		/* Older lvm-tools actually trigger this */
 		return false;
-- 
2.30.2

