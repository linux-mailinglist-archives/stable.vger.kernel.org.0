Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9444DD94D
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 12:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbiCRL6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 07:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbiCRL6s (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 18 Mar 2022 07:58:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD25024F28B
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 04:57:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66476B8219E
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 11:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FF7C340E8;
        Fri, 18 Mar 2022 11:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647604647;
        bh=JryUy3Zb4a7859pCYHgFXSKUKY3yslonApLL/NFmajY=;
        h=Subject:To:From:Date:From;
        b=hvkl1mAbQWeXMgky51CNamfjXI7DmS2sOAl9nb3WtRyslwPI3DeM1JAVrQdgAwkV9
         9e5xCiGSt+ib3Olxx46Jwi1fx9+OCe9BKMO7PGbMsT5r41aXE2mY4ue8HuiXcQrlqd
         bfv/xUqbrI5SpPR69NWgUPqsz5t/jynEMOBSCgFc=
Subject: patch "iio: accel: mma8452: use the correct logic to get mma8452_data" added to char-misc-testing
To:     haibo.chen@nxp.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, martink@posteo.de
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Mar 2022 12:43:49 +0100
Message-ID: <16476038292495@kroah.com>
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

    iio: accel: mma8452: use the correct logic to get mma8452_data

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From c87b7b12f48db86ac9909894f4dc0107d7df6375 Mon Sep 17 00:00:00 2001
From: Haibo Chen <haibo.chen@nxp.com>
Date: Tue, 22 Feb 2022 10:42:21 +0800
Subject: iio: accel: mma8452: use the correct logic to get mma8452_data

The original logic to get mma8452_data is wrong, the *dev point to
the device belong to iio_dev. we can't use this dev to find the
correct i2c_client. The original logic happen to work because it
finally use dev->driver_data to get iio_dev. Here use the API
to_i2c_client() is wrong and make reader confuse. To correct the
logic, it should be like this

  struct mma8452_data *data = iio_priv(dev_get_drvdata(dev));

But after commit 8b7651f25962 ("iio: iio_device_alloc(): Remove
unnecessary self drvdata"), the upper logic also can't work.
When try to show the avialable scale in userspace, will meet kernel
dump, kernel handle NULL pointer dereference.

So use dev_to_iio_dev() to correct the logic.

Dual fixes tags as the second reflects when the bug was exposed, whilst
the first reflects when the original bug was introduced.

Fixes: c3cdd6e48e35 ("iio: mma8452: refactor for seperating chip specific data")
Fixes: 8b7651f25962 ("iio: iio_device_alloc(): Remove unnecessary self drvdata")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Martin Kepplinger <martink@posteo.de>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1645497741-5402-1-git-send-email-haibo.chen@nxp.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/mma8452.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 6ea10700d048..9c02c681c84c 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -381,8 +381,8 @@ static ssize_t mma8452_show_scale_avail(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	struct mma8452_data *data = iio_priv(i2c_get_clientdata(
-					     to_i2c_client(dev)));
+	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
+	struct mma8452_data *data = iio_priv(indio_dev);
 
 	return mma8452_show_int_plus_micros(buf, data->chip_info->mma_scales,
 		ARRAY_SIZE(data->chip_info->mma_scales));
-- 
2.35.1


