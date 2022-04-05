Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26AC44F3A4D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379145AbiDELk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354389AbiDEKOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C82278FFE;
        Tue,  5 Apr 2022 02:59:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DB09616E7;
        Tue,  5 Apr 2022 09:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E4EC385A1;
        Tue,  5 Apr 2022 09:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152786;
        bh=0PIyyKmOrWUB83FqO0O88Etrn0R80ubZkYe33g16qUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+K9qyVe+FvEtSiXHY+rlP0hLIwCieYCoAv12iZG0Fpa8MebPQPjtODZLnhrFNgo0
         U11XrDURPW4xilfkmmr1MWJwkIwZ1d/SJZqkS/kOMO+xmmo44AkQEP/TYFkCPuLhIK
         5ZOPVhXPDf7cRSxmqt2yA2ATCYQiLzVNuKEoGAmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, k2ci <kernel-bot@kylinos.cn>,
        Jackie Liu <liuyun01@kylinos.cn>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 901/913] n64cart: convert bi_disk to bi_bdev->bd_disk fix build
Date:   Tue,  5 Apr 2022 09:32:43 +0200
Message-Id: <20220405070406.826756849@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jackie Liu <liuyun01@kylinos.cn>

commit b2479de38d8fc7ef13d5c78ff5ded6e5a1a4eac0 upstream.

My kernel robot report below:

  drivers/block/n64cart.c: In function ‘n64cart_submit_bio’:
  drivers/block/n64cart.c:91:26: error: ‘struct bio’ has no member named ‘bi_disk’
     91 |  struct device *dev = bio->bi_disk->private_data;
        |                          ^~
    CC      drivers/slimbus/qcom-ctrl.o
    CC      drivers/auxdisplay/hd44780.o
    CC      drivers/watchdog/watchdog_core.o
    CC      drivers/nvme/host/fault_inject.o
    AR      drivers/accessibility/braille/built-in.a
  make[2]: *** [scripts/Makefile.build:288: drivers/block/n64cart.o] Error 1

Fixes: 309dca309fc3 ("block: store a block_device pointer in struct bio");
Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20220321071216.1549596-1-liu.yun@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/n64cart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/n64cart.c
+++ b/drivers/block/n64cart.c
@@ -88,7 +88,7 @@ static blk_qc_t n64cart_submit_bio(struc
 {
 	struct bio_vec bvec;
 	struct bvec_iter iter;
-	struct device *dev = bio->bi_disk->private_data;
+	struct device *dev = bio->bi_bdev->bd_disk->private_data;
 	u32 pos = bio->bi_iter.bi_sector << SECTOR_SHIFT;
 
 	bio_for_each_segment(bvec, bio, iter) {


