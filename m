Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBF85BFEEF
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 15:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiIUN1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 09:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIUN1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 09:27:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF5582766
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 06:27:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCFCBB810AA
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 13:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C778C433C1;
        Wed, 21 Sep 2022 13:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663766869;
        bh=QfGPWgmfg/Vj9s0KpoKCmJaybyqRppXNaNxQOmOF6KY=;
        h=Subject:To:From:Date:From;
        b=P9lha0rhM9T1roQv3RrEwmVg14CBK+cBo3kZcbpUqUvEjtmPbLIB7ENrW9uYVBl3U
         bSTWUOVs0J62Xzj0gpdE9GmjGJy/xpVfoXEc6pq875jUvi//1CE27ucL1ttdaiJY+i
         ZeqMVCES2S9lRVUldL5gzwuFVNJzP3tejb6QASzU=
Subject: patch "fpga: m10bmc-sec: Fix possible memory leak of flash_buf" added to char-misc-linus
To:     russell.h.weight@intel.com, dan.carpenter@oracle.com,
        lkp@intel.com, stable@vger.kernel.org, trix@redhat.com,
        yilun.xu@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Sep 2022 15:27:46 +0200
Message-ID: <166376686612587@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    fpga: m10bmc-sec: Fix possible memory leak of flash_buf

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 468c9d928a8f38fdfaa61b05e81473cc7c8a6461 Mon Sep 17 00:00:00 2001
From: Russ Weight <russell.h.weight@intel.com>
Date: Fri, 16 Sep 2022 16:52:05 -0700
Subject: fpga: m10bmc-sec: Fix possible memory leak of flash_buf

There is an error check following the allocation of flash_buf that returns
without freeing flash_buf. It makes more sense to do the error check
before the allocation and the reordering eliminates the memory leak.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 154afa5c31cd ("fpga: m10bmc-sec: expose max10 flash update count")
Signed-off-by: Russ Weight <russell.h.weight@intel.com>
Reviewed-by: Tom Rix <trix@redhat.com>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220916235205.106873-1-russell.h.weight@intel.com
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
---
 drivers/fpga/intel-m10-bmc-sec-update.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/fpga/intel-m10-bmc-sec-update.c b/drivers/fpga/intel-m10-bmc-sec-update.c
index 72c677c910de..133e511355c9 100644
--- a/drivers/fpga/intel-m10-bmc-sec-update.c
+++ b/drivers/fpga/intel-m10-bmc-sec-update.c
@@ -148,10 +148,6 @@ static ssize_t flash_count_show(struct device *dev,
 	stride = regmap_get_reg_stride(sec->m10bmc->regmap);
 	num_bits = FLASH_COUNT_SIZE * 8;
 
-	flash_buf = kmalloc(FLASH_COUNT_SIZE, GFP_KERNEL);
-	if (!flash_buf)
-		return -ENOMEM;
-
 	if (FLASH_COUNT_SIZE % stride) {
 		dev_err(sec->dev,
 			"FLASH_COUNT_SIZE (0x%x) not aligned to stride (0x%x)\n",
@@ -160,6 +156,10 @@ static ssize_t flash_count_show(struct device *dev,
 		return -EINVAL;
 	}
 
+	flash_buf = kmalloc(FLASH_COUNT_SIZE, GFP_KERNEL);
+	if (!flash_buf)
+		return -ENOMEM;
+
 	ret = regmap_bulk_read(sec->m10bmc->regmap, STAGING_FLASH_COUNT,
 			       flash_buf, FLASH_COUNT_SIZE / stride);
 	if (ret) {
-- 
2.37.3


