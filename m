Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13034DD94A
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 12:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbiCRL6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 07:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbiCRL6h (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 18 Mar 2022 07:58:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EA02E0456
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 04:57:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C67C4617BB
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 11:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02BCC340EC;
        Fri, 18 Mar 2022 11:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647604637;
        bh=SKnvhKNQudE9aFQFVDNHEO2kiESa/0q270zGZR3AQzc=;
        h=Subject:To:From:Date:From;
        b=lnW1/YqxJcAmOISZRrYyEleFFDTtMCbKcyXaouBaqASbSNENCA8ISkGdAEtjjR66M
         9moh8hfC5d9HyBBfVxSfJgU7X6o4g9MFjK2Mt4CfXcItrPmL9PoaZhKFlWFtq9I1z7
         HYYBFuCDMGCzMb6YVeKPmo1+f+pmmi0qSVBGtots=
Subject: patch "iio: imu: st_lsm6dsx: use dev_to_iio_dev() to get iio_dev struct" added to char-misc-testing
To:     haibo.chen@nxp.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Mar 2022 12:43:46 +0100
Message-ID: <164760382637243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: st_lsm6dsx: use dev_to_iio_dev() to get iio_dev struct

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 6270bf1f0197739a9cddaf0a40699a99b7357cb5 Mon Sep 17 00:00:00 2001
From: Haibo Chen <haibo.chen@nxp.com>
Date: Thu, 24 Feb 2022 19:29:51 +0800
Subject: iio: imu: st_lsm6dsx: use dev_to_iio_dev() to get iio_dev struct

dev_get_drvdata() on iio_dev->dev no longer returns the iio_dev.
Use dev_to_iio_dev() to get iio_dev struct.

Fixes: 8b7651f25962 ("iio: iio_device_alloc(): Remove unnecessary self drvdata")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://lore.kernel.org/r/1645702191-9400-1-git-send-email-haibo.chen@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index 727b4b6ac696..8b662332c282 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1629,7 +1629,7 @@ st_lsm6dsx_sysfs_sampling_frequency_avail(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf)
 {
-	struct st_lsm6dsx_sensor *sensor = iio_priv(dev_get_drvdata(dev));
+	struct st_lsm6dsx_sensor *sensor = iio_priv(dev_to_iio_dev(dev));
 	const struct st_lsm6dsx_odr_table_entry *odr_table;
 	int i, len = 0;
 
@@ -1647,7 +1647,7 @@ static ssize_t st_lsm6dsx_sysfs_scale_avail(struct device *dev,
 					    struct device_attribute *attr,
 					    char *buf)
 {
-	struct st_lsm6dsx_sensor *sensor = iio_priv(dev_get_drvdata(dev));
+	struct st_lsm6dsx_sensor *sensor = iio_priv(dev_to_iio_dev(dev));
 	const struct st_lsm6dsx_fs_table_entry *fs_table;
 	struct st_lsm6dsx_hw *hw = sensor->hw;
 	int i, len = 0;
-- 
2.35.1


