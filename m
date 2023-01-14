Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9218F66AE47
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 23:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjANW13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 17:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjANW10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 17:27:26 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043259EFE;
        Sat, 14 Jan 2023 14:27:25 -0800 (PST)
Received: from fedcomp.intra.ispras.ru (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 4643740737B2;
        Sat, 14 Jan 2023 22:27:23 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 4643740737B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1673735243;
        bh=MVG9UIHgr7Ddx6rqmvo9/b6OwiqdYnOMCtD9ezoSTZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ri7ZgccehZLIphbbIpraaPu3cHWgT64hVlpWxfK1dNSdDuX12IHInQl7eDBz9/n93
         z50zaES8k/c5WxTV/xdjIWnZcIwNZKoOkd1LnmN6UKAH8jVLMkzBzSCE21jiUvcnX+
         mQESoYirS423bSVfLM2olWpbZKwkrIAVfXWAmdH4=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH 5.10 1/1] block: fix and cleanup bio_check_ro
Date:   Sun, 15 Jan 2023 01:27:09 +0300
Message-Id: <20230114222709.180795-2-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230114222709.180795-1-pchelkin@ispras.ru>
References: <20230114222709.180795-1-pchelkin@ispras.ru>
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

Don't use a WARN_ONCE when printing a potentially user triggered
condition.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20220304180105.409765-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 block/blk-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 26664f2a139e..921d436fa3c6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -701,8 +701,7 @@ static inline bool bio_check_ro(struct bio *bio, struct hd_struct *part)
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
 			return false;
 
-		WARN_ONCE(1,
-		       "Trying to write to read-only block-device %s (partno %d)\n",
+		pr_warn("Trying to write to read-only block-device %s (partno %d)\n",
 			bio_devname(bio, b), part->partno);
 		/* Older lvm-tools actually trigger this */
 		return false;
-- 
2.34.1

