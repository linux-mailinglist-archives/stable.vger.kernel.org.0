Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD185511E0
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 09:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239575AbiFTHvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 03:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239485AbiFTHvs (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 20 Jun 2022 03:51:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA8A101EA
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 00:51:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D64BB80EB4
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 07:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158D5C3411B;
        Mon, 20 Jun 2022 07:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655711505;
        bh=zWwNGS5Wfkt8YbevHWSUI1DDsbYrZm2sG0z/2TXI5Zk=;
        h=Subject:To:From:Date:From;
        b=LQDA5Wp+IiNXUe+MSxfFs0j0bgrqJCofjLqB1ezniqzTudIHhIHwkdsfqo2cCCb+T
         pJV943QySHNhSwq7OydHLMvGLyw9n2V6MJRxWTBV08UGTcrrUgk04Vtq/dm8IDX9jz
         m705MERY8/PnE2eU44lLUb1/5g3FTD8Momv0vc6Q=
Subject: patch "iio: imu: inv_icm42600: Fix broken icm42600 (chip id 0 value)" added to char-misc-linus
To:     jean-baptiste.maneyrol@tdk.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 09:50:49 +0200
Message-ID: <1655711449244155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: inv_icm42600: Fix broken icm42600 (chip id 0 value)

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 106b391e1b859100a3f38f0ad874236e9be06bde Mon Sep 17 00:00:00 2001
From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Date: Thu, 9 Jun 2022 12:23:01 +0200
Subject: iio: imu: inv_icm42600: Fix broken icm42600 (chip id 0 value)

The 0 value used for INV_CHIP_ICM42600 was not working since the
match in i2c/spi was checking against NULL value.

To keep this check, add a first INV_CHIP_INVALID 0 value as safe
guard.

Fixes: 31c24c1e93c3 ("iio: imu: inv_icm42600: add core of new inv_icm42600 driver")
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20220609102301.4794-1-jmaneyrol@invensense.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600.h      | 1 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600.h b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
index c0f5059b13b3..995a9dc06521 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600.h
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
@@ -17,6 +17,7 @@
 #include "inv_icm42600_buffer.h"
 
 enum inv_icm42600_chip {
+	INV_CHIP_INVALID,
 	INV_CHIP_ICM42600,
 	INV_CHIP_ICM42602,
 	INV_CHIP_ICM42605,
diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
index 86858da9cc38..ca85fccc9839 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -565,7 +565,7 @@ int inv_icm42600_core_probe(struct regmap *regmap, int chip, int irq,
 	bool open_drain;
 	int ret;
 
-	if (chip < 0 || chip >= INV_CHIP_NB) {
+	if (chip <= INV_CHIP_INVALID || chip >= INV_CHIP_NB) {
 		dev_err(dev, "invalid chip = %d\n", chip);
 		return -ENODEV;
 	}
-- 
2.36.1


