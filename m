Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC47A68299D
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjAaJxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbjAaJxj (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 31 Jan 2023 04:53:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98B745BC4
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 01:53:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 634B461487
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 09:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E62C433EF;
        Tue, 31 Jan 2023 09:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158814;
        bh=bbyoxaz5tYG7mhyfcqlei5jTQKEKQk7590qsL0/a12Y=;
        h=Subject:To:From:Date:From;
        b=GNCNWLMIWeVTpkj3ytQIdvyYZr8ReFQ5l7nZ/HkVP8INjmiJGAZM2e+fOEX8bD5ci
         fRj3t6qTOWoT3Gy7p4Qg2Ze84fJMLKVuCicbVYdJSTp3xmfNzLATu7HdBYiANSKGtc
         JTcZfz1ebr9Kj/UNH3Wn0vHaxUF9P9KjElSSzZGg=
Subject: patch "iio: imu: fxos8700: fix failed initialization ODR mode assignment" added to char-misc-linus
To:     carlos.song@nxp.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 10:52:45 +0100
Message-ID: <1675158765175133@kroah.com>
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

    iio: imu: fxos8700: fix failed initialization ODR mode assignment

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From eb6d8f8705bc19141bac81d8161461f9e256948a Mon Sep 17 00:00:00 2001
From: Carlos Song <carlos.song@nxp.com>
Date: Wed, 18 Jan 2023 15:42:25 +0800
Subject: iio: imu: fxos8700: fix failed initialization ODR mode assignment

The absence of correct offset leads a failed initialization ODR mode
assignment.

Select MAX ODR mode as the initialization ODR mode by field mask and
FIELD_PREP.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20230118074227.1665098-3-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/fxos8700_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/fxos8700_core.c b/drivers/iio/imu/fxos8700_core.c
index caa474402d53..514411d5ddff 100644
--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -664,8 +664,10 @@ static int fxos8700_chip_init(struct fxos8700_data *data, bool use_spi)
 		return ret;
 
 	/* Max ODR (800Hz individual or 400Hz hybrid), active mode */
-	return regmap_write(data->regmap, FXOS8700_CTRL_REG1,
-			   FXOS8700_CTRL_ODR_MAX | FXOS8700_ACTIVE);
+	return regmap_update_bits(data->regmap, FXOS8700_CTRL_REG1,
+				FXOS8700_CTRL_ODR_MSK | FXOS8700_ACTIVE,
+				FIELD_PREP(FXOS8700_CTRL_ODR_MSK, FXOS8700_CTRL_ODR_MAX) |
+				FXOS8700_ACTIVE);
 }
 
 static void fxos8700_chip_uninit(void *data)
-- 
2.39.1


