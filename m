Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1CBB681284
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237722AbjA3OV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237551AbjA3OVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:21:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9BD4109C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:20:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66F57B810C5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE917C433D2;
        Mon, 30 Jan 2023 14:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088392;
        bh=jOdHo7kOZUtalN5Jmsp4r2t0CBI+ZP472DCZl884ERo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYh41DnA4mCxthzF/LjToEUOpVkMX4pDFYJJhfafE/NTGZ6xSZ2tzzBZborJFDGVw
         tbZj1d39nkiefrrUelHR5bfP+PN8y9TZOZDsdvSydPL3B9EUTlkQRcfyziCjO2dhY3
         upG0FtxYg6BDBMQAY42/1J7Y6yPTXQOvdf1S1GAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.15 201/204] block: fix and cleanup bio_check_ro
Date:   Mon, 30 Jan 2023 14:52:46 +0100
Message-Id: <20230130134325.384604024@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -698,14 +698,10 @@ static inline bool should_fail_request(s
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


