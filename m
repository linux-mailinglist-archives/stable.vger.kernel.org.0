Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAB24F31F9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356187AbiDEKXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbiDEJah (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:30:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80150E41F8;
        Tue,  5 Apr 2022 02:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3E6D615E4;
        Tue,  5 Apr 2022 09:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60BEC385A0;
        Tue,  5 Apr 2022 09:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150251;
        bh=lAtKoaS9HUgr0Lm7QE70qsSO+vReFYiIsn0xRlig5Ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUQK+g6nxsc1PlUZIKu5d64SXG7zgCdH62akODO6q+LULZsvOXtP1GbLsG4UsmNgd
         IwmFymvBBcsi0BNGSFQ+lmXzZI/Yt5OmFe0MYiLkVgyAwVP78IJHEpNtYN16zRBbVo
         eEcdyZZRPBkfQEtSnesSN4LYNQhizOz+MUhdlH70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, k2ci <kernel-bot@kylinos.cn>,
        Jackie Liu <liuyun01@kylinos.cn>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 1009/1017] n64cart: convert bi_disk to bi_bdev->bd_disk fix build
Date:   Tue,  5 Apr 2022 09:32:02 +0200
Message-Id: <20220405070424.149130175@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
@@ -88,7 +88,7 @@ static void n64cart_submit_bio(struct bi
 {
 	struct bio_vec bvec;
 	struct bvec_iter iter;
-	struct device *dev = bio->bi_disk->private_data;
+	struct device *dev = bio->bi_bdev->bd_disk->private_data;
 	u32 pos = bio->bi_iter.bi_sector << SECTOR_SHIFT;
 
 	bio_for_each_segment(bvec, bio, iter) {


